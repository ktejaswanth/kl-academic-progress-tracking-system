import React, { useState } from 'react';
import api from '../api';

export default function StudentLookupView({ endpointPrefix }) {
    const [searchId, setSearchId] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const [data, setData] = useState(null);

    const handleSearch = async (e) => {
        e.preventDefault();
        if (!searchId.trim()) return;

        setLoading(true);
        setError('');
        setData(null);

        try {
            const response = await api.get(`${endpointPrefix}/students/lookup/${searchId.trim()}`);
            setData(response.data);
        } catch (err) {
            setError(err.response?.data || 'Failed to locate student record. Please verify the ID number.');
        } finally {
            setLoading(false);
        }
    };

    // UI rendering helpers (reused from student MyCourses page)
    const countCompleted = (courseList, completedCodes) => {
        return courseList.filter(c => 
            completedCodes.some(code => code && c.courseCode && code.trim().toUpperCase() === c.courseCode.trim().toUpperCase())
        ).length;
    };

    const getCourseStatus = (courseCode, completedCodes) => {
        const isCompleted = completedCodes.some(code => code && courseCode && code.trim().toUpperCase() === courseCode.trim().toUpperCase());
        if (isCompleted) return 'COMPLETED';
        return 'UNREGISTERED'; // In-progress is user-defined on student portal local storage, so default is UNREGISTERED for admin view
    };

    const renderProgressBar = (percentage, fillColor) => {
        return (
            <div style={{ display: 'flex', alignItems: 'center', gap: '12px', minWidth: '180px' }}>
                <div style={{
                    flex: 1,
                    height: '8px',
                    background: '#E2E8F0',
                    borderRadius: '10px',
                    overflow: 'hidden',
                    position: 'relative'
                }}>
                    <div style={{
                        width: `${percentage}%`,
                        height: '100%',
                        background: fillColor,
                        borderRadius: '10px',
                        transition: 'width 0.5s ease-out'
                    }}></div>
                </div>
                <span style={{ fontSize: '0.9rem', fontWeight: 700, color: '#475569', minWidth: '35px', textAlign: 'right' }}>
                    {percentage}%
                </span>
            </div>
        );
    };

    const renderCourseTable = (courseList, title, emptyMessage, completedCodes) => {
        if (!courseList || courseList.length === 0) {
            return (
                <div style={{ padding: '2rem', textAlign: 'center', color: '#94A3B8', fontStyle: 'italic', background: '#F8FAFC', borderRadius: '16px', border: '1px dashed #E2E8F0' }}>
                    {emptyMessage}
                </div>
            );
        }

        return (
            <div className="table-card" style={{ background: '#fff', borderRadius: '16px', overflow: 'hidden', border: '1px solid #EDF2F7', boxShadow: '0 4px 12px rgba(0,0,0,0.02)' }}>
                <table className="modern-table" style={{ width: '100%', borderCollapse: 'collapse' }}>
                    <thead>
                        <tr style={{ background: '#F8FAFC', borderBottom: '1px solid #E2E8F0' }}>
                            <th style={{ padding: '1rem 1.25rem', textAlign: 'left', color: '#64748B', fontWeight: 700, fontSize: '0.85rem', width: '50px' }}>Status</th>
                            <th style={{ padding: '1rem 1.25rem', textAlign: 'left', color: '#64748B', fontWeight: 700, fontSize: '0.85rem' }}>Course Code</th>
                            <th style={{ padding: '1rem 1.25rem', textAlign: 'left', color: '#64748B', fontWeight: 700, fontSize: '0.85rem' }}>Course Name</th>
                            <th style={{ padding: '1rem 1.25rem', textAlign: 'center', color: '#64748B', fontWeight: 700, fontSize: '0.85rem', width: '100px' }}>Credits</th>
                            <th style={{ padding: '1rem 1.25rem', textAlign: 'center', color: '#64748B', fontWeight: 700, fontSize: '0.85rem', width: '100px' }}>Category</th>
                        </tr>
                    </thead>
                    <tbody>
                        {courseList.map((course) => {
                            const status = getCourseStatus(course.courseCode, completedCodes);
                            return (
                                <tr 
                                    key={course.id} 
                                    className={status === 'COMPLETED' ? 'completed-row' : ''}
                                    style={{ 
                                        borderBottom: '1px solid #F1F5F9',
                                        background: status === 'COMPLETED' ? '#F0FDF4' : '#ffffff',
                                        opacity: status === 'COMPLETED' ? 0.9 : 1
                                    }}
                                >
                                    <td style={{ padding: '1rem 1.25rem', verticalAlign: 'middle' }}>
                                        <div className="checkbox-wrapper">
                                            <input 
                                                type="checkbox" 
                                                checked={status === 'COMPLETED'}
                                                disabled
                                                className={`curriculum-checkbox ${status === 'COMPLETED' ? 'completed-check' : 'unregistered-check'}`}
                                            />
                                        </div>
                                    </td>
                                    <td style={{ padding: '1rem 1.25rem', fontWeight: 700, color: '#1E293B' }}>{course.courseCode}</td>
                                    <td style={{ padding: '1rem 1.25rem', color: '#475569', fontWeight: 500 }}>{course.courseName}</td>
                                    <td style={{ padding: '1rem 1.25rem', textAlign: 'center', fontWeight: 700, color: '#1E293B' }}>{course.credits}</td>
                                    <td style={{ padding: '1rem 1.25rem', textAlign: 'center' }}>
                                        <span style={{ 
                                            background: '#F1F5F9', 
                                            color: '#475569', 
                                            padding: '4px 8px', 
                                            borderRadius: '6px', 
                                            fontSize: '0.75rem', 
                                            fontWeight: 700 
                                        }}>
                                            {course.category}
                                        </span>
                                    </td>
                                </tr>
                            );
                        })}
                    </tbody>
                </table>
            </div>
        );
    };

    // Destructure fetched curriculum
    const curriculum = data || {};
    const courses = curriculum.courses || [];
    const completedCourseCodes = curriculum.completedCourseCodes || [];

    const studentProfile = curriculum.student || {};
    const degreeType = studentProfile.degreeType || 'B.Tech';
    const branch = studentProfile.branch || 'CSE';
    const specializationName = studentProfile.specializationName || 'N/A';
    const honorsType = studentProfile.honorsType || 'REGULAR';

    // Segment courses
    const departmentCourses = courses.filter(c => c.category === 'DEPARTMENT');
    const specializationCourses = courses.filter(c => c.category === 'SPECIALIZATION');
    const honorsCourses = courses.filter(c => c.category === 'HONORS');
    const generalCourses = courses.filter(c => c.category === 'GENERAL');

    const deptCompleted = countCompleted(departmentCourses, completedCourseCodes);
    const deptPercent = departmentCourses.length > 0 ? Math.round((deptCompleted / departmentCourses.length) * 100) : 0;

    const specCompleted = countCompleted(specializationCourses, completedCourseCodes);
    const specPercent = specializationCourses.length > 0 ? Math.round((specCompleted / specializationCourses.length) * 100) : 0;

    const honorsCompleted = countCompleted(honorsCourses, completedCourseCodes);
    const honorsPercent = honorsCourses.length > 0 ? Math.round((honorsCompleted / honorsCourses.length) * 100) : 0;

    const generalCompleted = countCompleted(generalCourses, completedCourseCodes);
    const generalPercent = generalCourses.length > 0 ? Math.round((generalCompleted / generalCourses.length) * 100) : 0;

    const totalCredits = courses.reduce((sum, c) => sum + (c.credits || 0), 0);
    const totalCoursesCount = courses.length;
    const overallCompleted = countCompleted(courses, completedCourseCodes);
    const overallPercent = totalCoursesCount > 0 ? Math.round((overallCompleted / totalCoursesCount) * 100) : 0;

    return (
        <div style={{ paddingBottom: '3rem' }}>
            <header className="page-header" style={{ marginBottom: '2.5rem' }}>
                <div className="header-title">
                    <span className="welcome-tag">Academic Office</span>
                    <h1 style={{ fontSize: '2.2rem', margin: '0.5rem 0', color: '#0F172A' }}>Student Curriculum Lookup</h1>
                    <p style={{ color: '#64748B' }}>Search a student's ID number to view their required, completed, and missing B.Tech courses.</p>
                </div>
            </header>

            {/* Search Input Box */}
            <div style={{ background: '#fff', padding: '1.5rem 2rem', borderRadius: '20px', boxShadow: '0 4px 15px rgba(0,0,0,0.02)', border: '1px solid #E2E8F0', marginBottom: '2.5rem' }}>
                <form onSubmit={handleSearch} style={{ display: 'flex', gap: '15px', alignItems: 'center' }}>
                    <div style={{ flex: 1, position: 'relative' }}>
                        <span style={{ position: 'absolute', left: '16px', top: '50%', transform: 'translateY(-50%)', opacity: 0.5 }}>🔍</span>
                        <input 
                            type="text"
                            value={searchId}
                            onChange={(e) => setSearchId(e.target.value)}
                            placeholder="Enter Student ID Number (e.g. 220003901)..."
                            style={{ width: '100%', padding: '14px 14px 14px 44px', borderRadius: '12px', border: '1px solid #CBD5E1', outline: 'none', fontSize: '1rem' }}
                            required
                        />
                    </div>
                    <button 
                        type="submit" 
                        disabled={loading}
                        style={{ background: '#8B0000', color: '#fff', border: 'none', padding: '14px 28px', borderRadius: '12px', fontSize: '1rem', fontWeight: 700, cursor: 'pointer', transition: 'background 0.2s' }}
                    >
                        {loading ? 'Searching...' : 'Lookup Progress'}
                    </button>
                </form>
                {error && <div className="alert error" style={{ marginTop: '1.25rem', marginBottom: 0 }}>⚠️ {error}</div>}
            </div>

            {loading && (
                <div style={{ textAlign: 'center', padding: '4rem' }}>
                    <div className="premium-loader" style={{ margin: '0 auto 1.5rem auto' }}></div>
                    <p style={{ color: '#64748B', fontStyle: 'italic' }}>Resolving academic records and logs...</p>
                </div>
            )}

            {/* Read-Only Student Curriculum Display */}
            {data && (
                <div className="animate-fade">
                    {/* Header Track Panel */}
                    <header className="student-hero" style={{ background: 'linear-gradient(135deg, #8B0000 0%, #1e293b 100%)', minHeight: 'auto', padding: '2.5rem 3rem', borderRadius: '24px', marginBottom: '2.5rem' }}>
                        <div className="hero-content">
                            <span className="welcome-tag" style={{ background: 'rgba(255, 255, 255, 0.15)', color: '#fff' }}>Academic Overview</span>
                            <h1 style={{ fontSize: '2.2rem', margin: '0.5rem 0', color: '#fff' }}>
                                {studentProfile.firstName} {studentProfile.lastName}
                            </h1>
                            <p style={{ color: 'rgba(255, 255, 255, 0.85)', fontSize: '1.05rem', fontWeight: 500 }}>
                                {degreeType} in <span style={{ color: '#FCA5A5', fontWeight: 700 }}>{branch}</span> • Specialization: <span style={{ color: '#FCA5A5', fontWeight: 700 }}>{specializationName !== 'N/A' ? specializationName : 'None'}</span> • Honors: <span style={{ color: '#FCA5A5', fontWeight: 700 }}>{honorsType}</span>
                            </p>
                        </div>
                        <div className="hero-stats">
                            <div className="hero-stat-card" style={{ background: 'rgba(255, 255, 255, 0.08)', backdropFilter: 'blur(10px)', border: '1px solid rgba(255, 255, 255, 0.1)' }}>
                                <span className="label" style={{ color: 'rgba(255,255,255,0.7)' }}>Total Courses</span>
                                <span className="value" style={{ color: '#fff' }}>{totalCoursesCount}</span>
                            </div>
                            <div className="hero-stat-card" style={{ background: 'rgba(255, 255, 255, 0.08)', backdropFilter: 'blur(10px)', border: '1px solid rgba(255, 255, 255, 0.1)' }}>
                                <span className="label" style={{ color: 'rgba(255,255,255,0.7)' }}>Total Credits</span>
                                <span className="value" style={{ color: '#fff' }}>{totalCredits}</span>
                            </div>
                        </div>
                    </header>

                    {/* Analytics Grid */}
                    <div className="analytics-grid" style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: '2rem', marginBottom: '2.5rem' }}>
                        {/* Overall Progress Card */}
                        <div className="transcript-card" style={{ padding: '2rem', background: '#ffffff', borderRadius: '24px', boxShadow: '0 10px 30px rgba(0,0,0,0.03)', border: '1px solid #E2E8F0', display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
                            <h2 style={{ fontSize: '1.25rem', fontWeight: 800, color: '#0F172A', margin: 0, marginBottom: '1rem' }}>Overall Curriculum Progress</h2>
                            <div style={{
                                width: '100%',
                                height: '14px',
                                background: '#E2E8F0',
                                borderRadius: '20px',
                                overflow: 'hidden',
                                position: 'relative',
                                boxShadow: 'inset 0 2px 4px rgba(0,0,0,0.05)',
                                marginBottom: '1.5rem'
                            }}>
                                <div style={{
                                    width: `${overallPercent}%`,
                                    height: '100%',
                                    background: 'linear-gradient(90deg, #E11D48 0%, #BE123C 100%)',
                                    borderRadius: '20px',
                                    transition: 'width 0.8s cubic-bezier(0.4, 0, 0.2, 1)'
                                }}></div>
                            </div>
                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '15px' }}>
                                <div style={{ background: '#F8FAFC', padding: '10px 15px', borderRadius: '12px', border: '1px solid #F1F5F9' }}>
                                    <span style={{ fontSize: '0.8rem', color: '#64748B', display: 'block' }}>Department Core</span>
                                    <span style={{ fontSize: '1.1rem', fontWeight: 700, color: '#E11D48' }}>{deptPercent}%</span>
                                </div>
                                <div style={{ background: '#F8FAFC', padding: '10px 15px', borderRadius: '12px', border: '1px solid #F1F5F9' }}>
                                    <span style={{ fontSize: '0.8rem', color: '#64748B', display: 'block' }}>General & Electives</span>
                                    <span style={{ fontSize: '1.1rem', fontWeight: 700, color: '#059669' }}>{generalPercent}%</span>
                                </div>
                            </div>
                        </div>

                        {/* Donut Chart */}
                        <div className="transcript-card" style={{ padding: '2rem', background: '#ffffff', borderRadius: '24px', boxShadow: '0 10px 30px rgba(0,0,0,0.03)', border: '1px solid #E2E8F0', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
                            <h3 style={{ fontSize: '1.1rem', fontWeight: 800, color: '#0F172A', margin: '0 0 1.25rem 0', width: '100%', textAlign: 'center' }}>Curriculum Breakdown</h3>
                            
                            <div style={{ display: 'flex', alignItems: 'center', gap: '20px', justifyContent: 'center', width: '100%', flexWrap: 'wrap' }}>
                                <div style={{
                                    width: '110px',
                                    height: '110px',
                                    borderRadius: '50%',
                                    background: `conic-gradient(#10B981 0% ${overallPercent}%, #EF4444 ${overallPercent}% 100%)`,
                                    boxShadow: '0 4px 15px rgba(0,0,0,0.08)',
                                    position: 'relative',
                                    flexShrink: 0
                                }}>
                                    <div style={{
                                        width: '70px',
                                        height: '70px',
                                        borderRadius: '50%',
                                        background: '#ffffff',
                                        position: 'absolute',
                                        top: '50%',
                                        left: '50%',
                                        transform: 'translate(-50%, -50%)',
                                        display: 'flex',
                                        alignItems: 'center',
                                        justify-content: 'center',
                                        fontWeight: 800,
                                        fontSize: '1.1rem',
                                        color: '#1E293B'
                                    }}>
                                        {overallPercent}%
                                    </div>
                                </div>
                                <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
                                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                                        <span style={{ width: '10px', height: '10px', borderRadius: '50%', background: '#10B981', display: 'inline-block' }}></span>
                                        <span style={{ fontSize: '0.8rem', color: '#475569', fontWeight: 600 }}>Completed ({overallPercent}%)</span>
                                    </div>
                                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                                        <span style={{ width: '10px', height: '10px', borderRadius: '50%', background: '#EF4444', display: 'inline-block' }}></span>
                                        <span style={{ fontSize: '0.8rem', color: '#475569', fontWeight: 600 }}>Remaining ({100 - overallPercent}%)</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* 1. Department Requirements */}
                    <section className="curriculum-section" style={{ marginBottom: '2.5rem' }}>
                        <div className="section-header-pill" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '1rem', flexWrap: 'wrap', gap: '15px' }}>
                            <div style={{ display: 'flex', alignItems: 'center', gap: '20px', flexWrap: 'wrap' }}>
                                <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                                    <span style={{ fontSize: '1.5rem' }}>🏢</span>
                                    <h2 style={{ fontSize: '1.3rem', fontWeight: 700, color: '#0F172A', margin: 0 }}>Department Core ({branch})</h2>
                                </div>
                                {renderProgressBar(deptPercent, '#E11D48')}
                            </div>
                            <span className="count-badge" style={{ background: '#FFF1F2', color: '#BE123C', padding: '4px 12px', borderRadius: '12px', fontWeight: 700, fontSize: '0.85rem' }}>
                                {deptCompleted} / {departmentCourses.length} Completed
                            </span>
                        </div>
                        {renderCourseTable(departmentCourses, "Department Core", "No core department courses found in the catalog.", completedCourseCodes)}
                    </section>

                    {/* 2. Specialization Requirements */}
                    {specializationName !== 'N/A' && (
                        <section className="curriculum-section" style={{ marginBottom: '2.5rem' }}>
                            <div className="section-header-pill" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '1rem', flexWrap: 'wrap', gap: '15px' }}>
                                <div style={{ display: 'flex', alignItems: 'center', gap: '20px', flexWrap: 'wrap' }}>
                                    <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                                        <span style={{ fontSize: '1.5rem' }}>🎯</span>
                                        <h2 style={{ fontSize: '1.3rem', fontWeight: 700, color: '#0F172A', margin: 0 }}>Specialization Track ({specializationName})</h2>
                                    </div>
                                    {renderProgressBar(specPercent, '#2563EB')}
                                </div>
                                <span className="count-badge" style={{ background: '#EFF6FF', color: '#1D4ED8', padding: '4px 12px', borderRadius: '12px', fontWeight: 700, fontSize: '0.85rem' }}>
                                    {specCompleted} / {specializationCourses.length} Completed
                                </span>
                            </div>
                            {renderCourseTable(specializationCourses, "Specialization", "No specialization courses found in the catalog.", completedCourseCodes)}
                        </section>
                    )}

                    {/* 3. Honors Requirements */}
                    {honorsType !== 'REGULAR' && honorsType !== 'NONE' && (
                        <section className="curriculum-section" style={{ marginBottom: '2.5rem' }}>
                            <div className="section-header-pill" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '1rem', flexWrap: 'wrap', gap: '15px' }}>
                                <div style={{ display: 'flex', alignItems: 'center', gap: '20px', flexWrap: 'wrap' }}>
                                    <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                                        <span style={{ fontSize: '1.5rem' }}>🎖️</span>
                                        <h2 style={{ fontSize: '1.3rem', fontWeight: 700, color: '#0F172A', margin: 0 }}>Honors Track ({honorsType})</h2>
                                    </div>
                                    {renderProgressBar(honorsPercent, '#7C3AED')}
                                </div>
                                <span className="count-badge" style={{ background: '#F5F3FF', color: '#6D28D9', padding: '4px 12px', borderRadius: '12px', fontWeight: 700, fontSize: '0.85rem' }}>
                                    {honorsCompleted} / {honorsCourses.length} Completed
                                </span>
                            </div>
                            {renderCourseTable(honorsCourses, "Honors Modules", "No honors courses found in the catalog.", completedCourseCodes)}
                        </section>
                    )}

                    {/* 4. General Requirements & Electives */}
                    <section className="curriculum-section">
                        <div className="section-header-pill" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '1rem', flexWrap: 'wrap', gap: '15px' }}>
                            <div style={{ display: 'flex', alignItems: 'center', gap: '20px', flexWrap: 'wrap' }}>
                                <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                                    <span style={{ fontSize: '1.5rem' }}>📚</span>
                                    <h2 style={{ fontSize: '1.3rem', fontWeight: 700, color: '#0F172A', margin: 0 }}>General Requirements & Electives</h2>
                                </div>
                                {renderProgressBar(generalPercent, '#059669')}
                            </div>
                            <span className="count-badge" style={{ background: '#ECFDF5', color: '#047857', padding: '4px 12px', borderRadius: '12px', fontWeight: 700, fontSize: '0.85rem' }}>
                                {generalCompleted} / {generalCourses.length} Completed
                            </span>
                        </div>
                        {renderCourseTable(generalCourses, "General Requirements", "No general/elective requirements found in the catalog.", completedCourseCodes)}
                    </section>
                </div>
            )}

            <style>{`
                .checkbox-wrapper {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
                
                .curriculum-checkbox {
                    -webkit-appearance: none;
                    appearance: none;
                    width: 20px;
                    height: 20px;
                    border-radius: 6px;
                    display: grid;
                    place-content: center;
                    cursor: not-allowed;
                    background: #fff;
                    margin: 0;
                    position: relative;
                }

                .curriculum-checkbox::before {
                    content: "";
                    width: 10px;
                    height: 6px;
                    border-left: 2.5px solid #fff;
                    border-bottom: 2.5px solid #fff;
                    transform: rotate(-45deg) translate(1px, -1px);
                    opacity: 0;
                    transition: opacity 0.1s ease-in-out;
                }

                .curriculum-checkbox:checked::before {
                    opacity: 1;
                }

                .completed-check {
                    border: 2px solid #10B981;
                    background-color: #10B981;
                }

                .unregistered-check {
                    border: 2px solid #EF4444;
                    background-color: #FFF5F5;
                }

                .completed-row {
                    background: #F0FDF4 !important;
                    opacity: 0.85;
                }

                @media (max-width: 900px) {
                    .analytics-grid {
                        grid-template-columns: 1fr !important;
                    }
                }
            `}</style>
        </div>
    );
}
