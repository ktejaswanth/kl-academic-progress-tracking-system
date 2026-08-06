import React, { useEffect, useState } from 'react';
import api from '../api';
import './admin.css';

export default function ManageIssues() {
    const [issues, setIssues] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [search, setSearch] = useState('');
    const [statusFilter, setStatusFilter] = useState('ALL');
    const [updatingId, setUpdatingId] = useState(null);

    const fetchAllIssues = async () => {
        try {
            const response = await api.get('/admin/issues');
            setIssues(response.data);
        } catch (err) {
            setError('Failed to fetch student issues catalog.');
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchAllIssues();
    }, []);

    const handleStatusToggle = async (issueId, currentStatus) => {
        const nextStatus = currentStatus === 'RESOLVED' ? 'PENDING' : 'RESOLVED';
        setUpdatingId(issueId);
        try {
            await api.put(`/admin/issues/${issueId}/status`, { status: nextStatus });
            // Update locally
            setIssues(prev => prev.map(issue => 
                issue.id === issueId 
                    ? { ...issue, status: nextStatus, resolvedAt: nextStatus === 'RESOLVED' ? new Date().toISOString() : null } 
                    : issue
            ));
        } catch (err) {
            alert('Failed to update issue status: ' + (err.response?.data || err.message));
        } finally {
            setUpdatingId(null);
        }
    };

    // Filter issues based on search (student name, email, username, title, desc) and status
    const filteredIssues = issues.filter(issue => {
        const matchesStatus = statusFilter === 'ALL' || issue.status === statusFilter;
        
        const studentInfo = issue.student 
            ? `${issue.student.firstName} ${issue.student.lastName} ${issue.student.username} ${issue.student.email}`.toLowerCase()
            : '';
        const issueInfo = `${issue.title} ${issue.description}`.toLowerCase();
        const searchLower = search.toLowerCase();

        const matchesSearch = studentInfo.includes(searchLower) || issueInfo.includes(searchLower);

        return matchesStatus && matchesSearch;
    });

    return (
        <div className="admin-page-container animate-fade">
            <header className="page-header" style={{ marginBottom: '2.5rem' }}>
                <div className="header-title">
                    <span className="welcome-tag">Support Center</span>
                    <h1 style={{ fontSize: '2.2rem', margin: '0.5rem 0', color: '#0F172A' }}>Manage Student Issues</h1>
                    <p style={{ color: '#64748B' }}>Review, investigate, and mark student-reported academic issues as resolved.</p>
                </div>
            </header>

            {error && <div className="alert error" style={{ marginBottom: '2rem' }}>⚠️ {error}</div>}

            {/* Filters panel */}
            <div className="table-actions" style={{ display: 'flex', gap: '20px', alignItems: 'center', justifyContent: 'space-between', marginBottom: '2rem', background: '#fff', padding: '1.5rem', borderRadius: '16px', boxShadow: '0 2px 10px rgba(0,0,0,0.03)' }}>
                <div style={{ flex: 1, maxWidth: '400px', position: 'relative' }}>
                    <span style={{ position: 'absolute', left: '16px', top: '50%', transform: 'translateY(-50%)', opacity: 0.5 }}>🔍</span>
                    <input 
                        type="text" 
                        value={search}
                        onChange={(e) => setSearch(e.target.value)}
                        placeholder="Search student details or issues..."
                        className="input-field"
                        style={{ width: '100%', padding: '12px 12px 12px 42px', borderRadius: '12px', border: '1px solid #E2E8F0', outline: 'none' }}
                    />
                </div>
                
                <div style={{ display: 'flex', gap: '10px' }}>
                    <button 
                        onClick={() => setStatusFilter('ALL')} 
                        className={`filter-btn ${statusFilter === 'ALL' ? 'active' : ''}`}
                        style={{ padding: '8px 16px', borderRadius: '10px', border: '1px solid #CBD5E1', background: statusFilter === 'ALL' ? '#8B0000' : '#fff', color: statusFilter === 'ALL' ? '#fff' : '#475569', cursor: 'pointer', fontWeight: 600 }}
                    >
                        All Issues
                    </button>
                    <button 
                        onClick={() => setStatusFilter('PENDING')} 
                        className={`filter-btn ${statusFilter === 'PENDING' ? 'active' : ''}`}
                        style={{ padding: '8px 16px', borderRadius: '10px', border: '1px solid #CBD5E1', background: statusFilter === 'PENDING' ? '#8B0000' : '#fff', color: statusFilter === 'PENDING' ? '#fff' : '#475569', cursor: 'pointer', fontWeight: 600 }}
                    >
                        Pending
                    </button>
                    <button 
                        onClick={() => setStatusFilter('RESOLVED')} 
                        className={`filter-btn ${statusFilter === 'RESOLVED' ? 'active' : ''}`}
                        style={{ padding: '8px 16px', borderRadius: '10px', border: '1px solid #CBD5E1', background: statusFilter === 'RESOLVED' ? '#8B0000' : '#fff', color: statusFilter === 'RESOLVED' ? '#fff' : '#475569', cursor: 'pointer', fontWeight: 600 }}
                    >
                        Resolved
                    </button>
                </div>
            </div>

            {loading ? (
                <div className="loader-container"><div className="loader"></div><p>Loading issues feed...</p></div>
            ) : (
                <div className="table-card" style={{ background: '#fff', borderRadius: '20px', overflow: 'hidden', boxShadow: '0 4px 20px rgba(0,0,0,0.04)', border: '1px solid #EDF2F7' }}>
                    <table className="modern-table" style={{ width: '100%', borderCollapse: 'collapse' }}>
                        <thead>
                            <tr style={{ background: '#F8FAFC', borderBottom: '1px solid #E2E8F0' }}>
                                <th style={{ padding: '1.25rem 1.5rem', textAlign: 'left', color: '#64748B', fontWeight: 700 }}>Student Information</th>
                                <th style={{ padding: '1.25rem 1.5rem', textAlign: 'left', color: '#64748B', fontWeight: 700 }}>Issue Title</th>
                                <th style={{ padding: '1.25rem 1.5rem', textAlign: 'left', color: '#64748B', fontWeight: 700 }}>Description</th>
                                <th style={{ padding: '1.25rem 1.5rem', textAlign: 'left', color: '#64748B', fontWeight: 700 }}>Reported Date</th>
                                <th style={{ padding: '1.25rem 1.5rem', textAlign: 'left', color: '#64748B', fontWeight: 700 }}>Status</th>
                                <th style={{ padding: '1.25rem 1.5rem', textAlign: 'center', color: '#64748B', fontWeight: 700 }}>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {filteredIssues.map((issue) => (
                                <tr key={issue.id} style={{ borderBottom: '1px solid #F1F5F9' }}>
                                    <td style={{ padding: '1.25rem 1.5rem' }}>
                                        {issue.student ? (
                                            <div>
                                                <div style={{ fontWeight: 800, color: '#0F172A' }}>{issue.student.firstName} {issue.student.lastName}</div>
                                                <div style={{ fontSize: '0.8rem', color: '#64748B' }}>ID: {issue.student.username}</div>
                                                <div style={{ fontSize: '0.75rem', color: '#E11D48', fontWeight: 600 }}>{issue.student.department}</div>
                                            </div>
                                        ) : (
                                            <span style={{ fontStyle: 'italic', color: '#94A3B8' }}>Unknown Student</span>
                                        )}
                                    </td>
                                    <td style={{ padding: '1.25rem 1.5rem', fontWeight: 700, color: '#1E293B' }}>{issue.title}</td>
                                    <td style={{ padding: '1.25rem 1.5rem', color: '#475569', fontSize: '0.9rem', maxWidth: '300px', lineHeight: '1.4' }}>{issue.description}</td>
                                    <td style={{ padding: '1.25rem 1.5rem', fontSize: '0.8rem', color: '#64748B' }}>
                                        {new Date(issue.createdAt).toLocaleString()}
                                    </td>
                                    <td style={{ padding: '1.25rem 1.5rem' }}>
                                        <span className={`status-pill ${issue.status === 'RESOLVED' ? 'active' : 'inactive'}`}>
                                            {issue.status}
                                        </span>
                                    </td>
                                    <td style={{ padding: '1.25rem 1.5rem', textAlign: 'center' }}>
                                        <button 
                                            disabled={updatingId === issue.id}
                                            onClick={() => handleStatusToggle(issue.id, issue.status)}
                                            style={{
                                                background: issue.status === 'RESOLVED' ? '#FFF1F2' : '#DCFCE7',
                                                color: issue.status === 'RESOLVED' ? '#E11D48' : '#15803D',
                                                border: '1px solid',
                                                borderColor: issue.status === 'RESOLVED' ? '#FECACA' : '#BBF7D0',
                                                padding: '6px 12px',
                                                borderRadius: '8px',
                                                fontSize: '0.8rem',
                                                fontWeight: 700,
                                                cursor: 'pointer',
                                                transition: 'all 0.2s'
                                            }}
                                        >
                                            {updatingId === issue.id 
                                                ? 'Updating...' 
                                                : (issue.status === 'RESOLVED' ? 'Reopen Issue' : 'Mark Resolved')
                                            }
                                        </button>
                                    </td>
                                </tr>
                            ))}
                            {filteredIssues.length === 0 && (
                                <tr>
                                    <td colSpan="6" style={{ textAlign: 'center', padding: '3rem', color: '#94A3B8', fontStyle: 'italic' }}>
                                        No student issues found matching current criteria.
                                    </td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>
            )}
        </div>
    );
}
