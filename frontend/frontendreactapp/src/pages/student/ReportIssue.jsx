import React, { useEffect, useState } from 'react';
import api from '../../api';
import './student.css';

export default function ReportIssue() {
    const [issues, setIssues] = useState([]);
    const [title, setTitle] = useState('');
    const [description, setDescription] = useState('');
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);
    const [error, setError] = useState('');
    const [success, setSuccess] = useState('');

    const fetchIssues = async () => {
        try {
            const response = await api.get('/student/issues');
            setIssues(response.data);
        } catch (err) {
            setError('Failed to load your reported issues.');
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchIssues();
    }, []);

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!title.trim() || !description.trim()) return;

        setSubmitting(true);
        setError('');
        setSuccess('');

        try {
            await api.post('/student/issues', { title, description });
            setSuccess('Issue reported successfully. HOD/Admin will review it shortly.');
            setTitle('');
            setDescription('');
            fetchIssues(); // Refresh list
        } catch (err) {
            setError(err.response?.data || 'Failed to submit issue.');
        } finally {
            setSubmitting(false);
        }
    };

    return (
        <div className="student-dashboard animate-fade" style={{ paddingBottom: '3rem' }}>
            <header className="student-hero" style={{ background: 'linear-gradient(135deg, #8B0000 0%, #1e293b 100%)', minHeight: 'auto', padding: '2.5rem 3rem', borderRadius: '24px', marginBottom: '2.5rem' }}>
                <div className="hero-content">
                    <span className="welcome-tag" style={{ background: 'rgba(255, 255, 255, 0.15)', color: '#fff' }}>Support Desk</span>
                    <h1 style={{ fontSize: '2.2rem', margin: '0.5rem 0', color: '#fff' }}>Report Academic Issues</h1>
                    <p style={{ color: 'rgba(255, 255, 255, 0.85)', fontSize: '1rem' }}>
                        Submit your curriculum tracking, course registration, or system discrepancies to HOD/Admin.
                    </p>
                </div>
            </header>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1.5fr', gap: '2rem' }}>
                {/* Submit Issue Card */}
                <div className="glass-card" style={{ padding: '2rem', background: '#fff', borderRadius: '24px', boxShadow: '0 10px 30px rgba(0,0,0,0.02)', border: '1px solid #E2E8F0', height: 'fit-content' }}>
                    <h3 style={{ fontSize: '1.2rem', fontWeight: 800, color: '#0F172A', marginBottom: '1.5rem' }}>Submit New Issue</h3>
                    
                    {error && <div className="alert error" style={{ marginBottom: '1.25rem' }}>⚠️ {error}</div>}
                    {success && <div className="alert success" style={{ marginBottom: '1.25rem' }}>✓ {success}</div>}

                    <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '1.25rem' }}>
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                            <label style={{ fontSize: '0.85rem', fontWeight: 700, color: '#475569' }}>Issue Subject / Title</label>
                            <input 
                                type="text" 
                                value={title}
                                onChange={(e) => setTitle(e.target.value)}
                                placeholder="e.g. Missing HTE elective requirement"
                                className="input-field" 
                                style={{ padding: '12px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none' }}
                                required
                            />
                        </div>
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                            <label style={{ fontSize: '0.85rem', fontWeight: 700, color: '#475569' }}>Description of the Issue</label>
                            <textarea 
                                value={description}
                                onChange={(e) => setDescription(e.target.value)}
                                placeholder="Describe your problem in detail..."
                                className="input-field" 
                                rows="6"
                                style={{ padding: '12px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none', resize: 'vertical' }}
                                required
                            ></textarea>
                        </div>
                        <button 
                            type="submit" 
                            disabled={submitting}
                            className="btn-primary" 
                            style={{ 
                                background: '#8B0000', 
                                color: '#fff', 
                                border: 'none', 
                                padding: '12px', 
                                borderRadius: '10px', 
                                fontWeight: 700, 
                                cursor: 'pointer', 
                                transition: 'all 0.2s' 
                            }}
                        >
                            {submitting ? 'Submitting issue...' : 'Submit Issue to HOD'}
                        </button>
                    </form>
                </div>

                {/* History Card */}
                <div className="transcript-card" style={{ padding: '2rem', background: '#fff', borderRadius: '24px', boxShadow: '0 10px 30px rgba(0,0,0,0.02)', border: '1px solid #E2E8F0' }}>
                    <h3 style={{ fontSize: '1.2rem', fontWeight: 800, color: '#0F172A', marginBottom: '1.5rem' }}>Support Ticket History</h3>

                    {loading ? (
                        <p style={{ color: '#64748B', fontStyle: 'italic' }}>Loading issue history...</p>
                    ) : issues.length > 0 ? (
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
                            {issues.map((issue) => (
                                <div key={issue.id} style={{ borderBottom: '1px solid #F1F5F9', paddingBottom: '1rem' }}>
                                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '6px' }}>
                                        <h4 style={{ fontSize: '1.05rem', fontWeight: 700, color: '#1E293B', margin: 0 }}>{issue.title}</h4>
                                        <span className={`status-tag ${issue.status === 'RESOLVED' ? 'success' : 'warning'}`} style={{ 
                                            background: issue.status === 'RESOLVED' ? '#DCFCE7' : '#FEF3C7', 
                                            color: issue.status === 'RESOLVED' ? '#15803D' : '#D97706',
                                            border: issue.status === 'RESOLVED' ? '1px solid #BBF7D0' : '1px solid #FDE68A',
                                            padding: '4px 10px',
                                            borderRadius: '20px',
                                            fontSize: '0.75rem',
                                            fontWeight: 700
                                        }}>
                                            {issue.status}
                                        </span>
                                    </div>
                                    <p style={{ fontSize: '0.9rem', color: '#475569', margin: '4px 0 8px 0', lineHeight: '1.4' }}>{issue.description}</p>
                                    <div style={{ fontSize: '0.75rem', color: '#94A3B8' }}>
                                        Reported on: {new Date(issue.createdAt).toLocaleString()}
                                        {issue.resolvedAt && (
                                            <span style={{ marginLeft: '12px', color: '#15803D', fontWeight: 600 }}>
                                                • Resolved: {new Date(issue.resolvedAt).toLocaleString()}
                                            </span>
                                        )}
                                    </div>
                                </div>
                            ))}
                        </div>
                    ) : (
                        <div style={{ textAlign: 'center', padding: '3rem', color: '#94A3B8', fontStyle: 'italic' }}>
                            You have not submitted any issues yet.
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}
