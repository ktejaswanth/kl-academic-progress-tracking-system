import React, { useEffect, useState } from 'react';
import api from '../../api';
import './student.css';

export default function MyCourses() {
    const [curriculum, setCurriculum] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        const fetchCurriculum = async () => {
            try {
                const response = await api.get('/student/curriculum-courses');
                setCurriculum(response.data);
            } catch (err) {
                setError('Failed to retrieve B.Tech curriculum courses.');
            } finally {
                setLoading(false);
            }
        };
        fetchCurriculum();
    }, []);

    if (loading) {
        return (
            <div className="student-loader-container">
                <div className="premium-loader"></div>
                <p>Loading Curriculum Requirements...</p>
            </div>
        );
    }

    if (error) {
        return (
            <div className="student-dashboard">
                <div className="alert error">⚠️ {error}</div>
            </div>
        );
    }

    const { degreeType, specialization, honorsType, department, specializationName, specializationType, courses } = curriculum;

    // Grouping logic
    const honorsCourses = [];
    const specializationCourses = [];
    const departmentCourses = [];
    const generalCourses = [];

    (courses || []).forEach(course => {
        const bucket = (course.bucketName || '').toLowerCase();
        const honors = (course.honorsType || '').toLowerCase();
        
        // 1. Honors Group: If honorsType matches a specific honors program, or bucket name indicates honors
        if ((honors && honors !== 'regular' && honors !== 'none') || bucket.includes('honor')) {
            honorsCourses.push(course);
        }
        // 2. Specialization Group: If bucket name indicates specialization
        else if (bucket.includes('special') || bucket.includes('spec')) {
            specializationCourses.push(course);
        }
        // 3. Department Group: If bucket is core/mandatory/department requirement
        else if (bucket.includes('mandatory') || bucket.includes('core') || bucket.includes('dept')) {
            departmentCourses.push(course);
        }
        // 4. General Group: Everything else (electives, VAC, etc.)
        else {
            generalCourses.push(course);
        }
    });

    const renderCourseTable = (courseList, title, emptyMessage) => {
        if (!courseList || courseList.length === 0) {
            return (
                <div style={{ padding: '2rem', textAlign: 'center', color: '#64748B', fontStyle: 'italic', background: '#F8FAFC', borderRadius: '16px', border: '1px dashed #E2E8F0', marginBottom: '2.5rem' }}>
                    {emptyMessage}
                </div>
            );
        }

        return (
            <div className="transcript-card" style={{ padding: '1.5rem', background: '#fff', borderRadius: '24px', boxShadow: '0 10px 30px rgba(0,0,0,0.02)', marginBottom: '2.5rem', border: '1px solid #F1F5F9' }}>
                <table className="transcript-table">
                    <thead>
                        <tr>
                            <th style={{ width: '15%' }}>Course Code</th>
                            <th style={{ width: '50%' }}>Course Title</th>
                            <th style={{ width: '15%' }}>Credits</th>
                            <th style={{ width: '20%' }}>Type</th>
                        </tr>
                    </thead>
                    <tbody>
                        {courseList.map((course, idx) => (
                            <tr key={idx} className="course-row">
                                <td><code className="code-pill">{course.courseCode}</code></td>
                                <td><strong>{course.courseName}</strong></td>
                                <td style={{ fontWeight: 600 }}>{course.credits} Credits</td>
                                <td>
                                    {course.isMandatory ? (
                                        <span className="status-tag success" style={{ background: '#DCFCE7', color: '#15803D', border: '1px solid #BBF7D0' }}>Mandatory</span>
                                    ) : (
                                        <span className="status-tag warning" style={{ background: '#FEF3C7', color: '#D97706', border: '1px solid #FDE68A' }}>Elective</span>
                                    )}
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        );
    };

    const totalCredits = (courses || []).reduce((sum, c) => sum + (c.credits || 0), 0);

    return (
        <div className="student-dashboard animate-fade" style={{ paddingBottom: '3rem' }}>
            {/* Header Track Panel */}
            <header className="student-hero" style={{ background: 'linear-gradient(135deg, #8B0000 0%, #1e293b 100%)', minHeight: 'auto', padding: '2.5rem 3rem', borderRadius: '24px', marginBottom: '2.5rem' }}>
                <div className="hero-content">
                    <span className="welcome-tag" style={{ background: 'rgba(255, 255, 255, 0.15)', color: '#fff' }}>My Curriculum Path</span>
                    <h1 style={{ fontSize: '2.2rem', margin: '0.5rem 0', color: '#fff' }}>Organized Course Catalog</h1>
                    <p style={{ color: 'rgba(255, 255, 255, 0.85)', fontSize: '1rem', fontWeight: 500 }}>
                        {degreeType} in <span style={{ color: '#FCA5A5', fontWeight: 700 }}>{department}</span> • Specialization: <span style={{ color: '#FCA5A5', fontWeight: 700 }}>{specializationName !== 'N/A' ? specializationName : 'None'}</span> • Honors: <span style={{ color: '#FCA5A5', fontWeight: 700 }}>{honorsType}</span>
                    </p>
                </div>
                <div className="hero-stats">
                    <div className="hero-stat-card" style={{ background: 'rgba(255, 255, 255, 0.08)', backdropFilter: 'blur(10px)', border: '1px solid rgba(255, 255, 255, 0.1)' }}>
                        <span className="label" style={{ color: 'rgba(255,255,255,0.7)' }}>Total Courses</span>
                        <span className="value" style={{ color: '#fff' }}>{courses?.length || 0}</span>
                    </div>
                    <div className="hero-stat-card" style={{ background: 'rgba(255, 255, 255, 0.08)', backdropFilter: 'blur(10px)', border: '1px solid rgba(255, 255, 255, 0.1)' }}>
                        <span className="label" style={{ color: 'rgba(255,255,255,0.7)' }}>Total Credits</span>
                        <span className="value" style={{ color: '#fff' }}>{totalCredits}</span>
                    </div>
                </div>
            </header>

            {/* 1. Department Requirements Section */}
            <section className="curriculum-section">
                <div className="section-header-pill" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '1rem' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                        <span style={{ fontSize: '1.5rem' }}>🏢</span>
                        <h2 style={{ fontSize: '1.3rem', fontWeight: 700, color: '#0F172A', margin: 0 }}>Department Requirements ({department})</h2>
                    </div>
                    <span className="count-badge" style={{ background: '#FFF1F2', color: '#BE123C', padding: '4px 12px', borderRadius: '12px', fontWeight: 700, fontSize: '0.85rem' }}>
                        {departmentCourses.length} Courses
                    </span>
                </div>
                {renderCourseTable(departmentCourses, "Department Requirements", "No department requirements found in the catalog.")}
            </section>

            {/* 2. Specialization Requirements Section */}
            {specializationType !== 'NONE' && specializationName !== 'N/A' && (
                <section className="curriculum-section">
                    <div className="section-header-pill" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '1rem' }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                            <span style={{ fontSize: '1.5rem' }}>🎯</span>
                            <h2 style={{ fontSize: '1.3rem', fontWeight: 700, color: '#0F172A', margin: 0 }}>Specialization Track ({specializationName})</h2>
                        </div>
                        <span className="count-badge" style={{ background: '#EFF6FF', color: '#1D4ED8', padding: '4px 12px', borderRadius: '12px', fontWeight: 700, fontSize: '0.85rem' }}>
                            {specializationCourses.length} Courses
                        </span>
                    </div>
                    {renderCourseTable(specializationCourses, "Specialization Requirements", `No specialization courses found for ${specializationName}.`)}
                </section>
            )}

            {/* 3. Honors Requirements Section */}
            {honorsType !== 'REGULAR' && honorsType !== 'NONE' && (
                <section className="curriculum-section">
                    <div className="section-header-pill" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '1rem' }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                            <span style={{ fontSize: '1.5rem' }}>🏅</span>
                            <h2 style={{ fontSize: '1.3rem', fontWeight: 700, color: '#0F172A', margin: 0 }}>Honors Program Track ({honorsType})</h2>
                        </div>
                        <span className="count-badge" style={{ background: '#F5F3FF', color: '#6D28D9', padding: '4px 12px', borderRadius: '12px', fontWeight: 700, fontSize: '0.85rem' }}>
                            {honorsCourses.length} Courses
                        </span>
                    </div>
                    {renderCourseTable(honorsCourses, "Honors Requirements", `No honors courses found for ${honorsType}.`)}
                </section>
            )}

            {/* 4. General / Electives Section */}
            <section className="curriculum-section">
                <div className="section-header-pill" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '1rem' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                        <span style={{ fontSize: '1.5rem' }}>📚</span>
                        <h2 style={{ fontSize: '1.3rem', fontWeight: 700, color: '#0F172A', margin: 0 }}>General Requirements & Electives</h2>
                    </div>
                    <span className="count-badge" style={{ background: '#ECFDF5', color: '#047857', padding: '4px 12px', borderRadius: '12px', fontWeight: 700, fontSize: '0.85rem' }}>
                        {generalCourses.length} Courses
                    </span>
                </div>
                {renderCourseTable(generalCourses, "General Requirements", "No general/elective requirements found in the catalog.")}
            </section>
        </div>
    );
}
