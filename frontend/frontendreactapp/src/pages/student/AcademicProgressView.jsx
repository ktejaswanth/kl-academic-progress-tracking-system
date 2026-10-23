import React, { useState } from 'react';
import { useStudentData } from './StudentDataContext';
import './student.css';

export default function AcademicProgressView() {
    const { dashboardData, loading } = useStudentData();
    const [filterCategory, setFilterCategory] = useState('');

    if (loading) {
        return (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '60vh', color: '#8B0000' }}>
                <div className="spinner" style={{ width: '40px', height: '40px', borderTopColor: '#8B0000', borderWidth: '3px' }}></div>
            </div>
        );
    }

    const student = dashboardData?.student || {};
    const status = dashboardData?.degreeStatus || dashboardData?.status || {};
    const degreePath = dashboardData?.degreePath || {};
    const buckets = dashboardData?.buckets || [];
    const semesters = dashboardData?.semesterPerformance || [];

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

    const totalEarned = status.totalEarnedCredits || 0;
    const totalRequired = status.totalRequiredCredits || degreePath.totalRequiredCredits || 163;
    const remainingCredits = Math.max(0, totalRequired - totalEarned);
    const overallPercent = status.completionPercentage || Math.min(100, Math.round((totalEarned / totalRequired) * 100));

    const categories = Array.from(new Set(buckets.map(b => b.bucketCategory || 'General'))).sort();

    const filteredBuckets = buckets.filter(b => !filterCategory || (b.bucketCategory || 'General') === filterCategory);

    return (
        <div className="student-academic-progress animate-fade" style={{ maxWidth: '1400px', margin: '0 auto', paddingBottom: '3rem' }}>
            <div style={{ marginBottom: '2rem' }}>
                <h1 style={{ fontSize: '2rem', color: '#1E293B', margin: '0 0 6px', fontWeight: 800 }}>Academic Progress Audit</h1>
                <p style={{ color: '#64748B', margin: '0 0 8px', fontSize: '0.95rem' }}>
                    Detailed degree trajectory across requirement buckets and academic semesters
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

            {/* Overall Metric Cards */}
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: '1.2rem', marginBottom: '2rem' }}>
                <div className="glass-card" style={{ padding: '1.5rem', background: 'white' }}>
                    <span style={{ fontSize: '0.8rem', color: '#64748B', fontWeight: 700, textTransform: 'uppercase' }}>Total Required</span>
                    <span style={{ display: 'block', fontSize: '2.2rem', fontWeight: 900, color: '#1E293B', margin: '4px 0' }}>{totalRequired}</span>
                    <span style={{ fontSize: '0.8rem', color: '#64748B' }}>Total curriculum credits</span>
                </div>

                <div className="glass-card" style={{ padding: '1.5rem', background: 'white' }}>
                    <span style={{ fontSize: '0.8rem', color: '#64748B', fontWeight: 700, textTransform: 'uppercase' }}>Credits Completed</span>
                    <span style={{ display: 'block', fontSize: '2.2rem', fontWeight: 900, color: '#059669', margin: '4px 0' }}>{totalEarned}</span>
                    <span style={{ fontSize: '0.8rem', color: '#059669', fontWeight: 600 }}>Successfully earned</span>
                </div>

                <div className="glass-card" style={{ padding: '1.5rem', background: 'white' }}>
                    <span style={{ fontSize: '0.8rem', color: '#64748B', fontWeight: 700, textTransform: 'uppercase' }}>Credits Remaining</span>
                    <span style={{ display: 'block', fontSize: '2.2rem', fontWeight: 900, color: remainingCredits === 0 ? '#059669' : '#DC2626', margin: '4px 0' }}>
                        {remainingCredits}
                    </span>
                    <span style={{ fontSize: '0.8rem', color: '#64748B' }}>Pending for graduation</span>
                </div>

                <div className="glass-card" style={{ padding: '1.5rem', background: 'white' }}>
                    <span style={{ fontSize: '0.8rem', color: '#64748B', fontWeight: 700, textTransform: 'uppercase' }}>Overall Progress</span>
                    <span style={{ display: 'block', fontSize: '2.2rem', fontWeight: 900, color: '#8B0000', margin: '4px 0' }}>{overallPercent}%</span>
                    <div style={{ width: '100%', height: '6px', background: '#E2E8F0', borderRadius: '3px', marginTop: '6px' }}>
                        <div style={{ width: `${overallPercent}%`, height: '100%', background: '#8B0000', borderRadius: '3px' }}></div>
                    </div>
                </div>
            </div>

            {/* Semester-wise Progress Section */}
            {semesters.length > 0 && (
                <div className="glass-card" style={{ padding: '2rem', background: 'white', marginBottom: '2rem' }}>
                    <h3 style={{ margin: '0 0 1.2rem', color: '#1E293B', fontSize: '1.25rem' }}>Semester-wise Progress</h3>
                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))', gap: '1rem' }}>
                        {semesters.map((s, idx) => (
                            <div key={idx} style={{ padding: '14px', borderRadius: '12px', background: '#F8FAFC', border: '1px solid #E2E8F0', textAlign: 'center' }}>
                                <span style={{ fontSize: '0.78rem', fontWeight: 700, color: '#8B0000', textTransform: 'uppercase' }}>{s.semester}</span>
                                <span style={{ display: 'block', fontSize: '1.6rem', fontWeight: 800, color: '#1E293B', margin: '4px 0' }}>
                                    {s.creditsEarned} <span style={{ fontSize: '0.75rem', fontWeight: 500, color: '#64748B' }}>Cr</span>
                                </span>
                                <div style={{ fontSize: '0.78rem', color: '#64748B' }}>
                                    SGPA: <strong style={{ color: '#059669' }}>{s.sgpa || '8.5'}</strong> • {s.coursesCount} courses
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            )}

            {/* Bucket-wise Requirement Progress Table */}
            <div className="glass-card" style={{ padding: '2rem', background: 'white' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem', flexWrap: 'wrap', gap: '12px' }}>
                    <div>
                        <h3 style={{ margin: 0, color: '#1E293B', fontSize: '1.3rem' }}>Requirement Bucket Compliance</h3>
                        <p style={{ margin: '4px 0 0', color: '#64748B', fontSize: '0.88rem' }}>
                            Required Credits | Completed Credits | Remaining Credits | Progress % | Status
                        </p>
                    </div>

                    <div style={{ display: 'flex', gap: '10px' }}>
                        <select
                            value={filterCategory}
                            onChange={(e) => setFilterCategory(e.target.value)}
                            style={{ padding: '8px 14px', borderRadius: '8px', border: '1px solid #CBD5E1', outline: 'none', background: 'white', fontSize: '0.88rem' }}
                        >
                            <option value="">All Categories ({categories.length})</option>
                            {categories.map(c => (
                                <option key={c} value={c}>{c}</option>
                            ))}
                        </select>
                    </div>
                </div>

                <div style={{ overflowX: 'auto', borderRadius: '12px', border: '1px solid #E2E8F0' }}>
                    <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '0.9rem' }}>
                        <thead>
                            <tr style={{ background: '#F8FAFC', borderBottom: '2px solid #E2E8F0', color: '#475569' }}>
                                <th style={{ padding: '14px 16px' }}>Requirement Bucket</th>
                                <th style={{ padding: '14px 12px' }}>Category</th>
                                <th style={{ padding: '14px 12px', textAlign: 'center' }}>Required</th>
                                <th style={{ padding: '14px 12px', textAlign: 'center' }}>Completed</th>
                                <th style={{ padding: '14px 12px', textAlign: 'center' }}>Remaining</th>
                                <th style={{ padding: '14px 16px', minWidth: '160px' }}>Progress %</th>
                                <th style={{ padding: '14px 16px', textAlign: 'center' }}>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            {filteredBuckets.map((b, idx) => {
                                const rem = Math.max(0, b.requiredCredits - b.earnedCredits);
                                const isDone = b.status === 'COMPLETED' || rem === 0;
                                return (
                                    <tr key={idx} style={{ borderBottom: '1px solid #F1F5F9', background: idx % 2 === 0 ? 'white' : '#FCFDFD' }}>
                                        <td style={{ padding: '14px 16px' }}>
                                            <strong style={{ color: '#8B0000', display: 'block', fontFamily: 'monospace' }}>{b.bucketCode}</strong>
                                            <span style={{ color: '#1E293B', fontSize: '0.88rem' }}>{b.bucketName}</span>
                                        </td>
                                        <td style={{ padding: '14px 12px' }}>
                                            <span style={{ background: '#EFF6FF', color: '#2563EB', padding: '3px 8px', borderRadius: '6px', fontSize: '0.78rem', fontWeight: 700 }}>
                                                {b.bucketCategory || 'Core'}
                                            </span>
                                        </td>
                                        <td style={{ padding: '14px 12px', textAlign: 'center', fontWeight: 600 }}>
                                            {b.requiredCredits} Cr
                                        </td>
                                        <td style={{ padding: '14px 12px', textAlign: 'center', fontWeight: 800, color: '#059669' }}>
                                            {b.earnedCredits} Cr
                                        </td>
                                        <td style={{ padding: '14px 12px', textAlign: 'center', fontWeight: 700, color: rem === 0 ? '#059669' : '#DC2626' }}>
                                            {rem} Cr
                                        </td>
                                        <td style={{ padding: '14px 16px' }}>
                                            <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                                                <div style={{ flex: 1, height: '7px', background: '#E2E8F0', borderRadius: '4px', overflow: 'hidden' }}>
                                                    <div style={{
                                                        width: `${b.completionPercentage}%`,
                                                        height: '100%',
                                                        background: isDone ? '#10B981' : '#F59E0B'
                                                    }}></div>
                                                </div>
                                                <span style={{ fontSize: '0.8rem', fontWeight: 700, minWidth: '35px' }}>{b.completionPercentage}%</span>
                                            </div>
                                        </td>
                                        <td style={{ padding: '14px 16px', textAlign: 'center' }}>
                                            <span style={{
                                                padding: '4px 10px',
                                                borderRadius: '20px',
                                                fontSize: '0.75rem',
                                                fontWeight: 800,
                                                background: isDone ? '#DCFCE7' : '#FEF3C7',
                                                color: isDone ? '#166534' : '#92400E'
                                            }}>
                                                {isDone ? 'COMPLETED' : 'IN PROGRESS'}
                                            </span>
                                        </td>
                                    </tr>
                                );
                            })}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
}
