import React from 'react';
import './student.css';

export default function NotificationsView() {
    return (
        <div className="student-notifications animate-fade" style={{ maxWidth: '1400px', margin: '0 auto', paddingBottom: '3rem' }}>
            <div style={{ marginBottom: '2rem' }}>
                <h1 style={{ fontSize: '2rem', color: '#1E293B', margin: '0 0 6px', fontWeight: 800 }}>Notifications</h1>
                <p style={{ color: '#64748B', margin: 0, fontSize: '0.95rem' }}>
                    Institutional advisories, academic deadlines, and milestone updates
                </p>
            </div>

            <div style={{
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center',
                minHeight: '420px',
                padding: '2rem 1rem'
            }}>
                <div className="glass-card" style={{
                    maxWidth: '560px',
                    width: '100%',
                    background: 'white',
                    borderRadius: '24px',
                    padding: '3.5rem 2.5rem',
                    textAlign: 'center',
                    boxShadow: '0 10px 30px rgba(0, 0, 0, 0.04)',
                    border: '1px solid #EDF2F7',
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'center'
                }}>
                    <div style={{
                        width: '88px',
                        height: '88px',
                        borderRadius: '50%',
                        background: 'linear-gradient(135deg, #FFF1F2 0%, #FFE4E6 100%)',
                        border: '2px solid #FECDD3',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        fontSize: '2.5rem',
                        marginBottom: '1.5rem',
                        boxShadow: '0 8px 24px rgba(225, 29, 72, 0.1)'
                    }}>
                        🔔
                    </div>

                    <h2 style={{
                        fontSize: '1.8rem',
                        fontWeight: 800,
                        color: '#1E293B',
                        margin: '0 0 12px'
                    }}>
                        Coming Soon
                    </h2>

                    <p style={{
                        color: '#64748B',
                        fontSize: '1.02rem',
                        lineHeight: '1.6',
                        margin: '0 0 1.75rem',
                        maxWidth: '430px'
                    }}>
                        We're working on notifications to keep you updated on your academic progress.
                    </p>

                    <div style={{
                        display: 'inline-flex',
                        alignItems: 'center',
                        gap: '8px',
                        padding: '6px 16px',
                        borderRadius: '20px',
                        background: '#F8FAFC',
                        border: '1px solid #E2E8F0',
                        color: '#475569',
                        fontSize: '0.82rem',
                        fontWeight: 700,
                        letterSpacing: '0.02em'
                    }}>
                        <span style={{ width: '8px', height: '8px', borderRadius: '50%', background: '#E11D48', display: 'inline-block' }}></span>
                        Automated Academic Alert Engine In Development
                    </div>
                </div>
            </div>
        </div>
    );
}
