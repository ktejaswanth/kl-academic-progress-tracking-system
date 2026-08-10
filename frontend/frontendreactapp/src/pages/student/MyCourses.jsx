import React, { useEffect, useState } from 'react';
import api from '../../api';
import './student.css';

export default function MyCourses() {
    const [curriculum, setCurriculum] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    
    // Custom course logs state
    const [loggedCourses, setLoggedCourses] = useState([]);
    const [loggedLoading, setLoggedLoading] = useState(false);
    const [activeTab, setActiveTab] = useState("curriculum"); // "curriculum" or "my-records"

    // Modal Form State
    const [modalOpen, setModalOpen] = useState(false);
    const [formCourseName, setFormCourseName] = useState("");
    const [formCourseCode, setFormCourseCode] = useState("");
    const [formCategory, setFormCategory] = useState("Core");
    const [formCredits, setFormCredits] = useState(3);
    const [formStatus, setFormStatus] = useState("Completed");
    const [formSubmitting, setFormSubmitting] = useState(false);
    const [formError, setFormError] = useState("");

    // Planner state loaded from local storage specific to the current student
    const [plannedCourses, setPlannedCourses] = useState(() => {
        const storedUser = localStorage.getItem('user');
        const authUser = storedUser ? JSON.parse(storedUser) : null;
        const key = authUser ? authUser.username : 'default';
        const saved = localStorage.getItem(`plannedCourses_${key}`);
        return saved ? JSON.parse(saved) : [];
    });

    const fetchLoggedCourses = async () => {
        setLoggedLoading(true);
        try {
            const response = await api.get('/student/courses');
            setLoggedCourses(response.data);
        } catch (err) {
            console.error("Failed to load logged courses", err);
        } finally {
            setLoggedLoading(false);
        }
    };

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
        fetchLoggedCourses();
    }, []);

    const handleAddCourse = async (e) => {
        e.preventDefault();
        if (!formCourseName || !formCourseCode || !formCategory || !formCredits || !formStatus) {
            setFormError("All fields are required.");
            return;
        }
        setFormSubmitting(true);
        setFormError("");
        try {
            await api.post('/student/courses', {
                courseName: formCourseName,
                courseCode: formCourseCode,
                category: formCategory,
                credits: formCredits,
                status: formStatus
            });
            
            setFormCourseName("");
            setFormCourseCode("");
            setFormCategory("Core");
            setFormCredits(3);
            setFormStatus("Completed");
            setModalOpen(false);

            await fetchLoggedCourses();
            const curriculumResponse = await api.get('/student/curriculum-courses');
            setCurriculum(curriculumResponse.data);
        } catch (err) {
            setFormError(err.response?.data || "Failed to add course.");
        } finally {
            setFormSubmitting(false);
        }
    };

    const handleDeleteCourse = async (courseId) => {
        if (!window.confirm("Are you sure you want to delete this course record?")) return;
        try {
            await api.delete(`/student/courses/${courseId}`);
            await fetchLoggedCourses();
            const curriculumResponse = await api.get('/student/curriculum-courses');
            setCurriculum(curriculumResponse.data);
        } catch (err) {
            alert("Failed to delete course.");
        }
    };

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

    const plannedCount = (courses || []).filter(course => 
        plannedCourses.some(code => code && course.courseCode && code.trim().toUpperCase() === course.courseCode.trim().toUpperCase()) && 
        !(curriculum.completedCourseCodes || []).some(code => code && course.courseCode && code.trim().toUpperCase() === course.courseCode.trim().toUpperCase())
    ).length;
    const plannedPercent = totalCoursesCount > 0 ? Math.round((plannedCount / totalCoursesCount) * 100) : 0;

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

            {/* Tab Navigation */}
            <div className="tab-navigation-container" style={{ display: 'flex', gap: '10px', marginBottom: '2rem', borderBottom: '1px solid #E2E8F0', paddingBottom: '10px' }}>
                <button 
                    onClick={() => setActiveTab("curriculum")} 
                    className={`tab-btn ${activeTab === 'curriculum' ? 'active' : ''}`}
                    style={{
                        padding: '12px 24px',
                        background: activeTab === 'curriculum' ? '#8B0000' : 'transparent',
                        color: activeTab === 'curriculum' ? '#fff' : '#64748B',
                        border: 'none',
                        borderRadius: '12px',
                        fontWeight: 700,
                        cursor: 'pointer',
                        transition: 'all 0.2s',
                    }}
                >
                    📚 Curriculum Requirements
                </button>
                <button 
                    onClick={() => setActiveTab("my-records")} 
                    className={`tab-btn ${activeTab === 'my-records' ? 'active' : ''}`}
                    style={{
                        padding: '12px 24px',
                        background: activeTab === 'my-records' ? '#8B0000' : 'transparent',
                        color: activeTab === 'my-records' ? '#fff' : '#64748B',
                        border: 'none',
                        borderRadius: '12px',
                        fontWeight: 700,
                        cursor: 'pointer',
                        transition: 'all 0.2s',
                    }}
                >
                    📝 My Allocated & Logged Courses
                </button>
            </div>

            {activeTab === 'curriculum' ? (
                <>
                    {/* Analytics Grid */}
                    <div className="analytics-grid" style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: '2rem', marginBottom: '2.5rem' }}>
                        
                        {/* Column 1: Overall Progress Bar Card */}
                        <div className="transcript-card" style={{ padding: '2rem', background: '#ffffff', borderRadius: '24px', boxShadow: '0 10px 30px rgba(0,0,0,0.03)', border: '1px solid #E2E8F0', display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
                                <div>
                                    <h2 style={{ fontSize: '1.25rem', fontWeight: 800, color: '#0F172A', margin: 0 }}>Overall B.Tech Curriculum Progress</h2>
                                    <p style={{ fontSize: '0.9rem', color: '#64748B', margin: '4px 0 0 0' }}>
                                        You have completed <strong>{overallCompleted}</strong> out of <strong>{totalCoursesCount}</strong> total curriculum requirements.
                                    </p>
                                </div>
                            </div>
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
                                    <span style={{ fontSize: '0.8rem', color: '#64748B', display: 'block' }}>Department Completion</span>
                                    <span style={{ fontSize: '1.1rem', fontWeight: 700, color: '#E11D48' }}>{deptPercent}%</span>
                                </div>
                                <div style={{ background: '#F8FAFC', padding: '10px 15px', borderRadius: '12px', border: '1px solid #F1F5F9' }}>
                                    <span style={{ fontSize: '0.8rem', color: '#64748B', display: 'block' }}>Electives & General Completion</span>
                                    <span style={{ fontSize: '1.1rem', fontWeight: 700, color: '#059669' }}>{generalPercent}%</span>
                                </div>
                            </div>
                        </div>

                        {/* Column 2: Donut Pie Chart Card */}
                        <div className="transcript-card" style={{ padding: '2rem', background: '#ffffff', borderRadius: '24px', boxShadow: '0 10px 30px rgba(0,0,0,0.03)', border: '1px solid #E2E8F0', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
                            <h3 style={{ fontSize: '1.1rem', fontWeight: 800, color: '#0F172A', margin: '0 0 1.25rem 0', width: '100%', textAlign: 'center' }}>Curriculum Breakdown</h3>
                            
                            <div style={{ display: 'flex', alignItems: 'center', gap: '20px', justifyContent: 'center', width: '100%', flexWrap: 'wrap' }}>
                                {/* Conic Donut Chart */}
                                <div style={{
                                    width: '110px',
                                    height: '110px',
                                    borderRadius: '50%',
                                    background: `conic-gradient(
                                        #10B981 0% ${overallPercent}%, 
                                        #2563EB ${overallPercent}% ${overallPercent + plannedPercent}%, 
                                        #EF4444 ${overallPercent + plannedPercent}% 100%
                                    )`,
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
                                        justifyContent: 'center',
                                        fontWeight: 800,
                                        fontSize: '1.1rem',
                                        color: '#1E293B'
                                    }}>
                                        {overallPercent}%
                                    </div>
                                </div>

                                {/* Legend */}
                                <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', minWidth: '100px' }}>
                                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                                        <span style={{ width: '10px', height: '10px', borderRadius: '50%', background: '#10B981', display: 'inline-block' }}></span>
                                        <span style={{ fontSize: '0.8rem', color: '#475569', fontWeight: 600 }}>Done ({overallPercent}%)</span>
                                    </div>
                                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                                        <span style={{ width: '10px', height: '10px', borderRadius: '50%', background: '#2563EB', display: 'inline-block' }}></span>
                                        <span style={{ fontSize: '0.8rem', color: '#475569', fontWeight: 600 }}>Planned ({plannedPercent}%)</span>
                                    </div>
                                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                                        <span style={{ width: '10px', height: '10px', borderRadius: '50%', background: '#EF4444', display: 'inline-block' }}></span>
                                        <span style={{ fontSize: '0.8rem', color: '#475569', fontWeight: 600 }}>Not Reg ({Math.max(0, 100 - overallPercent - plannedPercent)}%)</span>
                                    </div>
                                </div>
                            </div>
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
                </>
            ) : (
                <div className="logged-courses-tab animate-fade">
                    {/* Logged Courses Analytics Card */}
                    <div className="analytics-grid" style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '1.5rem', marginBottom: '2.5rem' }}>
                        <div className="transcript-card" style={{ padding: '1.5rem 2rem', background: '#ffffff', borderRadius: '24px', boxShadow: '0 10px 30px rgba(0,0,0,0.03)', border: '1px solid #E2E8F0' }}>
                            <span style={{ fontSize: '0.85rem', color: '#64748B', display: 'block', fontWeight: 600 }}>Total Registered Courses</span>
                            <span style={{ fontSize: '2rem', fontWeight: 800, color: '#0F172A', display: 'block', marginTop: '5px' }}>
                                {loggedCourses.length}
                            </span>
                        </div>
                        <div className="transcript-card" style={{ padding: '1.5rem 2rem', background: '#ffffff', borderRadius: '24px', boxShadow: '0 10px 30px rgba(0,0,0,0.03)', border: '1px solid #E2E8F0' }}>
                            <span style={{ fontSize: '0.85rem', color: '#64748B', display: 'block', fontWeight: 600 }}>Completed Courses</span>
                            <span style={{ fontSize: '2rem', fontWeight: 800, color: '#10B981', display: 'block', marginTop: '5px' }}>
                                {loggedCourses.filter(c => c.status === null || c.status.toLowerCase() !== 'on-progress').length}
                            </span>
                        </div>
                        <div className="transcript-card" style={{ padding: '1.5rem 2rem', background: '#ffffff', borderRadius: '24px', boxShadow: '0 10px 30px rgba(0,0,0,0.03)', border: '1px solid #E2E8F0' }}>
                            <span style={{ fontSize: '0.85rem', color: '#64748B', display: 'block', fontWeight: 600 }}>On-Progress Courses</span>
                            <span style={{ fontSize: '2rem', fontWeight: 800, color: '#F59E0B', display: 'block', marginTop: '5px' }}>
                                {loggedCourses.filter(c => c.status !== null && c.status.toLowerCase() === 'on-progress').length}
                            </span>
                        </div>
                    </div>

                    {/* Section Header with Add Course Button */}
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2rem', flexWrap: 'wrap', gap: '15px' }}>
                        <div>
                            <h2 style={{ fontSize: '1.5rem', fontWeight: 800, color: '#0F172A', margin: 0 }}>My Custom & Logged Courses</h2>
                            <p style={{ fontSize: '0.9rem', color: '#64748B', marginTop: '4px' }}>All courses currently saved under your academic progress.</p>
                        </div>
                        <button 
                            onClick={() => setModalOpen(true)}
                            style={{
                                padding: '12px 24px',
                                background: '#8B0000',
                                color: '#fff',
                                border: 'none',
                                borderRadius: '12px',
                                fontWeight: 700,
                                cursor: 'pointer',
                                transition: 'all 0.2s',
                                boxShadow: '0 4px 12px rgba(139, 0, 0, 0.2)'
                            }}
                        >
                            ➕ Add Custom Course
                        </button>
                    </div>

                    {/* Logged Courses Table */}
                    {loggedLoading ? (
                        <div style={{ textAlign: 'center', padding: '3rem' }}>
                            <div className="premium-loader" style={{ margin: '0 auto 1rem auto' }}></div>
                            <p style={{ color: '#64748B' }}>Fetching your course logs...</p>
                        </div>
                    ) : loggedCourses.length === 0 ? (
                        <div style={{ padding: '4rem 2rem', textAlign: 'center', color: '#64748B', background: '#fff', borderRadius: '24px', border: '1px solid #E2E8F0', boxShadow: '0 10px 30px rgba(0,0,0,0.02)' }}>
                            <span style={{ fontSize: '3rem', display: 'block', marginBottom: '1rem' }}>🎓</span>
                            <h3>No logged courses found</h3>
                            <p style={{ color: '#94A3B8', marginTop: '5px', marginBottom: '1.5rem' }}>You haven't added any completed or on-progress courses yet.</p>
                            <button 
                                onClick={() => setModalOpen(true)}
                                style={{
                                    padding: '10px 20px',
                                    background: '#8B0000',
                                    color: '#fff',
                                    border: 'none',
                                    borderRadius: '10px',
                                    fontWeight: 700,
                                    cursor: 'pointer'
                                }}
                            >
                                Add Your First Course
                            </button>
                        </div>
                    ) : (
                        <div className="transcript-card" style={{ padding: '1.5rem', background: '#fff', borderRadius: '24px', boxShadow: '0 10px 30px rgba(0,0,0,0.02)', border: '1px solid #F1F5F9' }}>
                            <table className="transcript-table">
                                <thead>
                                    <tr>
                                        <th style={{ width: '15%' }}>Course Code</th>
                                        <th style={{ width: '35%' }}>Course Title</th>
                                        <th style={{ width: '15%' }}>Category</th>
                                        <th style={{ width: '10%' }}>Credits</th>
                                        <th style={{ width: '15%' }}>Status</th>
                                        <th style={{ width: '10%', textAlign: 'center' }}>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {loggedCourses.map((course) => (
                                        <tr key={course.id} className="course-row">
                                            <td><code className="code-pill">{course.courseCode}</code></td>
                                            <td><strong>{course.courseName}</strong></td>
                                            <td>
                                                <span className="cat-tag" style={{ background: '#F1F5F9', padding: '4px 10px', borderRadius: '20px', fontSize: '0.8rem', fontWeight: 700, color: '#475569' }}>
                                                    {course.category || 'Curriculum'}
                                                </span>
                                            </td>
                                            <td style={{ fontWeight: 600 }}>{course.credits} Credits</td>
                                            <td>
                                                <span className={`status-tag ${course.status === 'On-Progress' ? 'warning' : 'success'}`}>
                                                    {course.status === 'On-Progress' ? 'In Progress' : 'Completed'}
                                                </span>
                                            </td>
                                            <td style={{ textAlign: 'center' }}>
                                                <button 
                                                    onClick={() => handleDeleteCourse(course.id)}
                                                    style={{
                                                        background: 'transparent',
                                                        border: 'none',
                                                        color: '#EF4444',
                                                        fontSize: '1.1rem',
                                                        cursor: 'pointer',
                                                        padding: '4px 8px',
                                                        borderRadius: '6px',
                                                        transition: 'all 0.2s'
                                                    }}
                                                    title="Delete Course Record"
                                                >
                                                    🗑️
                                                </button>
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    )}
                </div>
            )}

            {/* Add Custom Course Modal */}
            {modalOpen && (
                <div className="modal-overlay" style={{
                    position: 'fixed',
                    top: 0, left: 0, right: 0, bottom: 0,
                    backgroundColor: 'rgba(15, 23, 42, 0.6)',
                    backdropFilter: 'blur(8px)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    zIndex: 1000
                }}>
                    <div className="modal-content" style={{
                        background: '#ffffff',
                        borderRadius: '24px',
                        padding: '2.5rem',
                        width: '100%',
                        maxWidth: '520px',
                        boxShadow: '0 20px 50px rgba(0, 0, 0, 0.15)',
                        border: '1px solid #E2E8F0',
                        position: 'relative'
                    }}>
                        <button 
                            onClick={() => setModalOpen(false)}
                            style={{
                                position: 'absolute',
                                top: '20px', right: '20px',
                                background: 'transparent',
                                border: 'none',
                                fontSize: '1.5rem',
                                color: '#94A3B8',
                                cursor: 'pointer'
                            }}
                        >
                            &times;
                        </button>
                        
                        <h2 style={{ fontSize: '1.5rem', fontWeight: 800, color: '#0F172A', marginBottom: '1.5rem' }}>Add Course Record</h2>
                        
                        {formError && (
                            <div style={{ background: '#FFF1F2', color: '#BE123C', padding: '12px 16px', borderRadius: '12px', fontSize: '0.9rem', marginBottom: '1.5rem', fontWeight: 600 }}>
                                ⚠️ {formError}
                            </div>
                        )}

                        <form onSubmit={handleAddCourse}>
                            <div className="form-group" style={{ marginBottom: '1.25rem' }}>
                                <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Course Full Name</label>
                                <input 
                                    type="text" 
                                    placeholder="e.g. Database Management Systems" 
                                    value={formCourseName}
                                    onChange={(e) => setFormCourseName(e.target.value)}
                                    required
                                    style={{
                                        width: '100%', padding: '12px 16px', borderRadius: '12px', border: '1px solid #CBD5E1', fontSize: '0.95rem', boxSizing: 'border-box'
                                    }}
                                />
                            </div>

                            <div className="form-group" style={{ marginBottom: '1.25rem' }}>
                                <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Course ID / Code</label>
                                <input 
                                    type="text" 
                                    placeholder="e.g. CSE301" 
                                    value={formCourseCode}
                                    onChange={(e) => setFormCourseCode(e.target.value)}
                                    required
                                    style={{
                                        width: '100%', padding: '12px 16px', borderRadius: '12px', border: '1px solid #CBD5E1', fontSize: '0.95rem', boxSizing: 'border-box'
                                    }}
                                />
                            </div>

                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '15px', marginBottom: '1.25rem' }}>
                                <div className="form-group">
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Category</label>
                                    <select 
                                        value={formCategory}
                                        onChange={(e) => setFormCategory(e.target.value)}
                                        style={{
                                            width: '100%', padding: '12px 16px', borderRadius: '12px', border: '1px solid #CBD5E1', fontSize: '0.95rem', background: '#fff', boxSizing: 'border-box'
                                        }}
                                    >
                                        <option value="Core">Core</option>
                                        <option value="Elective">Elective</option>
                                        <option value="Specialization">Specialization</option>
                                        <option value="Honors">Honors</option>
                                        <option value="VAC">VAC (Value Added)</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>

                                <div className="form-group">
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Credits</label>
                                    <select 
                                        value={formCredits}
                                        onChange={(e) => setFormCredits(parseInt(e.target.value))}
                                        style={{
                                            width: '100%', padding: '12px 16px', borderRadius: '12px', border: '1px solid #CBD5E1', fontSize: '0.95rem', background: '#fff', boxSizing: 'border-box'
                                        }}
                                    >
                                        <option value="1">1</option>
                                        <option value="2">2</option>
                                        <option value="3">3</option>
                                        <option value="4">4</option>
                                        <option value="5">5</option>
                                    </select>
                                </div>
                            </div>

                            <div className="form-group" style={{ marginBottom: '2rem' }}>
                                <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '10px' }}>Status</label>
                                <div style={{ display: 'flex', gap: '20px' }}>
                                    <label style={{ display: 'flex', alignItems: 'center', gap: '8px', cursor: 'pointer', fontSize: '0.95rem', fontWeight: 600, color: '#1E293B' }}>
                                        <input 
                                            type="radio" 
                                            name="status" 
                                            value="Completed" 
                                            checked={formStatus === 'Completed'} 
                                            onChange={() => setFormStatus('Completed')}
                                            style={{ width: '18px', height: '18px', accentColor: '#8B0000' }}
                                        />
                                        Completed
                                    </label>
                                    <label style={{ display: 'flex', alignItems: 'center', gap: '8px', cursor: 'pointer', fontSize: '0.95rem', fontWeight: 600, color: '#1E293B' }}>
                                        <input 
                                            type="radio" 
                                            name="status" 
                                            value="On-Progress" 
                                            checked={formStatus === 'On-Progress'} 
                                            onChange={() => setFormStatus('On-Progress')}
                                            style={{ width: '18px', height: '18px', accentColor: '#8B0000' }}
                                        />
                                        On-Progress
                                    </label>
                                </div>
                            </div>

                            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '12px' }}>
                                <button 
                                    type="button" 
                                    onClick={() => setModalOpen(false)}
                                    style={{
                                        padding: '12px 24px', borderRadius: '12px', border: '1px solid #CBD5E1', background: 'transparent', fontWeight: 700, color: '#475569', cursor: 'pointer'
                                    }}
                                >
                                    Cancel
                                </button>
                                <button 
                                    type="submit" 
                                    disabled={formSubmitting}
                                    style={{
                                        padding: '12px 28px', borderRadius: '12px', border: 'none', background: '#8B0000', fontWeight: 700, color: '#fff', cursor: 'pointer', opacity: formSubmitting ? 0.7 : 1
                                    }}
                                >
                                    {formSubmitting ? 'Saving...' : 'Add Course'}
                                </button>
                            </div>
                        </form>
                    </div>
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

                /* Custom Tab Button Hover Styles */
                .tab-btn:hover {
                    background: rgba(139, 0, 0, 0.05) !important;
                    color: #8B0000 !important;
                }
                .tab-btn.active:hover {
                    background: #8B0000 !important;
                    color: #fff !important;
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
