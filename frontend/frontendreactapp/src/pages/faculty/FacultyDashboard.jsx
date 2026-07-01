import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../../api';
import './faculty.css';

export default function FacultyDashboard() {
    const navigate = useNavigate();
    const [dashboardData, setDashboardData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [evaluating, setEvaluating] = useState(false);

    // Quick add course form state
    const [studentUsername, setStudentUsername] = useState('');
    const [courseCode, setCourseCode] = useState('');
    const [grade, setGrade] = useState('O');
    const [semester, setSemester] = useState('ODD');
    const [completedDate, setCompletedDate] = useState(new Date().toISOString().split('T')[0]);
    const [quickAddLoading, setQuickAddLoading] = useState(false);
    const [quickAddError, setQuickAddError] = useState('');
    const [quickAddSuccess, setQuickAddSuccess] = useState('');

    const fetchDashboard = async () => {
        try {
            const response = await api.get('/dyod/faculty/dashboard');
            setDashboardData(response.data);
        } catch (err) {
            console.error("Failed to fetch faculty dashboard", err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchDashboard();
    }, []);

    const handleBatchEvaluate = async () => {
        setEvaluating(true);
        try {
            await api.post('/dyod/progress/batch-evaluate');
            await fetchDashboard();
            alert("Successfully evaluated all students!");
        } catch (err) {
            alert("Error running batch evaluation.");
        } finally {
            setEvaluating(false);
        }
    };

    const handleQuickAddCourse = async (e) => {
        e.preventDefault();
        if (!studentUsername.trim() || !courseCode.trim()) {
            setQuickAddError('Student ID and Course Code are required');
            return;
        }

        setQuickAddLoading(true);
        setQuickAddError('');
        setQuickAddSuccess('');

        try {
            // Find student by username first (or pass to backend)
            // Backend takes student ID (Long) or username? Let's check backend AddCourseController:
            // AddCourseRequest has studentId (Long). But wait, does backend service allow finding by student ID?
            // Yes! But wait, does the faculty know the Long studentId or username?
            // Faculty knows username (e.g. 2100030001). Let's see: does backend have a way to lookup by username?
            // Wait! In AddCourseService:
            // userRepository.findByUsername(studentUsername)
            // But wait, the single add endpoint takes studentId (Long).
            // Let's lookup the student by username from the dashboard's students list first, or check if we can query it!
            // Let's lookup in `dashboardData.students`!
            const matchedStudent = dashboardData.students.find(s => s.student.username === studentUsername.trim());
            if (!matchedStudent) {
                throw new Error(`Student ${studentUsername} not found in this department roster.`);
            }

            await api.post('/dyod/courses/add', {
                studentId: matchedStudent.student.id,
                courseCode: courseCode.trim().toUpperCase(),
                grade,
                semester,
                completedDate
            });

            setQuickAddSuccess(`Successfully logged ${courseCode.toUpperCase()} for ${matchedStudent.student.firstName}!`);
            setStudentUsername('');
            setCourseCode('');
            fetchDashboard();
        } catch (err) {
            setQuickAddError(err.message || err.response?.data?.error || 'Failed to record course completion.');
        } finally {
            setQuickAddLoading(false);
        }
    };

    const handleDownloadDeptReport = async () => {
        try {
            const response = await api.get(`/reports/department/${dashboardData.department}/excel`, { responseType: 'blob' });
            const url = window.URL.createObjectURL(new Blob([response.data]));
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', `department_report_${dashboardData.department}.xlsx`);
            document.body.appendChild(link);
            link.click();
            link.parentNode.removeChild(link);
        } catch (err) {
            alert('Failed to download department progress report.');
        }
    };

    const handleDownloadGraduationReport = async () => {
        try {
            const response = await api.get('/reports/graduation-readiness/excel', { responseType: 'blob' });
            const url = window.URL.createObjectURL(new Blob([response.data]));
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', 'graduation_readiness_report.xlsx');
            document.body.appendChild(link);
            link.click();
            link.parentNode.removeChild(link);
        } catch (err) {
            alert('Failed to download graduation readiness report.');
        }
    };

    if (loading) return (
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', height: '80vh', color: '#8B0000' }}>
            <div className="spinner" style={{ width: '40px', height: '40px', borderTopColor: '#8B0000', borderWidth: '3px' }}></div>
            <p style={{ marginTop: '1rem', fontWeight: 600 }}>Loading Department Dashboard...</p>
        </div>
    );
    
    if (!dashboardData) return <div className="faculty-dashboard">Error loading data.</div>;

    return (
        <div className="faculty-dashboard animate-fade">
            <header className="dashboard-header" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: '15px' }}>
                <div className="welcome-text">
                    <h1>Faculty Portal <span className="badge">Verified</span></h1>
                    <p>Department of {dashboardData.department} • Academic Progress Oversight</p>
                </div>
                <div style={{ display: 'flex', gap: '10px', flexWrap: 'wrap' }}>
                    <button 
                        onClick={handleDownloadDeptReport}
                        className="action-btn"
                        style={{ padding: '10px 16px', background: '#FFF5F5', border: '1px solid #FECACA', color: '#8B0000', borderRadius: '8px', cursor: 'pointer', fontWeight: 600 }}
                    >
                        📊 Dept Report
                    </button>
                    <button 
                        onClick={handleDownloadGraduationReport}
                        className="action-btn"
                        style={{ padding: '10px 16px', background: '#F8F9FA', border: '1px solid #CBD5E1', color: '#2D3436', borderRadius: '8px', cursor: 'pointer', fontWeight: 600 }}
                    >
                        🎓 Univ Roster Report
                    </button>
                    <button 
                        onClick={() => navigate('/faculty/upload-courses')}
                        className="action-btn"
                        style={{ padding: '10px 16px', background: '#F8F9FA', border: '1px solid #E9ECEF', borderRadius: '8px', cursor: 'pointer', fontWeight: 600 }}
                    >
                        📤 Bulk Upload Courses
                    </button>
                    <button 
                        className="action-btn" 
                        onClick={handleBatchEvaluate} 
                        disabled={evaluating}
                        style={{ padding: '10px 16px', backgroundColor: '#8B0000', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontWeight: 600 }}
                    >
                        {evaluating ? 'Evaluating...' : 'Batch Audit'}
                    </button>
                </div>
            </header>

            <div className="stats-grid">
                <div className="stat-card crimson">
                    <div className="stat-icon">👥</div>
                    <div className="stat-info">
                        <h3>Total Students</h3>
                        <div className="value">{dashboardData.totalStudents}</div>
                        <p>In your department</p>
                    </div>
                </div>
                <div className="stat-card alabaster">
                    <div className="stat-icon text-crimson">🎓</div>
                    <div className="stat-info">
                        <h3 className="text-crimson">Eligible for Degree</h3>
                        <div className="value text-dark">{dashboardData.eligibleStudents}</div>
                        <p className="text-muted">Completed all buckets</p>
                    </div>
                </div>
                <div className="stat-card dark">
                    <div className="stat-icon">⏳</div>
                    <div className="stat-info">
                        <h3>In Progress</h3>
                        <div className="value">{dashboardData.pendingStudents}</div>
                        <p>Still completing credits</p>
                    </div>
                </div>
            </div>

            <div className="dashboard-content-grid" style={{ display: 'grid', gridTemplateColumns: '1.5fr 1fr', gap: '2rem', marginTop: '30px' }}>
                
                {/* Roster list */}
                <div className="content-card recent-activity">
                    <h3>Student Eligibility Roster</h3>
                    <p style={{ color: '#636E72', fontSize: '0.9rem', marginBottom: '1rem' }}>Click any student to view detailed bucket mapping and log course completions.</p>
                    <div style={{ overflowX: 'auto' }}>
                        <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
                            <thead>
                                <tr style={{ borderBottom: '2px solid #eee' }}>
                                    <th style={{ padding: '12px 8px' }}>Student</th>
                                    <th style={{ padding: '12px 8px' }}>Degree Path</th>
                                    <th style={{ padding: '12px 8px' }}>Credits</th>
                                    <th style={{ padding: '12px 8px' }}>Buckets</th>
                                    <th style={{ padding: '12px 8px' }}>Completion</th>
                                    <th style={{ padding: '12px 8px' }}>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {dashboardData.students && dashboardData.students.length > 0 ? (
                                    dashboardData.students.map((statusItem, idx) => (
                                        <tr 
                                            key={idx} 
                                            onClick={() => navigate(`/faculty/student/${statusItem.student.id}`)}
                                            style={{ borderBottom: '1px solid #eee', cursor: 'pointer' }}
                                            className="roster-row"
                                        >
                                            <td style={{ padding: '12px 8px' }}>
                                                <strong>{statusItem.student.firstName} {statusItem.student.lastName}</strong>
                                                <div style={{ fontSize: '0.85em', color: '#666' }}>{statusItem.student.username}</div>
                                            </td>
                                            <td style={{ padding: '12px 8px' }}>
                                                <span className="code-pill">
                                                    {statusItem.degreePath.pathCode}
                                                </span>
                                            </td>
                                            <td style={{ padding: '12px 8px' }}>{statusItem.totalEarnedCredits} / {statusItem.totalRequiredCredits}</td>
                                            <td style={{ padding: '12px 8px' }}>{statusItem.bucketsCompleted} / {statusItem.bucketsTotal}</td>
                                            <td style={{ padding: '12px 8px' }}>
                                                <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                                                    <span>{statusItem.completionPercentage}%</span>
                                                    <div style={{ flex: 1, height: '6px', background: '#eee', borderRadius: '3px', overflow: 'hidden' }}>
                                                        <div style={{ width: `${statusItem.completionPercentage}%`, height: '100%', background: statusItem.isDegreeEligible ? '#2E7D32' : '#8B0000' }}></div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td style={{ padding: '12px 8px' }}>
                                                {statusItem.isDegreeEligible ? (
                                                    <span className="status-tag success">ELIGIBLE</span>
                                                ) : (
                                                    <span className="status-tag warning">PENDING</span>
                                                )}
                                            </td>
                                        </tr>
                                    ))
                                ) : (
                                    <tr>
                                        <td colSpan="6" style={{ padding: '20px', textAlign: 'center', color: '#666' }}>No students found or evaluated yet.</td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>

                {/* Quick Add Course Panel */}
                <div className="content-card">
                    <h3>Quick Record Completion</h3>
                    <p style={{ color: '#636E72', fontSize: '0.9rem', marginBottom: '1.5rem' }}>Directly log a student's completed course by ID and course code.</p>
                    
                    <form onSubmit={handleQuickAddCourse} style={{ display: 'flex', flexDirection: 'column', gap: '1.2rem' }}>
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                            <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#636E72' }}>Student Username/ID</label>
                            <input 
                                type="text" 
                                placeholder="e.g. 2100030001"
                                value={studentUsername}
                                onChange={(e) => setStudentUsername(e.target.value)}
                                style={{ padding: '10px 14px', border: '1px solid #E9ECEF', borderRadius: '8px', outline: 'none' }}
                                required
                            />
                        </div>
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                            <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#636E72' }}>Course Code</label>
                            <input 
                                type="text" 
                                placeholder="e.g. 23CS2101"
                                value={courseCode}
                                onChange={(e) => setCourseCode(e.target.value)}
                                style={{ padding: '10px 14px', border: '1px solid #E9ECEF', borderRadius: '8px', outline: 'none' }}
                                required
                            />
                        </div>
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                            <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#636E72' }}>Grade Obtained</label>
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
                                required
                            />
                        </div>
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                            <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#636E72' }}>Completion Date</label>
                            <input 
                                type="date"
                                value={completedDate}
                                onChange={(e) => setCompletedDate(e.target.value)}
                                style={{ padding: '10px 14px', border: '1px solid #E9ECEF', borderRadius: '8px', outline: 'none' }}
                                required
                            />
                        </div>

                        <button 
                            type="submit" 
                            disabled={quickAddLoading}
                            style={{ padding: '12px', background: '#8B0000', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontWeight: 600, marginTop: '8px' }}
                        >
                            {quickAddLoading ? 'Logging Record...' : 'Log Completed Course'}
                        </button>
                    </form>

                    {quickAddError && <div className="alert error" style={{ marginTop: '1rem' }}>{quickAddError}</div>}
                    {quickAddSuccess && <div className="alert success" style={{ marginTop: '1rem' }}>{quickAddSuccess}</div>}
                </div>

            </div>
            <style>{`
                .roster-row:hover {
                    background-color: #F8FAFC !important;
                }
            `}</style>
        </div>
    );
}
