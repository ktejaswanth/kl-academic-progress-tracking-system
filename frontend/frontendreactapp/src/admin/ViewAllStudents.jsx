import api from '../api';
import React, { useEffect, useState } from 'react';
import * as XLSX from 'xlsx';

export default function ViewAllStudents() {
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");
    const [searchTerm, setSearchTerm] = useState("");
    const [visiblePasswords, setVisiblePasswords] = useState({});

    const fetchStudents = async () => {
        try {
            const response = await api.get("/admin/students");
            setData(response.data);
        } catch (err) {
            setError("Failed to fetch students. Please check your connection.");
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchStudents();
    }, []);

    const togglePassword = (index) => {
        setVisiblePasswords(prev => ({
            ...prev,
            [index]: !prev[index]
        }));
    };

    const downloadAllCredentials = () => {
        const exportData = filteredData.map(s => ({
            "Student ID": s.username,
            "Full Name": `${s.firstName} ${s.lastName}`,
            "Email": s.email,
            "Department": s.department,
            "Sub-Department": s.subDepartment || 'N/A',
            "Spec Type": s.specializationType,
            "Spec Name": s.specializationName || 'N/A',
            "Real Password": s.rawPassword || "NOT_STORED"
        }));

        const worksheet = XLSX.utils.json_to_sheet(exportData);
        const workbook = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(workbook, worksheet, "StudentPasswords");
        XLSX.writeFile(workbook, `All_Student_Credentials_${new Date().toLocaleDateString()}.xlsx`);
    };

    const filteredData = data.filter(s =>
        s.username.toLowerCase().includes(searchTerm.toLowerCase()) ||
        s.firstName.toLowerCase().includes(searchTerm.toLowerCase()) ||
        s.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
        (s.department && s.department.toLowerCase().includes(searchTerm.toLowerCase())) ||
        (s.specializationName && s.specializationName.toLowerCase().includes(searchTerm.toLowerCase()))
    );

    return (
        <div className="admin-page-container">
            <header className="page-header">
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', width: '100%' }}>
                    <div>
                        <h1>Student Management</h1>
                        <p>View and manage all registered student accounts including their credentials.</p>
                    </div>
                    <button onClick={downloadAllCredentials} className="download-btn-premium">
                        📥 Extract All Passwords (Excel)
                    </button>
                </div>
            </header>

            <div className="table-actions">
                <div className="search-box">
                    <span className="search-icon">🔍</span>
                    <input
                        type="text"
                        placeholder="Search by ID, Name, Email, Dept or Spec..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="input-field"
                    />
                </div>
                <div className="count-badge">
                    {filteredData.length} Students Found
                </div>
            </div>

            <div className="table-card">
                {loading ? (
                    <div className="loader-container">
                        <div className="loader"></div>
                        <p>Fetching Student Records...</p>
                    </div>
                ) : error ? (
                    <div className="alert error">{error}</div>
                ) : (
                    <div className="table-wrapper">
                        <table className="modern-table">
                            <thead>
                                <tr>
                                    <th>Student ID</th>
                                    <th>Full Name</th>
                                    <th>Email Address</th>
                                    <th>Dept / Sub-Dept</th>
                                    <th>Specialization</th>
                                    <th>Password</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {filteredData.map((student, index) => (
                                    <tr key={index}>
                                        <td><code>{student.username}</code></td>
                                        <td><strong>{student.firstName} {student.lastName}</strong></td>
                                        <td>{student.email}</td>
                                        <td>
                                            <div className="dept-cell">
                                                <span className="main-dept">{student.department}</span>
                                                <span className="sub-dept">{student.subDepartment || 'N/A'}</span>
                                            </div>
                                        </td>
                                        <td>
                                            <div className="spec-cell">
                                                <span className="spec-type">{student.specializationType}</span>
                                                <span className="spec-name">{student.specializationName || 'N/A'}</span>
                                            </div>
                                        </td>
                                        <td>
                                            <div className="password-display">
                                                <code>{visiblePasswords[index] ? (student.rawPassword || 'N/A') : '••••••••'}</code>
                                                <button
                                                    className="visibility-toggle"
                                                    onClick={() => togglePassword(index)}
                                                    title={visiblePasswords[index] ? "Hide Password" : "Show Password"}
                                                >
                                                    {visiblePasswords[index] ? '👁️‍🗨️' : '👁️'}
                                                </button>
                                            </div>
                                        </td>
                                        <td>
                                            <span className={`status-pill ${student.isActive ? 'active' : 'inactive'}`}>
                                                {student.isActive ? 'Active' : 'Disabled'}
                                            </span>
                                        </td>
                                    </tr>
                                ))}
                                {filteredData.length === 0 && (
                                    <tr>
                                        <td colSpan="7" className="empty-state">No students matching your search.</td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                )}
            </div>

            <style>{`
                .admin-page-container {
                    animation: fadeIn 0.5s ease-out;
                }
                @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

                .table-actions {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 2rem;
                    gap: 20px;
                    background: white;
                    padding: 1.5rem;
                    border-radius: 16px;
                    box-shadow: 0 2px 10px rgba(0,0,0,0.03);
                }
                .search-box { position: relative; flex: 1; max-width: 500px; }
                .search-icon { position: absolute; left: 16px; top: 50%; transform: translateY(-50%); opacity: 0.5; font-size: 1.1rem; }
                .search-box .input-field { 
                    padding: 12px 12px 12px 48px; 
                    border-radius: 12px; 
                    border: 1px solid #E2E8F0;
                    width: 100%;
                    transition: all 0.3s;
                }
                .search-box .input-field:focus {
                    border-color: var(--primary-red);
                    box-shadow: 0 0 0 3px rgba(225, 29, 72, 0.1);
                    outline: none;
                }
                
                .count-badge {
                    background: #FFF1F2;
                    color: #BE123C;
                    padding: 10px 20px;
                    border-radius: 30px;
                    font-weight: 700;
                    font-size: 0.9rem;
                    border: 1px solid rgba(225, 29, 72, 0.1);
                    white-space: nowrap;
                }

                .table-card {
                    background: white;
                    border-radius: 20px;
                    overflow: hidden;
                    box-shadow: 0 4px 20px rgba(0,0,0,0.04);
                    border: 1px solid #EDF2F7;
                }

                .modern-table {
                    width: 100%;
                    border-collapse: collapse;
                    text-align: left;
                }

                .modern-table th {
                    background: #F8FAFC;
                    padding: 1.25rem 1.5rem;
                    color: #64748B;
                    font-weight: 700;
                    font-size: 0.85rem;
                    text-transform: uppercase;
                    letter-spacing: 0.05em;
                    border-bottom: 1px solid #E2E8F0;
                }

                .modern-table td {
                    padding: 1.25rem 1.5rem;
                    border-bottom: 1px solid #F1F5F9;
                    vertical-align: middle;
                }

                .modern-table tr:hover { background: #FBFBFF; }

                .dept-cell, .spec-cell { 
                    display: flex; 
                    flex-direction: column; 
                    gap: 4px; 
                    min-width: 140px;
                }
                .main-dept, .spec-type { 
                    font-weight: 800; 
                    color: #E11D48; 
                    font-size: 0.7rem; 
                    background: #FFF1F2;
                    padding: 2px 8px;
                    border-radius: 4px;
                    width: fit-content;
                }
                .sub-dept, .spec-name { 
                    color: #475569; 
                    font-size: 0.85rem; 
                    font-weight: 500;
                    padding-left: 4px;
                }

                .password-display {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    background: #F8FAFC;
                    padding: 8px 12px;
                    border-radius: 10px;
                    border: 1px solid #E2E8F0;
                    width: fit-content;
                    transition: all 0.2s;
                }
                .password-display:hover { border-color: #CBD5E1; }
                .password-display code { 
                    font-family: 'JetBrains Mono', 'Courier New', monospace; 
                    font-size: 0.95rem; 
                    min-width: 100px; 
                    display: inline-block; 
                    color: #1E293B;
                }
                .visibility-toggle {
                    background: white;
                    border: 1px solid #E2E8F0;
                    cursor: pointer;
                    font-size: 1rem;
                    width: 32px;
                    height: 32px;
                    border-radius: 8px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    transition: all 0.2s;
                    box-shadow: 0 1px 2px rgba(0,0,0,0.05);
                }
                .visibility-toggle:hover { 
                    background: #F1F5F9; 
                    border-color: #CBD5E1;
                    transform: scale(1.1);
                }

                .status-pill {
                    padding: 6px 12px;
                    border-radius: 30px;
                    font-size: 0.75rem;
                    font-weight: 700;
                    text-transform: uppercase;
                    letter-spacing: 0.02em;
                }
                .status-pill.active { background: #DCFCE7; color: #15803D; border: 1px solid #BBF7D0; }
                .status-pill.inactive { background: #FEE2E2; color: #B91C1C; border: 1px solid #FECACA; }

                .empty-state { text-align: center; padding: 5rem !important; color: #94A3B8; font-style: italic; font-size: 1.1rem; }

                .loader-container { text-align: center; padding: 5rem; }
                .loader {
                    border: 4px solid #F1F5F9;
                    border-top: 4px solid #E11D48;
                    border-radius: 50%;
                    width: 50px;
                    height: 50px;
                    animation: spin 1s cubic-bezier(0.68, -0.55, 0.265, 1.55) infinite;
                    margin: 0 auto 1.5rem;
                }
                @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
            `}</style>
        </div>
    );
}
