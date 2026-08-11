import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import './curriculum-import.css';

export default function CurriculumRepository() {
    const navigate = useNavigate();
    const [imports, setImports] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        fetchImports();
    }, []);

    const fetchImports = async () => {
        setLoading(true);
        setError(null);
        try {
            const res = await api.get('/curriculum');
            setImports(res.data || []);
        } catch (err) {
            console.error("Failed to fetch imports:", err);
            setError("Failed to load curriculum imports repository.");
        } finally {
            setLoading(false);
        }
    };

    const handleDelete = async (id, e) => {
        e.stopPropagation(); // Prevent row click navigation
        if (!window.confirm("Are you sure you want to delete this curriculum import record?")) {
            return;
        }

        setLoading(true);
        try {
            await api.delete(`/curriculum/${id}`);
            setImports(prev => prev.filter(item => item.id !== id));
            setError(null);
        } catch (err) {
            console.error("Failed to delete import:", err);
            setError("Failed to delete import record.");
        } finally {
            setLoading(false);
        }
    };

    const handleRowClick = (id, status) => {
        if (status === 'UPLOADED') {
            // Trigger analysis first or prompt to trigger
            navigate(`/super_admin/curriculum-review/${id}`);
        } else {
            navigate(`/super_admin/curriculum-review/${id}`);
        }
    };

    const formatDate = (dateStr) => {
        if (!dateStr) return 'N/A';
        const date = new Date(dateStr);
        return date.toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    };

    return (
        <div className="curriculum-import-container">
            <div className="import-header-card">
                <div className="import-header-title">
                    <h1>Curriculum Import Repository</h1>
                    <p>Manage, review, and audit AI-imported program handbooks and curriculum versions.</p>
                </div>
                <div>
                    <button 
                        className="btn-primary" 
                        onClick={() => navigate('/super_admin/curriculum-upload')}
                    >
                        ➕ Import Curriculum
                    </button>
                </div>
            </div>

            {error && (
                <div className="validation-list" style={{ marginBottom: '20px' }}>
                    <h3>⚠️ Error</h3>
                    <ul>
                        <li>{error}</li>
                    </ul>
                </div>
            )}

            {loading && imports.length === 0 ? (
                <div style={{ textAlign: 'center', padding: '60px' }}>
                    <div className="spinner" style={{ margin: '0 auto 20px' }}></div>
                    <h2>Loading Repository...</h2>
                </div>
            ) : (
                <div className="repo-table-container">
                    <table className="custom-table">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Department</th>
                                <th>Regulation</th>
                                <th>Academic Year</th>
                                <th>PDF File</th>
                                <th>Status</th>
                                <th>Date Imported</th>
                                <th style={{ textAlign: 'right' }}>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {imports.map((item) => (
                                <tr 
                                    key={item.id} 
                                    onClick={() => handleRowClick(item.id, item.status)}
                                    style={{ cursor: 'pointer' }}
                                >
                                    <td style={{ fontWeight: '600', color: '#60a5fa' }}>{item.curriculumName}</td>
                                    <td>{item.department}</td>
                                    <td>{item.regulation}</td>
                                    <td>{item.academicYear}</td>
                                    <td style={{ fontSize: '12px', color: '#94a3b8' }}>{item.pdfFileName}</td>
                                    <td>
                                        <span className={`status-badge ${item.status?.toLowerCase()}`}>
                                            {item.status}
                                        </span>
                                    </td>
                                    <td>{formatDate(item.createdAt)}</td>
                                    <td style={{ textAlign: 'right' }}>
                                        <div style={{ display: 'flex', gap: '8px', justifyContent: 'flex-end' }}>
                                            <button 
                                                className="btn-secondary" 
                                                style={{ padding: '6px 12px', fontSize: '12px' }}
                                                onClick={(e) => { e.stopPropagation(); handleRowClick(item.id, item.status); }}
                                            >
                                                Review
                                            </button>
                                            <button 
                                                className="btn-danger" 
                                                style={{ padding: '6px 12px', fontSize: '12px' }}
                                                onClick={(e) => handleDelete(item.id, e)}
                                            >
                                                Delete
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            ))}
                            {imports.length === 0 && (
                                <tr>
                                    <td colSpan={8} style={{ textAlign: 'center', padding: '40px', color: '#64748b' }}>
                                        No curriculum imports found. Click "Import Curriculum" to get started.
                                    </td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>
            )}

            {loading && imports.length > 0 && (
                <div className="loading-overlay">
                    <div className="spinner"></div>
                    <h2 style={{ color: '#60a5fa' }}>Updating Repository...</h2>
                </div>
            )}
        </div>
    );
}
