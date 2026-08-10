import React, { useState, useEffect } from 'react';
import api from '../api';

export default function AdminDashboard() {
    const [realStats, setRealStats] = useState({
        totalStudents: 0,
        totalFaculty: 0,
        pendingAudits: 156, // Mock for now, could be added to backend later
        systemHealth: '99.9%'
    });
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchAnalytics = async () => {
            try {
                const response = await api.get('/admin/analytics');
                setRealStats(prev => ({
                    ...prev,
                    totalStudents: response.data.totalStudents,
                    totalFaculty: response.data.totalFaculty,
                }));
            } catch (err) {
                console.error("Failed to fetch analytics", err);
            } finally {
                setLoading(false);
            }
        };
        fetchAnalytics();
    }, []);

    const stats = [
        { label: 'Total Students', value: loading ? '...' : realStats.totalStudents.toLocaleString(), icon: '🎓', color: '#8B0000' },
        { label: 'Active Faculty', value: loading ? '...' : realStats.totalFaculty.toLocaleString(), icon: '🏫', color: '#8B0000' },
        { label: 'Pending Audits', value: realStats.pendingAudits, icon: '📄', color: '#8B0000' },
        { label: 'System Health', value: realStats.systemHealth, icon: '⚡', color: '#8B0000' },
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
                    animation: fadeIn 0.8s ease-out;
                }
                @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

                .dashboard-header { margin-bottom: 3rem; }
                .dashboard-header h2 { 
                    font-size: 2.8rem; 
                    color: #0F172A; 
                    font-weight: 800; 
                    letter-spacing: -1.5px;
                    margin-bottom: 8px;
                }
                .dashboard-header p {
                    color: #64748B;
                    font-weight: 500;
                    font-size: 1.1rem;
                }
                
                .stats-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                    gap: 2rem;
                    margin-bottom: 4rem;
                }

                .stat-card-premium {
                    background: white;
                    padding: 2.5rem 2rem;
                    border-radius: 30px;
                    border: 1px solid #F1F5F9;
                    box-shadow: 0 10px 40px rgba(0,0,0,0.03);
                    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                    position: relative;
                    overflow: hidden;
                }

                .stat-card-premium:hover { 
                    transform: translateY(-12px);
                    box-shadow: 0 20px 50px rgba(225, 29, 72, 0.1);
                    border-color: #FECACA;
                }

                .stat-icon-wrapper {
                    width: 60px;
                    height: 60px;
                    background: #FFF1F2;
                    border-radius: 18px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin-bottom: 2rem;
                    transition: all 0.3s;
                }
                .stat-card-premium:hover .stat-icon-wrapper {
                    background: #E11D48;
                    transform: rotate(10deg);
                }
                .stat-card-premium:hover .stat-icon-large {
                    filter: brightness(0) invert(1);
                }

                .stat-icon-large { font-size: 1.8rem; transition: all 0.3s; }
                
                .stat-details { display: flex; flex-direction: column; gap: 6px; }
                .stat-value-large { font-size: 2.5rem; font-weight: 900; color: #1E293B; letter-spacing: -1px; }
                .stat-label-muted { color: #64748B; font-size: 1rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; }

                .stat-progress-bar {
                    height: 6px;
                    background: #F1F5F9;
                    border-radius: 10px;
                    margin-top: 2rem;
                    overflow: hidden;
                }

                .progress-fill {
                    height: 100%;
                    background: linear-gradient(90deg, #E11D48, #F43F5E);
                    border-radius: 10px;
                    transition: width 1s ease-in-out;
                }

                .dashboard-main-grid {
                    display: grid;
                    grid-template-columns: 1.6fr 1fr;
                    gap: 2.5rem;
                }

                .dashboard-card {
                    background: white;
                    padding: 3rem;
                    border-radius: 32px;
                    border: 1px solid #F1F5F9;
                    box-shadow: 0 10px 40px rgba(0,0,0,0.02);
                }

                .dashboard-card h3 {
                    font-size: 1.5rem;
                    font-weight: 800;
                    color: #0F172A;
                    margin-bottom: 2.5rem;
                    letter-spacing: -0.5px;
                }

                .activity-list { display: flex; flex-direction: column; gap: 2.5rem; }
                .activity-item { display: flex; gap: 1.5rem; align-items: flex-start; }
                .activity-dot { width: 12px; height: 12px; border-radius: 50%; margin-top: 8px; flex-shrink: 0; }
                .activity-dot.success { background: #10B981; box-shadow: 0 0 0 5px rgba(16, 185, 129, 0.15); }
                .activity-dot.warning { background: #E11D48; box-shadow: 0 0 0 5px rgba(225, 29, 72, 0.15); }
                
                .activity-info strong { display: block; font-size: 1.1rem; color: #1E293B; margin-bottom: 4px; }
                .activity-info p { font-size: 1rem; color: #64748B; margin-bottom: 8px; line-height: 1.5; }
                .activity-time { font-size: 0.85rem; color: #E11D48; font-weight: 800; text-transform: uppercase; }

                .promo-card {
                    background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%);
                    color: white;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    position: relative;
                    overflow: hidden;
                    border: none;
                }
                
                .promo-card::after {
                    content: '';
                    position: absolute;
                    bottom: -50px;
                    left: -50px;
                    width: 200px;
                    height: 200px;
                    background: rgba(225, 29, 72, 0.1);
                    border-radius: 50%;
                    filter: blur(40px);
                }

                .promo-content h3 { color: white !important; font-size: 2rem; margin-bottom: 1.5rem; }
                .promo-content p { font-size: 1.1rem; opacity: 0.8; margin-bottom: 2.5rem; line-height: 1.7; }
                
                .btn-reports { 
                    background: #E11D48; 
                    color: white; 
                    border: none;
                    padding: 14px 32px;
                    border-radius: 16px;
                    font-weight: 700;
                    font-size: 1rem;
                    cursor: pointer;
                    transition: all 0.3s;
                    box-shadow: 0 10px 20px rgba(225, 29, 72, 0.3);
                }
                
                .btn-reports:hover {
                    transform: scale(1.05);
                    filter: brightness(1.1);
                }

                @media (max-width: 1100px) {
                    .dashboard-main-grid { grid-template-columns: 1fr; }
                }
            `}</style>
        </div>
    );
}
