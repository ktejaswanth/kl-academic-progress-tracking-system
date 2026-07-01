import React, { useEffect, useState } from 'react';
import api from '../../api';
import './student.css';

export default function BucketProgressView() {
    const [progressData, setProgressData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [expandedBucket, setExpandedBucket] = useState(null);

    useEffect(() => {
        const fetchProgress = async () => {
            try {
                const response = await api.get('/dyod/progress/student/me');
                setProgressData(response.data);
            } catch (err) {
                setError('Failed to load academic progress. Ensure your degree path is assigned.');
            } finally {
                setLoading(false);
            }
        };
        fetchProgress();
    }, []);

    const toggleExpand = (bucketId) => {
        if (expandedBucket === bucketId) {
            setExpandedBucket(null);
        } else {
            setExpandedBucket(bucketId);
        }
    };

    if (loading) return (
        <div className="student-loader-container">
            <div className="premium-loader"></div>
            <p>Gathering Bucket Specifications...</p>
        </div>
    );

    if (error) return (
        <div className="student-dashboard">
            <div className="alert error">{error}</div>
        </div>
    );

    const { buckets } = progressData;

    return (
        <div className="student-dashboard animate-fade">
            <header className="student-hero">
                <div className="hero-content">
                    <span className="welcome-tag">Curriculum Details</span>
                    <h1>DYOD Bucket Structure</h1>
                    <p>Track your satisfaction progress per course bucket</p>
                </div>
            </header>

            <div className="buckets-view-container">
                {buckets.map((bucket) => {
                    const isExpanded = expandedBucket === bucket.bucketId;
                    const statusClass = 
                        bucket.status === 'COMPLETED' ? 'success' : 
                        bucket.status === 'IN_PROGRESS' ? 'warning' : 'danger';

                    return (
                        <div 
                            key={bucket.bucketId} 
                            className={`glass-card bucket-card ${isExpanded ? 'expanded' : ''}`}
                        >
                            <div 
                                className="bucket-card-header" 
                                onClick={() => toggleExpand(bucket.bucketId)}
                                style={{ cursor: 'pointer' }}
                            >
                                <div className="bucket-info-main">
                                    <div className="bucket-code-wrapper">
                                        <span className="code-pill">{bucket.bucketCode}</span>
                                        <span className="cat-tag">{bucket.bucketCategory}</span>
                                    </div>
                                    <h3 className="bucket-title-text">{bucket.bucketName}</h3>
                                </div>

                                <div className="bucket-meta-stats">
                                    <div className="credits-display">
                                        <span className="credits-number">
                                            <strong>{bucket.earnedCredits}</strong> / {bucket.requiredCredits}
                                        </span>
                                        <span className="credits-label">Credits Earned</span>
                                    </div>

                                    <div className="progress-radial-wrapper">
                                        <span className={`status-tag ${statusClass}`}>{bucket.status}</span>
                                    </div>
                                    
                                    <span className="expand-indicator">{isExpanded ? '▲' : '▼'}</span>
                                </div>
                            </div>

                            <div className="bucket-progress-row">
                                <div className="cat-progress-bg">
                                    <div 
                                        className={`cat-progress-fill ${statusClass}`}
                                        style={{ width: `${bucket.completionPercentage}%` }}
                                    ></div>
                                </div>
                                <span className="percentage-text">{bucket.completionPercentage}%</span>
                            </div>

                            {isExpanded && (
                                <div className="bucket-drilldown animate-fade">
                                    <hr className="divider" />
                                    
                                    <div className="course-split-grid">
                                        {/* Completed Courses */}
                                        <div className="course-list-box">
                                            <h4>Completed Courses ({bucket.completedCourses?.length || 0})</h4>
                                            {bucket.completedCourses && bucket.completedCourses.length > 0 ? (
                                                <div className="course-mini-table">
                                                    {bucket.completedCourses.map((c, idx) => (
                                                        <div key={idx} className="course-mini-row">
                                                            <div className="c-info">
                                                                <span className="c-code">{c.courseCode}</span>
                                                                <span className="c-name">{c.courseName}</span>
                                                            </div>
                                                            <div className="c-stats" style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                                                                <span className="c-type" style={{ fontSize: '0.8rem', color: '#636E72', border: '1px solid #E9ECEF', padding: '2px 6px', borderRadius: '4px' }}>{c.courseType || 'Regular'}</span>
                                                                <span className="c-ltps" style={{ fontSize: '0.8rem', color: '#8B0000', fontWeight: 600 }}>{c.ltps}</span>
                                                                <span className="c-credits">{c.credits} LPU</span>
                                                            </div>
                                                        </div>
                                                    ))}
                                                </div>
                                            ) : (
                                                <p className="no-courses-placeholder">No courses completed in this bucket yet.</p>
                                            )}
                                        </div>

                                        {/* Pending Courses */}
                                        <div className="course-list-box">
                                            <h4>Suggested / Pending Courses ({bucket.pendingCourses?.length || 0})</h4>
                                            {bucket.pendingCourses && bucket.pendingCourses.length > 0 ? (
                                                <div className="course-mini-table">
                                                    {bucket.pendingCourses.map((c, idx) => (
                                                        <div key={idx} className="course-mini-row pending-course">
                                                            <div className="c-info">
                                                                <span className="c-code">{c.courseCode}</span>
                                                                <span className="c-name">{c.courseName}</span>
                                                            </div>
                                                            <div className="c-stats">
                                                                {c.isMandatory && (
                                                                    <span className="mandatory-star" title="Mandatory Course">★</span>
                                                                )}
                                                                <span className="c-credits">{c.credits} LPU</span>
                                                                <span className="sem-offered">Sem: {c.semesterOffered || 'Any'}</span>
                                                            </div>
                                                        </div>
                                                    ))}
                                                </div>
                                            ) : (
                                                <p className="no-courses-placeholder success-msg">All bucket requirements satisfied!</p>
                                            )}
                                        </div>
                                    </div>
                                </div>
                            )}
                        </div>
                    );
                })}
            </div>
        </div>
    );
}
