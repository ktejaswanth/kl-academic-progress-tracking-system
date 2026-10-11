import React from 'react';
import { useStudentData } from './StudentDataContext';
import './student.css';

export default function RecommendedCoursesView() {
    const { dashboardData, loading } = useStudentData();

    if (loading) {
        return (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '60vh', color: '#8B0000' }}>
                <div className="spinner" style={{ width: '40px', height: '40px', borderTopColor: '#8B0000', borderWidth: '3px' }}></div>
            </div>
        );
    }

    const recommended = dashboardData?.recommendedCourses || [];
    const narrative = dashboardData?.narrative || {};

    return (
        <div className="student-recommended-courses animate-fade" style={{ maxWidth: '1400px', margin: '0 auto', paddingBottom: '3rem' }}>
            <div style={{ marginBottom: '2rem' }}>
                <h1 style={{ fontSize: '2rem', color: '#1E293B', margin: '0 0 6px', fontWeight: 800 }}>Recommended Courses</h1>
                <p style={{ color: '#64748B', margin: 0, fontSize: '0.95rem' }}>
                    What Should I Take Next? Tailored academic recommendations mapped to your remaining requirement buckets
                </p>
            </div>

            {/* Strategy Banner */}
            <div style={{ background: '#FFF5F5', border: '1px solid #FED7D7', borderRadius: '18px', padding: '1.5rem 2rem', marginBottom: '2.5rem', borderLeft: '6px solid #8B0000' }}>
                <h3 style={{ margin: '0 0 6px', color: '#8B0000', fontSize: '1.2rem' }}>🎯 Recommended Enrolment Strategy</h3>
                <p style={{ margin: 0, color: '#475569', fontSize: '0.92rem', lineHeight: '1.5' }}>
                    {narrative.whatCanITakeNext ||
                        'These courses are selected from your department curriculum and active requirement baskets to directly resolve your pending credit requirements.'}
                </p>
            </div>

            {/* Courses Recommendations Grid */}
            {recommended.length > 0 ? (
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(340px, 1fr))', gap: '1.5rem' }}>
                    {recommended.map((c, idx) => (
                        <div key={idx} className="glass-card" style={{ padding: '1.8rem', background: 'white', display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
                            <div>
                                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '10px' }}>
                                    <span style={{ background: '#8B0000', color: 'white', padding: '4px 10px', borderRadius: '8px', fontWeight: 800, fontFamily: 'monospace', fontSize: '0.9rem' }}>
                                        {c.courseCode}
                                    </span>
                                    <span style={{ background: '#ECFDF5', color: '#059669', padding: '4px 10px', borderRadius: '12px', fontSize: '0.8rem', fontWeight: 700 }}>
                                        {c.credits !== undefined && c.credits !== null ? `${c.credits} Credits` : ''}
                                    </span>
                                </div>

                                <h3 style={{ margin: '0 0 10px', color: '#1E293B', fontSize: '1.2rem' }}>
                                    {c.courseName}
                                </h3>

                                <div style={{ background: '#F8FAFC', padding: '10px 14px', borderRadius: '10px', border: '1px solid #E2E8F0', marginBottom: '1rem', fontSize: '0.85rem' }}>
                                    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '4px' }}>
                                        <span style={{ color: '#64748B' }}>Satisfies Bucket:</span>
                                        <strong style={{ color: '#8B0000' }}>{c.bucketName || c.bucketCode || 'Program Core'}</strong>
                                    </div>
                                    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '4px' }}>
                                        <span style={{ color: '#64748B' }}>Prerequisites:</span>
                                        <strong style={{ color: '#1E293B' }}>{c.prerequisites || 'None Required'}</strong>
                                    </div>
                                    <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                                        <span style={{ color: '#64748B' }}>Student Eligibility:</span>
                                        <strong style={{ color: '#059669' }}>✅ Eligible to Enrol</strong>
                                    </div>
                                </div>
                            </div>

                            <div style={{ background: '#EFF6FF', border: '1px solid #BFDBFE', padding: '10px 14px', borderRadius: '10px', color: '#1D4ED8', fontSize: '0.82rem' }}>
                                💡 <strong>Why This Course:</strong> {c.recommendationReason || 'Fulfills pending core/elective credits in your degree path.'}
                            </div>
                        </div>
                    ))}
                </div>
            ) : (
                <div style={{ textAlign: 'center', padding: '4rem 1rem', background: '#F8FAFC', borderRadius: '16px', border: '1px dashed #CBD5E1' }}>
                    <span style={{ fontSize: '3rem' }}>🎉</span>
                    <h3 style={{ margin: '14px 0 6px', color: '#1E293B' }}>All Degree Requirements Satisfied!</h3>
                    <p style={{ color: '#64748B', margin: 0, fontSize: '0.92rem' }}>
                        You have completed all prerequisite course clusters and degree buckets. No further mandatory courses are required!
                    </p>
                </div>
            )}
        </div>
    );
}
