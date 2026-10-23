import React, { useState, useMemo } from 'react';
import { useStudentData } from './StudentDataContext';
import './student.css';

const BUCKET_DEFINITIONS = [
    { code: 'ALL', label: 'All Buckets', fullName: 'All Requirement Buckets', icon: '🎯', description: 'All eligible recommendations across requirement buckets' },
    { code: 'HAS', label: 'Humanities (HAS)', fullName: 'Humanities, Arts and Social Sciences', icon: '📚', description: 'Core communication, humanities, and management courses' },
    { code: 'BSC', label: 'Basic Sciences (BSC)', fullName: 'Basic Science Courses', icon: '🔬', description: 'Foundational mathematics and physical sciences' },
    { code: 'ESC', label: 'Engineering Sciences (ESC)', fullName: 'Engineering Science Courses', icon: '⚙️', description: 'Cross-disciplinary engineering foundations' },
    { code: 'FCC', label: 'Flexi Core (FCC)', fullName: 'Flexi Core Courses', icon: '🧩', description: 'Flexible core disciplinary specializations' },
    { code: 'PCC', label: 'Program Core (PCC)', fullName: 'Professional Core Courses', icon: '💻', description: 'Essential degree major curriculum courses' },
    { code: 'PEC', label: 'Electives (PEC)', fullName: 'Professional Elective Courses', icon: '⚡', description: 'Advanced in-depth professional domain electives' },
    { code: 'SDC', label: 'Skill Dev (SDC)', fullName: 'Skill Development Courses', icon: '🛠️', description: 'Industry certification and technical skill tracks' },
    { code: 'PRI', label: 'Projects & Intern (PRI)', fullName: 'Project Research and Internship', icon: '🚀', description: 'Term projects, capstone, and industrial internships' },
    { code: 'OEC', label: 'Open Electives (OEC)', fullName: 'Open Elective Courses', icon: '🌐', description: 'Interdisciplinary courses from other faculties' },
    { code: 'SIL', label: 'Social Immersive (SIL)', fullName: 'Social Immersive Learning', icon: '🤝', description: 'Community engagement and social immersion courses' },
];

export default function RecommendedCoursesView() {
    const { dashboardData, courses, loading } = useStudentData();
    const [selectedBucket, setSelectedBucket] = useState('ALL');

    const resolveCourseCategory = (course) => {
        if (!course) return 'PCC';
        if (course.categoryCode) return course.categoryCode.toUpperCase();
        if (course.category && BUCKET_DEFINITIONS.some(b => b.code === course.category.toUpperCase())) {
            return course.category.toUpperCase();
        }

        const bc = (course.bucketCode || course.bucketGroup || '').toUpperCase();
        const bn = (course.bucketName || '').toUpperCase();
        const cc = (course.courseCode || '').toUpperCase();
        const combined = `${bc} ${bn}`;

        if (combined.includes('HAS') || combined.includes('HUMANITIES') || combined.includes('MANAGEMENT') || cc.startsWith('23UC') || cc.startsWith('23HS') || cc.startsWith('23EN') || cc.startsWith('23MG')) return 'HAS';
        if (combined.includes('BSC') || combined.includes('BASIC SCIENCE') || combined.includes('MATH') || combined.includes('SCIENCE ELECTIVE') || cc.startsWith('23MT') || cc.startsWith('23SC3') || cc.startsWith('23MA') || cc.startsWith('23PH') || cc.startsWith('23CH')) return 'BSC';
        if (combined.includes('ESC') || combined.includes('ENGINEERING SCIENCE') || cc.startsWith('23EC') || cc.startsWith('23EE') || cc.startsWith('23ME') || cc.startsWith('23SC1') || cc === '23CS1207') return 'ESC';
        if (bc.startsWith('FC') || combined.includes('FLEXI CORE') || combined.includes('FCC') || bc.startsWith('HFC') || cc.endsWith('F')) return 'FCC';
        if (combined.includes('PCC') || combined.includes('PROFESSIONAL CORE') || cc.startsWith('23CS') || cc.startsWith('23AD')) return 'PCC';
        if (combined.includes('PEC') || combined.includes('ELECTIVE') || bc.startsWith('PE') || bc.startsWith('HEC') || cc.startsWith('23PE') || cc.startsWith('23ALT')) return 'PEC';
        if (combined.includes('SDC') || combined.includes('SDP') || combined.includes('SKILL') || cc.startsWith('23SD')) return 'SDC';
        if (combined.includes('PRI') || combined.includes('PROJECT') || combined.includes('INTERNSHIP') || combined.includes('RESEARCH') || cc.startsWith('23IE') || cc.startsWith('23PR') || cc.startsWith('23IN') || cc.startsWith('23CP')) return 'PRI';
        if (combined.includes('OEC') || bc.startsWith('OE') || combined.includes('OPEN ELECTIVE') || cc.startsWith('OE')) return 'OEC';
        if (combined.includes('SIL') || combined.includes('SELF') || combined.includes('IMMERSIVE') || cc.startsWith('22UC') || cc.startsWith('SIL')) return 'SIL';

        return 'PCC';
    };

    // Unified eligible recommendations built from backend recommendedCourses and pending bucket courses
    const allRecommended = useMemo(() => {
        const recMap = new Map();

        // 1. Process backend recommended courses
        const backendRecs = dashboardData?.recommendedCourses || [];
        backendRecs.forEach(c => {
            if (c && c.courseCode) {
                const cat = resolveCourseCategory(c);
                recMap.set(c.courseCode.toUpperCase(), {
                    ...c,
                    categoryCode: cat,
                    bucketName: c.bucketName || c.bucketCode || 'Program Requirement',
                    eligibility: c.eligibility || 'Eligible - Recommended for upcoming registration',
                    prerequisites: c.prerequisites || 'Satisfied / None',
                    recommendationReason: c.recommendationReason || c.recommendationRationale || `Satisfies pending credits in ${c.bucketName || c.bucketCode || 'degree path'}.`
                });
            }
        });

        // 2. Supplement from pending courses across active buckets to ensure comprehensive bucket coverage
        const buckets = dashboardData?.buckets || [];
        buckets.forEach(b => {
            if (b && b.status !== 'COMPLETED' && Array.isArray(b.pendingCourses)) {
                b.pendingCourses.forEach(c => {
                    if (c && c.courseCode && !recMap.has(c.courseCode.toUpperCase())) {
                        const cat = resolveCourseCategory({
                            ...c,
                            bucketCode: b.bucketCode,
                            bucketName: b.bucketName
                        });
                        recMap.set(c.courseCode.toUpperCase(), {
                            courseCode: c.courseCode,
                            courseName: c.courseName || c.courseCode,
                            credits: c.credits,
                            bucketCode: b.bucketCode,
                            bucketName: b.bucketName || b.bucketCode,
                            categoryCode: cat,
                            prerequisites: 'Satisfied / None',
                            eligibility: 'Eligible - Recommended for upcoming registration',
                            recommendationReason: `Satisfies required pending credits in ${b.bucketName || b.bucketCode}.`
                        });
                    }
                });
            }
        });

        return Array.from(recMap.values());
    }, [dashboardData]);

    // Student's completed courses grouped by category
    const completedCoursesByCategory = useMemo(() => {
        const map = {};
        BUCKET_DEFINITIONS.forEach(b => { map[b.code] = []; });
        (courses || []).forEach(c => {
            if (c && (c.status === 'COMPLETED' || (c.grade && c.grade !== 'F' && c.grade !== '-'))) {
                const cat = resolveCourseCategory(c);
                if (map[cat]) {
                    map[cat].push(c);
                }
            }
        });
        return map;
    }, [courses]);

    // Calculate real course counts per bucket
    const bucketCounts = useMemo(() => {
        const counts = { ALL: allRecommended.length };
        BUCKET_DEFINITIONS.forEach(b => {
            if (b.code !== 'ALL') counts[b.code] = 0;
        });
        allRecommended.forEach(c => {
            const cat = c.categoryCode || resolveCourseCategory(c);
            if (counts[cat] !== undefined) {
                counts[cat]++;
            }
        });
        return counts;
    }, [allRecommended]);

    // Bucket status summary (earned credits, required credits, completion state)
    const bucketStatusSummary = useMemo(() => {
        const summary = {};
        (dashboardData?.buckets || []).forEach(b => {
            const cat = resolveCourseCategory({ bucketCode: b.bucketCode, bucketName: b.bucketName });
            if (!summary[cat]) {
                summary[cat] = {
                    requiredCredits: 0,
                    earnedCredits: 0,
                    isCompleted: false,
                    bucketName: b.bucketName || b.bucketCode
                };
            }
            summary[cat].requiredCredits += Number(b.requiredCredits || b.minCredits || 0);
            summary[cat].earnedCredits += Number(b.earnedCredits || 0);
            if (b.status === 'COMPLETED') {
                summary[cat].isCompleted = true;
            }
        });
        return summary;
    }, [dashboardData]);

    // Filtered recommended courses based on selected bucket
    const filteredCourses = useMemo(() => {
        if (selectedBucket === 'ALL') return allRecommended;
        return allRecommended.filter(c => (c.categoryCode || resolveCourseCategory(c)) === selectedBucket);
    }, [allRecommended, selectedBucket]);

    const activeBucketObj = useMemo(() => {
        return BUCKET_DEFINITIONS.find(b => b.code === selectedBucket) || BUCKET_DEFINITIONS[0];
    }, [selectedBucket]);

    if (loading) {
        return (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '60vh', color: '#8B0000' }}>
                <div className="spinner" style={{ width: '40px', height: '40px', borderTopColor: '#8B0000', borderWidth: '3px' }}></div>
            </div>
        );
    }

    const narrative = dashboardData?.narrative || {};
    const selectedCompletedCourses = selectedBucket !== 'ALL' ? (completedCoursesByCategory[selectedBucket] || []) : [];
    const activeSummary = selectedBucket !== 'ALL' ? bucketStatusSummary[selectedBucket] : null;
    const isCategoryCompleted = activeSummary?.isCompleted || (activeSummary && activeSummary.earnedCredits >= activeSummary.requiredCredits && activeSummary.requiredCredits > 0) || (selectedCompletedCourses.length > 0 && filteredCourses.length === 0);

    const student = dashboardData?.student || {};
    const degreePath = dashboardData?.degreePath || {};
    const rawDept = student.department || degreePath.department || 'Not Available';
    const departmentDisplay = (rawDept !== 'Not Available' && !rawDept.toUpperCase().includes('DEPARTMENT')) 
        ? `${rawDept} Department` 
        : rawDept;
    const curriculumDisplay = student.curriculum || degreePath.curriculum || 'Y23 Regulation';
    const degreeTypeDisplay = student.degreeType || degreePath.degreeTypeName || 'Regular';
    const rawSpec = student.specialization || degreePath.specialization || student.addonName || degreePath.addonName;
    const specializationDisplay = (rawSpec && rawSpec !== 'N/A' && rawSpec !== 'NONE' && rawSpec !== 'Not Available')
        ? rawSpec
        : 'Not Available';

    return (
        <div className="student-recommended-courses animate-fade" style={{ maxWidth: '1400px', margin: '0 auto', paddingBottom: '3rem' }}>
            {/* Header */}
            <div style={{ marginBottom: '2rem' }}>
                <h1 style={{ fontSize: '2rem', color: '#1E293B', margin: '0 0 6px', fontWeight: 800 }}>Recommended Courses</h1>
                <p style={{ color: '#64748B', margin: '0 0 8px', fontSize: '0.95rem' }}>
                    What Should I Take Next? Tailored academic recommendations mapped to your remaining requirement buckets
                </p>
                <div style={{ fontSize: '0.9rem', color: '#8B0000', fontWeight: 700, display: 'flex', flexWrap: 'wrap', gap: '8px', alignItems: 'center' }}>
                    <span>{departmentDisplay}</span>
                    <span>•</span>
                    <span>Curriculum: <strong>{curriculumDisplay}</strong></span>
                    <span>•</span>
                    <span>Degree: <strong>{degreeTypeDisplay}</strong></span>
                    <span>•</span>
                    <span>Specialization: <strong>{specializationDisplay}</strong></span>
                </div>
            </div>

            {/* Strategy Banner */}
            <div style={{ background: '#FFF5F5', border: '1px solid #FED7D7', borderRadius: '18px', padding: '1.5rem 2rem', marginBottom: '2rem', borderLeft: '6px solid #8B0000' }}>
                <h3 style={{ margin: '0 0 6px', color: '#8B0000', fontSize: '1.2rem' }}>🎯 Recommended Enrolment Strategy</h3>
                <p style={{ margin: 0, color: '#475569', fontSize: '0.92rem', lineHeight: '1.5' }}>
                    {narrative.whatCanITakeNext ||
                        'These courses are selected from your department curriculum and active requirement baskets to directly resolve your pending credit requirements.'}
                </p>
            </div>

            {/* Clean Bucket Navigation Selector */}
            <div style={{ marginBottom: '1.75rem' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '12px', flexWrap: 'wrap', gap: '8px' }}>
                    <span style={{ fontSize: '0.85rem', fontWeight: 700, color: '#64748B', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
                        Filter By Academic Requirement Bucket
                    </span>
                    <span style={{ fontSize: '0.85rem', color: '#64748B' }}>
                        Showing <strong>{filteredCourses.length}</strong> {filteredCourses.length === 1 ? 'course' : 'courses'} in <strong>{activeBucketObj.label}</strong>
                    </span>
                </div>

                {/* Horizontal Scrollable Tabs */}
                <div style={{
                    display: 'flex',
                    gap: '10px',
                    overflowX: 'auto',
                    paddingBottom: '10px',
                    scrollbarWidth: 'thin',
                    WebkitOverflowScrolling: 'touch'
                }}>
                    {BUCKET_DEFINITIONS.map(b => {
                        const isSelected = selectedBucket === b.code;
                        const pendingCount = bucketCounts[b.code] || 0;
                        const summary = bucketStatusSummary[b.code];
                        const isDone = b.code !== 'ALL' && (summary?.isCompleted || (summary && summary.earnedCredits >= summary.requiredCredits && summary.requiredCredits > 0));

                        return (
                            <button
                                key={b.code}
                                onClick={() => setSelectedBucket(b.code)}
                                style={{
                                    display: 'inline-flex',
                                    alignItems: 'center',
                                    gap: '8px',
                                    padding: '9px 16px',
                                    borderRadius: '12px',
                                    border: isSelected ? '1.5px solid #8B0000' : '1px solid #E2E8F0',
                                    background: isSelected ? '#8B0000' : 'white',
                                    color: isSelected ? 'white' : '#334155',
                                    fontSize: '0.86rem',
                                    fontWeight: 700,
                                    cursor: 'pointer',
                                    whiteSpace: 'nowrap',
                                    transition: 'all 0.2s ease',
                                    boxShadow: isSelected ? '0 4px 12px rgba(139, 0, 0, 0.2)' : '0 1px 3px rgba(0,0,0,0.03)'
                                }}
                                title={`${b.code} — ${b.fullName}`}
                            >
                                <span>{b.icon}</span>
                                <span>{b.label}</span>
                                <span style={{
                                    padding: '2px 8px',
                                    borderRadius: '10px',
                                    fontSize: '0.75rem',
                                    fontWeight: 800,
                                    background: isSelected
                                        ? 'rgba(255, 255, 255, 0.25)'
                                        : pendingCount > 0
                                            ? '#FFF1F2'
                                            : isDone
                                                ? '#ECFDF5'
                                                : '#F1F5F9',
                                    color: isSelected
                                        ? 'white'
                                        : pendingCount > 0
                                            ? '#BE123C'
                                            : isDone
                                                ? '#059669'
                                                : '#94A3B8'
                                }}>
                                    {b.code === 'ALL'
                                        ? pendingCount
                                        : pendingCount > 0
                                            ? `${pendingCount} Rec`
                                            : isDone
                                                ? '✓ Done'
                                                : '0'}
                                </span>
                            </button>
                        );
                    })}
                </div>

                {/* Selected Bucket Info Pill */}
                {selectedBucket !== 'ALL' && (
                    <div style={{
                        marginTop: '10px',
                        padding: '12px 18px',
                        background: '#F8FAFC',
                        borderRadius: '12px',
                        border: '1px solid #E2E8F0',
                        display: 'flex',
                        justifyContent: 'space-between',
                        alignItems: 'center',
                        flexWrap: 'wrap',
                        gap: '12px'
                    }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '10px', flexWrap: 'wrap' }}>
                            <span style={{ fontSize: '1.2rem' }}>{activeBucketObj.icon}</span>
                            <div>
                                <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                                    <strong style={{ color: '#8B0000', fontSize: '0.92rem' }}>{activeBucketObj.code}:</strong>
                                    <span style={{ color: '#1E293B', fontSize: '0.92rem', fontWeight: 700 }}>{activeBucketObj.fullName}</span>
                                </div>
                                <span style={{ color: '#64748B', fontSize: '0.82rem' }}>{activeBucketObj.description}</span>
                            </div>
                        </div>

                        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                            {activeSummary && (
                                <span style={{ fontSize: '0.85rem', color: '#475569', background: 'white', padding: '4px 10px', borderRadius: '8px', border: '1px solid #E2E8F0' }}>
                                    Credits: <strong>{activeSummary.earnedCredits}</strong> / {activeSummary.requiredCredits} Earned
                                </span>
                            )}
                            <button
                                onClick={() => setSelectedBucket('ALL')}
                                style={{
                                    background: 'white',
                                    border: '1px solid #CBD5E1',
                                    color: '#8B0000',
                                    padding: '5px 12px',
                                    borderRadius: '8px',
                                    fontWeight: 700,
                                    fontSize: '0.82rem',
                                    cursor: 'pointer'
                                }}
                            >
                                ✕ Reset Filter
                            </button>
                        </div>
                    </div>
                )}
            </div>

            {/* Courses Recommendations Grid */}
            {filteredCourses.length > 0 ? (
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(340px, 1fr))', gap: '1.5rem' }}>
                    {filteredCourses.map((c, idx) => (
                        <div key={`${c.courseCode}-${idx}`} className="glass-card" style={{ padding: '1.8rem', background: 'white', display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
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
                                        <strong style={{ color: '#059669' }}>{c.eligibility || '✅ Eligible to Enrol'}</strong>
                                    </div>
                                </div>
                            </div>

                            <div style={{ background: '#EFF6FF', border: '1px solid #BFDBFE', padding: '10px 14px', borderRadius: '10px', color: '#1D4ED8', fontSize: '0.82rem' }}>
                                💡 <strong>Why This Course:</strong> {c.recommendationReason || 'Fulfills pending core/elective credits in your degree path.'}
                            </div>
                        </div>
                    ))}
                </div>
            ) : selectedBucket !== 'ALL' && isCategoryCompleted ? (
                /* When the bucket is 100% completed: Show congratulations + Completed courses list so user never gets "nothing"! */
                <div style={{ background: 'white', borderRadius: '20px', padding: '2rem', border: '1px solid #E2E8F0', boxShadow: '0 4px 20px rgba(0,0,0,0.03)' }}>
                    <div style={{ textAlign: 'center', marginBottom: '1.5rem', paddingBottom: '1.5rem', borderBottom: '1px solid #F1F5F9' }}>
                        <span style={{ fontSize: '2.5rem', display: 'block', marginBottom: '8px' }}>🎉</span>
                        <h3 style={{ margin: '0 0 6px', color: '#059669', fontSize: '1.3rem', fontWeight: 800 }}>
                            {activeBucketObj.fullName} — Requirements Satisfied!
                        </h3>
                        <p style={{ color: '#64748B', margin: 0, fontSize: '0.92rem' }}>
                            You have completed all prerequisite and mandatory credits required for this bucket. No additional courses are needed in this category.
                        </p>
                    </div>

                    {selectedCompletedCourses.length > 0 && (
                        <div>
                            <h4 style={{ fontSize: '0.95rem', color: '#334155', margin: '0 0 12px', fontWeight: 700 }}>
                                Courses Completed in this Category ({selectedCompletedCourses.length}):
                            </h4>
                            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '12px' }}>
                                {selectedCompletedCourses.map((cc, i) => (
                                    <div key={i} style={{ padding: '12px 16px', background: '#F8FAFC', borderRadius: '12px', border: '1px solid #E2E8F0', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                                        <div>
                                            <span style={{ fontFamily: 'monospace', fontWeight: 800, color: '#8B0000', fontSize: '0.85rem' }}>{cc.courseCode}</span>
                                            <p style={{ margin: '2px 0 0', color: '#1E293B', fontSize: '0.85rem', fontWeight: 600 }}>{cc.courseName}</p>
                                        </div>
                                        <div style={{ textAlign: 'right' }}>
                                            <span style={{ fontSize: '0.8rem', color: '#059669', fontWeight: 800, display: 'block' }}>{cc.credits} Cr</span>
                                            {cc.grade && <span style={{ fontSize: '0.75rem', color: '#64748B' }}>Grade: <strong>{cc.grade}</strong></span>}
                                        </div>
                                    </div>
                                ))}
                            </div>
                        </div>
                    )}

                    <div style={{ textAlign: 'center', marginTop: '1.5rem' }}>
                        <button
                            onClick={() => setSelectedBucket('ALL')}
                            style={{
                                background: '#8B0000',
                                color: 'white',
                                border: 'none',
                                padding: '10px 22px',
                                borderRadius: '10px',
                                fontWeight: 700,
                                fontSize: '0.88rem',
                                cursor: 'pointer'
                            }}
                        >
                            View Other Requirement Buckets
                        </button>
                    </div>
                </div>
            ) : selectedBucket !== 'ALL' ? (
                /* When the bucket has no courses scheduled */
                <div style={{ textAlign: 'center', padding: '3.5rem 1.5rem', background: '#F8FAFC', borderRadius: '16px', border: '1px dashed #CBD5E1' }}>
                    <span style={{ fontSize: '2.5rem' }}>✨</span>
                    <h3 style={{ margin: '12px 0 6px', color: '#1E293B' }}>No Pending Recommendations in {activeBucketObj.fullName} ({activeBucketObj.code})</h3>
                    <p style={{ color: '#64748B', margin: '0 0 16px', fontSize: '0.92rem', maxWidth: '520px', marginLeft: 'auto', marginRight: 'auto' }}>
                        No additional courses are currently scheduled for registration in this category.
                    </p>
                    <button
                        onClick={() => setSelectedBucket('ALL')}
                        style={{
                            background: '#8B0000',
                            color: 'white',
                            border: 'none',
                            padding: '10px 20px',
                            borderRadius: '10px',
                            fontWeight: 700,
                            fontSize: '0.88rem',
                            cursor: 'pointer'
                        }}
                    >
                        View All Recommended Courses
                    </button>
                </div>
            ) : (
                /* All Buckets Satisfied */
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
