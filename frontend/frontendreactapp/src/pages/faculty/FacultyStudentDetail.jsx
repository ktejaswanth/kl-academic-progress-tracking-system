import React, { useEffect, useState, useMemo } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import api from '../../api';
import './faculty.css';

const CATEGORIES = [
    { code: 'HAS', name: 'Humanities & Social Sciences', color: '#6366F1' },
    { code: 'BSC', name: 'Basic Science Core', color: '#0EA5E9' },
    { code: 'ESC', name: 'Engineering Science Core', color: '#10B981' },
    { code: 'FCC', name: 'Foundational Core Courses', color: '#F59E0B' },
    { code: 'PCC', name: 'Professional Core Courses', color: '#8B0000' },
    { code: 'PEC', name: 'Professional Elective Courses', color: '#EC4899' },
    { code: 'SDC', name: 'Skill Development Courses', color: '#8B5CF6' },
    { code: 'PRI', name: 'Project & Research / Internship', color: '#14B8A6' },
    { code: 'OEC', name: 'Open Elective Courses', color: '#F97316' },
    { code: 'SIL', name: 'Social Immersive Learning', color: '#059669' },
];

const GRADES = ['O', 'A+', 'A', 'B+', 'B', 'C', 'P', 'F'];
const STATUSES = ['COMPLETED', 'REGISTERED', 'FAILED'];

export default function FacultyStudentDetail() {
    const { studentId } = useParams();
    const navigate = useNavigate();

    // Data States
    const [courses, setCourses] = useState([]);
    const [exitSummary, setExitSummary] = useState(null);
    const [exitReport, setExitReport] = useState(null);
    const [buckets, setBuckets] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [toast, setToast] = useState(null);

    // Tab State: 'courses' | 'exit-report' | 'buckets'
    const [activeTab, setActiveTab] = useState('courses');

    // Filter & Search States
    const [searchTerm, setSearchTerm] = useState('');
    const [filterCategory, setFilterCategory] = useState('');
    const [filterSemester, setFilterSemester] = useState('');
    const [filterStatus, setFilterStatus] = useState('');

    // Catalog Autocomplete for Add Course Form
    const [catalogOptions, setCatalogOptions] = useState([]);
    const [catalogSearch, setCatalogSearch] = useState('');
    const [catalogLoading, setCatalogLoading] = useState(false);

    // Modal States
    const [showAddModal, setShowAddModal] = useState(false);
    const [showEditModal, setShowEditModal] = useState(false);
    const [showDeleteModal, setShowDeleteModal] = useState(false);
    const [modalSubmitting, setModalSubmitting] = useState(false);
    const [modalError, setModalError] = useState('');

    // Form fields for Add / Edit
    const [formData, setFormData] = useState({
        courseCode: '',
        courseName: '',
        category: 'PCC',
        credits: 3.0,
        obtainedCredits: 3.0,
        semester: 'Odd Sem',
        academicYear: '2024-2025',
        attempt1: 'A+',
        attempt2: '-',
        attempt3: '-',
        grade: 'A+',
        status: 'COMPLETED'
    });

    const [selectedCourseForAction, setSelectedCourseForAction] = useState(null);

    const showToast = (type, message) => {
        setToast({ type, message });
        setTimeout(() => setToast(null), 4000);
    };

    // Load Student Records, Courses, and Exit Requirement Summary
    const loadStudentData = async () => {
        try {
            setLoading(true);
            const [coursesRes, summaryRes] = await Promise.all([
                api.get(`/student-course-management/students/${studentId}/courses`),
                api.get(`/student-course-management/students/${studentId}/summary`).catch(() => null)
            ]);

            setCourses(coursesRes.data || []);
            if (summaryRes?.data) {
                setExitSummary(summaryRes.data);
            }

            // Also load legacy bucket compliance & exit report if available
            try {
                const [bucketRes, reportRes] = await Promise.all([
                    api.get(`/dyod/progress/student/${studentId}/buckets`).catch(() => null),
                    api.get(`/exit/admin/report/${studentId}`).catch(() => 
                        api.get(`/exit/faculty/report/${studentId}`).catch(() => null)
                    )
                ]);
                if (bucketRes?.data) setBuckets(bucketRes.data);
                if (reportRes?.data) setExitReport(reportRes.data);
            } catch (ignore) {}

        } catch (err) {
            console.error('Error fetching student course management data:', err);
            setError('Failed to fetch student details. Verify that the student ID is valid.');
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        loadStudentData();
    }, [studentId]);

    // Live catalog search for Add Modal
    useEffect(() => {
        if (!showAddModal) return;
        const delayDebounce = setTimeout(async () => {
            setCatalogLoading(true);
            try {
                const res = await api.get(`/student-course-management/catalog`, {
                    params: { search: catalogSearch.trim() }
                });
                setCatalogOptions(res.data || []);
            } catch (err) {
                console.error('Failed to load course catalog', err);
            } finally {
                setCatalogLoading(false);
            }
        }, 250);

        return () => clearTimeout(delayDebounce);
    }, [catalogSearch, showAddModal]);

    // Filtered courses list
    const filteredCourses = useMemo(() => {
        return courses.filter(c => {
            const matchesSearch = !searchTerm || 
                c.courseCode?.toLowerCase().includes(searchTerm.toLowerCase()) ||
                c.courseName?.toLowerCase().includes(searchTerm.toLowerCase());
            const matchesCat = !filterCategory || c.category === filterCategory;
            const matchesSem = !filterSemester || c.semester === filterSemester;
            const matchesStatus = !filterStatus || c.status === filterStatus;
            return matchesSearch && matchesCat && matchesSem && matchesStatus;
        });
    }, [courses, searchTerm, filterCategory, filterSemester, filterStatus]);

    // Unique semesters for dropdown
    const availableSemesters = useMemo(() => {
        const set = new Set();
        courses.forEach(c => { if (c.semester) set.add(c.semester); });
        return Array.from(set).sort();
    }, [courses]);

    // Handlers for Add Course
    const openAddModal = () => {
        setCatalogSearch('');
        setFormData({
            courseCode: '',
            courseName: '',
            category: 'PCC',
            credits: 3.0,
            obtainedCredits: 3.0,
            semester: 'Odd Sem',
            academicYear: '2024-2025',
            attempt1: 'A+',
            attempt2: '-',
            attempt3: '-',
            grade: 'A+',
            status: 'COMPLETED'
        });
        setModalError('');
        setShowAddModal(true);
    };

    const handleSelectCatalogCourse = (item) => {
        setFormData(prev => ({
            ...prev,
            courseCode: item.courseCode,
            courseName: item.courseName,
            credits: item.credits || 3.0,
            obtainedCredits: item.credits || 3.0,
            category: item.category || prev.category
        }));
        setCatalogSearch(`${item.courseCode} - ${item.courseName}`);
    };

    const submitAddCourse = async (e) => {
        e.preventDefault();
        if (!formData.courseCode.trim()) {
            setModalError('Please enter or select a valid Course Code.');
            return;
        }

        setModalSubmitting(true);
        setModalError('');

        try {
            const res = await api.post(`/student-course-management/students/${studentId}/courses`, formData);
            showToast('success', res.data.message || `Course ${formData.courseCode} added successfully!`);
            setShowAddModal(false);
            if (res.data.exitSummary) {
                setExitSummary(res.data.exitSummary);
            }
            // Refresh list
            loadStudentData();
        } catch (err) {
            setModalError(err.response?.data?.message || err.response?.data?.error || 'Failed to add course record.');
        } finally {
            setModalSubmitting(false);
        }
    };

    // Handlers for Edit Course
    const openEditModal = (course) => {
        setSelectedCourseForAction(course);
        setFormData({
            courseCode: course.courseCode,
            courseName: course.courseName,
            category: course.category || 'PCC',
            credits: course.credits || 3.0,
            obtainedCredits: course.obtainedCredits != null ? course.obtainedCredits : (course.credits || 3.0),
            semester: course.semester || 'Odd Sem',
            academicYear: course.academicYear || '2024-2025',
            attempt1: course.attempt1 || '-',
            attempt2: course.attempt2 || '-',
            attempt3: course.attempt3 || '-',
            grade: course.grade || 'A+',
            status: course.status || 'COMPLETED'
        });
        setModalError('');
        setShowEditModal(true);
    };

    const submitEditCourse = async (e) => {
        e.preventDefault();
        setModalSubmitting(true);
        setModalError('');

        try {
            const res = await api.put(
                `/student-course-management/students/${studentId}/courses/${selectedCourseForAction.courseCode}`,
                formData
            );
            showToast('success', res.data.message || `Course ${selectedCourseForAction.courseCode} updated successfully!`);
            setShowEditModal(false);
            if (res.data.exitSummary) {
                setExitSummary(res.data.exitSummary);
            }
            // Refresh list
            loadStudentData();
        } catch (err) {
            setModalError(err.response?.data?.message || err.response?.data?.error || 'Failed to update course.');
        } finally {
            setModalSubmitting(false);
        }
    };

    // Handlers for Delete Course (Soft-delete)
    const openDeleteModal = (course) => {
        setSelectedCourseForAction(course);
        setShowDeleteModal(true);
    };

    const submitDeleteCourse = async () => {
        if (!selectedCourseForAction) return;
        setModalSubmitting(true);
        try {
            const res = await api.delete(
                `/student-course-management/students/${studentId}/courses/${selectedCourseForAction.courseCode}`
            );
            showToast('success', res.data.message || `Course ${selectedCourseForAction.courseCode} removed.`);
            setShowDeleteModal(false);
            if (res.data.exitSummary) {
                setExitSummary(res.data.exitSummary);
            }
            loadStudentData();
        } catch (err) {
            alert(err.response?.data?.message || err.response?.data?.error || 'Failed to remove course.');
        } finally {
            setModalSubmitting(false);
        }
    };

    // Download PDF
    const handleDownloadPdf = async () => {
        try {
            showToast('info', 'Generating official 6-page Exit Requirement PDF...');
            let url = `/exit/admin/download-pdf/${studentId}`;
            let res;
            try {
                res = await api.get(url, { responseType: 'blob' });
            } catch (e) {
                // Try faculty endpoint
                url = `/exit/faculty/download-pdf/${studentId}`;
                res = await api.get(url, { responseType: 'blob' });
            }

            const blobUrl = window.URL.createObjectURL(new Blob([res.data], { type: 'application/pdf' }));
            const link = document.createElement('a');
            link.href = blobUrl;
            link.setAttribute('download', `Student_exit_requirement_${studentId}.pdf`);
            document.body.appendChild(link);
            link.click();
            link.parentNode.removeChild(link);
            showToast('success', 'PDF downloaded successfully!');
        } catch (err) {
            console.error('PDF download error:', err);
            showToast('error', 'Failed to generate PDF. Ensure the student has registered records.');
        }
    };

    if (loading) {
        return (
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', height: '70vh', color: '#8B0000' }}>
                <div className="spinner" style={{ width: '45px', height: '45px', borderTopColor: '#8B0000', borderWidth: '3px' }}></div>
                <p style={{ marginTop: '1.2rem', fontWeight: 600, fontSize: '1.1rem' }}>Loading Student Academic Records & Course Management...</p>
            </div>
        );
    }

    if (error) {
        return (
            <div style={{ padding: '2rem' }}>
                <button onClick={() => navigate(-1)} style={{ marginBottom: '1.5rem', background: '#F1F3F5', border: '1px solid #E9ECEF', padding: '8px 16px', borderRadius: '8px', cursor: 'pointer', fontWeight: 600 }}>
                    ← Back to Students
                </button>
                <div className="alert error">{error}</div>
            </div>
        );
    }

    // Extract & calculate student academic profile attributes
    const studentInfo = useMemo(() => {
        const raw = exitSummary || {};
        const st = raw.student || {};
        const firstCourse = courses[0] || {};

        const rollNumber = st.rollNumber || raw.rollNumber || firstCourse.rollNumber || studentId;
        const studentName = st.studentName || raw.studentName || firstCourse.studentName || 'Student Academic Profile';
        const department = st.department || st.branch || raw.department || firstCourse.department || 'B.Tech';
        const academicYear = raw.academicYear || st.academicYear || 'Y23';
        const curriculum = st.curriculum || raw.curriculum || `${academicYear} B.Tech`;
        const degreeType = st.degreeType || raw.degreeType || 'REGULAR';
        const addon = st.addon || raw.addon || 'NONE';
        const pathCode = raw.pathCode || st.pathCode || '';

        return {
            ...raw,
            rollNumber,
            studentName,
            department,
            curriculum,
            academicYear,
            degreeType,
            addon,
            pathCode
        };
    }, [exitSummary, courses, studentId]);

    // Robust category credits calculation from courses + backend exitSummary
    const categoryCreditsMap = useMemo(() => {
        const map = {};
        CATEGORIES.forEach(cat => { map[cat.code] = 0; });

        // 1. Calculate from courses list
        courses.forEach(c => {
            const cat = c.category?.toUpperCase();
            if (cat && map[cat] !== undefined) {
                const isCompleted = c.status === 'COMPLETED' || (c.grade && c.grade !== 'F' && c.grade !== '-');
                if (isCompleted) {
                    map[cat] += Number(c.obtainedCredits != null ? c.obtainedCredits : (c.credits || 0));
                }
            }
        });

        // 2. Overlay with exitSummary.categoryCredits if provided by backend
        if (exitSummary?.categoryCredits) {
            Object.entries(exitSummary.categoryCredits).forEach(([catCode, cr]) => {
                if (map[catCode] !== undefined) {
                    map[catCode] = Math.max(map[catCode], Number(cr) || 0);
                }
            });
        }

        // 3. Overlay with exitSummary.categories if array
        if (Array.isArray(exitSummary?.categories)) {
            exitSummary.categories.forEach(cat => {
                if (cat.categoryCode && map[cat.categoryCode] !== undefined) {
                    map[cat.categoryCode] = Math.max(map[cat.categoryCode], Number(cat.obtainedCredits) || 0);
                }
            });
        }

        return map;
    }, [courses, exitSummary]);

    const totalEarned = useMemo(() => {
        const sumFromCats = Object.values(categoryCreditsMap).reduce((a, b) => a + b, 0);
        const sumFromCourses = courses
            .filter(c => c.status === 'COMPLETED' || (c.grade && c.grade !== 'F' && c.grade !== '-'))
            .reduce((sum, c) => sum + Number(c.obtainedCredits != null ? c.obtainedCredits : (c.credits || 0)), 0);
        
        const backendTotal = exitSummary?.summary?.totalObtainedCredits ?? exitSummary?.totalObtainedCredits;
        if (backendTotal != null && backendTotal > 0) return backendTotal;
        return Math.max(sumFromCats, sumFromCourses);
    }, [categoryCreditsMap, courses, exitSummary]);

    const totalReq = exitSummary?.totalRequiredCredits || 
                     exitSummary?.summary?.totalRequiredCredits || 
                     exitSummary?.student?.totalRequiredCredits || 
                     (studentInfo?.department?.toUpperCase().includes('AIDS') ? 166 : 163);
    const isEligible = exitSummary?.summary?.isEligible ?? exitSummary?.isEligible ?? (totalEarned >= totalReq);

    return (
        <div className="faculty-student-detail animate-fade" style={{ paddingBottom: '4rem', maxWidth: '1450px', margin: '0 auto' }}>
            {/* Toast Notification */}
            {toast && (
                <div style={{
                    position: 'fixed',
                    top: '20px',
                    right: '25px',
                    zIndex: 9999,
                    background: toast.type === 'error' ? '#EF4444' : toast.type === 'info' ? '#3B82F6' : '#10B981',
                    color: 'white',
                    padding: '14px 22px',
                    borderRadius: '10px',
                    boxShadow: '0 8px 24px rgba(0,0,0,0.18)',
                    fontWeight: 600,
                    display: 'flex',
                    alignItems: 'center',
                    gap: '10px',
                    animation: 'slideIn 0.3s ease'
                }}>
                    <span>{toast.type === 'error' ? '⚠️' : toast.type === 'info' ? 'ℹ️' : '✅'}</span>
                    <span>{toast.message}</span>
                </div>
            )}

            {/* Top Navigation Row */}
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem' }}>
                <button 
                    onClick={() => navigate(-1)} 
                    style={{ background: '#F1F3F5', border: '1px solid #E9ECEF', padding: '10px 18px', borderRadius: '10px', cursor: 'pointer', fontWeight: 600, display: 'flex', alignItems: 'center', gap: '8px', color: '#2D3436' }}
                >
                    ← Back to View Students
                </button>
                <div style={{ display: 'flex', gap: '12px' }}>
                    <button
                        onClick={handleDownloadPdf}
                        style={{ background: '#8B0000', color: 'white', border: 'none', padding: '10px 18px', borderRadius: '10px', cursor: 'pointer', fontWeight: 600, display: 'flex', alignItems: 'center', gap: '8px', boxShadow: '0 4px 12px rgba(139, 0, 0, 0.2)' }}
                    >
                        📄 Download 6-Page Exit PDF
                    </button>
                    <button
                        onClick={loadStudentData}
                        style={{ background: '#FFFFFF', border: '1px solid #CBD5E1', padding: '10px 16px', borderRadius: '10px', cursor: 'pointer', fontWeight: 600, display: 'flex', alignItems: 'center', gap: '6px' }}
                        title="Refresh academic data"
                    >
                        🔄 Refresh
                    </button>
                </div>
            </div>

            {/* Student Profile Header Banner */}
            <header className="glass-card" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2rem', padding: '2rem', borderLeft: '6px solid #8B0000', background: 'linear-gradient(to right, #FFFFFF, #FFFBFB)' }}>
                <div>
                    <span className="welcome-tag" style={{ background: '#FFF5F5', color: '#8B0000', fontWeight: 700, padding: '4px 12px', borderRadius: '12px', fontSize: '0.8rem' }}>
                        OFFICIAL ACADEMIC RECORD
                    </span>
                    <h1 style={{ fontSize: '2.1rem', margin: '8px 0', color: '#1E293B', fontWeight: 800 }}>
                        {studentInfo.studentName || 'Student Academic Profile'}
                    </h1>
                    <div style={{ display: 'flex', flexWrap: 'wrap', gap: '15px', color: '#64748B', fontSize: '0.92rem', marginTop: '4px' }}>
                        <span>Roll Number: <strong style={{ color: '#0F172A' }}>{studentInfo.rollNumber || studentId}</strong></span>
                        <span>•</span>
                        <span>Department: <strong style={{ color: '#0F172A' }}>{studentInfo.department || 'B.Tech'}</strong></span>
                        <span>•</span>
                        <span>Curriculum: <strong style={{ color: '#0F172A' }}>{studentInfo.curriculum || 'Y23 B.Tech'}</strong></span>
                        {studentInfo.pathCode && (
                            <>
                                <span>•</span>
                                <span>Degree Path: <strong style={{ color: '#8B0000' }}>{studentInfo.pathCode}</strong></span>
                            </>
                        )}
                        <span>•</span>
                        <span>Total Courses: <strong style={{ color: '#0F172A' }}>{courses.length}</strong></span>
                    </div>
                </div>
                <div style={{ textAlign: 'right', display: 'flex', flexDirection: 'column', alignItems: 'flex-end', gap: '10px' }}>
                    <span className={`status-tag ${isEligible ? 'success' : 'warning'}`} style={{ fontSize: '1rem', padding: '8px 18px', borderRadius: '20px', fontWeight: 700 }}>
                        {isEligible ? 'GRADUATION ELIGIBLE' : 'IN PROGRESS'}
                    </span>
                    <div style={{ display: 'flex', gap: '12px' }}>
                        <div style={{ background: '#FFF5F5', padding: '8px 16px', borderRadius: '12px', border: '1px solid #FED7D7', textAlign: 'center' }}>
                            <span style={{ display: 'block', fontSize: '1.25rem', fontWeight: 800, color: '#8B0000' }}>{totalEarned}</span>
                            <span style={{ fontSize: '0.72rem', color: '#64748B', fontWeight: 600 }}>Obtained Cr</span>
                        </div>
                        <div style={{ background: '#F8FAFC', padding: '8px 16px', borderRadius: '12px', border: '1px solid #E2E8F0', textAlign: 'center' }}>
                            <span style={{ display: 'block', fontSize: '1.25rem', fontWeight: 800, color: '#334155' }}>{totalReq}</span>
                            <span style={{ fontSize: '0.72rem', color: '#64748B', fontWeight: 600 }}>Required Cr</span>
                        </div>
                    </div>
                </div>
            </header>

            {/* Category Credit Overview Bar (10 Exit Requirement Categories) */}
            <div style={{ background: 'white', padding: '1.2rem', borderRadius: '16px', border: '1px solid #E2E8F0', marginBottom: '2rem', boxShadow: '0 2px 10px rgba(0,0,0,0.02)' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '10px' }}>
                    <span style={{ fontSize: '0.85rem', fontWeight: 700, color: '#475569', textTransform: 'uppercase', letterSpacing: '0.5px' }}>
                        Exit Requirement Category Breakdown ({CATEGORIES.length} Categories)
                    </span>
                    <span style={{ fontSize: '0.8rem', color: '#64748B' }}>Click any category pill to filter the course list</span>
                </div>
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(125px, 1fr))', gap: '8px' }}>
                    {CATEGORIES.map(cat => {
                        const catCredits = categoryCreditsMap[cat.code] || 0;
                        const isFiltered = filterCategory === cat.code;
                        return (
                            <button
                                key={cat.code}
                                onClick={() => setFilterCategory(isFiltered ? '' : cat.code)}
                                style={{
                                    display: 'flex',
                                    flexDirection: 'column',
                                    alignItems: 'center',
                                    justifyContent: 'center',
                                    padding: '10px 8px',
                                    borderRadius: '12px',
                                    border: isFiltered ? `2px solid ${cat.color}` : '1px solid #E2E8F0',
                                    background: isFiltered ? `${cat.color}15` : '#F8FAFC',
                                    cursor: 'pointer',
                                    transition: 'all 0.15s ease'
                                }}
                            >
                                <div style={{ display: 'flex', alignItems: 'center', gap: '5px' }}>
                                    <span style={{ width: '8px', height: '8px', borderRadius: '50%', background: cat.color }}></span>
                                    <strong style={{ fontSize: '0.9rem', color: cat.color }}>{cat.code}</strong>
                                </div>
                                <span style={{ fontSize: '1.1rem', fontWeight: 800, color: '#1E293B', marginTop: '2px' }}>
                                    {catCredits} <span style={{ fontSize: '0.7rem', fontWeight: 500, color: '#64748B' }}>Cr</span>
                                </span>
                            </button>
                        );
                    })}
                </div>
            </div>

            {/* Navigation Tabs */}
            <div style={{ display: 'flex', gap: '8px', borderBottom: '2px solid #E2E8F0', marginBottom: '1.8rem' }}>
                <button
                    onClick={() => setActiveTab('courses')}
                    style={{
                        padding: '12px 24px',
                        fontWeight: 700,
                        fontSize: '1rem',
                        border: 'none',
                        background: 'transparent',
                        cursor: 'pointer',
                        color: activeTab === 'courses' ? '#8B0000' : '#64748B',
                        borderBottom: activeTab === 'courses' ? '3px solid #8B0000' : '3px solid transparent',
                        transition: 'all 0.2s ease',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '8px'
                    }}
                >
                    📚 Course Management (CRUD)
                    <span style={{ background: activeTab === 'courses' ? '#8B0000' : '#E2E8F0', color: activeTab === 'courses' ? 'white' : '#64748B', fontSize: '0.75rem', padding: '2px 8px', borderRadius: '10px' }}>
                        {courses.length}
                    </span>
                </button>
                <button
                    onClick={() => setActiveTab('exit-report')}
                    style={{
                        padding: '12px 24px',
                        fontWeight: 700,
                        fontSize: '1rem',
                        border: 'none',
                        background: 'transparent',
                        cursor: 'pointer',
                        color: activeTab === 'exit-report' ? '#8B0000' : '#64748B',
                        borderBottom: activeTab === 'exit-report' ? '3px solid #8B0000' : '3px solid transparent',
                        transition: 'all 0.2s ease',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '8px'
                    }}
                >
                    📋 Exit Requirement Audit (10 Categories)
                </button>
                <button
                    onClick={() => setActiveTab('buckets')}
                    style={{
                        padding: '12px 24px',
                        fontWeight: 700,
                        fontSize: '1rem',
                        border: 'none',
                        background: 'transparent',
                        cursor: 'pointer',
                        color: activeTab === 'buckets' ? '#8B0000' : '#64748B',
                        borderBottom: activeTab === 'buckets' ? '3px solid #8B0000' : '3px solid transparent',
                        transition: 'all 0.2s ease',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '8px'
                    }}
                >
                    🪣 Bucket Compliance
                </button>
            </div>

            {/* TAB 1: COURSE MANAGEMENT (CRUD) */}
            {activeTab === 'courses' && (
                <div className="glass-card" style={{ padding: '2rem' }}>
                    {/* Top Action Bar: Search, Filters, and Add Course Button */}
                    <div style={{ display: 'flex', flexWrap: 'wrap', justifyContent: 'space-between', alignItems: 'center', gap: '15px', marginBottom: '1.5rem' }}>
                        <div style={{ display: 'flex', flexWrap: 'wrap', gap: '12px', flex: 1, minWidth: '300px' }}>
                            <input
                                type="text"
                                placeholder="🔍 Search course code or name..."
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                                style={{ padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', minWidth: '240px', outline: 'none' }}
                            />
                            <select
                                value={filterCategory}
                                onChange={(e) => setFilterCategory(e.target.value)}
                                style={{ padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none', background: 'white' }}
                            >
                                <option value="">All Categories ({CATEGORIES.length})</option>
                                {CATEGORIES.map(c => (
                                    <option key={c.code} value={c.code}>{c.code} - {c.name}</option>
                                ))}
                            </select>
                            <select
                                value={filterSemester}
                                onChange={(e) => setFilterSemester(e.target.value)}
                                style={{ padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none', background: 'white' }}
                            >
                                <option value="">All Semesters</option>
                                {availableSemesters.map(s => (
                                    <option key={s} value={s}>{s}</option>
                                ))}
                            </select>
                            <select
                                value={filterStatus}
                                onChange={(e) => setFilterStatus(e.target.value)}
                                style={{ padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none', background: 'white' }}
                            >
                                <option value="">All Statuses</option>
                                {STATUSES.map(s => (
                                    <option key={s} value={s}>{s}</option>
                                ))}
                            </select>
                            {(searchTerm || filterCategory || filterSemester || filterStatus) && (
                                <button
                                    onClick={() => { setSearchTerm(''); setFilterCategory(''); setFilterSemester(''); setFilterStatus(''); }}
                                    style={{ background: '#F1F5F9', border: 'none', padding: '10px 14px', borderRadius: '10px', cursor: 'pointer', color: '#64748B', fontWeight: 600 }}
                                >
                                    Clear Filters
                                </button>
                            )}
                        </div>

                        <button
                            onClick={openAddModal}
                            style={{
                                background: '#8B0000',
                                color: 'white',
                                border: 'none',
                                padding: '12px 22px',
                                borderRadius: '10px',
                                cursor: 'pointer',
                                fontWeight: 700,
                                fontSize: '0.95rem',
                                display: 'flex',
                                alignItems: 'center',
                                gap: '8px',
                                boxShadow: '0 4px 14px rgba(139, 0, 0, 0.25)'
                            }}
                        >
                            ➕ Add Course Record
                        </button>
                    </div>

                    {/* Courses CRUD Table */}
                    {filteredCourses.length > 0 ? (
                        <div style={{ overflowX: 'auto', borderRadius: '12px', border: '1px solid #E2E8F0' }}>
                            <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '0.88rem' }}>
                                <thead>
                                    <tr style={{ background: '#F8FAFC', borderBottom: '2px solid #E2E8F0', color: '#475569' }}>
                                        <th style={{ padding: '14px 12px' }}>Code</th>
                                        <th style={{ padding: '14px 12px', minWidth: '180px' }}>Course Title</th>
                                        <th style={{ padding: '14px 12px' }}>Category</th>
                                        <th style={{ padding: '14px 10px', textAlign: 'center' }}>Master Cr</th>
                                        <th style={{ padding: '14px 10px', textAlign: 'center' }}>Obt Cr</th>
                                        <th style={{ padding: '14px 10px' }}>Semester</th>
                                        <th style={{ padding: '14px 10px' }}>Year</th>
                                        <th style={{ padding: '14px 8px', textAlign: 'center' }}>Att 1</th>
                                        <th style={{ padding: '14px 8px', textAlign: 'center' }}>Att 2</th>
                                        <th style={{ padding: '14px 8px', textAlign: 'center' }}>Att 3</th>
                                        <th style={{ padding: '14px 10px', textAlign: 'center' }}>Grade</th>
                                        <th style={{ padding: '14px 10px', textAlign: 'center' }}>Status</th>
                                        <th style={{ padding: '14px 12px', textAlign: 'right' }}>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {filteredCourses.map((c, idx) => {
                                        const catObj = CATEGORIES.find(k => k.code === c.category) || { color: '#64748B' };
                                        return (
                                            <tr key={c.id || c.courseCode || idx} style={{ borderBottom: '1px solid #F1F5F9', background: idx % 2 === 0 ? 'white' : '#FCFDFD' }}>
                                                <td style={{ padding: '12px' }}>
                                                    <span style={{ fontWeight: 800, color: '#8B0000', fontFamily: 'monospace', fontSize: '0.92rem' }}>
                                                        {c.courseCode}
                                                    </span>
                                                </td>
                                                <td style={{ padding: '12px' }}>
                                                    <strong style={{ color: '#1E293B' }}>{c.courseName}</strong>
                                                </td>
                                                <td style={{ padding: '12px' }}>
                                                    <span style={{
                                                        background: `${catObj.color}18`,
                                                        color: catObj.color,
                                                        border: `1px solid ${catObj.color}40`,
                                                        padding: '3px 8px',
                                                        borderRadius: '8px',
                                                        fontWeight: 700,
                                                        fontSize: '0.78rem'
                                                    }}>
                                                        {c.category || 'PCC'}
                                                    </span>
                                                </td>
                                                <td style={{ padding: '12px 10px', textAlign: 'center', fontWeight: 600 }}>
                                                    {c.credits}
                                                </td>
                                                <td style={{ padding: '12px 10px', textAlign: 'center', fontWeight: 700, color: '#059669' }}>
                                                    {c.obtainedCredits != null ? c.obtainedCredits : c.credits}
                                                </td>
                                                <td style={{ padding: '12px 10px', color: '#64748B' }}>
                                                    {c.semester || '-'}
                                                </td>
                                                <td style={{ padding: '12px 10px', color: '#64748B', fontSize: '0.82rem' }}>
                                                    {c.academicYear || '-'}
                                                </td>
                                                <td style={{ padding: '12px 8px', textAlign: 'center', fontFamily: 'monospace' }}>
                                                    {c.attempt1 || '-'}
                                                </td>
                                                <td style={{ padding: '12px 8px', textAlign: 'center', fontFamily: 'monospace' }}>
                                                    {c.attempt2 || '-'}
                                                </td>
                                                <td style={{ padding: '12px 8px', textAlign: 'center', fontFamily: 'monospace' }}>
                                                    {c.attempt3 || '-'}
                                                </td>
                                                <td style={{ padding: '12px 10px', textAlign: 'center' }}>
                                                    <span style={{
                                                        padding: '3px 8px',
                                                        borderRadius: '6px',
                                                        fontWeight: 800,
                                                        fontSize: '0.82rem',
                                                        background: c.grade === 'F' ? '#FEE2E2' : ['O', 'A+'].includes(c.grade) ? '#ECFDF5' : '#EFF6FF',
                                                        color: c.grade === 'F' ? '#DC2626' : ['O', 'A+'].includes(c.grade) ? '#059669' : '#2563EB'
                                                    }}>
                                                        {c.grade || '-'}
                                                    </span>
                                                </td>
                                                <td style={{ padding: '12px 10px', textAlign: 'center' }}>
                                                    <span style={{
                                                        padding: '3px 8px',
                                                        borderRadius: '6px',
                                                        fontSize: '0.74rem',
                                                        fontWeight: 700,
                                                        background: c.status === 'COMPLETED' ? '#DCFCE7' : c.status === 'FAILED' ? '#FEE2E2' : '#FEF3C7',
                                                        color: c.status === 'COMPLETED' ? '#166534' : c.status === 'FAILED' ? '#991B1B' : '#92400E'
                                                    }}>
                                                        {c.status || 'COMPLETED'}
                                                    </span>
                                                </td>
                                                <td style={{ padding: '12px', textAlign: 'right' }}>
                                                    <div style={{ display: 'inline-flex', gap: '6px' }}>
                                                        <button
                                                            onClick={() => openEditModal(c)}
                                                            style={{
                                                                background: '#EFF6FF',
                                                                border: '1px solid #BFDBFE',
                                                                color: '#1D4ED8',
                                                                padding: '6px 12px',
                                                                borderRadius: '8px',
                                                                cursor: 'pointer',
                                                                fontWeight: 600,
                                                                fontSize: '0.8rem'
                                                            }}
                                                            title="Edit student record"
                                                        >
                                                            ✏️ Edit
                                                        </button>
                                                        <button
                                                            onClick={() => openDeleteModal(c)}
                                                            style={{
                                                                background: '#FFF5F5',
                                                                border: '1px solid #FECACA',
                                                                color: '#DC2626',
                                                                padding: '6px 10px',
                                                                borderRadius: '8px',
                                                                cursor: 'pointer',
                                                                fontWeight: 600,
                                                                fontSize: '0.8rem'
                                                            }}
                                                            title="Delete / Soft-remove record"
                                                        >
                                                            🗑️
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        );
                                    })}
                                </tbody>
                            </table>
                        </div>
                    ) : (
                        <div style={{ textAlign: 'center', padding: '3.5rem 1rem', background: '#F8FAFC', borderRadius: '12px', border: '1px dashed #CBD5E1' }}>
                            <span style={{ fontSize: '2.5rem' }}>🔍</span>
                            <h4 style={{ margin: '12px 0 6px', color: '#1E293B' }}>No course records match your query</h4>
                            <p style={{ color: '#64748B', margin: 0, fontSize: '0.9rem' }}>Try clearing filters or clicking "Add Course Record" to register an academic course.</p>
                        </div>
                    )}
                </div>
            )}

            {/* TAB 2: EXIT REQUIREMENT AUDIT (10 CATEGORIES) */}
            {activeTab === 'exit-report' && (
                <div className="glass-card" style={{ padding: '2rem' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2rem' }}>
                        <div>
                            <h3 style={{ margin: 0, color: '#1E293B', fontSize: '1.4rem' }}>Student Exit Requirement Report Audit</h3>
                            <p style={{ color: '#64748B', margin: '4px 0 0', fontSize: '0.9rem' }}>
                                Comprehensive 10-category breakdown linked with Course Management CRUD
                            </p>
                        </div>
                        <button
                            onClick={handleDownloadPdf}
                            style={{ background: '#8B0000', color: 'white', border: 'none', padding: '10px 18px', borderRadius: '10px', cursor: 'pointer', fontWeight: 600 }}
                        >
                            📄 Download PDF Report
                        </button>
                    </div>

                    {exitReport?.categories ? (
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '1.8rem' }}>
                            {exitReport.categories.map((cat) => {
                                const meta = CATEGORIES.find(k => k.code === cat.categoryCode) || { color: '#8B0000' };
                                const isSatisfied = cat.obtainedCredits >= cat.requiredCredits;
                                return (
                                    <div key={cat.categoryCode} style={{ border: '1px solid #E2E8F0', borderRadius: '14px', overflow: 'hidden' }}>
                                        <div style={{
                                            background: '#F8FAFC',
                                            padding: '14px 20px',
                                            display: 'flex',
                                            justifyContent: 'space-between',
                                            alignItems: 'center',
                                            borderBottom: '1px solid #E2E8F0'
                                        }}>
                                            <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                                                <span style={{ background: meta.color, color: 'white', padding: '4px 10px', borderRadius: '8px', fontWeight: 800, fontSize: '0.85rem' }}>
                                                    {cat.categoryCode}
                                                </span>
                                                <strong style={{ fontSize: '1.05rem', color: '#1E293B' }}>{cat.categoryName}</strong>
                                            </div>
                                            <div style={{ display: 'flex', alignItems: 'center', gap: '15px' }}>
                                                <span style={{ fontSize: '0.95rem', fontWeight: 700, color: isSatisfied ? '#059669' : '#DC2626' }}>
                                                    {cat.obtainedCredits} / {cat.requiredCredits} Credits
                                                </span>
                                                <span style={{
                                                    fontSize: '0.75rem',
                                                    fontWeight: 700,
                                                    padding: '3px 10px',
                                                    borderRadius: '12px',
                                                    background: isSatisfied ? '#DCFCE7' : '#FEE2E2',
                                                    color: isSatisfied ? '#166534' : '#991B1B'
                                                }}>
                                                    {isSatisfied ? 'SATISFIED' : `${cat.requiredCredits - cat.obtainedCredits} CR REMAINING`}
                                                </span>
                                            </div>
                                        </div>
                                        <div style={{ padding: '15px' }}>
                                            {cat.courses && cat.courses.length > 0 ? (
                                                <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.84rem' }}>
                                                    <thead>
                                                        <tr style={{ color: '#64748B', borderBottom: '1px solid #F1F5F9' }}>
                                                            <th style={{ padding: '8px 10px', textAlign: 'left' }}>Course Code</th>
                                                            <th style={{ padding: '8px 10px', textAlign: 'left' }}>Course Title</th>
                                                            <th style={{ padding: '8px 10px', textAlign: 'center' }}>Credits</th>
                                                            <th style={{ padding: '8px 10px', textAlign: 'center' }}>Obtained</th>
                                                            <th style={{ padding: '8px 10px', textAlign: 'center' }}>Grade</th>
                                                            <th style={{ padding: '8px 10px', textAlign: 'center' }}>Status</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        {cat.courses.map((c, i) => (
                                                            <tr key={i} style={{ borderBottom: '1px solid #F8FAFC' }}>
                                                                <td style={{ padding: '8px 10px', fontWeight: 700, color: '#8B0000', fontFamily: 'monospace' }}>{c.courseCode}</td>
                                                                <td style={{ padding: '8px 10px', color: '#1E293B' }}>{c.courseName}</td>
                                                                <td style={{ padding: '8px 10px', textAlign: 'center' }}>{c.credits}</td>
                                                                <td style={{ padding: '8px 10px', textAlign: 'center', fontWeight: 700, color: '#059669' }}>{c.obtainedCredits != null ? c.obtainedCredits : c.credits}</td>
                                                                <td style={{ padding: '8px 10px', textAlign: 'center', fontWeight: 700 }}>{c.grade || '-'}</td>
                                                                <td style={{ padding: '8px 10px', textAlign: 'center' }}>{c.status || 'COMPLETED'}</td>
                                                            </tr>
                                                        ))}
                                                    </tbody>
                                                </table>
                                            ) : (
                                                <p style={{ color: '#94A3B8', margin: '8px 0', fontSize: '0.85rem', fontStyle: 'italic' }}>
                                                    No courses currently logged in this requirement category. Use Course Management to add eligible courses.
                                                </p>
                                            )}
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    ) : (
                        <p style={{ color: '#64748B', textAlign: 'center', padding: '3rem' }}>
                            Exit requirement audit details are loading or not available.
                        </p>
                    )}
                </div>
            )}

            {/* TAB 3: BUCKET COMPLIANCE */}
            {activeTab === 'buckets' && (
                <div className="glass-card" style={{ padding: '2rem' }}>
                    <h3 style={{ marginBottom: '1.5rem', color: '#1E293B' }}>Curriculum Bucket Compliance</h3>
                    {buckets.length > 0 ? (
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '1.2rem' }}>
                            {buckets.map((b, idx) => (
                                <div key={idx} style={{ display: 'flex', flexDirection: 'column', gap: '5px', padding: '12px 16px', background: '#F8FAFC', borderRadius: '12px', border: '1px solid #E2E8F0' }}>
                                    <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.92rem' }}>
                                        <span>
                                            <strong style={{ color: '#8B0000' }}>{b.bucketCode}</strong> — {b.bucketName}
                                        </span>
                                        <strong>{b.earnedCredits} / {b.requiredCredits} Cr</strong>
                                    </div>
                                    <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginTop: '4px' }}>
                                        <div style={{ flex: 1, height: '8px', background: '#E2E8F0', borderRadius: '4px', overflow: 'hidden' }}>
                                            <div style={{
                                                width: `${b.completionPercentage}%`,
                                                height: '100%',
                                                background: b.status === 'COMPLETED' ? '#10B981' : b.status === 'IN_PROGRESS' ? '#F59E0B' : '#EF4444',
                                                borderRadius: '4px'
                                            }}></div>
                                        </div>
                                        <span style={{ fontSize: '0.82rem', fontWeight: 700, minWidth: '40px' }}>{b.completionPercentage}%</span>
                                    </div>
                                </div>
                            ))}
                        </div>
                    ) : (
                        <p style={{ color: '#64748B', textAlign: 'center', padding: '2rem' }}>No bucket evaluation records found for this student.</p>
                    )}
                </div>
            )}

            {/* MODAL: ADD COURSE */}
            {showAddModal && (
                <div style={{
                    position: 'fixed',
                    top: 0, left: 0, right: 0, bottom: 0,
                    background: 'rgba(15, 23, 42, 0.65)',
                    backdropFilter: 'blur(4px)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    zIndex: 10000,
                    padding: '20px'
                }}>
                    <div style={{
                        background: 'white',
                        borderRadius: '20px',
                        width: '100%',
                        maxWidth: '720px',
                        maxHeight: '90vh',
                        overflowY: 'auto',
                        padding: '2.5rem',
                        boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.25)',
                        animation: 'fadeIn 0.2s ease'
                    }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem', borderBottom: '1px solid #E2E8F0', paddingBottom: '1rem' }}>
                            <div>
                                <h3 style={{ margin: 0, color: '#1E293B', fontSize: '1.4rem' }}>Add Student Course Record</h3>
                                <p style={{ margin: '4px 0 0', color: '#64748B', fontSize: '0.85rem' }}>
                                    Search authorative master course catalogue to prevent definition mutations
                                </p>
                            </div>
                            <button onClick={() => setShowAddModal(false)} style={{ background: 'transparent', border: 'none', fontSize: '1.4rem', cursor: 'pointer', color: '#94A3B8' }}>
                                ✕
                            </button>
                        </div>

                        {modalError && (
                            <div style={{ background: '#FEE2E2', border: '1px solid #FECACA', color: '#991B1B', padding: '10px 14px', borderRadius: '10px', marginBottom: '1.2rem', fontSize: '0.9rem' }}>
                                ⚠️ {modalError}
                            </div>
                        )}

                        <form onSubmit={submitAddCourse}>
                            {/* Authoritative Catalog Autocomplete Search */}
                            <div style={{ marginBottom: '1.2rem' }}>
                                <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>
                                    Authoritative Course Catalog Lookup *
                                </label>
                                <input
                                    type="text"
                                    placeholder="Type Course Code or Name (e.g. 23CS1101, Data Structures)..."
                                    value={catalogSearch}
                                    onChange={(e) => setCatalogSearch(e.target.value)}
                                    style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none' }}
                                />
                                {catalogLoading && <span style={{ fontSize: '0.75rem', color: '#8B0000' }}>Searching catalog...</span>}

                                {catalogOptions.length > 0 && (
                                    <div style={{ maxHeight: '160px', overflowY: 'auto', border: '1px solid #E2E8F0', borderRadius: '10px', marginTop: '6px', background: '#F8FAFC' }}>
                                        {catalogOptions.slice(0, 10).map((opt) => (
                                            <div
                                                key={opt.courseId || opt.courseCode}
                                                onClick={() => handleSelectCatalogCourse(opt)}
                                                style={{ padding: '8px 12px', borderBottom: '1px solid #EDF2F7', cursor: 'pointer', fontSize: '0.85rem', display: 'flex', justifyContent: 'space-between' }}
                                                onMouseEnter={(e) => e.currentTarget.style.background = '#EDF2F7'}
                                                onMouseLeave={(e) => e.currentTarget.style.background = 'transparent'}
                                            >
                                                <span><strong>{opt.courseCode}</strong> — {opt.courseName}</span>
                                                <span style={{ color: '#8B0000', fontWeight: 600 }}>{opt.credits} Cr ({opt.category || 'PCC'})</span>
                                            </div>
                                        ))}
                                    </div>
                                )}
                            </div>

                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', marginBottom: '1.2rem' }}>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Course Code *</label>
                                    <input
                                        type="text"
                                        required
                                        value={formData.courseCode}
                                        onChange={(e) => setFormData({ ...formData, courseCode: e.target.value.toUpperCase() })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none', fontWeight: 700 }}
                                    />
                                </div>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Course Name *</label>
                                    <input
                                        type="text"
                                        required
                                        value={formData.courseName}
                                        onChange={(e) => setFormData({ ...formData, courseName: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none' }}
                                    />
                                </div>
                            </div>

                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '1rem', marginBottom: '1.2rem' }}>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Category *</label>
                                    <select
                                        value={formData.category}
                                        onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none', background: 'white' }}
                                    >
                                        {CATEGORIES.map(c => (
                                            <option key={c.code} value={c.code}>{c.code} ({c.name})</option>
                                        ))}
                                    </select>
                                </div>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Course Credits *</label>
                                    <input
                                        type="number"
                                        step="0.5"
                                        required
                                        value={formData.credits}
                                        onChange={(e) => setFormData({ ...formData, credits: parseFloat(e.target.value) || 0 })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none' }}
                                    />
                                </div>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Obtained Credits *</label>
                                    <input
                                        type="number"
                                        step="0.5"
                                        required
                                        value={formData.obtainedCredits}
                                        onChange={(e) => setFormData({ ...formData, obtainedCredits: parseFloat(e.target.value) || 0 })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none' }}
                                    />
                                </div>
                            </div>

                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', marginBottom: '1.2rem' }}>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Semester</label>
                                    <input
                                        type="text"
                                        placeholder="e.g. Sem 1, Odd Sem"
                                        value={formData.semester}
                                        onChange={(e) => setFormData({ ...formData, semester: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none' }}
                                    />
                                </div>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Academic Year</label>
                                    <input
                                        type="text"
                                        placeholder="e.g. 2024-2025"
                                        value={formData.academicYear}
                                        onChange={(e) => setFormData({ ...formData, academicYear: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none' }}
                                    />
                                </div>
                            </div>

                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '1rem', marginBottom: '1.2rem' }}>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Attempt 1</label>
                                    <input
                                        type="text"
                                        placeholder="e.g. A+, B"
                                        value={formData.attempt1}
                                        onChange={(e) => setFormData({ ...formData, attempt1: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none' }}
                                    />
                                </div>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Attempt 2</label>
                                    <input
                                        type="text"
                                        placeholder="e.g. -"
                                        value={formData.attempt2}
                                        onChange={(e) => setFormData({ ...formData, attempt2: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none' }}
                                    />
                                </div>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Attempt 3</label>
                                    <input
                                        type="text"
                                        placeholder="e.g. -"
                                        value={formData.attempt3}
                                        onChange={(e) => setFormData({ ...formData, attempt3: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none' }}
                                    />
                                </div>
                            </div>

                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', marginBottom: '1.8rem' }}>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Final Grade / Result *</label>
                                    <select
                                        value={formData.grade}
                                        onChange={(e) => setFormData({ ...formData, grade: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none', background: 'white' }}
                                    >
                                        {GRADES.map(g => (
                                            <option key={g} value={g}>{g}</option>
                                        ))}
                                    </select>
                                </div>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Completion Status *</label>
                                    <select
                                        value={formData.status}
                                        onChange={(e) => setFormData({ ...formData, status: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none', background: 'white' }}
                                    >
                                        {STATUSES.map(s => (
                                            <option key={s} value={s}>{s}</option>
                                        ))}
                                    </select>
                                </div>
                            </div>

                            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '12px', borderTop: '1px solid #E2E8F0', paddingTop: '1.2rem' }}>
                                <button
                                    type="button"
                                    onClick={() => setShowAddModal(false)}
                                    style={{ padding: '11px 20px', borderRadius: '10px', border: '1px solid #CBD5E1', background: '#F8FAFC', cursor: 'pointer', fontWeight: 600, color: '#475569' }}
                                >
                                    Cancel
                                </button>
                                <button
                                    type="submit"
                                    disabled={modalSubmitting}
                                    style={{ padding: '11px 24px', borderRadius: '10px', border: 'none', background: '#8B0000', color: 'white', cursor: 'pointer', fontWeight: 700 }}
                                >
                                    {modalSubmitting ? 'Registering...' : 'Add Course Record'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}

            {/* MODAL: EDIT COURSE */}
            {showEditModal && (
                <div style={{
                    position: 'fixed',
                    top: 0, left: 0, right: 0, bottom: 0,
                    background: 'rgba(15, 23, 42, 0.65)',
                    backdropFilter: 'blur(4px)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    zIndex: 10000,
                    padding: '20px'
                }}>
                    <div style={{
                        background: 'white',
                        borderRadius: '20px',
                        width: '100%',
                        maxWidth: '700px',
                        maxHeight: '90vh',
                        overflowY: 'auto',
                        padding: '2.5rem',
                        boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.25)'
                    }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem', borderBottom: '1px solid #E2E8F0', paddingBottom: '1rem' }}>
                            <div>
                                <h3 style={{ margin: 0, color: '#1E293B', fontSize: '1.4rem' }}>Edit Course Record</h3>
                                <p style={{ margin: '4px 0 0', color: '#64748B', fontSize: '0.85rem' }}>
                                    Editing student record for <strong>{formData.courseCode}</strong> ({formData.courseName})
                                </p>
                            </div>
                            <button onClick={() => setShowEditModal(false)} style={{ background: 'transparent', border: 'none', fontSize: '1.4rem', cursor: 'pointer', color: '#94A3B8' }}>
                                ✕
                            </button>
                        </div>

                        {modalError && (
                            <div style={{ background: '#FEE2E2', border: '1px solid #FECACA', color: '#991B1B', padding: '10px 14px', borderRadius: '10px', marginBottom: '1.2rem', fontSize: '0.9rem' }}>
                                ⚠️ {modalError}
                            </div>
                        )}

                        <form onSubmit={submitEditCourse}>
                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', marginBottom: '1.2rem' }}>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Category *</label>
                                    <select
                                        value={formData.category}
                                        onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none', background: 'white' }}
                                    >
                                        {CATEGORIES.map(c => (
                                            <option key={c.code} value={c.code}>{c.code} ({c.name})</option>
                                        ))}
                                    </select>
                                </div>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Obtained Credits *</label>
                                    <input
                                        type="number"
                                        step="0.5"
                                        required
                                        value={formData.obtainedCredits}
                                        onChange={(e) => setFormData({ ...formData, obtainedCredits: parseFloat(e.target.value) || 0 })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none' }}
                                    />
                                </div>
                            </div>

                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', marginBottom: '1.2rem' }}>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Semester</label>
                                    <input
                                        type="text"
                                        value={formData.semester}
                                        onChange={(e) => setFormData({ ...formData, semester: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none' }}
                                    />
                                </div>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Academic Year</label>
                                    <input
                                        type="text"
                                        value={formData.academicYear}
                                        onChange={(e) => setFormData({ ...formData, academicYear: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none' }}
                                    />
                                </div>
                            </div>

                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '1rem', marginBottom: '1.2rem' }}>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Attempt 1</label>
                                    <input
                                        type="text"
                                        value={formData.attempt1}
                                        onChange={(e) => setFormData({ ...formData, attempt1: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none' }}
                                    />
                                </div>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Attempt 2</label>
                                    <input
                                        type="text"
                                        value={formData.attempt2}
                                        onChange={(e) => setFormData({ ...formData, attempt2: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none' }}
                                    />
                                </div>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Attempt 3</label>
                                    <input
                                        type="text"
                                        value={formData.attempt3}
                                        onChange={(e) => setFormData({ ...formData, attempt3: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none' }}
                                    />
                                </div>
                            </div>

                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', marginBottom: '1.8rem' }}>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Grade / Result *</label>
                                    <select
                                        value={formData.grade}
                                        onChange={(e) => setFormData({ ...formData, grade: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none', background: 'white' }}
                                    >
                                        {GRADES.map(g => (
                                            <option key={g} value={g}>{g}</option>
                                        ))}
                                    </select>
                                </div>
                                <div>
                                    <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>Status *</label>
                                    <select
                                        value={formData.status}
                                        onChange={(e) => setFormData({ ...formData, status: e.target.value })}
                                        style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none', background: 'white' }}
                                    >
                                        {STATUSES.map(s => (
                                            <option key={s} value={s}>{s}</option>
                                        ))}
                                    </select>
                                </div>
                            </div>

                            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '12px', borderTop: '1px solid #E2E8F0', paddingTop: '1.2rem' }}>
                                <button
                                    type="button"
                                    onClick={() => setShowEditModal(false)}
                                    style={{ padding: '11px 20px', borderRadius: '10px', border: '1px solid #CBD5E1', background: '#F8FAFC', cursor: 'pointer', fontWeight: 600 }}
                                >
                                    Cancel
                                </button>
                                <button
                                    type="submit"
                                    disabled={modalSubmitting}
                                    style={{ padding: '11px 24px', borderRadius: '10px', border: 'none', background: '#8B0000', color: 'white', cursor: 'pointer', fontWeight: 700 }}
                                >
                                    {modalSubmitting ? 'Saving Changes...' : 'Save Changes'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}

            {/* MODAL: DELETE COURSE CONFIRMATION */}
            {showDeleteModal && selectedCourseForAction && (
                <div style={{
                    position: 'fixed',
                    top: 0, left: 0, right: 0, bottom: 0,
                    background: 'rgba(15, 23, 42, 0.65)',
                    backdropFilter: 'blur(4px)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    zIndex: 10000,
                    padding: '20px'
                }}>
                    <div style={{
                        background: 'white',
                        borderRadius: '20px',
                        width: '100%',
                        maxWidth: '520px',
                        padding: '2.5rem',
                        boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.25)',
                        textAlign: 'center'
                    }}>
                        <div style={{ fontSize: '3rem', marginBottom: '1rem' }}>🗑️</div>
                        <h3 style={{ margin: '0 0 8px', color: '#1E293B', fontSize: '1.35rem' }}>Remove Course Record?</h3>
                        <p style={{ color: '#64748B', fontSize: '0.92rem', lineHeight: '1.5', margin: '0 0 1.5rem' }}>
                            Are you sure you want to remove <strong>{selectedCourseForAction.courseCode}</strong> ({selectedCourseForAction.courseName})?
                            <br /><br />
                            <span style={{ fontSize: '0.82rem', background: '#FEF3C7', color: '#92400E', padding: '4px 10px', borderRadius: '6px' }}>
                                ℹ️ This record will be deactivated (soft-deleted) preserving audit logs. Category and total credits will immediately recalculate.
                            </span>
                        </p>

                        <div style={{ display: 'flex', justifyContent: 'center', gap: '12px' }}>
                            <button
                                onClick={() => setShowDeleteModal(false)}
                                disabled={modalSubmitting}
                                style={{ padding: '11px 22px', borderRadius: '10px', border: '1px solid #CBD5E1', background: '#F8FAFC', cursor: 'pointer', fontWeight: 600 }}
                            >
                                Cancel
                            </button>
                            <button
                                onClick={submitDeleteCourse}
                                disabled={modalSubmitting}
                                style={{ padding: '11px 24px', borderRadius: '10px', border: 'none', background: '#DC2626', color: 'white', cursor: 'pointer', fontWeight: 700 }}
                            >
                                {modalSubmitting ? 'Removing...' : 'Yes, Remove Course'}
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
