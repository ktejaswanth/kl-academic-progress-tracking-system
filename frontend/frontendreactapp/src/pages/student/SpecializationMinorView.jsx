import React from 'react';
import { useStudentData } from './StudentDataContext';
import './student.css';

export default function SpecializationMinorView() {
    const { dashboardData, loading } = useStudentData();

    if (loading) {
        return (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '60vh', color: '#8B0000' }}>
                <div className="spinner" style={{ width: '40px', height: '40px', borderTopColor: '#8B0000', borderWidth: '3px' }}></div>
            </div>
        );
    }

    const spec = dashboardData?.specializationProgress || {};
    const minor = dashboardData?.minorProgress || {};
    const doubleMajor = dashboardData?.secondMajorProgress || {};

    const renderTrackCard = (title, data, defaultName, icon) => {
        const isApplicable = data && data.status !== 'NOT_APPLICABLE';
        const name = data?.specializationName || data?.minorName || data?.majorName || defaultName;
        const required = data?.requiredCredits || 20;
        const earned = data?.earnedCredits || 0;
        const remaining = Math.max(0, required - earned);
        const percent = data?.progressPercentage || (required > 0 ? Math.min(100, Math.round((earned / required) * 100)) : 0);
        const status = data?.status || (isApplicable ? (earned >= required ? 'COMPLETED' : 'IN_PROGRESS') : 'NOT_ENROLLED');

        return (
            <div className="glass-card" style={{ padding: '2rem', background: 'white', marginBottom: '2rem' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: '15px', marginBottom: '1.5rem' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                        <span style={{ fontSize: '2rem' }}>{icon}</span>
                        <div>
                            <span style={{ fontSize: '0.78rem', fontWeight: 700, color: '#8B0000', textTransform: 'uppercase' }}>{title}</span>
                            <h3 style={{ margin: '2px 0 0', color: '#1E293B', fontSize: '1.3rem' }}>{name}</h3>
                        </div>
                    </div>

                    <div>
                        <span style={{
                            padding: '6px 14px',
                            borderRadius: '20px',
                            fontSize: '0.8rem',
                            fontWeight: 800,
                            background: status === 'COMPLETED' ? '#DCFCE7' : status === 'IN_PROGRESS' ? '#FEF3C7' : '#F1F5F9',
                            color: status === 'COMPLETED' ? '#166534' : status === 'IN_PROGRESS' ? '#92400E' : '#64748B'
                        }}>
                            {status === 'COMPLETED' ? '✅ COMPLETED' : status === 'IN_PROGRESS' ? '⏳ IN PROGRESS' : 'NOT APPLICABLE'}
                        </span>
                    </div>
                </div>

                {isApplicable ? (
                    <>
                        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))', gap: '1rem', marginBottom: '1.5rem' }}>
                            <div style={{ background: '#F8FAFC', padding: '12px 16px', borderRadius: '12px', border: '1px solid #E2E8F0' }}>
                                <span style={{ fontSize: '0.75rem', color: '#64748B', fontWeight: 600 }}>REQUIRED CREDITS</span>
                                <strong style={{ display: 'block', fontSize: '1.4rem', color: '#1E293B' }}>{required} Cr</strong>
                            </div>
                            <div style={{ background: '#F8FAFC', padding: '12px 16px', borderRadius: '12px', border: '1px solid #E2E8F0' }}>
                                <span style={{ fontSize: '0.75rem', color: '#64748B', fontWeight: 600 }}>COMPLETED CREDITS</span>
                                <strong style={{ display: 'block', fontSize: '1.4rem', color: '#059669' }}>{earned} Cr</strong>
                            </div>
                            <div style={{ background: '#F8FAFC', padding: '12px 16px', borderRadius: '12px', border: '1px solid #E2E8F0' }}>
                                <span style={{ fontSize: '0.75rem', color: '#64748B', fontWeight: 600 }}>REMAINING CREDITS</span>
                                <strong style={{ display: 'block', fontSize: '1.4rem', color: remaining === 0 ? '#059669' : '#DC2626' }}>{remaining} Cr</strong>
                            </div>
                            <div style={{ background: '#F8FAFC', padding: '12px 16px', borderRadius: '12px', border: '1px solid #E2E8F0' }}>
                                <span style={{ fontSize: '0.75rem', color: '#64748B', fontWeight: 600 }}>TRACK PROGRESS</span>
                                <strong style={{ display: 'block', fontSize: '1.4rem', color: '#8B0000' }}>{percent}%</strong>
                            </div>
                        </div>

                        <div style={{ height: '8px', background: '#E2E8F0', borderRadius: '4px', overflow: 'hidden', marginBottom: '1.5rem' }}>
                            <div style={{ width: `${percent}%`, height: '100%', background: '#8B0000' }}></div>
                        </div>

                        {data.completedCourses && data.completedCourses.length > 0 && (
                            <div>
                                <span style={{ fontSize: '0.8rem', fontWeight: 700, color: '#64748B', textTransform: 'uppercase', display: 'block', marginBottom: '8px' }}>
                                    Completed Courses Towards Track ({data.completedCourses.length}):
                                </span>
                                <div style={{ display: 'flex', flexWrap: 'wrap', gap: '8px' }}>
                                    {data.completedCourses.map((c, i) => (
                                        <span key={i} style={{ background: '#EFF6FF', border: '1px solid #BFDBFE', color: '#1D4ED8', padding: '4px 10px', borderRadius: '8px', fontSize: '0.82rem', fontWeight: 600 }}>
                                            {c.courseCode || c} — {c.courseName || 'Track Elective'}
                                        </span>
                                    ))}
                                </div>
                            </div>
                        )}
                    </>
                ) : (
                    <p style={{ margin: 0, color: '#64748B', fontSize: '0.9rem', fontStyle: 'italic' }}>
                        You are currently not enrolled in this additional credential track. You can consult with your faculty counselor to opt-in during second-year registrations.
                    </p>
                )}
            </div>
        );
    };

    return (
        <div className="student-specialization animate-fade" style={{ maxWidth: '1400px', margin: '0 auto', paddingBottom: '3rem' }}>
            <div style={{ marginBottom: '2rem' }}>
                <h1 style={{ fontSize: '2rem', color: '#1E293B', margin: '0 0 6px', fontWeight: 800 }}>Specialization & Credential Tracks</h1>
                <p style={{ color: '#64748B', margin: 0, fontSize: '0.95rem' }}>
                    Track your optional and integrated Specialization, Minor, or Double Major program requirements
                </p>
            </div>

            {renderTrackCard('Degree Specialization', spec, 'Artificial Intelligence & Machine Learning', '🎯')}
            {renderTrackCard('Academic Minor Track', minor, 'Data Analytics Minor', '📘')}
            {renderTrackCard('Double Major Track', doubleMajor, 'Second Major in Computer Science', '🎓')}
        </div>
    );
}
