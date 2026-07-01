import React, { useEffect, useState } from 'react';
import api from '../../api';
import './student.css';

export default function StudentDashboard() {
    const [progress, setProgress] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        const fetchProgress = async () => {
            try {
                const response = await api.get('/student/progress');
                setProgress(response.data);
            } catch {
                setError('Failed to load academic progress. Please ensure your profile is set up.');
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

    const radius = 85;
    const circumference = 2 * Math.PI * radius;
    const offset = circumference - (progress?.completionPercentage / 100) * circumference;

    return (
        <div className="student-dashboard animate-fade">
            <header className="student-hero">
                <div className="hero-content">
                    <span className="welcome-tag">Student Overview</span>
                    <h1>Welcome Back, <span className="highlight">{progress.studentName}</span></h1>
                    <p>{progress.degree} • {progress.specialization} • Batch of 2025</p>
                </div>
                <div className="hero-stats">
                    <div className="hero-stat-card">
                        <span className="label">GPA</span>
                        <span className="value">3.82</span>
                    </div>
                    <div className="hero-stat-card">
                        <span className="label">Rank</span>
                        <span className="value">#12</span>
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
                            <span className="big-percent">{progress.completionPercentage}%</span>
                            <span className="sub-label">Audit Score</span>
                        </div>
                    </div>

                    <div className="credit-pills">
                        <div className="pill">
                            <strong>{progress.totalCreditsCompleted}</strong>
                            <span>Earned</span>
                        </div>
                        <div className="pill dark">
                            <strong>{progress.totalCreditsRequired}</strong>
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
                        {Object.entries(progress.categorySummaries).map(([name, data]) => (
                            <div key={name} className="cat-row">
                                <div className="cat-meta">
                                    <span className="cat-name">{name}</span>
                                    <span className="cat-count">{data.completed}/{data.required}</span>
                                </div>
                                <div className="cat-progress-bg">
                                    <div 
                                        className="cat-progress-fill" 
                                        style={{ width: `${data.percentage}%` }}
                                    ></div>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            </div>

            {/* Course History Section */}
            <section className="history-section">
                <div className="section-header">
                    <h2>Academic Transcript</h2>
                    <div className="filters">
                        <button className="filter-chip active">All Courses</button>
                        <button className="filter-chip">Mandatory</button>
                        <button className="filter-chip">Electives</button>
                    </div>
                </div>

                <div className="transcript-card">
                    <table className="transcript-table">
                        <thead>
                            <tr>
                                <th>Code</th>
                                <th>Course Title</th>
                                <th>Category</th>
                                <th>Credits</th>
                                <th>Grade</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            {progress.completedCourses.map((course, idx) => (
                                <tr key={idx} className="course-row">
                                    <td><code className="code-pill">{course.courseCode}</code></td>
                                    <td><strong>{course.courseName}</strong></td>
                                    <td><span className="cat-tag">{course.category}</span></td>
                                    <td>{course.credits}</td>
                                    <td><span className="grade-box">{course.grade}</span></td>
                                    <td><span className="status-tag success">Pass</span></td>
                                </tr>
                            ))}
                            {progress.missingMandatory.map((course, idx) => (
                                <tr key={`missing-${idx}`} className="course-row pending">
                                    <td><code className="code-pill">PENDING</code></td>
                                    <td className="pending-text"><strong>{course.courseName}</strong></td>
                                    <td><span className="cat-tag">{course.category}</span></td>
                                    <td>{course.credits}</td>
                                    <td>—</td>
                                    <td><span className="status-tag warning">Required</span></td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    );
}
