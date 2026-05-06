import React from 'react';

export default function AdminDashboard() {
    const stats = [
        { label: 'Total Students', value: '1,248', icon: '🎓', color: '#e11d48' },
        { label: 'Active Faculty', value: '42', icon: '👨‍🏫', color: '#9f1239' },
        { label: 'Pending Audits', value: '156', icon: '📄', color: '#f43f5e' },
        { label: 'System Health', value: '99.9%', icon: '⚡', color: '#ef4444' },
    ];

    return (
        <div className="dashboard-container">
            <header className="dashboard-header">
                <h2>Overview Dashboard</h2>
                <p>Real-time analytics and management summary.</p>
            </header>

            <div className="stats-grid">
                {stats.map((stat, index) => (
                    <div key={index} className="stat-card-premium" style={{ '--accent': stat.color }}>
                        <div className="stat-icon-wrapper">
                            <span className="stat-icon-large">{stat.icon}</span>
                        </div>
                        <div className="stat-details">
                            <span className="stat-value-large">{stat.value}</span>
                            <span className="stat-label-muted">{stat.label}</span>
                        </div>
                        <div className="stat-progress-bar">
                            <div className="progress-fill" style={{ width: '70%' }}></div>
                        </div>
                    </div>
                ))}
            </div>

            <div className="dashboard-main-grid">
                <div className="dashboard-card info-card">
                    <h3>Recent System Activities</h3>
                    <div className="activity-list">
                        <div className="activity-item">
                            <div className="activity-dot success"></div>
                            <div className="activity-info">
                                <strong>Bulk Upload Completed</strong>
                                <p>Faculty "Dr. Smith" uploaded 50 students.</p>
                                <span className="activity-time">2 minutes ago</span>
                            </div>
                        </div>
                        <div className="activity-item">
                            <div className="activity-dot warning"></div>
                            <div className="activity-info">
                                <strong>New Faculty Added</strong>
                                <p>Super Admin created account for "Prof. Jane".</p>
                                <span className="activity-time">45 minutes ago</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div className="dashboard-card promo-card">
                    <div className="promo-content">
                        <h3>Identity Management</h3>
                        <p>Generate secure credentials and manage academic audits with one click.</p>
                        <button className="btn-primary">View Reports</button>
                    </div>
                    <div className="promo-visual">🚀</div>
                </div>
            </div>

            <style>{`
                .dashboard-header { margin-bottom: 2.5rem; }
                .dashboard-header h2 { font-size: 2rem; color: var(--deep-red); font-weight: 800; }
                
                .stats-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                    gap: 1.5rem;
                    margin-bottom: 3rem;
                }

                .stat-card-premium {
                    background: white;
                    padding: 1.5rem;
                    border-radius: 20px;
                    border: 1px solid var(--border);
                    position: relative;
                    overflow: hidden;
                    transition: transform 0.3s;
                }

                .stat-card-premium:hover { transform: translateY(-5px); }

                .stat-icon-wrapper {
                    width: 50px;
                    height: 50px;
                    background: var(--soft-red);
                    border-radius: 12px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin-bottom: 1rem;
                }

                .stat-icon-large { font-size: 1.5rem; }
                
                .stat-details { display: flex; flex-direction: column; }
                .stat-value-large { font-size: 1.8rem; font-weight: 800; color: var(--text-main); }
                .stat-label-muted { color: var(--text-muted); font-size: 0.9rem; font-weight: 600; }

                .stat-progress-bar {
                    height: 4px;
                    background: var(--border);
                    border-radius: 2px;
                    margin-top: 1rem;
                }

                .progress-fill {
                    height: 100%;
                    background: var(--accent);
                    border-radius: 2px;
                }

                .dashboard-main-grid {
                    display: grid;
                    grid-template-columns: 1.5fr 1fr;
                    gap: 2rem;
                }

                .dashboard-card {
                    background: white;
                    padding: 2rem;
                    border-radius: 24px;
                    border: 1px solid var(--border);
                }

                .activity-list { margin-top: 1.5rem; display: flex; flex-direction: column; gap: 1.5rem; }
                .activity-item { display: flex; gap: 1rem; }
                .activity-dot { width: 12px; height: 12px; border-radius: 50%; margin-top: 5px; }
                .activity-dot.success { background: #10b981; }
                .activity-dot.warning { background: var(--primary-red); }
                
                .activity-info strong { display: block; font-size: 1rem; color: var(--text-main); }
                .activity-info p { font-size: 0.9rem; color: var(--text-muted); }
                .activity-time { font-size: 0.8rem; color: var(--primary-red); font-weight: 600; }

                .promo-card {
                    background: linear-gradient(135deg, var(--primary-red) 0%, var(--deep-red) 100%);
                    color: white;
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                }
                .promo-content h3 { font-size: 1.5rem; margin-bottom: 0.5rem; }
                .promo-content p { font-size: 0.95rem; opacity: 0.9; margin-bottom: 1.5rem; }
                .promo-content .btn-primary { background: white; color: var(--primary-red); }
                .promo-visual { font-size: 4rem; opacity: 0.2; }
            `}</style>
        </div>
    );
}
