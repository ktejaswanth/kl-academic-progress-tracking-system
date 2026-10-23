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

    const student = dashboardData?.student || {};
    const degreePath = dashboardData?.degreePath || {};
    const spec = dashboardData?.specializationProgress || {};
    const minor = dashboardData?.minorProgress || {};
    const doubleMajor = dashboardData?.secondMajorProgress || {};

    const rawSpec = student.specialization || degreePath.specialization || student.addonName || degreePath.addonName;
    const defaultSpecName = (rawSpec && rawSpec !== 'N/A' && rawSpec !== 'NONE' && rawSpec !== 'Not Available')
        ? rawSpec
        : 'Not Available';

    const renderTrackCard = (title, data, defaultName, icon) => {
        const isApplicable = data && data.status !== 'NOT_APPLICABLE';
        const name = data?.specializationName || data?.minorName || data?.majorName || defaultName;
        const required = data?.requiredCredits || 20;
        const earned = data?.earnedCredits || 0;
        const remaining = Math.max(0, required - earned);
        const percent = data?.progressPercentage || (required > 0 ? Math.min(100, Math.round((earned / required) * 100)) : 0);
        const status = data?.status || (isApplicable ? (earned >= required ? 'COMPLETED' : 'IN_PROGRESS') : 'NOT_ENROLLED');

        return (
            <div className="glass-card" style={{ padding: '1.8rem 2rem', background: 'white', marginBottom: '1.5rem' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: '15px' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '14px' }}>
                        <span style={{ fontSize: '2.2rem' }}>{icon}</span>
                        <div>
                            <span style={{ fontSize: '0.78rem', fontWeight: 700, color: '#8B0000', textTransform: 'uppercase', letterSpacing: '0.5px' }}>{title}</span>
                            <h3 style={{ margin: '2px 0 0', color: '#1E293B', fontSize: '1.25rem', fontWeight: 800 }}>{name}</h3>
                        </div>
                    </div>

                    <div>
                        <span style={{
                            padding: '6px 16px',
                            borderRadius: '20px',
                            fontSize: '0.82rem',
                            fontWeight: 800,
                            background: status === 'COMPLETED' ? '#DCFCE7' : status === 'IN_PROGRESS' ? '#FEF3C7' : '#F1F5F9',
                            color: status === 'COMPLETED' ? '#166534' : status === 'IN_PROGRESS' ? '#92400E' : '#64748B'
                        }}>
                            {status === 'COMPLETED' ? '✅ COMPLETED' : status === 'IN_PROGRESS' ? '⏳ IN PROGRESS' : 'NOT APPLICABLE'}
                        </span>
                    </div>
                </div>

                {!isApplicable && (
                    <p style={{ margin: '1rem 0 0', color: '#64748B', fontSize: '0.88rem', fontStyle: 'italic' }}>
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

            {renderTrackCard('Degree Specialization', spec, defaultSpecName, '🎯')}
            {renderTrackCard('Academic Minor Track', minor, 'Data Analytics Minor', '📘')}
            {renderTrackCard('Double Major Track', doubleMajor, 'Second Major in Computer Science', '🎓')}
        </div>
    );
}
