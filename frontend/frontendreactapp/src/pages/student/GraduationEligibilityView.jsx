import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useStudentData } from './StudentDataContext';
import './student.css';

export default function GraduationEligibilityView() {
    const { dashboardData, loading } = useStudentData();
    const navigate = useNavigate();

    if (loading) {
        return (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '60vh', color: '#8B0000' }}>
                <div className="spinner" style={{ width: '40px', height: '40px', borderTopColor: '#8B0000', borderWidth: '3px' }}></div>
            </div>
        );
    }

    const status = dashboardData?.degreeStatus || {};
    const buckets = dashboardData?.buckets || [];
    const cgpa = dashboardData?.cgpa !== undefined && dashboardData?.cgpa !== null ? dashboardData.cgpa : 0.0;
    const readiness = dashboardData?.graduationReadiness || {};

    const totalEarned = status.totalEarnedCredits || 0;
    const totalRequired = status.totalRequiredCredits || dashboardData?.degreePath?.totalRequiredCredits || 0;
    const isEligible = status.isDegreeEligible || (totalRequired > 0 && totalEarned >= totalRequired);

    // Identify blockers / preventing factors
    const bucketBlockers = buckets.filter(b => b.earnedCredits < b.requiredCredits);
    const hasCgpaIssue = cgpa < 5.0;

    return (
        <div className="student-graduation-eligibility animate-fade" style={{ maxWidth: '1400px', margin: '0 auto', paddingBottom: '3rem' }}>
            <div style={{ marginBottom: '2rem' }}>
                <h1 style={{ fontSize: '2rem', color: '#1E293B', margin: '0 0 6px', fontWeight: 800 }}>Graduation Readiness & Eligibility</h1>
                <p style={{ color: '#64748B', margin: 0, fontSize: '0.95rem' }}>
                    Institutional evaluation against KL University official degree conferral criteria
                </p>
            </div>

            {/* Top Status Banner */}
            <div className="glass-card" style={{
                padding: '2.2rem',
                background: isEligible ? 'linear-gradient(135deg, #059669 0%, #065F46 100%)' : 'linear-gradient(135deg, #1E293B 0%, #0F172A 100%)',
                color: 'white',
                borderRadius: '24px',
                marginBottom: '2.5rem',
                boxShadow: '0 12px 30px rgba(0,0,0,0.12)'
            }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: '20px' }}>
                    <div>
                        <span style={{ background: 'rgba(255,255,255,0.2)', padding: '4px 12px', borderRadius: '12px', fontSize: '0.8rem', fontWeight: 700, textTransform: 'uppercase' }}>
                            OFFICIAL AUDIT VERDICT
                        </span>
                        <h2 style={{ fontSize: '2.2rem', margin: '10px 0 6px', fontWeight: 900 }}>
                            {isEligible ? '🎉 You are Eligible for Graduation!' : '⏳ Graduation Criteria in Progress'}
                        </h2>
                        <p style={{ margin: 0, opacity: 0.9, fontSize: '1rem' }}>
                            {isEligible
                                ? 'Congratulations! You have satisfied all credit requirements and institutional clearance policies.'
                                : 'You have pending requirements that must be cleared before graduation clearance can be issued.'}
                        </p>
                    </div>

                    <div style={{ textAlign: 'right' }}>
                        <span style={{
                            display: 'inline-block',
                            padding: '10px 24px',
                            borderRadius: '30px',
                            fontSize: '1.1rem',
                            fontWeight: 800,
                            background: isEligible ? '#34D399' : '#F59E0B',
                            color: isEligible ? '#064E3B' : '#78350F'
                        }}>
                            {isEligible ? 'STATUS: ELIGIBLE' : 'STATUS: NOT YET ELIGIBLE'}
                        </span>
                    </div>
                </div>
            </div>

            {/* CRUCIAL REQUIREMENT: WHAT IS PREVENTING THE STUDENT FROM BECOMING ELIGIBLE? */}
            <section style={{
                background: 'white',
                border: '1px solid #E2E8F0',
                borderRadius: '20px',
                padding: '2rem',
                marginBottom: '2.5rem',
                borderLeft: isEligible ? '6px solid #10B981' : '6px solid #DC2626'
            }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '10px', marginBottom: '1.2rem' }}>
                    <span style={{ fontSize: '1.6rem' }}>{isEligible ? '🏆' : '🚨'}</span>
                    <h3 style={{ margin: 0, color: '#1E293B', fontSize: '1.35rem', fontWeight: 800 }}>
                        What is preventing you from becoming eligible for graduation?
                    </h3>
                </div>

                {!isEligible && bucketBlockers.length > 0 ? (
                    <div>
                        <p style={{ color: '#475569', fontSize: '1rem', lineHeight: '1.6', marginBottom: '1.2rem' }}>
                            To be conferred your B.Tech degree, the academic senate requires completion of 100% of curriculum clusters.
                            The following <strong>{bucketBlockers.length} requirement(s)</strong> are currently preventing graduation:
                        </p>

                        <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                            {bucketBlockers.map((b, idx) => {
                                const rem = b.requiredCredits - b.earnedCredits;
                                return (
                                    <div key={idx} style={{
                                        background: '#FEF2F2',
                                        border: '1px solid #FEE2E2',
                                        padding: '14px 18px',
                                        borderRadius: '12px',
                                        display: 'flex',
                                        justifyContent: 'space-between',
                                        alignItems: 'center',
                                        flexWrap: 'wrap',
                                        gap: '10px'
                                    }}>
                                        <div>
                                            <span style={{ fontWeight: 800, color: '#991B1B' }}>❌ {b.bucketName} ({b.bucketCode})</span>
                                            <p style={{ margin: '4px 0 0', fontSize: '0.85rem', color: '#7F1D1D' }}>
                                                Shortfall: <strong>{rem} Credits</strong> remaining (Completed {b.earnedCredits} of {b.requiredCredits} credits required).
                                            </p>
                                        </div>
                                        <button
                                            onClick={() => navigate('/student/recommended-courses')}
                                            style={{ background: '#DC2626', color: 'white', border: 'none', padding: '8px 14px', borderRadius: '8px', cursor: 'pointer', fontWeight: 600, fontSize: '0.82rem' }}
                                        >
                                            Find Courses to Clear →
                                        </button>
                                    </div>
                                );
                            })}
                        </div>
                    </div>
                ) : (
                    <div style={{ background: '#F0FDF4', border: '1px solid #BBF7D0', padding: '16px 20px', borderRadius: '12px', color: '#166534' }}>
                        <h4 style={{ margin: '0 0 6px', fontSize: '1.1rem' }}>Zero Blockers Detected!</h4>
                        <p style={{ margin: 0, fontSize: '0.92rem', lineHeight: '1.5' }}>
                            You have satisfied all mandatory course credits, elective distributions, and academic criteria. No curriculum shortfalls or policy holds exist on your student account.
                        </p>
                    </div>
                )}
            </section>

            {/* Checklist of Graduation Requirements */}
            <div className="glass-card" style={{ padding: '2rem', background: 'white' }}>
                <h3 style={{ margin: '0 0 1.5rem', color: '#1E293B', fontSize: '1.3rem' }}>Institutional Graduation Checklist</h3>

                <div style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '14px', background: '#F8FAFC', borderRadius: '12px', border: '1px solid #E2E8F0' }}>
                        <div>
                            <strong>1. Total Credit Requirement</strong>
                            <div style={{ fontSize: '0.85rem', color: '#64748B' }}>Minimum required: {totalRequired} credits</div>
                        </div>
                        <span style={{ fontWeight: 700, color: totalEarned >= totalRequired ? '#059669' : '#DC2626' }}>
                            {totalEarned >= totalRequired ? '✅ Completed' : `⚠️ ${totalRequired - totalEarned} Cr Remaining`}
                        </span>
                    </div>

                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '14px', background: '#F8FAFC', borderRadius: '12px', border: '1px solid #E2E8F0' }}>
                        <div>
                            <strong>2. Cumulative Grade Point Average (CGPA)</strong>
                            <div style={{ fontSize: '0.85rem', color: '#64748B' }}>Institutional minimum threshold: 5.00 CGPA</div>
                        </div>
                        <span style={{ fontWeight: 700, color: cgpa >= 5.0 ? '#059669' : '#DC2626' }}>
                            {cgpa >= 5.0 ? `✅ Satisfied (${cgpa} CGPA)` : `❌ Below Threshold (${cgpa})`}
                        </span>
                    </div>

                    {buckets.map((b, i) => {
                        const done = b.earnedCredits >= b.requiredCredits;
                        return (
                            <div key={i} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '14px', background: '#F8FAFC', borderRadius: '12px', border: '1px solid #E2E8F0' }}>
                                <div>
                                    <strong>{i + 3}. {b.bucketName} ({b.bucketCode})</strong>
                                    <div style={{ fontSize: '0.85rem', color: '#64748B' }}>Required: {b.requiredCredits} credits</div>
                                </div>
                                <span style={{ fontWeight: 700, color: done ? '#059669' : '#DC2626' }}>
                                    {done ? '✅ Completed' : `⚠️ ${b.requiredCredits - b.earnedCredits} Cr Remaining`}
                                </span>
                            </div>
                        );
                    })}
                </div>
            </div>
        </div>
    );
}
