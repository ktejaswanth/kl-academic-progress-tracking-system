import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import api from '../../api';
import './faculty.css';

export default function FacultyStudentDetail() {
    const { studentId } = useParams();
    const navigate = useNavigate();

    const [statusData, setStatusData] = useState(null);
    const [buckets, setBuckets] = useState([]);
    const [courses, setCourses] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    // Add Course Form State
    const [courseCode, setCourseCode] = useState('');
    const [grade, setGrade] = useState('O');
    const [semester, setSemester] = useState('ODD');
    const [completedDate, setCompletedDate] = useState(new Date().toISOString().split('T')[0]);
    const [formLoading, setFormLoading] = useState(false);
    const [formError, setFormError] = useState('');
    const [formSuccess, setFormSuccess] = useState('');

    // Role check for Edit permissions
    const storedUser = localStorage.getItem('user');
    const currentUser = storedUser ? JSON.parse(storedUser) : null;
    const userRole = currentUser?.role ? String(currentUser.role).toUpperCase() : '';
    const canEdit = userRole === 'SUPER_ADMIN' || userRole === 'ADMIN' || userRole === 'FACULTY';

    // Edit Course Form State
    const [editModalOpen, setEditModalOpen] = useState(false);
    const [editingCourse, setEditingCourse] = useState(null);
    const [editCourseCode, setEditCourseCode] = useState('');
    const [editCourseName, setEditCourseName] = useState('');
    const [editCredits, setEditCredits] = useState(3);
    const [editGrade, setEditGrade] = useState('O');
    const [editSemester, setEditSemester] = useState('ODD');
    const [editAcademicYear, setEditAcademicYear] = useState('');
    const [editSectionNo, setEditSectionNo] = useState('');
    const [editStatus, setEditStatus] = useState('Completed');
    const [editFormLoading, setEditFormLoading] = useState(false);
    const [editFormError, setEditFormError] = useState('');
    const [editFormSuccess, setEditFormSuccess] = useState('');

    const fetchData = async () => {
        try {
            const [statusRes, bucketsRes, coursesRes] = await Promise.all([
                api.get(`/dyod/progress/student/${studentId}/status`),
                api.get(`/dyod/progress/student/${studentId}/buckets`),
                api.get(`/dyod/courses/student/${studentId}`)
            ]);
            setStatusData(statusRes.data);
            setBuckets(bucketsRes.data);
            setCourses(coursesRes.data);
        } catch (err) {
            setError('Failed to fetch student details. Ensure the student has been evaluated and a path is assigned.');
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchData();
    }, [studentId]);

    const handleAddCourse = async (e) => {
        e.preventDefault();
        if (!courseCode.trim()) {
            setFormError('Course code is required');
            return;
        }

        setFormLoading(true);
        setFormError('');
        setFormSuccess('');

        try {
            await api.post('/dyod/courses/add', {
                studentId: parseInt(studentId),
                courseCode: courseCode.trim().toUpperCase(),
                grade,
                semester,
                completedDate
            });
            setFormSuccess(`Course ${courseCode.toUpperCase()} added successfully!`);
            setCourseCode('');
            // Reload page data to refresh visual progress metrics
            fetchData();
        } catch (err) {
            setFormError(err.response?.data?.error || 'Failed to add completed course. Ensure course code exists and is not duplicate.');
        } finally {
            setFormLoading(false);
        }
    };

    const handleOpenEditModal = (course) => {
        setEditingCourse(course);
        setEditCourseCode(course.courseCode || '');
        setEditCourseName(course.courseName || '');
        setEditCredits(course.credits != null ? course.credits : 3);
        setEditGrade(course.grade || 'O');
        setEditSemester(course.semester || 'ODD');
        setEditAcademicYear(course.academicYear || '');
        setEditSectionNo(course.sectionNo || '');
        setEditStatus(course.status || 'Completed');
        setEditFormError('');
        setEditFormSuccess('');
        setEditModalOpen(true);
    };

    const handleCloseEditModal = () => {
        setEditModalOpen(false);
        setEditingCourse(null);
        setEditFormError('');
        setEditFormSuccess('');
    };

    const handleUpdateCourse = async (e) => {
        e.preventDefault();
        if (!editCourseCode.trim()) {
            setEditFormError('Course code is required.');
            return;
        }

        const credNum = parseInt(editCredits);
        if (isNaN(credNum) || credNum < 0 || credNum > 30) {
            setEditFormError('Credits must be a valid number between 0 and 30.');
            return;
        }

        setEditFormLoading(true);
        setEditFormError('');
        setEditFormSuccess('');

        if (!canEdit) {
            setEditFormError('You are not authorized to edit course records.');
            setEditFormLoading(false);
            return;
        }

        try {
            await api.put(`/dyod/courses/${editingCourse.id}`, {
                courseCode: editCourseCode.trim().toUpperCase(),
                courseName: editCourseName.trim(),
                credits: credNum,
                grade: editGrade,
                semester: editSemester.trim(),
                academicYear: editAcademicYear.trim(),
                sectionNo: editSectionNo.trim(),
                status: editStatus
            });
            setEditFormSuccess(`Course ${editCourseCode.toUpperCase()} updated successfully!`);
            await fetchData();
            setTimeout(() => {
                handleCloseEditModal();
            }, 600);
        } catch (err) {
            setEditFormError(err.response?.data?.error || err.response?.data?.message || 'Failed to update course.');
        } finally {
            setEditFormLoading(false);
        }
    };

    const handleDeleteCourse = async (courseId, code) => {
        if (!window.confirm(`Are you sure you want to delete course ${code} for this student?`)) {
            return;
        }
        try {
            await api.delete(`/dyod/courses/${courseId}`);
            fetchData();
        } catch (err) {
            alert('Failed to delete course record.');
        }
    };

    if (loading) return (
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', height: '80vh', color: '#8B0000' }}>
            <div className="spinner" style={{ width: '40px', height: '40px', borderTopColor: '#8B0000', borderWidth: '3px' }}></div>
            <p style={{ marginTop: '1rem', fontWeight: 600 }}>Loading Student Academic Audits...</p>
        </div>
    );

    if (error) return (
        <div style={{ padding: '2rem' }}>
            <button onClick={() => navigate('/faculty/home')} style={{ marginBottom: '1.5rem', background: '#F1F3F5', border: '1px solid #E9ECEF', padding: '8px 16px', borderRadius: '8px', cursor: 'pointer' }}>
                ← Back to Dashboard
            </button>
            <div className="alert error">{error}</div>
        </div>
    );

    const student = statusData.student;
    const isEligible = statusData.isDegreeEligible;
    const radius = 85;
    const circumference = 2 * Math.PI * radius;
    const offset = circumference - (statusData.completionPercentage / 100) * circumference;

    return (
        <div className="faculty-student-detail animate-fade" style={{ paddingBottom: '4rem' }}>
            <button onClick={() => navigate('/faculty/home')} style={{ marginBottom: '1.5rem', background: '#F1F3F5', border: '1px solid #E9ECEF', padding: '8px 16px', borderRadius: '8px', cursor: 'pointer', fontWeight: 600 }}>
                ← Back to Dashboard
            </button>

            <header className="student-profile-header glass-card" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2.5rem' }}>
                <div>
                    <span className="welcome-tag" style={{ background: '#FFF5F5', color: '#8B0000' }}>Student Record</span>
                    <h1 style={{ fontSize: '2.2rem', margin: '8px 0' }}>{student.firstName} {student.lastName}</h1>
                    <p style={{ color: '#636E72', margin: 0 }}>
                        ID: <strong>{student.username}</strong> • {student.department} Department • {student.subDepartment} Path
                    </p>
                </div>
                <div style={{ textAlign: 'right' }}>
                    <span className={`status-tag ${isEligible ? 'success' : 'warning'}`} style={{ fontSize: '1.1rem', padding: '8px 18px' }}>
                        {isEligible ? 'ELIGIBLE' : 'IN PROGRESS'}
                    </span>
                </div>
            </header>

            <div className="student-grid-layout" style={{ display: 'grid', gridTemplateColumns: '1fr 1.5fr', gap: '2rem', marginBottom: '3rem' }}>
                {/* Visual Completion Radial Card */}
                <div className="glass-card" style={{ textAlign: 'center' }}>
                    <h3 style={{ marginBottom: '1.5rem', color: '#2D3436' }}>Degree Audited Score</h3>
                    <div className="circular-container" style={{ position: 'relative', width: '200px', height: '200px', margin: '0 auto 1.5rem' }}>
                        <svg width="200" height="200" viewBox="0 0 200 200">
                            <defs>
                                <linearGradient id="facultyGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                                    <stop offset="0%" style={{stopColor: '#8B0000', stopOpacity: 1}} />
                                    <stop offset="100%" style={{stopColor: '#D32F2F', stopOpacity: 1}} />
                                </linearGradient>
                            </defs>
                            <circle cx="100" cy="100" r={radius} style={{ fill: 'none', stroke: '#F8F9FA', strokeWidth: 12 }} />
                            <circle 
                                cx="100" cy="100" r={radius} 
                                style={{ 
                                    fill: 'none', 
                                    strokeWidth: 12, 
                                    strokeLinecap: 'round', 
                                    strokeDasharray: circumference, 
                                    strokeDashoffset: offset,
                                    stroke: 'url(#facultyGrad)',
                                    transform: 'rotate(-90deg)',
                                    transformOrigin: '50% 50%',
                                    transition: 'stroke-dashoffset 1s ease'
                                }}
                            />
                        </svg>
                        <div style={{ position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%, -50%)', textAlign: 'center' }}>
                            <span style={{ display: 'block', fontSize: '2.5rem', fontWeight: 900, color: '#8B0000' }}>{statusData.completionPercentage}%</span>
                            <span style={{ fontSize: '0.8rem', color: '#636E72', fontWeight: 600 }}>COMPLETED</span>
                        </div>
                    </div>

                    <div style={{ display: 'flex', gap: '10px' }}>
                        <div className="pill" style={{ flex: 1, background: '#FFF5F5', padding: '10px' }}>
                            <strong style={{ display: 'block', fontSize: '1.2rem' }}>{statusData.totalEarnedCredits}</strong>
                            <span style={{ fontSize: '0.75rem', color: '#636E72' }}>Earned</span>
                        </div>
                        <div className="pill" style={{ flex: 1, background: '#F8F9FA', padding: '10px' }}>
                            <strong style={{ display: 'block', fontSize: '1.2rem' }}>{statusData.totalRequiredCredits}</strong>
                            <span style={{ fontSize: '0.75rem', color: '#636E72' }}>Required</span>
                        </div>
                    </div>
                </div>

                {/* Bucket Completion Details */}
                <div className="glass-card">
                    <h3 style={{ marginBottom: '1.5rem', color: '#2D3436' }}>Bucket Compliance</h3>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '1.2rem' }}>
                        {buckets.map((b, idx) => (
                            <div key={idx} style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
                                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.9rem' }}>
                                    <span>
                                        <strong>{b.bucketCode}</strong> - {b.bucketName}
                                    </span>
                                    <strong>{b.earnedCredits} / {b.requiredCredits} Cr</strong>
                                </div>
                                <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                                    <div style={{ flex: 1, height: '8px', background: '#F1F3F5', borderRadius: '4px', overflow: 'hidden' }}>
                                        <div style={{
                                            width: `${b.completionPercentage}%`,
                                            height: '100%',
                                            background: b.status === 'COMPLETED' ? '#2E7D32' : b.status === 'IN_PROGRESS' ? '#EF6C00' : '#C62828',
                                            borderRadius: '4px'
                                        }}></div>
                                    </div>
                                    <span style={{ fontSize: '0.8rem', fontWeight: 600, minWidth: '35px' }}>{b.completionPercentage}%</span>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            </div>

            {/* Completed Courses Table */}
            <div className="glass-card" style={{ marginBottom: '3rem' }}>
                <h3 style={{ marginBottom: '1.5rem' }}>Course Enrolment Roster</h3>
                {courses.length > 0 ? (
                    <div style={{ overflowX: 'auto' }}>
                        <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
                            <thead>
                                <tr style={{ borderBottom: '2px solid #E9ECEF' }}>
                                    <th style={{ padding: '12px' }}>Code</th>
                                    <th style={{ padding: '12px' }}>Course Name</th>
                                    <th style={{ padding: '12px' }}>Credits</th>
                                    <th style={{ padding: '12px' }}>Grade</th>
                                    <th style={{ padding: '12px' }}>Semester</th>
                                    <th style={{ padding: '12px', textAlign: 'right' }}>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {courses.map((c) => (
                                    <tr key={c.id} style={{ borderBottom: '1px solid #F1F3F5' }}>
                                        <td style={{ padding: '12px' }}><span className="code-pill">{c.courseCode}</span></td>
                                        <td style={{ padding: '12px' }}><strong>{c.courseName}</strong></td>
                                        <td style={{ padding: '12px' }}>{c.credits} Cr</td>
                                        <td style={{ padding: '12px' }}><span className="grade-box">{c.grade}</span></td>
                                        <td style={{ padding: '12px' }}>{c.semester}</td>
                                        <td style={{ padding: '12px', textAlign: 'right' }}>
                                            <div style={{ display: 'flex', gap: '8px', justifyContent: 'flex-end', alignItems: 'center' }}>
                                                {canEdit && (
                                                    <button 
                                                        onClick={() => handleOpenEditModal(c)}
                                                        style={{ background: '#F8F9FA', border: '1px solid #CED4DA', color: '#2B2D42', padding: '6px 12px', borderRadius: '8px', cursor: 'pointer', fontWeight: 600 }}
                                                    >
                                                        Edit
                                                    </button>
                                                )}
                                                <button 
                                                    onClick={() => handleDeleteCourse(c.id, c.courseCode)}
                                                    style={{ background: '#FFF5F5', border: '1px solid #FECACA', color: '#8B0000', padding: '6px 12px', borderRadius: '8px', cursor: 'pointer', fontWeight: 600 }}
                                                >
                                                    Delete
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                ) : (
                    <p style={{ textAlign: 'center', color: '#636E72', padding: '2rem' }}>No courses completed by this student yet.</p>
                )}
            </div>

            {/* Add Completed Course Form */}
            <div className="glass-card">
                <h3 style={{ marginBottom: '1.5rem' }}>Log Completed Course</h3>
                <form onSubmit={handleAddCourse} style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '1.5rem', alignItems: 'end' }}>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                        <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#636E72' }}>Course Code</label>
                        <input 
                            type="text" 
                            placeholder="e.g. 23CS2101"
                            value={courseCode}
                            onChange={(e) => setCourseCode(e.target.value)}
                            style={{ padding: '10px 14px', border: '1px solid #E9ECEF', borderRadius: '8px', outline: 'none' }}
                        />
                    </div>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                        <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#636E72' }}>Grade</label>
                        <select 
                            value={grade} 
                            onChange={(e) => setGrade(e.target.value)}
                            style={{ padding: '10px 14px', border: '1px solid #E9ECEF', borderRadius: '8px', outline: 'none', background: 'white' }}
                        >
                            <option value="O">O</option>
                            <option value="A+">A+</option>
                            <option value="A">A</option>
                            <option value="B+">B+</option>
                            <option value="B">B</option>
                            <option value="C">C</option>
                            <option value="P">P</option>
                            <option value="F">F</option>
                        </select>
                    </div>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                        <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#636E72' }}>Semester</label>
                        <input 
                            type="text" 
                            placeholder="e.g. ODD 2025"
                            value={semester}
                            onChange={(e) => setSemester(e.target.value)}
                            style={{ padding: '10px 14px', border: '1px solid #E9ECEF', borderRadius: '8px', outline: 'none' }}
                        />
                    </div>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                        <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#636E72' }}>Completed Date</label>
                        <input 
                            type="date"
                            value={completedDate}
                            onChange={(e) => setCompletedDate(e.target.value)}
                            style={{ padding: '10px 14px', border: '1px solid #E9ECEF', borderRadius: '8px', outline: 'none' }}
                        />
                    </div>
                    <div>
                        <button 
                            type="submit" 
                            disabled={formLoading}
                            style={{ width: '100%', padding: '11px', background: '#8B0000', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontWeight: 600 }}
                        >
                            {formLoading ? 'Submitting...' : 'Log Course'}
                        </button>
                    </div>
                </form>

                {formError && <div className="alert error" style={{ marginTop: '1.5rem' }}>{formError}</div>}
                {formSuccess && <div className="alert success" style={{ marginTop: '1.5rem' }}>{formSuccess}</div>}
            </div>

            {/* Edit Course Modal */}
            {editModalOpen && editingCourse && (
                <div className="modal-overlay" style={{
                    position: 'fixed',
                    top: 0, left: 0, right: 0, bottom: 0,
                    backgroundColor: 'rgba(15, 23, 42, 0.65)',
                    backdropFilter: 'blur(8px)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    zIndex: 1000
                }}>
                    <div className="modal-content glass-card" style={{
                        background: '#ffffff',
                        borderRadius: '20px',
                        padding: '2.2rem',
                        width: '100%',
                        maxWidth: '560px',
                        boxShadow: '0 25px 60px rgba(0, 0, 0, 0.2)',
                        border: '1px solid #E2E8F0',
                        position: 'relative'
                    }}>
                        <button 
                            onClick={handleCloseEditModal}
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

                        <div style={{ marginBottom: '1.5rem' }}>
                            <span style={{ fontSize: '0.8rem', fontWeight: 700, color: '#8B0000', textTransform: 'uppercase', letterSpacing: '0.5px' }}>Faculty Academic Edit</span>
                            <h2 style={{ fontSize: '1.6rem', fontWeight: 800, color: '#1E293B', margin: '4px 0' }}>Edit Course Record</h2>
                            <p style={{ color: '#64748B', fontSize: '0.85rem', margin: 0 }}>
                                Student: <strong>{student.firstName} {student.lastName}</strong> ({student.username})
                            </p>
                        </div>

                        {editFormError && (
                            <div className="alert error" style={{ marginBottom: '1.2rem', padding: '10px 14px', borderRadius: '8px' }}>
                                ⚠️ {editFormError}
                            </div>
                        )}
                        {editFormSuccess && (
                            <div className="alert success" style={{ marginBottom: '1.2rem', padding: '10px 14px', borderRadius: '8px' }}>
                                ✅ {editFormSuccess}
                            </div>
                        )}

                        <form onSubmit={handleUpdateCourse}>
                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', marginBottom: '1rem' }}>
                                <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                                    <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#475569' }}>Course Code *</label>
                                    <input 
                                        type="text" 
                                        value={editCourseCode}
                                        onChange={(e) => setEditCourseCode(e.target.value)}
                                        style={{ padding: '9px 12px', border: '1px solid #CBD5E1', borderRadius: '8px', outline: 'none' }}
                                        required
                                    />
                                </div>
                                <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                                    <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#475569' }}>Credits *</label>
                                    <input 
                                        type="number" 
                                        min="0"
                                        max="30"
                                        value={editCredits}
                                        onChange={(e) => setEditCredits(e.target.value)}
                                        style={{ padding: '9px 12px', border: '1px solid #CBD5E1', borderRadius: '8px', outline: 'none' }}
                                        required
                                    />
                                </div>
                            </div>

                            <div style={{ display: 'flex', flexDirection: 'column', gap: '6px', marginBottom: '1rem' }}>
                                <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#475569' }}>Course Name</label>
                                <input 
                                    type="text" 
                                    value={editCourseName}
                                    onChange={(e) => setEditCourseName(e.target.value)}
                                    placeholder="Course Title"
                                    style={{ padding: '9px 12px', border: '1px solid #CBD5E1', borderRadius: '8px', outline: 'none' }}
                                />
                            </div>

                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', marginBottom: '1rem' }}>
                                <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                                    <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#475569' }}>Grade</label>
                                    <select 
                                        value={editGrade}
                                        onChange={(e) => setEditGrade(e.target.value)}
                                        style={{ padding: '9px 12px', border: '1px solid #CBD5E1', borderRadius: '8px', outline: 'none', background: 'white' }}
                                    >
                                        <option value="O">O</option>
                                        <option value="A+">A+</option>
                                        <option value="A">A</option>
                                        <option value="B+">B+</option>
                                        <option value="B">B</option>
                                        <option value="C">C</option>
                                        <option value="P">P</option>
                                        <option value="F">F</option>
                                        <option value="Pass">Pass</option>
                                        <option value="IP">IP</option>
                                    </select>
                                </div>
                                <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                                    <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#475569' }}>Status</label>
                                    <select 
                                        value={editStatus}
                                        onChange={(e) => setEditStatus(e.target.value)}
                                        style={{ padding: '9px 12px', border: '1px solid #CBD5E1', borderRadius: '8px', outline: 'none', background: 'white' }}
                                    >
                                        <option value="Completed">Completed</option>
                                        <option value="On-Progress">On-Progress</option>
                                        <option value="In-Progress">In-Progress</option>
                                    </select>
                                </div>
                            </div>

                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', marginBottom: '1rem' }}>
                                <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                                    <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#475569' }}>Semester</label>
                                    <input 
                                        type="text" 
                                        placeholder="e.g. ODD"
                                        value={editSemester}
                                        onChange={(e) => setEditSemester(e.target.value)}
                                        style={{ padding: '9px 12px', border: '1px solid #CBD5E1', borderRadius: '8px', outline: 'none' }}
                                    />
                                </div>
                                <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                                    <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#475569' }}>Academic Year</label>
                                    <input 
                                        type="text" 
                                        placeholder="e.g. 2023-2024"
                                        value={editAcademicYear}
                                        onChange={(e) => setEditAcademicYear(e.target.value)}
                                        style={{ padding: '9px 12px', border: '1px solid #CBD5E1', borderRadius: '8px', outline: 'none' }}
                                    />
                                </div>
                            </div>

                            <div style={{ display: 'flex', flexDirection: 'column', gap: '6px', marginBottom: '1.5rem' }}>
                                <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#475569' }}>Section</label>
                                <input 
                                    type="text" 
                                    placeholder="e.g. S1"
                                    value={editSectionNo}
                                    onChange={(e) => setEditSectionNo(e.target.value)}
                                    style={{ padding: '9px 12px', border: '1px solid #CBD5E1', borderRadius: '8px', outline: 'none' }}
                                />
                            </div>

                            <div style={{ display: 'flex', gap: '12px', justifyContent: 'flex-end' }}>
                                <button 
                                    type="button" 
                                    onClick={handleCloseEditModal}
                                    disabled={editFormLoading}
                                    style={{ padding: '10px 18px', background: '#F1F5F9', border: '1px solid #E2E8F0', borderRadius: '8px', cursor: 'pointer', fontWeight: 600, color: '#475569' }}
                                >
                                    Cancel
                                </button>
                                <button 
                                    type="submit" 
                                    disabled={editFormLoading}
                                    style={{ padding: '10px 20px', background: '#8B0000', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontWeight: 600 }}
                                >
                                    {editFormLoading ? 'Saving...' : 'Save Changes'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}
        </div>
    );
}
