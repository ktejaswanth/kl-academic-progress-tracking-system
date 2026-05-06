import React, { useState, useEffect } from 'react';
import api from '../../api';
import './faculty.css';

export default function FacultyDashboard() {
    const [stats, setStats] = useState({
        totalStudents: 0,
        recentUploads: 0,
        pendingAudits: 0
    });

    useEffect(() => {
        // In a real app, we would fetch these from a faculty stats endpoint
        // For now, we simulate with some data
        setStats({
            totalStudents: 124,
            recentUploads: 45,
            pendingAudits: 12
        });
    }, []);

    return (
        <div className="faculty-dashboard">
            <header className="dashboard-header">
                <div className="welcome-text">
                    <h1>Faculty Portal <span className="badge">Verified</span></h1>
                    <p>Academic year 2023-24 • Semester 2</p>
                </div>
            </header>

            <div className="stats-grid">
                <div className="stat-card crimson">
                    <div className="stat-icon">👥</div>
                    <div className="stat-info">
                        <h3>Total Students</h3>
                        <div className="value">{stats.totalStudents}</div>
                        <p>Under your supervision</p>
                    </div>
                </div>
                <div className="stat-card alabaster">
                    <div className="stat-icon text-crimson">📂</div>
                    <div className="stat-info">
                        <h3 className="text-crimson">Recent Uploads</h3>
                        <div className="value text-dark">{stats.recentUploads}</div>
                        <p className="text-muted">In the last 30 days</p>
                    </div>
                </div>
                <div className="stat-card dark">
                    <div className="stat-icon">⚖️</div>
                    <div className="stat-info">
                        <h3>Pending Audits</h3>
                        <div className="value">{stats.pendingAudits}</div>
                        <p>Requiring attention</p>
                    </div>
                </div>
            </div>

            <div className="dashboard-content-grid">
                <div className="content-card quick-actions">
                    <h3>Quick Management</h3>
                    <div className="action-buttons">
                        <a href="/faculty/upload" className="action-btn">
                            <span className="icon">📝</span>
                            <div className="btn-text">
                                <strong>Bulk Student Upload</strong>
                                <span>Register multiple students via Excel</span>
                            </div>
                        </a>
                        <button className="action-btn">
                            <span className="icon">🔍</span>
                            <div className="btn-text">
                                <strong>Audit Records</strong>
                                <span>Review individual student progress</span>
                            </div>
                        </button>
                    </div>
                </div>

                <div className="content-card recent-activity">
                    <h3>System Announcements</h3>
                    <div className="announcement-list">
                        <div className="announcement-item">
                            <div className="date">May 05</div>
                            <div className="text">New academic audit requirements for Batch 2021 have been updated.</div>
                        </div>
                        <div className="announcement-item">
                            <div className="date">May 02</div>
                            <div className="text">Quarterly database maintenance completed successfully.</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
