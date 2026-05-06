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
                .role-tag {
                    background: var(--soft-red);
                    color: var(--primary-red);
                    padding: 4px 10px;
                    border-radius: 6px;
                    font-size: 0.85rem;
                    font-weight: 700;
                }
            `}</style>
        </div>
    );
}