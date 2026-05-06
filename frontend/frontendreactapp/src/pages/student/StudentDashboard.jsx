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
            } catch (err) {
                setError('Failed to load academic progress. Please ensure your profile is set up.');
            } finally {
                setLoading(false);
            }
        };
        fetchProgress();
    }, []);

    if (loading) return (
        <div className="loader-container">
            <div className="loader"></div>
            <p>Analyzing Academic Progress...</p>
        </div>
    );

    if (error) return <div className="student-dashboard"><div className="alert error">{error}</div></div>;

    const radius = 90;
    const circumference = 2 * Math.PI * radius;
    const offset = circumference - (progress?.completionPercentage / 100) * circumference;

    return (
        <div className="student-dashboard">
            <header className="page-header">
                <h1>Academic Progress Tracker</h1>
                <p>Welcome, <strong>{progress.studentName}</strong>. You are enrolled in <strong>{progress.degree} ({progress.specialization})</strong>.</p>
            </header>

            <div className="dashboard-grid">
                {/* Summary Card with Circle Progress */}
                <div className="summary-card">
                    <h3>Overall Completion</h3>
                    <div className="progress-circle-container">
                        <svg className="progress-circle-svg" width="220" height="220">
                            <circle className="progress-circle-bg" cx="110" cy="110" r={radius} />
                            <circle 
                                className="progress-circle-fill" 
                                cx="110" cy="110" r={radius} 
                                style={{ strokeDasharray: circumference, strokeDashoffset: offset }}
                            />
                        </svg>
                        <div className="progress-text">
                            <span className="percentage">{progress.completionPercentage}%</span>
                            <span className="label">Complete</span>
                        </div>
                    </div>
                    
                    <div className="stats-row">
                        <div className="mini-stat">
                            <span className="val">{progress.totalCreditsCompleted}</span>
                            <span className="lbl">Earned</span>
                        </div>
                        <div className="mini-stat">
                            <span className="val">{progress.totalCreditsRequired}</span>
                            <span className="lbl">Required</span>
                        </div>
                    </div>
                </div>

                {/* Category Breakdown */}
                <div className="categories-card">
                    <h3>Credit Breakdown by Category</h3>
                    <div className="category-list" style={{ marginTop: '2rem' }}>
                        {Object.entries(progress.categorySummaries).map(([name, data]) => (
                            <div key={name} className="category-item">
                                <div className="category-info">
                                    <h4>{name}</h4>
                                    <span>{data.completed} / {data.required} Credits</span>
                                </div>
                                <div className="category-bar-bg">
                                    <div 
                                        className="category-bar-fill" 
                                        style={{ width: `${data.percentage}%` }}
                                    ></div>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            </div>

            {/* Course History Table */}
            <div className="course-table-card">
                <h3>Course History</h3>
                <div className="table-wrapper" style={{ marginTop: '1.5rem' }}>
                    <table className="modern-table">
                        <thead>
                            <tr>
                                <th>Code</th>
                                <th>Course Name</th>
                                <th>Semester</th>
                                <th>Credits</th>
                                <th>Grade</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            {progress.completedCourses.map((course, idx) => (
                                <tr key={idx}>
                                    <td><code>{course.courseCode}</code></td>
                                    <td><strong>{course.courseName}</strong></td>
                                    <td>{course.semester}</td>
                                    <td>{course.credits}</td>
                                    <td><span className="grade-badge">{course.grade}</span></td>
                                    <td><span className="status-badge completed">Completed</span></td>
                                </tr>
                            ))}
                            {progress.missingMandatory.map((course, idx) => (
                                <tr key={`missing-${idx}`}>
                                    <td><code>{course.courseCode}</code></td>
                                    <td style={{ color: 'var(--primary-red)' }}><strong>{course.courseName}</strong></td>
                                    <td>-</td>
                                    <td>{course.credits}</td>
                                    <td>-</td>
                                    <td><span className="status-badge pending">Pending</span></td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
}
