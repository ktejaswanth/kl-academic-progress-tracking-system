import React, { useEffect, useState } from 'react';
import api from '../../api';
import './student.css';

export default function MyCourses() {
    const [curriculum, setCurriculum] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    
    // Planner state loaded from local storage specific to the current student
    const [plannedCourses, setPlannedCourses] = useState(() => {
        const storedUser = localStorage.getItem('user');
        const authUser = storedUser ? JSON.parse(storedUser) : null;
        const key = authUser ? authUser.username : 'default';
        const saved = localStorage.getItem(`plannedCourses_${key}`);
        return saved ? JSON.parse(saved) : [];
    });

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

    // Save planned courses to localStorage on update
    useEffect(() => {
        const storedUser = localStorage.getItem('user');
        const authUser = storedUser ? JSON.parse(storedUser) : null;
        const key = authUser ? authUser.username : 'default';
        localStorage.setItem(`plannedCourses_${key}`, JSON.stringify(plannedCourses));
    }, [plannedCourses]);

    const togglePlanCourse = (courseCode) => {
        setPlannedCourses(prev => {
            if (prev.includes(courseCode)) {
                return prev.filter(code => code !== courseCode);
            } else {
                return [...prev, courseCode];
            }
        });
    };

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

        const completedCodes = curriculum.completedCourseCodes || [];

        return (
            <div className="transcript-card" style={{ padding: '1.5rem', background: '#fff', borderRadius: '24px', boxShadow: '0 10px 30px rgba(0,0,0,0.02)', marginBottom: '2.5rem', border: '1px solid #F1F5F9' }}>
                <table className="transcript-table">
                    <thead>
                        <tr>
                            <th style={{ width: '8%', textAlign: 'center' }}>Plan</th>
                            <th style={{ width: '15%' }}>Course Code</th>
                            <th style={{ width: '42%' }}>Course Title</th>
                            <th style={{ width: '15%' }}>Credits</th>
                            <th style={{ width: '20%' }}>Type</th>
                        </tr>
                    </thead>
                    <tbody>
                        {courseList.map((course, idx) => {
                            const isCompleted = completedCodes.some(code => code && course.courseCode && code.trim().toUpperCase() === course.courseCode.trim().toUpperCase());
                            const isPlanned = plannedCourses.some(code => code && course.courseCode && code.trim().toUpperCase() === course.courseCode.trim().toUpperCase());

                            return (
                                <tr key={idx} className={`course-row ${isCompleted ? 'completed-row' : ''} ${isPlanned && !isCompleted ? 'planned-row' : ''}`}>
                                    <td style={{ textAlign: 'center', verticalAlign: 'middle' }}>
                                        <div className="checkbox-wrapper">
                                            <input 
                                                type="checkbox"
                                                checked={isCompleted || isPlanned}
                                                disabled={isCompleted}
                                                onChange={() => togglePlanCourse(course.courseCode)}
                                                className={`curriculum-checkbox ${isCompleted ? 'completed-check' : (isPlanned ? 'planned-check' : 'unregistered-check')}`}
                                                title={isCompleted ? "Completed Course" : (isPlanned ? "Planned Course" : "Not Registered")}
                                            />
                                        </div>
                                    </td>
                                    <td><code className="code-pill">{course.courseCode}</code></td>
                                    <td>
                                        <strong>{course.courseName}</strong>
                                        {isCompleted && (
                                            <span style={{ marginLeft: '10px', background: '#DCFCE7', color: '#15803D', fontSize: '0.7rem', padding: '2px 8px', borderRadius: '10px', fontWeight: 600 }}>
                                                ✓ Completed
                                            </span>
                                        )}
                                        {isPlanned && !isCompleted && (
                                            <span style={{ marginLeft: '10px', background: '#EFF6FF', color: '#1D4ED8', fontSize: '0.7rem', padding: '2px 8px', borderRadius: '10px', fontWeight: 600 }}>
                                                📅 Planned
                                            </span>
                                        )}
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
                            );
                        })}
                    </tbody>
                </table>
            </div>
        );
    };

    const countCompleted = (courseList) => {
        const completedCodes = curriculum.completedCourseCodes || [];
        return courseList.filter(course => 
            completedCodes.some(code => code && course.courseCode && code.trim().toUpperCase() === course.courseCode.trim().toUpperCase())
        ).length;
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

    const deptCompleted = countCompleted(departmentCourses);
    const deptPercent = departmentCourses.length > 0 ? Math.round((deptCompleted / departmentCourses.length) * 100) : 0;

    const specCompleted = countCompleted(specializationCourses);
    const specPercent = specializationCourses.length > 0 ? Math.round((specCompleted / specializationCourses.length) * 100) : 0;

    const honorsCompleted = countCompleted(honorsCourses);
    const honorsPercent = honorsCourses.length > 0 ? Math.round((honorsCompleted / honorsCourses.length) * 100) : 0;

    const generalCompleted = countCompleted(generalCourses);
    const generalPercent = generalCourses.length > 0 ? Math.round((generalCompleted / generalCourses.length) * 100) : 0;

    const totalCredits = (courses || []).reduce((sum, c) => sum + (c.credits || 0), 0);
    const totalCoursesCount = courses ? courses.length : 0;
    const overallCompleted = (courses || []).filter(course => 
        (curriculum.completedCourseCodes || []).some(code => code && course.courseCode && code.trim().toUpperCase() === course.courseCode.trim().toUpperCase())
    ).length;
    const overallPercent = totalCoursesCount > 0 ? Math.round((overallCompleted / totalCoursesCount) * 100) : 0;

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

            {/* Overall Progress Panel */}
            <div className="transcript-card animate-fade" style={{ padding: '2rem', background: 'linear-gradient(135deg, #ffffff 0%, #f8fafc 100%)', borderRadius: '24px', boxShadow: '0 10px 30px rgba(0,0,0,0.03)', marginBottom: '2.5rem', border: '1px solid #E2E8F0' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem', flexWrap: 'wrap', gap: '10px' }}>
                    <div>
                        <h2 style={{ fontSize: '1.2rem', fontWeight: 800, color: '#0F172A', margin: 0 }}>Overall B.Tech Curriculum Progress</h2>
                        <p style={{ fontSize: '0.9rem', color: '#64748B', margin: '4px 0 0 0' }}>
                            You have completed <strong>{overallCompleted}</strong> out of <strong>{totalCoursesCount}</strong> total curriculum requirements.
                        </p>
                    </div>
                    <span style={{ fontSize: '1.8rem', fontWeight: 900, color: '#E11D48' }}>
                        {overallPercent}%
                    </span>
                </div>
                <div style={{
                    width: '100%',
                    height: '14px',
                    background: '#E2E8F0',
                    borderRadius: '20px',
                    overflow: 'hidden',
                    position: 'relative',
                    boxShadow: 'inset 0 2px 4px rgba(0,0,0,0.05)'
                }}>
                    <div style={{
                        width: `${overallPercent}%`,
                        height: '100%',
                        background: 'linear-gradient(90deg, #E11D48 0%, #BE123C 100%)',
                        borderRadius: '20px',
                        transition: 'width 0.8s cubic-bezier(0.4, 0, 0.2, 1)'
                    }}></div>
                </div>
            </div>

            {/* 1. Department Requirements Section */}
            <section className="curriculum-section">
                <div className="section-header-pill" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '1rem', flexWrap: 'wrap', gap: '15px' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '20px', flexWrap: 'wrap' }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                            <span style={{ fontSize: '1.5rem' }}>🏢</span>
                            <h2 style={{ fontSize: '1.3rem', fontWeight: 700, color: '#0F172A', margin: 0 }}>Department Requirements ({department})</h2>
                        </div>
                        {renderProgressBar(deptPercent, '#E11D48')}
                    </div>
                    <span className="count-badge" style={{ background: '#FFF1F2', color: '#BE123C', padding: '4px 12px', borderRadius: '12px', fontWeight: 700, fontSize: '0.85rem' }}>
                        {deptCompleted} / {departmentCourses.length} Completed
                    </span>
                </div>
                {renderCourseTable(departmentCourses, "Department Requirements", "No department requirements found in the catalog.")}
            </section>

            {/* 2. Specialization Requirements Section */}
            {specializationType !== 'NONE' && specializationName !== 'N/A' && (
                <section className="curriculum-section">
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
                    {renderCourseTable(specializationCourses, "Specialization Requirements", `No specialization courses found for ${specializationName}.`)}
                </section>
            )}

            {/* 3. Honors Requirements Section */}
            {honorsType !== 'REGULAR' && honorsType !== 'NONE' && (
                <section className="curriculum-section">
                    <div className="section-header-pill" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '1rem', flexWrap: 'wrap', gap: '15px' }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '20px', flexWrap: 'wrap' }}>
                            <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                                <span style={{ fontSize: '1.5rem' }}>🏅</span>
                                <h2 style={{ fontSize: '1.3rem', fontWeight: 700, color: '#0F172A', margin: 0 }}>Honors Program Track ({honorsType})</h2>
                            </div>
                            {renderProgressBar(honorsPercent, '#7C3AED')}
                        </div>
                        <span className="count-badge" style={{ background: '#F5F3FF', color: '#6D28D9', padding: '4px 12px', borderRadius: '12px', fontWeight: 700, fontSize: '0.85rem' }}>
                            {honorsCompleted} / {honorsCourses.length} Completed
                        </span>
                    </div>
                    {renderCourseTable(honorsCourses, "Honors Requirements", `No honors courses found for ${honorsType}.`)}
                </section>
            )}

            {/* 4. General / Electives Section */}
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
                {renderCourseTable(generalCourses, "General Requirements", "No general/elective requirements found in the catalog.")}
            </section>

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
                    cursor: pointer;
                    background: #fff;
                    transition: all 0.2s ease-in-out;
                    margin: 0;
                    position: relative;
                }

                .curriculum-checkbox::before {
                    content: "";
                    width: 10px;
                    height: 6px;
                    border-left: 2.5px solid white;
                    border-bottom: 2.5px solid white;
                    transform: rotate(-45deg) scale(0);
                    transition: transform 0.15s ease-in-out;
                    margin-top: -2px;
                }

                .curriculum-checkbox:checked::before {
                    transform: rotate(-45deg) scale(1);
                }

                /* Completed: Green */
                .completed-check {
                    border: 2px solid #10B981;
                    background-color: #10B981;
                    cursor: not-allowed;
                }

                /* Planned / On-Progress: Blue ("dont do anything special") */
                .planned-check {
                    border: 2px solid #2563EB;
                    background-color: #2563EB;
                }

                /* Unregistered: Red */
                .unregistered-check {
                    border: 2px solid #EF4444;
                    background-color: #FFF5F5;
                }
                .unregistered-check:hover {
                    border-color: #DC2626;
                    box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.2);
                }

                .completed-row {
                    background: #F0FDF4 !important; /* Soft green */
                    opacity: 0.85;
                }
                .planned-row {
                    background: #EFF6FF !important; /* Soft blue */
                }
            `}</style>
        </div>
    );
}
