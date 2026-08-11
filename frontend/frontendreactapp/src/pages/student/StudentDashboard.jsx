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
                // Try new unified progress API first
                const response = await api.get('/student/progress/dashboard');
                setProgressData(response.data);
            } catch (err) {
                try {
                    // Fallback to legacy endpoint
                    const response = await api.get('/dyod/progress/student/me');
                    setProgressData(response.data);
                } catch (fallbackErr) {
                    setError('Failed to load academic progress. Your degree path might not be assigned yet.');
                }
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

    const student = progressData?.student || {};
    const degreePath = progressData?.degreePath || {};
    const status = progressData?.degreeStatus || progressData?.status || {};
    const buckets = progressData?.buckets || [];
    const specializationProgress = progressData?.specializationProgress;

    const studentName = student.fullName || progressData?.studentName || 'Student';
    const department = student.department || progressData?.department || 'AIDS';
    const degreeTypeName = degreePath.degreeTypeName || student.degreeType || 'Regular';
    const addonName = degreePath.addonName || student.addonName || '';

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

    const completionPercentage = status.completionPercentage || 0.0;
    const isEligible = status.isDegreeEligible || status.degreeEligible;

    const radius = 85;
    const circumference = 2 * Math.PI * radius;
    const offset = circumference - (completionPercentage / 100) * circumference;

    const categories = {};
    buckets.forEach(b => {
        const cat = b.bucketCategory || 'Other';
        if (!categories[cat]) categories[cat] = { earned: 0, required: 0 };
        categories[cat].earned += (b.earnedCredits || 0);
        categories[cat].required += (b.requiredCredits || 0);
    });

    return (
        <div className="student-dashboard animate-fade">
            <header className="student-hero">
                <div className="hero-content">
                    <span className="welcome-tag">Student Overview</span>
                    <h1>Welcome Back, <span className="highlight">{studentName}</span></h1>
                    <p>{department} • {degreeTypeName} {addonName ? `• ${addonName}` : ''}</p>
                </div>
                <div className="hero-stats" style={{ alignItems: 'center' }}>
                    <div className="hero-stat-card" style={{ display: 'flex', flexDirection: 'column', gap: '8px', alignItems: 'center' }}>
                        <span className="label">Degree Status</span>
                        <span className={`value ${isEligible ? 'success' : ''}`}>
                            {isEligible ? 'ELIGIBLE' : 'IN PROGRESS'}
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
                        <span className="badge-outline">Y23 AIDS Path</span>
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
                            <span className="big-percent">{completionPercentage}%</span>
                            <span className="sub-label">Completion</span>
                        </div>
                    </div>

                    <div className="credit-pills">
                        <div className="pill">
                            <strong>{status.totalEarnedCredits || 0}</strong>
                            <span>Earned Credits</span>
                        </div>
                        <div className="pill dark">
                            <strong>{status.totalRequiredCredits || degreePath.totalRequiredCredits || 163}</strong>
                            <span>Required Credits</span>
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

            {/* Specialization Card if present */}
            {specializationProgress && (
                <section className="history-section" style={{ marginTop: '24px' }}>
                    <div className="glass-card" style={{ padding: '20px' }}>
                        <div className="card-header">
                            <h3>Specialization: {specializationProgress.specializationName}</h3>
                            <span className={`status-tag ${specializationProgress.status === 'COMPLETED' ? 'success' : 'warning'}`}>{specializationProgress.status}</span>
                        </div>
                        <p style={{ marginTop: '8px', color: '#636E72' }}>
                            Earned <strong>{specializationProgress.earnedCredits}</strong> / {specializationProgress.requiredCredits} Credits ({specializationProgress.progressPercentage}%)
                        </p>
                    </div>
                </section>
            )}

            {/* Bucket Progress Section */}
            <section className="history-section" style={{ marginTop: '24px' }}>
                <div className="section-header">
                    <h2>Bucket Requirements & Progress</h2>
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
                                    <td><span className="cat-tag">{bucket.bucketCategory || 'Core'}</span></td>
                                    <td>
                                        <div className="bucket-credits-bar">
                                            <span>{bucket.earnedCredits} / {bucket.requiredCredits} Credits</span>
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
