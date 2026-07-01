import React, { useEffect, useState } from 'react';
import api from '../../api';
import './student.css';

export default function StudentDashboard() {
    const [progressData, setProgressData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        const fetchProgress = async () => {
            try {
                const response = await api.get('/dyod/progress/student/me');
                setProgressData(response.data);
            } catch (err) {
                setError('Failed to load academic progress. Your degree path might not be assigned yet.');
            } finally {
                setLoading(false);
            }
        };
        fetchProgress();
    }, []);

    if (loading) return (
        <div className="student-loader-container">
            <div className="premium-loader"></div>
            <p>Analyzing Academic Records...</p>
        </div>
    );

    if (error) return <div className="student-dashboard"><div className="alert error">{error}</div></div>;

    const { status, buckets, studentName, department, subDepartment, specialization } = progressData;

    const handleDownloadReport = async () => {
        try {
            const response = await api.get('/reports/student/me/excel', { responseType: 'blob' });
            const url = window.URL.createObjectURL(new Blob([response.data]));
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', `${studentName.replace(/\s+/g, '_')}_progress_report.xlsx`);
            document.body.appendChild(link);
            link.click();
            link.parentNode.removeChild(link);
        } catch (err) {
            alert('Failed to download progress report.');
        }
    };

    const radius = 85;
    const circumference = 2 * Math.PI * radius;
    const offset = circumference - (status.completionPercentage / 100) * circumference;

    // Group buckets by category for the breakdown
    const categories = {};
    buckets.forEach(b => {
        const cat = b.bucketCategory || 'Other';
        if (!categories[cat]) categories[cat] = { earned: 0, required: 0 };
        categories[cat].earned += b.earnedCredits;
        categories[cat].required += b.requiredCredits;
    });

    return (
        <div className="student-dashboard animate-fade">
            <header className="student-hero">
                <div className="hero-content">
                    <span className="welcome-tag">Student Overview</span>
                    <h1>Welcome Back, <span className="highlight">{studentName}</span></h1>
                    <p>{department} • {subDepartment} {specialization ? `• ${specialization}` : ''}</p>
                </div>
                <div className="hero-stats" style={{ alignItems: 'center' }}>
                    <div className="hero-stat-card" style={{ display: 'flex', flexDirection: 'column', gap: '8px', alignItems: 'center' }}>
                        <span className="label">Status</span>
                        <span className={`value ${status.isDegreeEligible ? 'success' : ''}`}>
                            {status.isDegreeEligible ? 'Eligible' : 'In Progress'}
                        </span>
                        <button 
                            onClick={handleDownloadReport}
                            className="filter-chip active" 
                            style={{ margin: '8px 0 0 0', padding: '6px 12px', fontSize: '0.8rem', background: '#FFD700', color: '#8B0000', border: 'none', borderRadius: '8px', fontWeight: 'bold', cursor: 'pointer' }}
                        >
                            📥 Download Report
                        </button>
                    </div>
                </div>
            </header>

            <div className="student-grid-layout">
                {/* Visual Completion Card */}
                <div className="glass-card main-progress">
                    <div className="card-header">
                        <h3>Degree Completion</h3>
                        <span className="badge-outline">Live Sync</span>
                    </div>
                    
                    <div className="circular-container">
                        <svg width="240" height="240" viewBox="0 0 240 240">
                            <defs>
                                <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="100%">
                                    <stop offset="0%" style={{stopColor: '#8B0000', stopOpacity: 1}} />
                                    <stop offset="100%" style={{stopColor: '#D32F2F', stopOpacity: 1}} />
                                </linearGradient>
                            </defs>
                            <circle className="circle-bg" cx="120" cy="120" r={radius} />
                            <circle 
                                className="circle-progress" 
                                cx="120" cy="120" r={radius} 
                                style={{ 
                                    strokeDasharray: circumference, 
                                    strokeDashoffset: offset,
                                    stroke: 'url(#grad1)'
                                }}
                            />
                        </svg>
                        <div className="inner-text">
                            <span className="big-percent">{status.completionPercentage}%</span>
                            <span className="sub-label">Audit Score</span>
                        </div>
                    </div>

                    <div className="credit-pills">
                        <div className="pill">
                            <strong>{status.totalEarnedCredits}</strong>
                            <span>Earned</span>
                        </div>
                        <div className="pill dark">
                            <strong>{status.totalRequiredCredits}</strong>
                            <span>Required</span>
                        </div>
                    </div>
                </div>

                {/* Categories Card */}
                <div className="glass-card categories-breakdown">
                    <div className="card-header">
                        <h3>Academic Categories</h3>
                        <p>Credit distribution across your curriculum</p>
                    </div>
                    
                    <div className="category-scroll">
                        {Object.entries(categories).map(([name, data]) => {
                            const percent = data.required > 0 ? Math.min(100, (data.earned / data.required) * 100) : 100;
                            return (
                                <div key={name} className="cat-row">
                                    <div className="cat-meta">
                                        <span className="cat-name">{name}</span>
                                        <span className="cat-count">{data.earned}/{data.required}</span>
                                    </div>
                                    <div className="cat-progress-bg">
                                        <div 
                                            className="cat-progress-fill" 
                                            style={{ width: `${percent}%` }}
                                        ></div>
                                    </div>
                                </div>
                            );
                        })}
                    </div>
                </div>
            </div>

            {/* Bucket Progress Section */}
            <section className="history-section">
                <div className="section-header">
                    <h2>Bucket Progress</h2>
                </div>

                <div className="transcript-card">
                    <table className="transcript-table">
                        <thead>
                            <tr>
                                <th>Bucket</th>
                                <th>Category</th>
                                <th>Earned / Required</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            {buckets.map((bucket, idx) => (
                                <tr key={idx} className={`course-row ${bucket.status === 'COMPLETED' ? '' : 'pending'}`}>
                                    <td>
                                        <strong>{bucket.bucketCode}</strong>
                                        <div className="sub-text">{bucket.bucketName}</div>
                                    </td>
                                    <td><span className="cat-tag">{bucket.bucketCategory}</span></td>
                                    <td>
                                        <div className="bucket-credits-bar">
                                            <span>{bucket.earnedCredits} / {bucket.requiredCredits}</span>
                                            <div className="mini-progress-bg">
                                                <div 
                                                    className="mini-progress-fill" 
                                                    style={{ width: `${bucket.completionPercentage}%` }}
                                                ></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        {bucket.status === 'COMPLETED' ? (
                                            <span className="status-tag success">Completed</span>
                                        ) : bucket.status === 'IN_PROGRESS' ? (
                                            <span className="status-tag warning">In Progress</span>
                                        ) : (
                                            <span className="status-tag danger">Pending</span>
                                        )}
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    );
}
