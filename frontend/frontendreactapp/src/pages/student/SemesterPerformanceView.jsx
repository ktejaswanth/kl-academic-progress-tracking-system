import React from 'react';
import { useStudentData } from './StudentDataContext';
import './student.css';

export default function SemesterPerformanceView() {
    const { dashboardData, loading } = useStudentData();

    if (loading) {
        return (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '60vh', color: '#8B0000' }}>
                <div className="spinner" style={{ width: '40px', height: '40px', borderTopColor: '#8B0000', borderWidth: '3px' }}></div>
            </div>
        );
    }

    const semesters = dashboardData?.semesterPerformance || [];
    const cgpa = dashboardData?.cgpa || 8.85;

    // SVG Chart dimensions
    const chartHeight = 180;
    const chartWidth = 700;
    const maxGpa = 10;

    return (
        <div className="student-semester-performance animate-fade" style={{ maxWidth: '1400px', margin: '0 auto', paddingBottom: '3rem' }}>
            <div style={{ marginBottom: '2rem' }}>
                <h1 style={{ fontSize: '2rem', color: '#1E293B', margin: '0 0 6px', fontWeight: 800 }}>Semester Academic Performance</h1>
                <p style={{ color: '#64748B', margin: 0, fontSize: '0.95rem' }}>
                    Semester Grade Point Average (SGPA), cumulative milestones, and completed course credits
                </p>
            </div>

            {/* Performance Overview Banner */}
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: '1.2rem', marginBottom: '2.5rem' }}>
                <div className="glass-card" style={{ padding: '1.5rem', background: 'white', textAlign: 'center' }}>
                    <span style={{ fontSize: '0.8rem', color: '#64748B', fontWeight: 700, textTransform: 'uppercase' }}>Current Cumulative GPA</span>
                    <span style={{ display: 'block', fontSize: '2.5rem', fontWeight: 900, color: '#8B0000', margin: '4px 0' }}>{cgpa}</span>
                    <span style={{ fontSize: '0.82rem', color: '#059669', fontWeight: 600 }}>First Class with Distinction</span>
                </div>

                <div className="glass-card" style={{ padding: '1.5rem', background: 'white', textAlign: 'center' }}>
                    <span style={{ fontSize: '0.8rem', color: '#64748B', fontWeight: 700, textTransform: 'uppercase' }}>Evaluated Semesters</span>
                    <span style={{ display: 'block', fontSize: '2.5rem', fontWeight: 900, color: '#1E293B', margin: '4px 0' }}>{semesters.length}</span>
                    <span style={{ fontSize: '0.82rem', color: '#64748B' }}>Recorded academic terms</span>
                </div>

                <div className="glass-card" style={{ padding: '1.5rem', background: 'white', textAlign: 'center' }}>
                    <span style={{ fontSize: '0.8rem', color: '#64748B', fontWeight: 700, textTransform: 'uppercase' }}>Academic Standing</span>
                    <span style={{ display: 'block', fontSize: '1.6rem', fontWeight: 900, color: '#059669', margin: '10px 0' }}>GOOD STANDING</span>
                    <span style={{ fontSize: '0.82rem', color: '#64748B' }}>Zero active academic warnings</span>
                </div>
            </div>

            {/* Visual Performance Trend Chart */}
            {semesters.length > 0 && (
                <div className="glass-card" style={{ padding: '2rem', background: 'white', marginBottom: '2.5rem' }}>
                    <h3 style={{ margin: '0 0 1.5rem', color: '#1E293B', fontSize: '1.25rem' }}>SGPA Progression Trend</h3>

                    <div style={{ display: 'flex', alignItems: 'flex-end', gap: '20px', height: '220px', padding: '20px 10px', background: '#F8FAFC', borderRadius: '14px', border: '1px solid #E2E8F0' }}>
                        {semesters.map((s, idx) => {
                            const val = parseFloat(s.sgpa) || 8.5;
                            const heightPercent = Math.min(100, (val / maxGpa) * 100);
                            return (
                                <div key={idx} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', height: '100%', justifyContent: 'flex-end' }}>
                                    <span style={{ fontSize: '0.82rem', fontWeight: 800, color: '#8B0000', marginBottom: '6px' }}>{val.toFixed(2)}</span>
                                    <div style={{
                                        width: '45px',
                                        height: `${heightPercent}%`,
                                        background: 'linear-gradient(180deg, #8B0000 0%, #D32F2F 100%)',
                                        borderRadius: '8px 8px 0 0',
                                        transition: 'height 0.5s ease',
                                        boxShadow: '0 4px 10px rgba(139, 0, 0, 0.2)'
                                    }}></div>
                                    <span style={{ fontSize: '0.75rem', fontWeight: 700, color: '#64748B', marginTop: '8px' }}>
                                        {s.semester}
                                    </span>
                                </div>
                            );
                        })}
                    </div>
                </div>
            )}

            {/* Semester-wise Breakdown Table */}
            <div className="glass-card" style={{ padding: '2rem', background: 'white' }}>
                <h3 style={{ margin: '0 0 1.2rem', color: '#1E293B', fontSize: '1.25rem' }}>Detailed Term Transcript</h3>

                <div style={{ overflowX: 'auto', borderRadius: '12px', border: '1px solid #E2E8F0' }}>
                    <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '0.9rem' }}>
                        <thead>
                            <tr style={{ background: '#F8FAFC', borderBottom: '2px solid #E2E8F0', color: '#475569' }}>
                                <th style={{ padding: '14px 16px' }}>Academic Semester</th>
                                <th style={{ padding: '14px 16px', textAlign: 'center' }}>Courses Enrolled</th>
                                <th style={{ padding: '14px 16px', textAlign: 'center' }}>Credits Earned</th>
                                <th style={{ padding: '14px 16px', textAlign: 'center' }}>SGPA</th>
                                <th style={{ padding: '14px 16px', textAlign: 'center' }}>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            {semesters.map((s, idx) => (
                                <tr key={idx} style={{ borderBottom: '1px solid #F1F5F9', background: idx % 2 === 0 ? 'white' : '#FCFDFD' }}>
                                    <td style={{ padding: '14px 16px' }}>
                                        <strong style={{ color: '#8B0000' }}>{s.semester}</strong>
                                    </td>
                                    <td style={{ padding: '14px 16px', textAlign: 'center', color: '#1E293B' }}>
                                        {s.coursesCount} courses
                                    </td>
                                    <td style={{ padding: '14px 16px', textAlign: 'center', fontWeight: 800, color: '#059669' }}>
                                        {s.creditsEarned} Credits
                                    </td>
                                    <td style={{ padding: '14px 16px', textAlign: 'center', fontWeight: 800, color: '#8B0000', fontSize: '1rem' }}>
                                        {s.sgpa}
                                    </td>
                                    <td style={{ padding: '14px 16px', textAlign: 'center' }}>
                                        <span style={{ padding: '4px 10px', borderRadius: '12px', fontSize: '0.75rem', fontWeight: 700, background: '#DCFCE7', color: '#166534' }}>
                                            PASSED
                                        </span>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
}
