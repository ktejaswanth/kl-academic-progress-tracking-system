import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useStudentData } from './StudentDataContext';
import './student.css';

export default function StudentDashboard() {
    const { dashboardData, loading, error, refreshData } = useStudentData();
    const navigate = useNavigate();

    if (loading) {
        return (
            <div className="student-loader-container" style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', height: '65vh', color: '#8B0000' }}>
                <div className="spinner" style={{ width: '45px', height: '45px', borderTopColor: '#8B0000', borderWidth: '3px' }}></div>
                <p style={{ marginTop: '1.2rem', fontWeight: 600 }}>Loading Academic Progress Dashboard...</p>
            </div>
        );
    }

    if (error) {
        return (
            <div className="student-dashboard">
                <div className="alert error" style={{ padding: '1.5rem', borderRadius: '12px', background: '#FEE2E2', color: '#991B1B' }}>
                    {error}
                </div>
            </div>
        );
    }

    const student = dashboardData?.student || {};
    const degreePath = dashboardData?.degreePath || {};
    const status = dashboardData?.degreeStatus || dashboardData?.status || {};
    const buckets = dashboardData?.buckets || [];
    const narrative = dashboardData?.narrative || {};
    const readiness = dashboardData?.graduationReadiness || {};
    const cgpa = dashboardData?.cgpa !== undefined && dashboardData?.cgpa !== null ? dashboardData.cgpa : 0.0;

    const studentName = student.fullName || `${student.firstName || ''} ${student.lastName || ''}`.trim() || student.studentId || 'Student';
    const rollNumber = student.studentId || student.username || 'N/A';
    const department = student.department || degreePath.departmentName || degreePath.department || 'N/A';
    const degreeType = degreePath.degreeTypeName || student.degreeType || 'Regular Track';
    const curriculum = student.curriculum || degreePath.curriculumVersion || 'N/A';
    const specialization = (degreePath.addonName && degreePath.addonName !== 'N/A' && degreePath.addonName !== 'NONE')
        ? degreePath.addonName
        : (student.addonName && student.addonName !== 'N/A' && student.addonName !== 'NONE')
            ? student.addonName
            : null;

    const totalEarned = status.totalEarnedCredits || 0;
    const totalRequired = status.totalRequiredCredits || degreePath.totalRequiredCredits || 0;
    const remainingCredits = Math.max(0, totalRequired - totalEarned);
    const completionPercentage = status.completionPercentage || Math.min(100, Math.round((totalEarned / totalRequired) * 100));
    const isEligible = status.isDegreeEligible || (totalEarned >= totalRequired);

    const radius = 80;
    const circumference = 2 * Math.PI * radius;
    const offset = circumference - (completionPercentage / 100) * circumference;

    return (
        <div className="student-dashboard animate-fade" style={{ maxWidth: '1400px', margin: '0 auto', paddingBottom: '3rem' }}>
            {/* Header Hero Banner */}
            <header className="student-hero" style={{ background: 'linear-gradient(135deg, #8B0000 0%, #4A0000 100%)', borderRadius: '24px', padding: '2.5rem', color: 'white', marginBottom: '2rem', boxShadow: '0 12px 30px rgba(74, 0, 0, 0.2)' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', flexWrap: 'wrap', gap: '20px' }}>
                    <div>
                        <span className="welcome-tag" style={{ background: 'rgba(255,255,255,0.15)', padding: '5px 14px', borderRadius: '15px', fontSize: '0.8rem', fontWeight: 700, letterSpacing: '0.5px' }}>
                            STUDENT ACADEMIC PORTAL
                        </span>
                        <h1 style={{ fontSize: '2.4rem', margin: '10px 0 6px', fontWeight: 800 }}>
                            Welcome, <span style={{ color: '#FFD700' }}>{studentName}</span>
                        </h1>
                        <p style={{ margin: 0, opacity: 0.9, fontSize: '1rem', display: 'flex', flexWrap: 'wrap', gap: '10px', alignItems: 'center' }}>
                            <span>ID: <strong>{rollNumber}</strong></span>
                            <span>•</span>
                            <span>{department} Department</span>
                            <span>•</span>
                            <span>Curriculum: <strong>{curriculum}</strong></span>
                            <span>•</span>
                            <span>Degree: <strong>{degreeType}</strong></span>
                            {specialization && (
                                <>
                                    <span>•</span>
                                    <span>Specialization: <strong style={{ color: '#FFD700' }}>{specialization}</strong></span>
                                </>
                            )}
                        </p>
                    </div>

                    <div style={{ display: 'flex', gap: '15px', alignItems: 'center', flexWrap: 'wrap' }}>
                        <div style={{ background: 'rgba(255,255,255,0.12)', backdropFilter: 'blur(8px)', padding: '12px 20px', borderRadius: '16px', textAlign: 'center', border: '1px solid rgba(255,255,255,0.15)' }}>
                            <span style={{ display: 'block', fontSize: '0.78rem', opacity: 0.8, fontWeight: 600 }}>CUMULATIVE GPA</span>
                            <span style={{ fontSize: '1.8rem', fontWeight: 900, color: '#FFD700' }}>{cgpa}</span>
                        </div>
                        <div style={{ background: 'rgba(255,255,255,0.12)', backdropFilter: 'blur(8px)', padding: '12px 20px', borderRadius: '16px', textAlign: 'center', border: '1px solid rgba(255,255,255,0.15)' }}>
                            <span style={{ display: 'block', fontSize: '0.78rem', opacity: 0.8, fontWeight: 600 }}>GRADUATION STATUS</span>
                            <span style={{ fontSize: '1.05rem', fontWeight: 800, color: isEligible ? '#4ADE80' : '#FBBF24', marginTop: '4px', display: 'block' }}>
                                {isEligible ? '✅ ELIGIBLE' : '⚠️ IN PROGRESS'}
                            </span>
                        </div>
                    </div>
                </div>
            </header>

            {/* UX NARRATIVE SECTION: "Academic Situation in Simple Terms" */}
            <section style={{
                background: 'white',
                border: '1px solid #E2E8F0',
                borderRadius: '20px',
                padding: '1.8rem 2.2rem',
                marginBottom: '2rem',
                boxShadow: '0 4px 20px rgba(0,0,0,0.03)',
                borderLeft: '6px solid #8B0000'
            }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '10px', marginBottom: '10px' }}>
                    <span style={{ fontSize: '1.4rem' }}>💡</span>
                    <h3 style={{ margin: 0, color: '#1E293B', fontSize: '1.25rem', fontWeight: 800 }}>
                        Your Academic Journey in Plain Language
                    </h3>
                </div>

                {/* Primary Narrative Summary */}
                <p style={{ fontSize: '1.1rem', color: '#1E293B', lineHeight: '1.6', margin: '0 0 1.5rem', fontWeight: 500 }}>
                    {narrative.summary || (
                        isEligible
                            ? `You have completed ${totalEarned} of ${totalRequired} credits. 0 credits are remaining. All curriculum requirements are satisfied. You are eligible for graduation!`
                            : `You have completed ${totalEarned} of ${totalRequired} credits. ${remainingCredits} credits are remaining to fulfill your degree requirements.`
                    )}
                </p>

                {/* 6 Key Student Questions Grid */}
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '1rem' }}>
                    <div style={{ background: '#F8FAFC', padding: '14px 18px', borderRadius: '14px', border: '1px solid #E2E8F0' }}>
                        <span style={{ fontSize: '0.75rem', fontWeight: 700, color: '#059669', textTransform: 'uppercase' }}>✅ What Have I Completed?</span>
                        <p style={{ margin: '6px 0 0', fontSize: '0.9rem', color: '#334155' }}>
                            {narrative.whatHaveICompleted || `${totalEarned} credits across University Core, Engineering Sciences, and Foundation courses.`}
                        </p>
                    </div>

                    <div style={{ background: '#F8FAFC', padding: '14px 18px', borderRadius: '14px', border: '1px solid #E2E8F0' }}>
                        <span style={{ fontSize: '0.75rem', fontWeight: 700, color: '#2563EB', textTransform: 'uppercase' }}>⏳ What Am I Doing Now?</span>
                        <p style={{ margin: '6px 0 0', fontSize: '0.9rem', color: '#334155' }}>
                            {narrative.whatAmIDoingNow || `Currently advancing in Semester 7/8 with project work and professional electives.`}
                        </p>
                    </div>

                    <div style={{ background: '#F8FAFC', padding: '14px 18px', borderRadius: '14px', border: '1px solid #E2E8F0' }}>
                        <span style={{ fontSize: '0.75rem', fontWeight: 700, color: remainingCredits > 0 ? '#DC2626' : '#059669', textTransform: 'uppercase' }}>
                            {remainingCredits > 0 ? '⚠️ What Is Remaining?' : '🎉 Degree Complete'}
                        </span>
                        <p style={{ margin: '6px 0 0', fontSize: '0.9rem', color: '#334155' }}>
                            {narrative.whatIsRemaining || `${remainingCredits} credits remaining across your program buckets.`}
                        </p>
                    </div>

                    <div style={{ background: '#F8FAFC', padding: '14px 18px', borderRadius: '14px', border: '1px solid #E2E8F0' }}>
                        <span style={{ fontSize: '0.75rem', fontWeight: 700, color: '#8B5CF6', textTransform: 'uppercase' }}>🎯 What Can I Take Next?</span>
                        <p style={{ margin: '6px 0 0', fontSize: '0.9rem', color: '#334155' }}>
                            {narrative.whatCanITakeNext || 'Review Recommended Courses to select eligible electives that clear remaining buckets.'}
                        </p>
                    </div>
                </div>
            </section>

            {/* Quick Stats Grid */}
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: '1.2rem', marginBottom: '2rem' }}>
                <div className="glass-card" style={{ padding: '1.5rem', textAlign: 'center', background: 'white' }}>
                    <span style={{ fontSize: '0.8rem', color: '#64748B', fontWeight: 700, textTransform: 'uppercase' }}>Credits Completed</span>
                    <span style={{ display: 'block', fontSize: '2.4rem', fontWeight: 900, color: '#8B0000', margin: '4px 0' }}>{totalEarned}</span>
                    <span style={{ fontSize: '0.8rem', color: '#059669', fontWeight: 600 }}>Out of {totalRequired} required</span>
                </div>

                <div className="glass-card" style={{ padding: '1.5rem', textAlign: 'center', background: 'white' }}>
                    <span style={{ fontSize: '0.8rem', color: '#64748B', fontWeight: 700, textTransform: 'uppercase' }}>Credits Remaining</span>
                    <span style={{ display: 'block', fontSize: '2.4rem', fontWeight: 900, color: remainingCredits === 0 ? '#059669' : '#DC2626', margin: '4px 0' }}>
                        {remainingCredits}
                    </span>
                    <span style={{ fontSize: '0.8rem', color: '#64748B' }}>To reach graduation criteria</span>
                </div>

                <div className="glass-card" style={{ padding: '1.5rem', textAlign: 'center', background: 'white' }}>
                    <span style={{ fontSize: '0.8rem', color: '#64748B', fontWeight: 700, textTransform: 'uppercase' }}>Degree Completion</span>
                    <span style={{ display: 'block', fontSize: '2.4rem', fontWeight: 900, color: '#1E293B', margin: '4px 0' }}>{completionPercentage}%</span>
                    <div style={{ width: '100%', height: '6px', background: '#E2E8F0', borderRadius: '3px', marginTop: '8px', overflow: 'hidden' }}>
                        <div style={{ width: `${completionPercentage}%`, height: '100%', background: '#8B0000', borderRadius: '3px' }}></div>
                    </div>
                </div>

                <div className="glass-card" style={{ padding: '1.5rem', textAlign: 'center', background: 'white' }}>
                    <span style={{ fontSize: '0.8rem', color: '#64748B', fontWeight: 700, textTransform: 'uppercase' }}>Buckets Completed</span>
                    <span style={{ display: 'block', fontSize: '2.4rem', fontWeight: 900, color: '#2563EB', margin: '4px 0' }}>
                        {buckets.filter(b => b.status === 'COMPLETED').length} / {buckets.length}
                    </span>
                    <span style={{ fontSize: '0.8rem', color: '#64748B' }}>Requirement buckets</span>
                </div>
            </div>

            {/* Main Progress & Category Breakdown */}
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1.6fr', gap: '2rem', marginBottom: '2rem' }}>
                {/* Visual Circle Gauge */}
                <div className="glass-card" style={{ padding: '2rem', textAlign: 'center', background: 'white' }}>
                    <h3 style={{ margin: '0 0 1.5rem', color: '#1E293B', fontSize: '1.25rem' }}>Degree Progress Score</h3>
                    <div style={{ position: 'relative', width: '200px', height: '200px', margin: '0 auto 1.5rem' }}>
                        <svg width="200" height="200" viewBox="0 0 200 200">
                            <defs>
                                <linearGradient id="studentGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                                    <stop offset="0%" stopColor="#8B0000" />
                                    <stop offset="100%" stopColor="#D32F2F" />
                                </linearGradient>
                            </defs>
                            <circle cx="100" cy="100" r={radius} style={{ fill: 'none', stroke: '#F1F5F9', strokeWidth: 14 }} />
                            <circle
                                cx="100" cy="100" r={radius}
                                style={{
                                    fill: 'none',
                                    strokeWidth: 14,
                                    strokeLinecap: 'round',
                                    strokeDasharray: circumference,
                                    strokeDashoffset: offset,
                                    stroke: 'url(#studentGrad)',
                                    transform: 'rotate(-90deg)',
                                    transformOrigin: '50% 50%',
                                    transition: 'stroke-dashoffset 1s ease'
                                }}
                            />
                        </svg>
                        <div style={{ position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%, -50%)', textAlign: 'center' }}>
                            <span style={{ display: 'block', fontSize: '2.5rem', fontWeight: 900, color: '#8B0000' }}>{completionPercentage}%</span>
                            <span style={{ fontSize: '0.75rem', color: '#64748B', fontWeight: 700, textTransform: 'uppercase' }}>COMPLETE</span>
                        </div>
                    </div>

                    <div style={{ display: 'flex', gap: '10px' }}>
                        <button
                            onClick={() => navigate('/student/requirements')}
                            style={{ flex: 1, padding: '10px', background: '#F8FAFC', border: '1px solid #E2E8F0', borderRadius: '10px', cursor: 'pointer', fontWeight: 600, fontSize: '0.85rem', color: '#1E293B' }}
                        >
                            View Requirements →
                        </button>
                        <button
                            onClick={() => navigate('/student/graduation-readiness')}
                            style={{ flex: 1, padding: '10px', background: '#FFF5F5', border: '1px solid #FED7D7', borderRadius: '10px', cursor: 'pointer', fontWeight: 700, fontSize: '0.85rem', color: '#8B0000' }}
                        >
                            Check Readiness →
                        </button>
                    </div>
                </div>

                {/* Requirement Buckets Overview */}
                <div className="glass-card" style={{ padding: '2rem', background: 'white' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.2rem' }}>
                        <h3 style={{ margin: 0, color: '#1E293B', fontSize: '1.25rem' }}>Requirement Buckets Status</h3>
                        <button
                            onClick={() => navigate('/student/progress')}
                            style={{ background: 'none', border: 'none', color: '#8B0000', fontWeight: 700, cursor: 'pointer', fontSize: '0.88rem' }}
                        >
                            See All Buckets →
                        </button>
                    </div>

                    <div style={{ display: 'flex', flexDirection: 'column', gap: '12px', maxHeight: '280px', overflowY: 'auto' }}>
                        {buckets.slice(0, 6).map((b, idx) => (
                            <div key={idx} style={{ padding: '10px 14px', background: '#F8FAFC', borderRadius: '10px', border: '1px solid #E2E8F0' }}>
                                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.86rem', marginBottom: '4px' }}>
                                    <span>
                                        <strong style={{ color: '#8B0000' }}>{b.bucketCode}</strong> — {b.bucketName}
                                    </span>
                                    <span style={{ fontWeight: 700, color: b.earnedCredits >= b.requiredCredits ? '#059669' : '#D97706' }}>
                                        {b.earnedCredits} / {b.requiredCredits} Cr
                                    </span>
                                </div>
                                <div style={{ height: '6px', background: '#E2E8F0', borderRadius: '3px', overflow: 'hidden' }}>
                                    <div style={{
                                        width: `${b.completionPercentage}%`,
                                        height: '100%',
                                        background: b.status === 'COMPLETED' ? '#10B981' : '#F59E0B'
                                    }}></div>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            </div>

            {/* Quick Action Hub */}
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '1rem' }}>
                <div onClick={() => navigate('/student/courses')} style={{ background: 'white', padding: '18px', borderRadius: '16px', border: '1px solid #E2E8F0', cursor: 'pointer', transition: 'transform 0.2s' }}>
                    <span style={{ fontSize: '1.8rem' }}>📚</span>
                    <h4 style={{ margin: '8px 0 4px', color: '#1E293B' }}>My Courses</h4>
                    <p style={{ margin: 0, fontSize: '0.82rem', color: '#64748B' }}>View complete academic course history</p>
                </div>
                <div onClick={() => navigate('/student/recommended-courses')} style={{ background: 'white', padding: '18px', borderRadius: '16px', border: '1px solid #E2E8F0', cursor: 'pointer' }}>
                    <span style={{ fontSize: '1.8rem' }}>🎯</span>
                    <h4 style={{ margin: '8px 0 4px', color: '#1E293B' }}>Recommended Courses</h4>
                    <p style={{ margin: 0, fontSize: '0.82rem', color: '#64748B' }}>What Should I Take Next?</p>
                </div>
                <div onClick={() => navigate('/student/reports')} style={{ background: 'white', padding: '18px', borderRadius: '16px', border: '1px solid #E2E8F0', cursor: 'pointer' }}>
                    <span style={{ fontSize: '1.8rem' }}>📄</span>
                    <h4 style={{ margin: '8px 0 4px', color: '#1E293B' }}>Official Reports</h4>
                    <p style={{ margin: 0, fontSize: '0.82rem', color: '#64748B' }}>Download 6-Page Exit PDF & transcripts</p>
                </div>
                <div onClick={() => navigate('/student/graduation-readiness')} style={{ background: 'white', padding: '18px', borderRadius: '16px', border: '1px solid #E2E8F0', cursor: 'pointer' }}>
                    <span style={{ fontSize: '1.8rem' }}>🎓</span>
                    <h4 style={{ margin: '8px 0 4px', color: '#1E293B' }}>Graduation Eligibility</h4>
                    <p style={{ margin: 0, fontSize: '0.82rem', color: '#64748B' }}>Review readiness and clearance status</p>
                </div>
            </div>
        </div>
    );
}
