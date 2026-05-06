import api from '../api';
import React, { useEffect, useState } from 'react';

export default function ViewAllFaculty() {
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");
    const [searchTerm, setSearchTerm] = useState("");

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
                                    <th>Designation</th>
                                </tr>
                            </thead>
                            <tbody>
                                {filteredData.map((faculty, index) => (
                                    <tr key={index}>
                                        <td><code>{faculty.username}</code></td>
                                        <td><strong>{faculty.firstName} {faculty.lastName}</strong></td>
                                        <td>{faculty.email}</td>
                                        <td><span className="dept-tag">{faculty.department}</span></td>
                                        <td><span className="role-tag">{faculty.designation || 'Faculty'}</span></td>
                                    </tr>
                                ))}
                                {filteredData.length === 0 && (
                                    <tr>
                                        <td colSpan="5" className="empty-state">No faculty found matching your search.</td>
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

                .role-tag {
                    background: #F1F5F9;
                    color: #1E293B;
                    padding: 6px 12px;
                    border-radius: 30px;
                    font-size: 0.85rem;
                    font-weight: 700;
                    border: 1px solid #E2E8F0;
                }

                .empty-state { text-align: center; padding: 5rem !important; color: #94A3B8; font-style: italic; }
            `}</style>
        </div>
    );
}