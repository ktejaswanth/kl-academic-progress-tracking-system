import api from '../api';
import React, { useEffect, useState } from 'react';

export default function ViewAllFaculty() {
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");
    const [searchTerm, setSearchTerm] = useState("");

    const [visiblePasswords, setVisiblePasswords] = useState({});
    
    const fetchFaculty = async () => {
        try {
            const response = await api.get("/admin/faculty");
            setData(response.data);
        } catch (err) {
            setError("Failed to fetch faculty records.");
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchFaculty();
    }, []);

    const togglePassword = (index) => {
        setVisiblePasswords(prev => ({
            ...prev,
            [index]: !prev[index]
        }));
    };

    const deleteFaculty = async (id) => {
        if (!window.confirm("Are you sure you want to delete this faculty account?")) return;
        try {
            await api.delete(`/admin/users/${id}`);
            setData(data.filter(f => f.id !== id));
            alert("Faculty account deleted.");
        } catch (err) {
            alert("Error deleting: " + (err.response?.data || "Unknown error"));
        }
    };

    const filteredData = data.filter(f => 
        f.username.toLowerCase().includes(searchTerm.toLowerCase()) ||
        f.firstName.toLowerCase().includes(searchTerm.toLowerCase()) ||
        f.email.toLowerCase().includes(searchTerm.toLowerCase())
    );

    return (
        <div className="admin-page-container">
            <header className="page-header">
                <h1>Faculty Directory</h1>
                <p>Manage and monitor academic staff profiles.</p>
            </header>

            <div className="table-actions">
                <div className="search-box">
                    <span className="search-icon">🔍</span>
                    <input 
                        type="text" 
                        placeholder="Search by ID, Name or Email..." 
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="input-field"
                    />
                </div>
                <div className="count-badge">
                    {filteredData.length} Faculty Members Found
                </div>
            </div>

            <div className="table-card">
                {loading ? (
                    <div className="loader-container">
                        <div className="loader"></div>
                        <p>Loading Faculty Records...</p>
                    </div>
                ) : error ? (
                    <div className="alert error">{error}</div>
                ) : (
                    <div className="table-wrapper">
                        <table className="modern-table">
                            <thead>
                                <tr>
                                    <th>Employee ID</th>
                                    <th>Full Name</th>
                                    <th>Email Address</th>
                                    <th>Department</th>
                                    <th>Password</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {filteredData.map((faculty, index) => (
                                    <tr key={index}>
                                        <td><code>{faculty.username}</code></td>
                                        <td><strong>{faculty.firstName} {faculty.lastName}</strong></td>
                                        <td>{faculty.email}</td>
                                        <td><span className="dept-tag">{faculty.department}</span></td>
                                        <td>
                                            <div className="password-display">
                                                <code>{visiblePasswords[index] ? (faculty.rawPassword || 'N/A') : '••••••••'}</code>
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
                                            <div className="row-actions">
                                                <button 
                                                    className="action-btn delete" 
                                                    onClick={() => deleteFaculty(faculty.id)}
                                                    title="Delete Faculty"
                                                >
                                                    🗑️
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                ))}
                                {filteredData.length === 0 && (
                                    <tr>
                                        <td colSpan="6" className="empty-state">No faculty found matching your search.</td>
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
                    border-color: #E11D48;
                    box-shadow: 0 0 0 3px rgba(225, 29, 72, 0.1);
                    outline: none;
                }
                
                .count-badge {
                    background: #F1F5F9;
                    color: #475569;
                    padding: 10px 20px;
                    border-radius: 30px;
                    font-weight: 700;
                    font-size: 0.9rem;
                    border: 1px solid #E2E8F0;
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
                    border-bottom: 1px solid #E2E8F0;
                }
                .modern-table td {
                    padding: 1.25rem 1.5rem;
                    border-bottom: 1px solid #F1F5F9;
                    vertical-align: middle;
                }
                .modern-table tr:hover { background: #FBFBFF; }

                .dept-tag {
                    background: #E0F2FE;
                    color: #0369A1;
                    padding: 4px 12px;
                    border-radius: 6px;
                    font-size: 0.75rem;
                    font-weight: 800;
                    text-transform: uppercase;
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
                }
                .password-display code { 
                    font-family: 'JetBrains Mono', monospace; 
                    font-size: 0.95rem; 
                    min-width: 100px; 
                    display: inline-block; 
                    color: #1E293B;
                }
                .visibility-toggle {
                    background: white;
                    border: 1px solid #E2E8F0;
                    cursor: pointer;
                    width: 32px;
                    height: 32px;
                    border-radius: 8px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    transition: all 0.2s;
                }
                .visibility-toggle:hover { background: #F1F5F9; transform: scale(1.1); }

                .row-actions {
                    display: flex;
                    gap: 8px;
                }
                .action-btn {
                    width: 36px;
                    height: 36px;
                    border-radius: 10px;
                    border: 1px solid #E2E8F0;
                    background: white;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    cursor: pointer;
                    transition: all 0.2s;
                }
                .action-btn.delete:hover {
                    background: #FFF1F2;
                    border-color: #FECACA;
                    color: #E11D48;
                    transform: scale(1.1);
                }

                .loader-container { text-align: center; padding: 5rem; }
                .loader {
                    border: 4px solid #F1F5F9;
                    border-top: 4px solid #E11D48;
                    border-radius: 50%;
                    width: 50px;
                    height: 50px;
                    animation: spin 1s linear infinite;
                    margin: 0 auto 1.5rem;
                }
                @keyframes spin { to { transform: rotate(360deg); } }

                .empty-state { text-align: center; padding: 5rem !important; color: #94A3B8; font-style: italic; }
                .alert.error { padding: 1.5rem; color: #991B1B; background: #FEF2F2; text-align: center; border-radius: 12px; }
            `}</style>
        </div>
    );
}