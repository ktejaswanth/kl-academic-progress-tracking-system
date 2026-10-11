import React, { useState, useEffect } from 'react';
import { useSearchParams } from 'react-router-dom';
import { useStudentData } from './StudentDataContext';
import './student.css';

export default function DegreeRequirementsView() {
    const { dashboardData, loading } = useStudentData();
    const [searchParams] = useSearchParams();
    const tabParam = searchParams.get('tab');
    const [activeTab, setActiveTab] = useState(tabParam || 'all'); // 'all' | 'bucket-progress' | 'remaining'

    useEffect(() => {
        if (tabParam) {
            setActiveTab(tabParam);
        }
    }, [tabParam]);

    if (loading) {
        return (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '60vh', color: '#8B0000' }}>
                <div className="spinner" style={{ width: '40px', height: '40px', borderTopColor: '#8B0000', borderWidth: '3px' }}></div>
            </div>
        );
    }

    const degreePath = dashboardData?.degreePath || {};
    const buckets = dashboardData?.buckets || [];

    const completedBuckets = buckets.filter(b => b.status === 'COMPLETED' || (b.earnedCredits >= b.requiredCredits));
    const pendingBuckets = buckets.filter(b => b.status !== 'COMPLETED' && (b.earnedCredits < b.requiredCredits));

    const displayedBuckets = activeTab === 'remaining' 
        ? pendingBuckets 
        : buckets;

    const getPendingReason = (b) => {
        const rem = Math.max(0, b.requiredCredits - b.earnedCredits);
        if (rem === 0) return 'All required credits in this bucket have been satisfied.';
        if (b.earnedCredits === 0) {
            return `No courses registered in ${b.bucketName}. Requires earning ${b.requiredCredits} credits to satisfy this cluster.`;
        }
        return `You have completed ${b.earnedCredits} of ${b.requiredCredits} credits. A shortfall of ${rem} credits remains before this bucket is fulfilled.`;
    };

    return (
        <div className="student-degree-requirements animate-fade" style={{ maxWidth: '1400px', margin: '0 auto', paddingBottom: '3rem' }}>
            <div style={{ marginBottom: '2rem' }}>
                <h1 style={{ fontSize: '2rem', color: '#1E293B', margin: '0 0 6px', fontWeight: 800 }}>Degree Requirements</h1>
                <p style={{ color: '#64748B', margin: 0, fontSize: '0.95rem' }}>
                    Curriculum structure for <strong>{degreePath.degreeTypeName || 'B.Tech'}</strong> • {degreePath.departmentName || 'AIDS'} ({degreePath.curriculumVersion || '2023-2027'})
                </p>
            </div>

            {/* Sub-view navigation tabs */}
            <div style={{ display: 'flex', gap: '8px', borderBottom: '2px solid #E2E8F0', marginBottom: '1.8rem' }}>
                <button
                    onClick={() => setActiveTab('all')}
                    style={{
                        padding: '12px 20px',
                        fontWeight: 700,
                        fontSize: '0.95rem',
                        border: 'none',
                        background: 'transparent',
                        cursor: 'pointer',
                        color: activeTab === 'all' ? '#8B0000' : '#64748B',
                        borderBottom: activeTab === 'all' ? '3px solid #8B0000' : '3px solid transparent',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '8px'
                    }}
                >
                    📋 All Requirements ({buckets.length})
                </button>
                <button
                    onClick={() => setActiveTab('bucket-progress')}
                    style={{
                        padding: '12px 20px',
                        fontWeight: 700,
                        fontSize: '0.95rem',
                        border: 'none',
                        background: 'transparent',
                        cursor: 'pointer',
                        color: activeTab === 'bucket-progress' ? '#8B0000' : '#64748B',
                        borderBottom: activeTab === 'bucket-progress' ? '3px solid #8B0000' : '3px solid transparent',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '8px'
                    }}
                >
                    🪣 Bucket Progress
                </button>
                <button
                    onClick={() => setActiveTab('remaining')}
                    style={{
                        padding: '12px 20px',
                        fontWeight: 700,
                        fontSize: '0.95rem',
                        border: 'none',
                        background: 'transparent',
                        cursor: 'pointer',
                        color: activeTab === 'remaining' ? '#8B0000' : '#64748B',
                        borderBottom: activeTab === 'remaining' ? '3px solid #8B0000' : '3px solid transparent',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '8px'
                    }}
                >
                    ⚠️ Remaining Requirements ({pendingBuckets.length})
                </button>
            </div>

            {/* Summary Banner */}
            <div style={{ background: '#F8FAFC', padding: '1.2rem 1.8rem', borderRadius: '16px', border: '1px solid #E2E8F0', marginBottom: '2rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: '15px' }}>
                <div style={{ display: 'flex', gap: '20px', alignItems: 'center' }}>
                    <div>
                        <span style={{ fontSize: '0.78rem', color: '#64748B', fontWeight: 600 }}>COMPLETED BUCKETS</span>
                        <strong style={{ display: 'block', fontSize: '1.4rem', color: '#059669' }}>{completedBuckets.length}</strong>
                    </div>
                    <div style={{ height: '30px', width: '1px', background: '#CBD5E1' }}></div>
                    <div>
                        <span style={{ fontSize: '0.78rem', color: '#64748B', fontWeight: 600 }}>PENDING / IN-PROGRESS</span>
                        <strong style={{ display: 'block', fontSize: '1.4rem', color: pendingBuckets.length === 0 ? '#059669' : '#DC2626' }}>{pendingBuckets.length}</strong>
                    </div>
                </div>
                <span style={{ fontSize: '0.88rem', color: '#475569' }}>
                    All bucket requirements must be fully satisfied to receive official degree clearance.
                </span>
            </div>

            {/* Requirements Cards */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
                {displayedBuckets.map((b, idx) => {
                    const rem = Math.max(0, b.requiredCredits - b.earnedCredits);
                    const isDone = b.status === 'COMPLETED' || rem === 0;
                    return (
                        <div key={idx} className="glass-card" style={{ padding: '1.8rem', background: 'white', borderLeft: isDone ? '5px solid #10B981' : '5px solid #F59E0B' }}>
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: '15px', marginBottom: '1rem' }}>
                                <div>
                                    <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                                        <span style={{ background: '#8B0000', color: 'white', padding: '3px 8px', borderRadius: '6px', fontSize: '0.8rem', fontWeight: 800, fontFamily: 'monospace' }}>
                                            {b.bucketCode}
                                        </span>
                                        <h3 style={{ margin: 0, color: '#1E293B', fontSize: '1.25rem' }}>{b.bucketName}</h3>
                                        <span style={{ background: '#EFF6FF', color: '#1D4ED8', padding: '3px 8px', borderRadius: '6px', fontSize: '0.75rem', fontWeight: 700 }}>
                                            {b.bucketCategory || 'Core Category'}
                                        </span>
                                    </div>
                                    <p style={{ margin: '6px 0 0', color: '#64748B', fontSize: '0.88rem' }}>
                                        {b.description || `Required curriculum basket for ${b.bucketName}.`}
                                    </p>
                                </div>

                                <div style={{ textAlign: 'right' }}>
                                    <span style={{
                                        padding: '4px 12px',
                                        borderRadius: '20px',
                                        fontSize: '0.8rem',
                                        fontWeight: 800,
                                        background: isDone ? '#DCFCE7' : '#FEF3C7',
                                        color: isDone ? '#166534' : '#92400E'
                                    }}>
                                        {isDone ? '✅ COMPLETED' : '⚠️ PENDING'}
                                    </span>
                                    <span style={{ display: 'block', fontSize: '1.1rem', fontWeight: 800, color: '#1E293B', marginTop: '6px' }}>
                                        {b.earnedCredits} / {b.requiredCredits} Credits
                                    </span>
                                </div>
                            </div>

                            {/* Progress Bar */}
                            <div style={{ marginBottom: '1.2rem' }}>
                                <div style={{ height: '8px', background: '#E2E8F0', borderRadius: '4px', overflow: 'hidden' }}>
                                    <div style={{
                                        width: `${b.completionPercentage}%`,
                                        height: '100%',
                                        background: isDone ? '#10B981' : '#F59E0B'
                                    }}></div>
                                </div>
                            </div>

                            {/* EXPLANATION OF WHY REQUIREMENT IS PENDING */}
                            <div style={{
                                background: isDone ? '#F0FDF4' : '#FFFBEB',
                                border: isDone ? '1px solid #BBF7D0' : '1px solid #FDE68A',
                                padding: '12px 16px',
                                borderRadius: '10px',
                                fontSize: '0.88rem',
                                color: isDone ? '#166534' : '#92400E',
                                display: 'flex',
                                alignItems: 'center',
                                gap: '10px'
                            }}>
                                <span>{isDone ? '🎉' : '💡'}</span>
                                <div>
                                    <strong>Status Diagnosis: </strong>
                                    <span>{getPendingReason(b)}</span>
                                </div>
                            </div>

                            {/* Enrolled Courses in this Bucket */}
                            {b.courses && b.courses.length > 0 && (
                                <div style={{ marginTop: '1.2rem', borderTop: '1px solid #F1F5F9', paddingTop: '1rem' }}>
                                    <span style={{ fontSize: '0.8rem', fontWeight: 700, color: '#64748B', textTransform: 'uppercase', display: 'block', marginBottom: '8px' }}>
                                        Satisfying Courses Completed ({b.courses.length}):
                                    </span>
                                    <div style={{ display: 'flex', flexWrap: 'wrap', gap: '8px' }}>
                                        {b.courses.map((c, i) => (
                                            <span key={i} style={{ background: '#F8FAFC', border: '1px solid #E2E8F0', padding: '4px 10px', borderRadius: '8px', fontSize: '0.82rem' }}>
                                                <strong style={{ color: '#8B0000' }}>{c.courseCode}</strong> — {c.courseName} ({c.credits} Cr)
                                            </span>
                                        ))}
                                    </div>
                                </div>
                            )}
                        </div>
                    );
                })}
            </div>
        </div>
    );
}
