import React, { useEffect, useState } from 'react';
import api from '../../api';
import './student.css';

export default function EligibilityChecker() {
    const [progressData, setProgressData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        const fetchProgress = async () => {
            try {
                const response = await api.get('/dyod/progress/student/me');
                setProgressData(response.data);
            } catch (err) {
                setError('Failed to retrieve academic progress. Ensure your degree path is assigned.');
            } finally {
                setLoading(false);
            }
        };
        fetchProgress();
    }, []);

    if (loading) return (
        <div className="student-loader-container">
            <div className="premium-loader"></div>
            <p>Running Eligibility Auditor...</p>
        </div>
    );

    if (error) return (
        <div className="student-dashboard">
            <div className="alert error">{error}</div>
        </div>
    );

    const { status, buckets } = progressData;
    const isEligible = status.isDegreeEligible;

    let failedBuckets = [];
    try {
        const parsedDetails = typeof status.details === 'string' ? JSON.parse(status.details) : status.details;
        failedBuckets = parsedDetails?.failedBuckets || [];
    } catch (e) {
        console.error('Error parsing status details', e);
    }

    return (
        <div className="student-dashboard animate-fade">
            <header className="student-hero">
                <div className="hero-content">
                    <span className="welcome-tag">Graduation Eligibility</span>
                    <h1>Degree Audit Status</h1>
                    <p>Track your satisfaction check against your assigned degree path: <strong>{status.degreePath?.pathName || 'N/A'}</strong></p>
                </div>
            </header>

            <div className="eligibility-status-banner glass-card" style={{
                background: isEligible ? 'linear-gradient(135deg, #00b894 0%, #00876c 100%)' : 'linear-gradient(135deg, #8B0000 0%, #4A0000 100%)',
                color: 'white',
                padding: '3rem',
                borderRadius: '32px',
                textAlign: 'center',
                marginBottom: '3rem',
                boxShadow: '0 20px 40px rgba(0,0,0,0.1)'
            }}>
                <div className="eligibility-badge-icon" style={{ fontSize: '5rem', marginBottom: '1rem' }}>
                    {isEligible ? '🎉' : '⚠️'}
                </div>
                <h2 style={{ fontSize: '2.5rem', fontWeight: '800', margin: '0 0 1rem 0' }}>
                    {isEligible ? 'CONGRATULATIONS!' : 'DEGREE IN PROGRESS'}
                </h2>
                <p style={{ fontSize: '1.2rem', opacity: 0.9, maxWidth: '600px', margin: '0 auto' }}>
                    {isEligible 
                        ? 'You have fully satisfied all required course credit buckets and are eligible for degree conferral.'
                        : `You have completed ${status.bucketsCompleted} out of ${status.bucketsTotal} required course buckets. Please complete remaining requirements.`}
                </p>
            </div>

            <div className="student-grid-layout">
                {/* Audit summary */}
                <div className="glass-card">
                    <div className="card-header">
                        <h3>Audit Metrics</h3>
                    </div>
                    <div className="metrics-list" style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', borderBottom: '1px solid #F1F3F5', paddingBottom: '0.8rem' }}>
                            <span style={{ color: '#636E72', fontWeight: 600 }}>Degree Path</span>
                            <strong style={{ color: '#2D3436' }}>{status.degreePath?.pathName} ({status.degreePath?.pathCode})</strong>
                        </div>
                        <div style={{ display: 'flex', justifyContent: 'space-between', borderBottom: '1px solid #F1F3F5', paddingBottom: '0.8rem' }}>
                            <span style={{ color: '#636E72', fontWeight: 600 }}>Total Buckets Satisfied</span>
                            <strong style={{ color: isEligible ? '#00b894' : '#8B0000' }}>{status.bucketsCompleted} / {status.bucketsTotal}</strong>
                        </div>
                        <div style={{ display: 'flex', justifyContent: 'space-between', borderBottom: '1px solid #F1F3F5', paddingBottom: '0.8rem' }}>
                            <span style={{ color: '#636E72', fontWeight: 600 }}>Total Credits Earned</span>
                            <strong style={{ color: '#2D3436' }}>{status.totalEarnedCredits} / {status.totalRequiredCredits}</strong>
                        </div>
                        <div style={{ display: 'flex', justifyContent: 'space-between', borderBottom: '1px solid #F1F3F5', paddingBottom: '0.8rem' }}>
                            <span style={{ color: '#636E72', fontWeight: 600 }}>Completion %</span>
                            <strong style={{ color: '#8B0000' }}>{status.completionPercentage}%</strong>
                        </div>
                        <div style={{ display: 'flex', justifyContent: 'space-between', paddingBottom: '0.8rem' }}>
                            <span style={{ color: '#636E72', fontWeight: 600 }}>Last Audited</span>
                            <span style={{ color: '#636E72' }}>{status.lastEvaluated ? new Date(status.lastEvaluated).toLocaleString() : 'N/A'}</span>
                        </div>
                    </div>
                </div>

                {/* Requirements shortfall checklist */}
                <div className="glass-card">
                    <div className="card-header">
                        <h3>Shortfalls & Missing Credits</h3>
                    </div>
                    {failedBuckets.length > 0 ? (
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
                            {failedBuckets.map((fail, idx) => {
                                const fullBucket = buckets.find(b => b.bucketCode === fail.bucketCode);
                                return (
                                    <div key={idx} className="shortfall-item" style={{
                                        border: '1px solid #FFF5F5',
                                        background: '#FFF5F5',
                                        padding: '1.2rem',
                                        borderRadius: '16px',
                                        display: 'flex',
                                        justifyContent: 'space-between',
                                        alignItems: 'center'
                                    }}>
                                        <div>
                                            <strong style={{ color: '#8B0000', display: 'block' }}>{fail.bucketCode}</strong>
                                            <span style={{ fontSize: '0.85rem', color: '#636E72' }}>
                                                {fullBucket?.bucketName || 'Bucket Requirement'}
                                            </span>
                                        </div>
                                        <div style={{ textAlign: 'right' }}>
                                            <span style={{ fontSize: '0.85rem', display: 'block', color: '#636E72' }}>
                                                Earned: {fail.earned} / {fail.required}
                                            </span>
                                            <strong style={{ color: '#8B0000' }}>
                                                Shortfall: {fail.shortfall} Credits
                                            </strong>
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    ) : (
                        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', height: '100%', color: '#00b894', padding: '2rem' }}>
                            <span style={{ fontSize: '3rem' }}>✓</span>
                            <strong>All credit requirements are fully satisfied!</strong>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}
