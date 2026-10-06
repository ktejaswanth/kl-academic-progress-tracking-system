import api from '../api';
import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';

export default function ViewAllAdmins() {
    const navigate = useNavigate();
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");
    const [searchTerm, setSearchTerm] = useState("");
    const [visiblePasswords, setVisiblePasswords] = useState({});

    const fetchAdmins = async () => {
        try {
            const response = await api.get("/admin/admins");
            setData(response.data);
        } catch {
            setError("Failed to fetch administrator records.");
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchAdmins();
    }, []);

    const togglePassword = (index) => {
        setVisiblePasswords(prev => ({
            ...prev,
            [index]: !prev[index]
        }));
    };

    const deleteAdmin = async (id, username) => {
        if (username === 'admin') {
            alert("The primary Super Admin 'admin' cannot be deleted.");
            return;
        }
        if (!window.confirm(`Are you sure you want to delete admin '${username}'? This action cannot be undone.`)) return;
        try {
            await api.delete(`/admin/admins/${id}`);
            setData(data.filter(a => a.id !== id));
            alert("Administrator account deleted.");
        } catch (err) {
            alert("Error deleting admin: " + (err.response?.data || "Unknown error"));
        }
    };

    const filteredData = data.filter(a =>
        (a.username && a.username.toLowerCase().includes(searchTerm.toLowerCase())) ||
        (a.firstName && a.firstName.toLowerCase().includes(searchTerm.toLowerCase())) ||
        (a.lastName && a.lastName.toLowerCase().includes(searchTerm.toLowerCase())) ||
        (a.email && a.email.toLowerCase().includes(searchTerm.toLowerCase())) ||
        (a.empId && a.empId.toLowerCase().includes(searchTerm.toLowerCase())) ||
        (a.designation && a.designation.toLowerCase().includes(searchTerm.toLowerCase()))
    );

    return (
        <div className="admin-page-container">
            <header className="page-header">
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', width: '100%' }}>
                    <div>
                        <h1>Administrator Directory</h1>
                        <p>Manage and monitor privileged administrator accounts.</p>
                    </div>
                    <button 
                        onClick={() => navigate('/super_admin/addadmin')} 
                        className="btn-primary" 
                        style={{ padding: '0.6rem 1.4rem' }}
                    >
                        ➕ Add New Admin
                    </button>
                </div>
            </header>

            <div className="table-actions">
                <div className="search-box">
                    <span className="search-icon">🔍</span>
                    <input 
                        type="text" 
                        placeholder="Search by ID, Username, Name, Designation..." 
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="input-field"
                    />
                </div>
                <div className="count-badge">
                    {filteredData.length} Administrators
                </div>
            </div>

            <div className="table-card">
                {loading ? (
                    <div className="loader-container">
                        <div className="loader"></div>
                        <p>Loading Administrator Records...</p>
                    </div>
                ) : error ? (
                    <div className="alert error">{error}</div>
                ) : (
                    <div className="table-wrapper">
                        <table className="modern-table">
                            <thead>
                                <tr>
                                    <th>Emp ID</th>
                                    <th>Username</th>
                                    <th>Full Name</th>
                                    <th>Email Address</th>
                                    <th>Designation</th>
                                    <th>Contact No</th>
                                    <th>Status</th>
                                    <th>Password</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {filteredData.map((admin, index) => (
                                    <tr key={admin.id || index}>
                                        <td><code>{admin.empId || 'N/A'}</code></td>
                                        <td><strong>{admin.username}</strong></td>
                                        <td>{admin.firstName} {admin.lastName}</td>
                                        <td>{admin.email}</td>
                                        <td><span className="designation-tag">{admin.designation || 'Administrator'}</span></td>
                                        <td>{admin.contactNo || '—'}</td>
                                        <td>
                                            <span className={`status-pill ${admin.isActive !== false ? 'active' : 'inactive'}`}>
                                                {admin.isActive !== false ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>
                                        <td>
                                            <div className="password-display">
                                                <code>{visiblePasswords[index] ? (admin.rawPassword || '••••••••') : '••••••••'}</code>
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
                                            {admin.username !== 'admin' && (
                                                <button 
                                                    className="action-btn delete" 
                                                    onClick={() => deleteAdmin(admin.id, admin.username)}
                                                    title="Delete Administrator"
                                                >
                                                    🗑️
                                                </button>
                                            )}
                                        </td>
                                    </tr>
                                ))}
                                {filteredData.length === 0 && (
                                    <tr>
                                        <td colSpan="9" className="empty-state">No administrators found matching your search.</td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                )}
            </div>

            <style>{`
                .admin-page-container {
                    animation: fadeIn 0.4s ease-out;
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

                .designation-tag {
                    background: #FEE2E2;
                    color: #BE123C;
                    padding: 4px 12px;
                    border-radius: 6px;
                    font-size: 0.78rem;
                    font-weight: 800;
                }

                .status-pill {
                    padding: 4px 10px;
                    border-radius: 12px;
                    font-size: 0.75rem;
                    font-weight: 700;
                }
                .status-pill.active { background: #DCFCE7; color: #166534; }
                .status-pill.inactive { background: #F1F5F9; color: #64748B; }

                .password-display {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    background: #F8FAFC;
                    padding: 6px 10px;
                    border-radius: 8px;
                    border: 1px solid #E2E8F0;
                    width: fit-content;
                }
                .password-display code { 
                    font-family: 'JetBrains Mono', monospace; 
                    font-size: 0.9rem; 
                    min-width: 90px; 
                    display: inline-block; 
                    color: #1E293B;
                }
                .visibility-toggle {
                    background: white;
                    border: 1px solid #E2E8F0;
                    cursor: pointer;
                    width: 28px;
                    height: 28px;
                    border-radius: 6px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    transition: all 0.2s;
                }
                .visibility-toggle:hover { background: #F1F5F9; transform: scale(1.08); }

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
                    width: 45px;
                    height: 45px;
                    animation: spin 1s linear infinite;
                    margin: 0 auto 1.5rem;
                }
                @keyframes spin { to { transform: rotate(360deg); } }

                .empty-state { text-align: center; padding: 4rem !important; color: #94A3B8; font-style: italic; }
                .alert.error { padding: 1.5rem; color: #991B1B; background: #FEF2F2; text-align: center; border-radius: 12px; }
            `}</style>
        </div>
    );
}
