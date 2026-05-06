import React from 'react';

export default function AdminDashboard() {
    const stats = [
        { label: 'Total Students', value: '1,248', icon: '🎓', color: '#8B0000' },
        { label: 'Active Faculty', value: '42', icon: '🏫', color: '#8B0000' },
        { label: 'Pending Audits', value: '156', icon: '📄', color: '#8B0000' },
        { label: 'System Health', value: '99.9%', icon: '⚡', color: '#8B0000' },
    ];

    return (
        <div className="dashboard-container animate-fade">
            <header className="dashboard-header">
                <h2>Overview Dashboard</h2>
                <p>Real-time analytics and management summary.</p>
            </header>

            <div className="stats-grid">
                {stats.map((stat, index) => (
                    <div key={index} className="stat-card-premium">
                        <div className="stat-icon-wrapper">
                            <span className="stat-icon-large">{stat.icon}</span>
                        </div>
                        <div className="stat-details">
                            <span className="stat-value-large">{stat.value}</span>
                            <span className="stat-label-muted">{stat.label}</span>
                        </div>
                        <div className="stat-progress-bar">
                            <div className="progress-fill" style={{ width: index % 2 === 0 ? '60%' : '85%' }}></div>
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
                        <button className="btn-reports">View Reports</button>
                    </div>
                </div>
            </div>

            <style>{`
                .dashboard-container {
                    padding: 1rem;
                }
                .dashboard-header { margin-bottom: 2.5rem; }
                .dashboard-header h2 { 
                    font-size: 2.4rem; 
                    color: #8B0000; 
                    font-weight: 800; 
                    margin-bottom: 4px;
                    letter-spacing: -0.5px;
                }
                .dashboard-header p {
                    color: #636E72;
                    font-weight: 500;
                }
                
                .stats-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
                    gap: 1.5rem;
                    margin-bottom: 3.5rem;
                }

                .stat-card-premium {
                    background: white;
                    padding: 2rem 1.5rem;
                    border-radius: 24px;
                    border: 1px solid #E9ECEF;
                    box-shadow: 0 4px 20px rgba(0,0,0,0.02);
                    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                }

                .stat-card-premium:hover { 
                    transform: translateY(-8px);
                    box-shadow: 0 12px 30px rgba(139,0,0,0.08);
                    border-color: #F8D7DA;
                }

                .stat-icon-wrapper {
                    width: 54px;
                    height: 54px;
                    background: #FFF5F5;
                    border-radius: 14px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin-bottom: 1.5rem;
                }

                .stat-icon-large { font-size: 1.5rem; }
                
                .stat-details { display: flex; flex-direction: column; gap: 4px; }
                .stat-value-large { font-size: 2.2rem; font-weight: 800; color: #2D3436; }
                .stat-label-muted { color: #636E72; font-size: 0.95rem; font-weight: 600; }

                .stat-progress-bar {
                    height: 5px;
                    background: #F1F3F5;
                    border-radius: 10px;
                    margin-top: 1.5rem;
                    overflow: hidden;
                }

                .progress-fill {
                    height: 100%;
                    background: #8B0000;
                    border-radius: 10px;
                }

                .dashboard-main-grid {
                    display: grid;
                    grid-template-columns: 1.6fr 1fr;
                    gap: 2rem;
                }

                .dashboard-card {
                    background: white;
                    padding: 2.5rem;
                    border-radius: 28px;
                    border: 1px solid #E9ECEF;
                }

                .dashboard-card h3 {
                    font-size: 1.3rem;
                    font-weight: 800;
                    color: #2D3436;
                    margin-bottom: 2rem;
                }

                .activity-list { display: flex; flex-direction: column; gap: 2rem; }
                .activity-item { display: flex; gap: 1.2rem; align-items: flex-start; }
                .activity-dot { width: 14px; height: 14px; border-radius: 50%; margin-top: 6px; flex-shrink: 0; }
                .activity-dot.success { background: #00B894; box-shadow: 0 0 0 4px #E6F8F4; }
                .activity-dot.warning { background: #8B0000; box-shadow: 0 0 0 4px #FCE8E8; }
                
                .activity-info strong { display: block; font-size: 1.05rem; color: #2D3436; margin-bottom: 2px; }
                .activity-info p { font-size: 0.95rem; color: #636E72; margin-bottom: 6px; }
                .activity-time { font-size: 0.85rem; color: #8B0000; font-weight: 700; }

                .promo-card {
                    background: #8B0000;
                    color: white;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    position: relative;
                    overflow: hidden;
                }
                
                .promo-card::before {
                    content: '';
                    position: absolute;
                    top: -50px;
                    right: -50px;
                    width: 150px;
                    height: 150px;
                    background: rgba(255,255,255,0.05);
                    border-radius: 50%;
                }

                .promo-content h3 { color: white !important; font-size: 1.8rem; margin-bottom: 1rem; }
                .promo-content p { font-size: 1rem; opacity: 0.9; margin-bottom: 2rem; line-height: 1.6; }
                
                .btn-reports { 
                    background: white; 
                    color: #8B0000; 
                    border: none;
                    padding: 12px 28px;
                    border-radius: 12px;
                    font-weight: 700;
                    font-size: 0.95rem;
                    cursor: pointer;
                    transition: all 0.3s;
                }
                
                .btn-reports:hover {
                    transform: scale(1.05);
                    box-shadow: 0 8px 20px rgba(0,0,0,0.2);
                }

                @media (max-width: 992px) {
                    .dashboard-main-grid {
                        grid-template-columns: 1fr;
                    }
                }
            `}</style>
        </div>
    );
}
