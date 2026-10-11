import React from 'react';
import { useStudentData } from './StudentDataContext';
import './student.css';

export default function NotificationsView() {
    const { dashboardData, loading } = useStudentData();

    if (loading) {
        return (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '60vh', color: '#8B0000' }}>
                <div className="spinner" style={{ width: '40px', height: '40px', borderTopColor: '#8B0000', borderWidth: '3px' }}></div>
            </div>
        );
    }

    const allNotifications = dashboardData?.notifications || [];

    return (
        <div className="student-notifications animate-fade" style={{ maxWidth: '1400px', margin: '0 auto', paddingBottom: '3rem' }}>
            <div style={{ marginBottom: '2rem' }}>
                <h1 style={{ fontSize: '2rem', color: '#1E293B', margin: '0 0 6px', fontWeight: 800 }}>Academic Notifications & Alerts</h1>
                <p style={{ color: '#64748B', margin: 0, fontSize: '0.95rem' }}>
                    Institutional advisories, prerequisite updates, and graduation readiness notices
                </p>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
                {allNotifications.length > 0 ? (
                    allNotifications.map((n, idx) => {
                        const isSuccess = n.type === 'SUCCESS' || n.type === 'CLEARANCE';
                        const isWarning = n.type === 'WARNING' || n.type === 'PENDING';
                        return (
                        <div key={idx} className="glass-card" style={{
                            padding: '1.5rem',
                            background: 'white',
                            borderLeft: isSuccess ? '5px solid #10B981' : isWarning ? '5px solid #F59E0B' : '5px solid #3B82F6',
                            display: 'flex',
                            alignItems: 'flex-start',
                            gap: '16px'
                        }}>
                            <span style={{ fontSize: '1.8rem' }}>
                                {isSuccess ? '✅' : isWarning ? '⚠️' : '📢'}
                            </span>
                            <div style={{ flex: 1 }}>
                                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '4px' }}>
                                    <h3 style={{ margin: 0, color: '#1E293B', fontSize: '1.15rem' }}>{n.title}</h3>
                                    <span style={{ fontSize: '0.8rem', color: '#94A3B8' }}>{n.date || 'Active'}</span>
                                </div>
                                <p style={{ margin: 0, color: '#475569', fontSize: '0.92rem', lineHeight: '1.5' }}>
                                    {n.message}
                                </p>
                            </div>
                        </div>
                    );
                })
            ) : (
                <div className="glass-card" style={{ padding: '2.5rem', textAlign: 'center', background: 'white' }}>
                    <p style={{ margin: 0, color: '#64748B', fontSize: '1rem', fontWeight: 600 }}>
                        No active academic alerts or notifications at this time.
                    </p>
                </div>
            )}
        </div>
    </div>
);
}
