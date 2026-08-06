import React, { useEffect, useState } from 'react';
import api from '../../api';
import './student.css';

export default function MyCourses() {
    const [curriculum, setCurriculum] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [activeFilter, setActiveFilter] = useState('ALL');

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

    const { degreeType, specialization, honorsType, courses } = curriculum;

    // Filter courses based on active filter button
    const filteredCourses = (courses || []).filter(course => {
        if (activeFilter === 'ALL') return true;
        if (activeFilter === 'MANDATORY') return course.isMandatory;
        if (activeFilter === 'ELECTIVES') return !course.isMandatory && !course.bucketName?.toLowerCase().includes('honors');
        if (activeFilter === 'HONORS') return course.bucketName?.toLowerCase().includes('honors');
        return true;
    });

    const totalCredits = (courses || []).reduce((sum, c) => sum + (c.credits || 0), 0);

    return (
        <div className="student-dashboard animate-fade" style={{ paddingBottom: '3rem' }}>
            {/* Header Track Panel */}
            <header className="student-hero" style={{ background: 'linear-gradient(135deg, #8B0000 0%, #1e293b 100%)', minHeight: 'auto', padding: '2.5rem 3rem', borderRadius: '24px', marginBottom: '2.5rem' }}>
                <div className="hero-content">
                    <span className="welcome-tag" style={{ background: 'rgba(255, 255, 255, 0.15)', color: '#fff' }}>My Curriculum Path</span>
                    <h1 style={{ fontSize: '2.2rem', margin: '0.5rem 0', color: '#fff' }}>Required B.Tech Curriculum</h1>
                    <p style={{ color: 'rgba(255, 255, 255, 0.85)', fontSize: '1rem', fontWeight: 500 }}>
                        {degreeType} in <span style={{ color: '#FCA5A5', fontWeight: 700 }}>{specialization}</span> • Track: <span style={{ color: '#FCA5A5', fontWeight: 700 }}>{honorsType}</span>
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

            {/* Courses View Section */}
            <section className="history-section" style={{ marginTop: '0' }}>
                <div className="section-header" style={{ marginBottom: '1.5rem' }}>
                    <h2>B.Tech Academic Catalog</h2>
                    <div className="filters">
                        <button 
                            className={`filter-chip ${activeFilter === 'ALL' ? 'active' : ''}`}
                            onClick={() => setActiveFilter('ALL')}
                        >
                            All Courses
                        </button>
                        <button 
                            className={`filter-chip ${activeFilter === 'MANDATORY' ? 'active' : ''}`}
                            onClick={() => setActiveFilter('MANDATORY')}
                        >
                            Mandatory Core
                        </button>
                        <button 
                            className={`filter-chip ${activeFilter === 'ELECTIVES' ? 'active' : ''}`}
                            onClick={() => setActiveFilter('ELECTIVES')}
                        >
                            Regular Electives
                        </button>
                        {honorsType !== 'REGULAR' && honorsType !== 'NONE' && (
                            <button 
                                className={`filter-chip ${activeFilter === 'HONORS' ? 'active' : ''}`}
                                onClick={() => setActiveFilter('HONORS')}
                            >
                                Honors Bucket
                            </button>
                        )}
                    </div>
                </div>

                <div className="transcript-card" style={{ padding: '1.5rem', background: '#fff', borderRadius: '24px', boxShadow: '0 10px 30px rgba(0,0,0,0.02)' }}>
                    {filteredCourses.length > 0 ? (
                        <table className="transcript-table">
                            <thead>
                                <tr>
                                    <th style={{ width: '15%' }}>Course Code</th>
                                    <th style={{ width: '45%' }}>Course Title</th>
                                    <th style={{ width: '20%' }}>Category Bucket</th>
                                    <th style={{ width: '10%' }}>Credits</th>
                                    <th style={{ width: '10%' }}>Type</th>
                                </tr>
                            </thead>
                            <tbody>
                                {filteredCourses.map((course, idx) => (
                                    <tr key={idx} className="course-row">
                                        <td><code className="code-pill">{course.courseCode}</code></td>
                                        <td><strong>{course.courseName}</strong></td>
                                        <td>
                                            <span className="cat-tag" style={{ 
                                                background: course.bucketName?.toLowerCase().includes('honors') ? '#FFF1F2' : '#EFF6FF',
                                                color: course.bucketName?.toLowerCase().includes('honors') ? '#E11D48' : '#2563EB',
                                                border: course.bucketName?.toLowerCase().includes('honors') ? '1px solid #FFE4E6' : '1px solid #DBEAFE'
                                            }}>
                                                {course.bucketName}
                                            </span>
                                        </td>
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
                    ) : (
                        <div style={{ textAlign: 'center', padding: '4rem', color: '#64748B', fontStyle: 'italic' }}>
                            No courses available under the "{activeFilter.toLowerCase()}" filter.
                        </div>
                    )}
                </div>
            </section>
        </div>
    );
}
