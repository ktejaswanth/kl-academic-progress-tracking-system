import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import api from '../api';
import './curriculum-import.css';

export default function CurriculumReview() {
    const { importId } = useParams();
    const navigate = useNavigate();
    
    const [summary, setSummary] = useState(null);
    const [detail, setDetail] = useState(null);
    const [activeTab, setActiveTab] = useState('courses');
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    
    // Editing states
    const [editMode, setEditMode] = useState(false);
    const [editedCourses, setEditedCourses] = useState([]);
    const [searchQuery, setSearchQuery] = useState('');
    
    useEffect(() => {
        fetchData();
    }, [importId]);

    const fetchData = async () => {
        setLoading(true);
        setError(null);
        try {
            const [sumRes, detRes] = await Promise.all([
                api.get(`/curriculum/${importId}/summary`),
                api.get(`/curriculum/${importId}/detail`)
            ]);
            setSummary(sumRes.data);
            setDetail(detRes.data);
            setEditedCourses(detRes.data.courses || []);
        } catch (err) {
            console.error("Failed to fetch curriculum details:", err);
            setError("Failed to load analyzed curriculum data.");
        } finally {
            setLoading(false);
        }
    };

    const handleCourseChange = (index, field, value) => {
        const updated = [...editedCourses];
        updated[index] = { ...updated[index], [field]: value };
        setEditedCourses(updated);
    };

    const handleDeleteCourse = (index) => {
        const updated = editedCourses.filter((_, i) => i !== index);
        setEditedCourses(updated);
    };

    const handleAddCourse = () => {
        const newCourse = {
            courseCode: 'NEW_CODE',
            courseName: 'New Course Name',
            credits: 3,
            category: 'PCC',
            subCategory: 'PCC-CORE',
            lectureHours: 3,
            tutorialHours: 0,
            practicalHours: 0,
            skillHours: 0,
            contactHours: 3,
            mode: 'R',
            acronym: '',
            isMandatory: false,
            prerequisite: null
        };
        setEditedCourses([newCourse, ...editedCourses]);
    };

    const handleSaveEdits = async () => {
        setLoading(true);
        try {
            const updatedDetail = { ...detail, courses: editedCourses };
            const res = await api.put(`/curriculum/${importId}/edit`, updatedDetail);
            setSummary(res.data);
            setDetail(updatedDetail);
            setEditMode(false);
            setError(null);
        } catch (err) {
            console.error("Failed to save edits:", err);
            setError(err.response?.data?.error || "Failed to save edits.");
        } finally {
            setLoading(false);
        }
    };

    const handleApprove = async () => {
        if (!window.confirm("Are you sure you want to approve this curriculum? This will populate the master database tables.")) {
            return;
        }
        setLoading(true);
        try {
            await api.post(`/curriculum/${importId}/approve`);
            alert("Curriculum approved and saved to database successfully!");
            navigate('/super_admin/curriculum-repository');
        } catch (err) {
            console.error("Approval failed:", err);
            setError(err.response?.data?.error || "Failed to approve curriculum.");
            setLoading(false);
        }
    };

    const handleReject = async () => {
        if (!window.confirm("Are you sure you want to reject this curriculum import?")) {
            return;
        }
        setLoading(true);
        try {
            await api.post(`/curriculum/${importId}/reject`);
            navigate('/super_admin/curriculum-repository');
        } catch (err) {
            console.error("Rejection failed:", err);
            setError("Failed to reject curriculum.");
            setLoading(false);
        }
    };

    if (loading && !summary) {
        return (
            <div className="curriculum-import-container" style={{ textAlign: 'center', paddingTop: '100px' }}>
                <div className="spinner" style={{ margin: '0 auto 20px' }}></div>
                <h2>Loading Curriculum Data...</h2>
            </div>
        );
    }

    const filteredCourses = editedCourses.filter(course => 
        course.courseCode?.toLowerCase().includes(searchQuery.toLowerCase()) ||
        course.courseName?.toLowerCase().includes(searchQuery.toLowerCase()) ||
        course.subCategory?.toLowerCase().includes(searchQuery.toLowerCase())
    );

    return (
        <div className="curriculum-import-container">
            <div className="import-header-card">
                <div className="import-header-title">
                    <h1>Curriculum Review: {summary?.curriculumName}</h1>
                    <p>Analyze Gemini's parsed result, perform inline corrections, and persist into the database.</p>
                </div>
                <div style={{ display: 'flex', gap: '12px' }}>
                    <button className="btn-secondary" onClick={() => navigate('/super_admin/curriculum-repository')}>
                        Back to Repo
                    </button>
                    {summary?.status === 'ANALYZED' && (
                        <>
                            <button className="btn-danger" onClick={handleReject}>
                                Reject ❌
                            </button>
                            <button className="btn-primary" onClick={handleApprove}>
                                Approve & Save ✅
                            </button>
                        </>
                    )}
                </div>
            </div>

            {error && (
                <div className="validation-list" style={{ marginBottom: '20px' }}>
                    <h3>⚠️ Error Details</h3>
                    <ul>
                        <li>{error}</li>
                    </ul>
                </div>
            )}

            {/* Stats Cards */}
            <div className="stats-grid">
                <div className="stat-card">
                    <div className="stat-value">{summary?.coursesFound}</div>
                    <div className="stat-label">Courses</div>
                </div>
                <div className="stat-card">
                    <div className="stat-value">{summary?.bucketsFound}</div>
                    <div className="stat-label">Buckets</div>
                </div>
                <div className="stat-card">
                    <div className="stat-value">{summary?.degreeTypesFound}</div>
                    <div className="stat-label">Degree Paths</div>
                </div>
                <div className="stat-card">
                    <div className="stat-value">{summary?.specializationsFound}</div>
                    <div className="stat-label">Specs</div>
                </div>
                <div className="stat-card">
                    <div className="stat-value">{summary?.minorsFound}</div>
                    <div className="stat-label">Minors</div>
                </div>
                <div className="stat-card">
                    <div className="stat-value">
                        <span className={`status-badge ${summary?.status?.toLowerCase()}`}>
                            {summary?.status}
                        </span>
                    </div>
                    <div className="stat-label" style={{ marginTop: '8px' }}>Status</div>
                </div>
            </div>

            {/* Tabs */}
            <div className="review-tabs">
                <button 
                    className={`tab-btn ${activeTab === 'courses' ? 'active' : ''}`}
                    onClick={() => setActiveTab('courses')}
                >
                    📚 Courses List
                </button>
                <button 
                    className={`tab-btn ${activeTab === 'buckets' ? 'active' : ''}`}
                    onClick={() => setActiveTab('buckets')}
                >
                    🪣 Bucket Requirements
                </button>
                <button 
                    className={`tab-btn ${activeTab === 'paths' ? 'active' : ''}`}
                    onClick={() => setActiveTab('paths')}
                >
                    🧬 Degree Paths
                </button>
                <button 
                    className={`tab-btn ${activeTab === 'validation' ? 'active' : ''}`}
                    onClick={() => setActiveTab('validation')}
                >
                    ⚠️ Validation Warnings ({summary?.validationErrors?.length || 0})
                </button>
            </div>

            {/* Tab Contents */}
            <div className="tab-content">
                {activeTab === 'courses' && (
                    <div className="repo-table-container">
                        <div style={{ padding: '20px', display: 'flex', justifyContent: 'space-between', alignItems: 'center', borderBottom: '1px solid rgba(255,255,255,0.08)' }}>
                            <div style={{ display: 'flex', gap: '12px', alignItems: 'center' }}>
                                <input
                                    type="text"
                                    placeholder="Search code, name, bucket..."
                                    style={{ background: 'rgba(0,0,0,0.2)', border: '1px solid rgba(255,255,255,0.1)', color: 'white', padding: '8px 12px', borderRadius: '6px', fontSize: '13px', outline: 'none' }}
                                    value={searchQuery}
                                    onChange={(e) => setSearchQuery(e.target.value)}
                                />
                                {editMode && (
                                    <button className="btn-secondary" style={{ padding: '6px 12px', fontSize: '12px' }} onClick={handleAddCourse}>
                                        + Add Course
                                    </button>
                                )}
                            </div>
                            <div>
                                {summary?.status === 'ANALYZED' && (
                                    editMode ? (
                                        <div style={{ display: 'flex', gap: '8px' }}>
                                            <button className="btn-secondary" onClick={() => { setEditedCourses(detail?.courses || []); setEditMode(false); }}>
                                                Cancel
                                            </button>
                                            <button className="btn-primary" onClick={handleSaveEdits}>
                                                Save Changes
                                            </button>
                                        </div>
                                    ) : (
                                        <button className="btn-secondary" onClick={() => setEditMode(true)}>
                                            ✏️ Edit Courses
                                        </button>
                                    )
                                )}
                            </div>
                        </div>

                        <div style={{ overflowX: 'auto' }}>
                            <table className="custom-table">
                                <thead>
                                    <tr>
                                        <th>Code</th>
                                        <th>Course Name</th>
                                        <th style={{ width: '80px' }}>Credits</th>
                                        <th style={{ width: '120px' }}>L-T-P-S</th>
                                        <th>Category</th>
                                        <th>Bucket Assignment</th>
                                        <th style={{ width: '100px' }}>Mandatory</th>
                                        {editMode && <th style={{ width: '80px' }}>Actions</th>}
                                    </tr>
                                </thead>
                                <tbody>
                                    {filteredCourses.map((course, idx) => (
                                        <tr key={idx}>
                                            <td>
                                                {editMode ? (
                                                    <input 
                                                        type="text" 
                                                        style={{ width: '90px', background: 'rgba(0,0,0,0.3)', border: '1px solid #555', color: 'white', padding: '4px' }} 
                                                        value={course.courseCode} 
                                                        onChange={(e) => handleCourseChange(idx, 'courseCode', e.target.value)}
                                                    />
                                                ) : course.courseCode}
                                            </td>
                                            <td>
                                                {editMode ? (
                                                    <input 
                                                        type="text" 
                                                        style={{ width: '100%', minWidth: '180px', background: 'rgba(0,0,0,0.3)', border: '1px solid #555', color: 'white', padding: '4px' }} 
                                                        value={course.courseName} 
                                                        onChange={(e) => handleCourseChange(idx, 'courseName', e.target.value)}
                                                    />
                                                ) : course.courseName}
                                            </td>
                                            <td>
                                                {editMode ? (
                                                    <input 
                                                        type="number" 
                                                        style={{ width: '50px', background: 'rgba(0,0,0,0.3)', border: '1px solid #555', color: 'white', padding: '4px' }} 
                                                        value={course.credits} 
                                                        onChange={(e) => handleCourseChange(idx, 'credits', parseInt(e.target.value) || 0)}
                                                    />
                                                ) : course.credits}
                                            </td>
                                            <td>
                                                {editMode ? (
                                                    <div style={{ display: 'flex', gap: '2px' }}>
                                                        <input type="number" style={{ width: '25px', background: 'rgba(0,0,0,0.3)', border: '1px solid #555', color: 'white', padding: '2px' }} value={course.lectureHours} onChange={(e) => handleCourseChange(idx, 'lectureHours', parseInt(e.target.value) || 0)} />
                                                        <input type="number" style={{ width: '25px', background: 'rgba(0,0,0,0.3)', border: '1px solid #555', color: 'white', padding: '2px' }} value={course.tutorialHours} onChange={(e) => handleCourseChange(idx, 'tutorialHours', parseInt(e.target.value) || 0)} />
                                                        <input type="number" style={{ width: '25px', background: 'rgba(0,0,0,0.3)', border: '1px solid #555', color: 'white', padding: '2px' }} value={course.practicalHours} onChange={(e) => handleCourseChange(idx, 'practicalHours', parseInt(e.target.value) || 0)} />
                                                        <input type="number" style={{ width: '25px', background: 'rgba(0,0,0,0.3)', border: '1px solid #555', color: 'white', padding: '2px' }} value={course.skillHours} onChange={(e) => handleCourseChange(idx, 'skillHours', parseInt(e.target.value) || 0)} />
                                                    </div>
                                                ) : (
                                                    `${course.lectureHours}-${course.tutorialHours}-${course.practicalHours}-${course.skillHours}`
                                                )}
                                            </td>
                                            <td>
                                                {editMode ? (
                                                    <input 
                                                        type="text" 
                                                        style={{ width: '70px', background: 'rgba(0,0,0,0.3)', border: '1px solid #555', color: 'white', padding: '4px' }} 
                                                        value={course.category} 
                                                        onChange={(e) => handleCourseChange(idx, 'category', e.target.value)}
                                                    />
                                                ) : course.category}
                                            </td>
                                            <td>
                                                {editMode ? (
                                                    <input 
                                                        type="text" 
                                                        style={{ width: '120px', background: 'rgba(0,0,0,0.3)', border: '1px solid #555', color: 'white', padding: '4px' }} 
                                                        value={course.subCategory} 
                                                        onChange={(e) => handleCourseChange(idx, 'subCategory', e.target.value)}
                                                    />
                                                ) : course.subCategory}
                                            </td>
                                            <td>
                                                {editMode ? (
                                                    <input 
                                                        type="checkbox" 
                                                        checked={course.isMandatory} 
                                                        onChange={(e) => handleCourseChange(idx, 'isMandatory', e.target.checked)}
                                                    />
                                                ) : (course.isMandatory ? 'Yes ✅' : 'No')}
                                            </td>
                                            {editMode && (
                                                <td>
                                                    <button className="btn-danger" style={{ padding: '2px 8px', fontSize: '11px' }} onClick={() => handleDeleteCourse(idx)}>
                                                        Delete
                                                    </button>
                                                </td>
                                            )}
                                        </tr>
                                    ))}
                                    {filteredCourses.length === 0 && (
                                        <tr>
                                            <td colSpan={editMode ? 8 : 7} style={{ textAlign: 'center', padding: '30px' }}>No courses match your query.</td>
                                        </tr>
                                    )}
                                </tbody>
                            </table>
                        </div>
                    </div>
                )}

                {activeTab === 'buckets' && (
                    <div className="repo-table-container">
                        <table className="custom-table">
                            <thead>
                                <tr>
                                    <th>Bucket Code</th>
                                    <th>Name</th>
                                    <th>Category</th>
                                    <th>Min Credits</th>
                                    <th>Max Credits</th>
                                    <th>Min Courses</th>
                                    <th>Degree Type</th>
                                </tr>
                            </thead>
                            <tbody>
                                {detail?.bucketRequirements?.map((req, idx) => (
                                    <tr key={idx}>
                                        <td style={{ fontWeight: '600', color: '#60a5fa' }}>{req.bucketCode}</td>
                                        <td>{req.bucketName}</td>
                                        <td>{req.bucketCategory}</td>
                                        <td>{req.minCredits}</td>
                                        <td>{req.maxCredits}</td>
                                        <td>{req.minCourses}</td>
                                        <td>
                                            <span style={{ background: 'rgba(255,255,255,0.06)', padding: '2px 6px', borderRadius: '4px', fontSize: '12px' }}>
                                                {req.degreeType}
                                            </span>
                                        </td>
                                    </tr>
                                ))}
                                {(!detail?.bucketRequirements || detail.bucketRequirements.length === 0) && (
                                    <tr>
                                        <td colSpan={7} style={{ textAlign: 'center', padding: '30px' }}>No bucket requirements found.</td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                )}

                {activeTab === 'paths' && (
                    <div className="repo-table-container">
                        <table className="custom-table">
                            <thead>
                                <tr>
                                    <th>Degree Type</th>
                                    <th>Addon Type</th>
                                    <th>Addon Name (If specified)</th>
                                    <th>Required Graduation Credits</th>
                                </tr>
                            </thead>
                            <tbody>
                                {detail?.degreePaths?.map((path, idx) => (
                                    <tr key={idx}>
                                        <td style={{ fontWeight: '600' }}>{path.degreeType}</td>
                                        <td>
                                            <span style={{ color: path.addonType !== 'NONE' ? '#f59e0b' : '#94a3b8' }}>
                                                {path.addonType}
                                            </span>
                                        </td>
                                        <td>{path.addonName || 'N/A'}</td>
                                        <td style={{ fontWeight: 'bold', color: '#10b981' }}>{path.totalCredits} credits</td>
                                    </tr>
                                ))}
                                {(!detail?.degreePaths || detail.degreePaths.length === 0) && (
                                    <tr>
                                        <td colSpan={4} style={{ textAlign: 'center', padding: '30px' }}>No degree paths parsed.</td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                )}

                {activeTab === 'validation' && (
                    <div className="validation-list" style={{ background: 'rgba(30, 41, 59, 0.4)' }}>
                        <h3 style={{ color: '#fb923c' }}>📋 Automated Validation Log</h3>
                        {summary?.validationErrors && summary.validationErrors.length > 0 ? (
                            <ul>
                                {summary.validationErrors.map((err, idx) => (
                                    <li key={idx} style={{ 
                                        color: err.startsWith('ERROR:') ? '#f87171' : err.startsWith('WARNING:') ? '#fb923c' : '#94a3b8' 
                                    }}>
                                        {err}
                                    </li>
                                ))}
                            </ul>
                        ) : (
                            <p style={{ color: '#4ade80', fontSize: '14px' }}>✨ No validation warnings. The parsed curriculum structure is consistent!</p>
                        )}
                    </div>
                )}
            </div>

            {loading && (
                <div className="loading-overlay">
                    <div className="spinner"></div>
                    <h2 style={{ color: '#60a5fa' }}>Processing request...</h2>
                </div>
            )}
        </div>
    );
}
