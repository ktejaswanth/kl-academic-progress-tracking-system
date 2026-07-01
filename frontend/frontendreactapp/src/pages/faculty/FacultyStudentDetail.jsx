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
                                            <button 
                                                onClick={() => handleDeleteCourse(c.id, c.courseCode)}
                                                style={{ background: '#FFF5F5', border: '1px solid #FECACA', color: '#8B0000', padding: '6px 12px', borderRadius: '8px', cursor: 'pointer', fontWeight: 600 }}
                                            >
                                                Delete Record
                                            </button>
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
        </div>
    );
}
