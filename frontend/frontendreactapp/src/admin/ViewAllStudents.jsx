import api from '../api';
import React, { useEffect, useState } from 'react';

export default function ViewAllStudents() {
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");
    const [searchTerm, setSearchTerm] = useState("");

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

    const filteredData = data.filter(s => 
        s.username.toLowerCase().includes(searchTerm.toLowerCase()) ||
        s.firstName.toLowerCase().includes(searchTerm.toLowerCase()) ||
        s.email.toLowerCase().includes(searchTerm.toLowerCase())
    );

    return (
        <div className="admin-page-container">
            <header className="page-header">
                <h1>Student Management</h1>
                <p>View and manage all registered student accounts.</p>
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
                                    <th>Department</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {filteredData.map((student, index) => (
                                    <tr key={index}>
                                        <td><code>{student.username}</code></td>
                                        <td><strong>{student.firstName} {student.lastName}</strong></td>
                                        <td>{student.email}</td>
                                        <td><span className="dept-tag">{student.department}</span></td>
                                        <td>
                                            <span className={`status-pill ${student.isActive ? 'active' : 'inactive'}`}>
                                                {student.isActive ? 'Active' : 'Disabled'}
                                            </span>
                                        </td>
                                    </tr>
                                ))}
                                {filteredData.length === 0 && (
                                    <tr>
                                        <td colSpan="5" className="empty-state">No students matching your search.</td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                )}
            </div>

            <style>{`
                .table-actions {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 2rem;
                    gap: 20px;
                }
                .search-box { position: relative; flex: 1; max-width: 400px; }
                .search-icon { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); opacity: 0.5; }
                .search-box .input-field { padding-left: 40px; }
                
                .count-badge {
                    background: var(--soft-red);
                    color: var(--primary-red);
                    padding: 8px 16px;
                    border-radius: 30px;
                    font-weight: 700;
                    font-size: 0.9rem;
                    border: 1px solid rgba(225, 29, 72, 0.1);
                }

                .dept-tag {
                    background: #f1f5f9;
                    color: #475569;
                    padding: 4px 10px;
                    border-radius: 6px;
                    font-size: 0.85rem;
                    font-weight: 600;
                }

                .status-pill {
                    padding: 4px 10px;
                    border-radius: 20px;
                    font-size: 0.8rem;
                    font-weight: 700;
                }
                .status-pill.active { background: #dcfce7; color: #166534; }
                .status-pill.inactive { background: #fee2e2; color: #991b1b; }

                .empty-state { text-align: center; padding: 4rem !important; color: var(--text-muted); font-style: italic; }

                .loader-container { text-align: center; padding: 4rem; }
                .loader {
                    border: 4px solid var(--soft-red);
                    border-top: 4px solid var(--primary-red);
                    border-radius: 50%;
                    width: 40px;
                    height: 40px;
                    animation: spin 1s linear infinite;
                    margin: 0 auto 1rem;
                }
                @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
            `}</style>
        </div>
    );
}
