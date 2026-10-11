import React, { useState, useEffect } from 'react';
import api from '../api';
import '../pages/student/exit-requirements.css';
import './admin.css';

export default function AdminExitManagement() {
    const [stats, setStats] = useState(null);
    const [students, setStudents] = useState([]);
    const [requirements, setRequirements] = useState([]);
    const [loading, setLoading] = useState(true);
    const [activeTab, setActiveTab] = useState('roster'); // 'roster', 'rules'

    // Filter states
    const [deptFilter, setDeptFilter] = useState('ALL');
    const [statusFilter, setStatusFilter] = useState('ALL');
    const [search, setSearch] = useState('');

    // Student Detail Modal state
    const [selectedStudent, setSelectedStudent] = useState(null);
    const [studentDetail, setStudentDetail] = useState(null);
    const [detailLoading, setDetailLoading] = useState(false);

    // Review Item Modal state
    const [reviewItem, setReviewItem] = useState(null);
    const [reviewStatus, setReviewStatus] = useState('APPROVED');
    const [reviewRemarks, setReviewRemarks] = useState('');
    const [actionLoading, setActionLoading] = useState(false);

    // Final Clearance Modal state
    const [finalClearanceStudent, setFinalClearanceStudent] = useState(null);
    const [finalRemarks, setFinalRemarks] = useState('');

    const fetchAllData = async () => {
        try {
            setLoading(true);
            const [dashRes, rosterRes, reqsRes] = await Promise.all([
                api.get('/exit/admin/dashboard'),
                api.get(`/exit/admin/all-students?department=${deptFilter}&status=${statusFilter}&search=${encodeURIComponent(search)}`),
                api.get('/exit/admin/requirements')
            ]);
            setStats(dashRes.data);
            setStudents(rosterRes.data);
            setRequirements(reqsRes.data);
        } catch (err) {
            console.error('Error loading admin exit data:', err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchAllData();
    }, [deptFilter, statusFilter]);

    const handleSearchSubmit = (e) => {
        e.preventDefault();
        fetchAllData();
    };

    const handleAutoEvaluate = async () => {
        if (!window.confirm('Run automated academic audit check across all students in the university? This will verify credits and CGPA.')) return;
        try {
            setActionLoading(true);
            const res = await api.post('/exit/admin/auto-evaluate-all');
            alert(`Auto-evaluation completed!\nStudents Evaluated: ${res.data.totalStudentsEvaluated}\nNewly Ready for Final Clearance: ${res.data.readyForFinalApproval}`);
            await fetchAllData();
        } catch (err) {
            alert('Auto-evaluation failed: ' + err.message);
        } finally {
            setActionLoading(false);
        }
    };

    const handleExportExcel = async () => {
        try {
            const response = await api.get('/exit/admin/export-excel', { responseType: 'blob' });
            const url = window.URL.createObjectURL(new Blob([response.data]));
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', 'university_exit_clearance_report.xlsx');
            document.body.appendChild(link);
            link.click();
            link.remove();
        } catch (err) {
            alert('Failed to export Excel report: ' + err.message);
        }
    };

    // PDF downloading & printing states
    const [downloadingPdfId, setDownloadingPdfId] = useState(null);

    const handleDownloadPdf = async (student) => {
        if (!student) return;
        try {
            setDownloadingPdfId(student.studentId);
            const response = await api.get(`/exit/admin/download-pdf/${student.studentId}`, { responseType: 'blob' });
            const blob = new Blob([response.data], { type: 'application/pdf' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.setAttribute('download', `Exit_Requirement_${student.universityId || student.studentId}.pdf`);
            document.body.appendChild(a);
            a.click();
            a.remove();
            window.URL.revokeObjectURL(url);
        } catch (err) {
            alert('Failed to download Exit Requirement PDF: ' + (err.response?.data?.message || err.message));
        } finally {
            setDownloadingPdfId(null);
        }
    };

    const handlePrintPdf = async (student) => {
        if (!student) return;
        try {
            setDownloadingPdfId(student.studentId);
            const response = await api.get(`/exit/admin/download-pdf/${student.studentId}`, { responseType: 'blob' });
            const blob = new Blob([response.data], { type: 'application/pdf' });
            const url = window.URL.createObjectURL(blob);
            const iframe = document.createElement('iframe');
            iframe.style.position = 'fixed';
            iframe.style.right = '0';
            iframe.style.bottom = '0';
            iframe.style.width = '0';
            iframe.style.height = '0';
            iframe.style.border = '0';
            iframe.src = url;
            document.body.appendChild(iframe);
            iframe.onload = () => {
                setTimeout(() => {
                    iframe.focus();
                    iframe.contentWindow.print();
                }, 300);
            };
        } catch (err) {
            alert('Failed to print Exit Requirement report: ' + (err.response?.data?.message || err.message));
        } finally {
            setDownloadingPdfId(null);
        }
    };

    const handleViewDetail = async (student) => {
        setSelectedStudent(student);
        try {
            setDetailLoading(true);
            const res = await api.get(`/exit/admin/student/${student.studentId}`);
            setStudentDetail(res.data);
        } catch (err) {
            alert('Failed to load student exit checklist: ' + err.message);
        } finally {
            setDetailLoading(false);
        }
    };

    const handleSaveReview = async (e) => {
        e.preventDefault();
        if (!reviewItem) return;
        try {
            setActionLoading(true);
            await api.post('/exit/admin/review', {
                clearanceId: reviewItem.id.toString(),
                status: reviewStatus,
                remarks: reviewRemarks
            });
            setReviewItem(null);
            if (selectedStudent) {
                const res = await api.get(`/exit/admin/student/${selectedStudent.studentId}`);
                setStudentDetail(res.data);
            }
            await fetchAllData();
        } catch (err) {
            alert('Failed to update requirement: ' + err.message);
        } finally {
            setActionLoading(false);
        }
    };

    const handleConfirmFinalClearance = async (e) => {
        e.preventDefault();
        if (!finalClearanceStudent) return;
        try {
            setActionLoading(true);
            await api.post(`/exit/admin/final-clearance/${finalClearanceStudent.studentId}`, {
                remarks: finalRemarks
            });
            alert(`Official Graduation & Exit Clearance granted to ${finalClearanceStudent.name}!`);
            setFinalClearanceStudent(null);
            if (selectedStudent && selectedStudent.studentId === finalClearanceStudent.studentId) {
                const res = await api.get(`/exit/admin/student/${selectedStudent.studentId}`);
                setStudentDetail(res.data);
            }
            await fetchAllData();
        } catch (err) {
            alert('Failed to grant final clearance: ' + err.message);
        } finally {
            setActionLoading(false);
        }
    };

    const getStatusBadge = (st) => {
        switch (st) {
            case 'CLEARED_FOR_GRADUATION':
                return <span className="badge-status badge-approved">🎓 Conferred & Cleared</span>;
            case 'PENDING_FINAL_APPROVAL':
                return <span className="badge-status badge-in_review">⏳ Ready for Endorsement</span>;
            case 'IN_PROGRESS':
                return <span className="badge-status badge-submitted">⚡ In Progress</span>;
            default:
                return <span className="badge-status badge-pending">○ Not Started</span>;
        }
    };

    return (
        <div className="admin-content animate-fade">
            {/* Page Header */}
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem', flexWrap: 'wrap', gap: '1rem' }}>
                <div>
                    <h2 style={{ margin: 0, color: '#1f2937' }}>Student Exit Requirement & Graduation Clearance</h2>
                    <p style={{ margin: '0.25rem 0 0 0', color: '#6b7280' }}>
                        University-wide oversight, administrative clearance authorizations, and final graduation degree conferrals.
                    </p>
                </div>
                <div style={{ display: 'flex', gap: '0.75rem' }}>
                    <button 
                        className="btn-action-outline" 
                        onClick={handleAutoEvaluate}
                        disabled={actionLoading}
                    >
                        🔄 Auto-Audit Academic Rules
                    </button>
                    <button 
                        className="btn-action-primary" 
                        onClick={handleExportExcel}
                    >
                        📥 Export Excel Report
                    </button>
                </div>
            </div>

            {/* University Stats Cards */}
            <div className="exit-stats-grid" style={{ marginBottom: '1.5rem' }}>
                <div className="exit-stat-card">
                    <div className="exit-stat-icon">🎓</div>
                    <div className="exit-stat-info">
                        <h4>{stats?.clearedForGraduation || 0}</h4>
                        <span>Graduation Cleared ({stats?.overallClearanceRate || 0}%)</span>
                    </div>
                </div>

                <div className="exit-stat-card">
                    <div className="exit-stat-icon" style={{ background: '#fffbeb', color: '#b45309' }}>⏳</div>
                    <div className="exit-stat-info">
                        <h4>{stats?.pendingFinalApproval || 0}</h4>
                        <span>Awaiting Final Sign-Off</span>
                    </div>
                </div>

                <div className="exit-stat-card">
                    <div className="exit-stat-icon" style={{ background: '#eff6ff', color: '#1d4ed8' }}>⚡</div>
                    <div className="exit-stat-info">
                        <h4>{stats?.inProgress || 0}</h4>
                        <span>Clearance In Progress</span>
                    </div>
                </div>

                <div className="exit-stat-card">
                    <div className="exit-stat-icon" style={{ background: '#f3f4f6', color: '#4b5563' }}>👥</div>
                    <div className="exit-stat-info">
                        <h4>{stats?.totalStudents || 0}</h4>
                        <span>Total Graduating Cohort</span>
                    </div>
                </div>
            </div>

            {/* Tab Navigation */}
            <div style={{ display: 'flex', gap: '1rem', borderBottom: '2px solid #e5e7eb', marginBottom: '1.5rem' }}>
                <button
                    onClick={() => setActiveTab('roster')}
                    style={{
                        padding: '0.75rem 1.25rem',
                        background: 'transparent',
                        border: 'none',
                        borderBottom: activeTab === 'roster' ? '3px solid #8c1d40' : '3px solid transparent',
                        color: activeTab === 'roster' ? '#8c1d40' : '#4b5563',
                        fontWeight: 700,
                        cursor: 'pointer'
                    }}
                >
                    📋 Student Clearance Roster ({students.length})
                </button>
                <button
                    onClick={() => setActiveTab('rules')}
                    style={{
                        padding: '0.75rem 1.25rem',
                        background: 'transparent',
                        border: 'none',
                        borderBottom: activeTab === 'rules' ? '3px solid #8c1d40' : '3px solid transparent',
                        color: activeTab === 'rules' ? '#8c1d40' : '#4b5563',
                        fontWeight: 700,
                        cursor: 'pointer'
                    }}
                >
                    ⚙️ Exit Requirements Master Rules ({requirements.length})
                </button>
            </div>

            {/* TAB 1: ROSTER */}
            {activeTab === 'roster' && (
                <div>
                    {/* Filters */}
                    <div className="card" style={{ padding: '1rem 1.5rem', marginBottom: '1.5rem' }}>
                        <form onSubmit={handleSearchSubmit} style={{ display: 'flex', gap: '1rem', flexWrap: 'wrap', alignItems: 'center' }}>
                            <input
                                type="text"
                                className="form-control"
                                placeholder="Search by Student ID or Name..."
                                value={search}
                                onChange={(e) => setSearch(e.target.value)}
                                style={{ flex: 1, minWidth: '240px', padding: '0.6rem 1rem', border: '1px solid #d1d5db', borderRadius: '8px' }}
                            />
                            <select
                                className="form-control"
                                value={deptFilter}
                                onChange={(e) => setDeptFilter(e.target.value)}
                                style={{ padding: '0.6rem', borderRadius: '8px', border: '1px solid #d1d5db' }}
                            >
                                <option value="ALL">All Departments</option>
                                <option value="CSE">CSE Department</option>
                                <option value="AIDS">AIDS Department</option>
                            </select>
                            <select
                                className="form-control"
                                value={statusFilter}
                                onChange={(e) => setStatusFilter(e.target.value)}
                                style={{ padding: '0.6rem', borderRadius: '8px', border: '1px solid #d1d5db' }}
                            >
                                <option value="ALL">All Statuses</option>
                                <option value="PENDING_FINAL_APPROVAL">Ready for Final Sign-off</option>
                                <option value="CLEARED_FOR_GRADUATION">Fully Cleared</option>
                                <option value="IN_PROGRESS">In Progress</option>
                                <option value="NOT_STARTED">Not Started</option>
                            </select>
                            <button type="submit" className="btn-action-primary">Filter</button>
                        </form>
                    </div>

                    {/* Table */}
                    <div className="card" style={{ padding: 0, overflow: 'hidden' }}>
                        <div className="table-responsive">
                            <table className="table" style={{ width: '100%', borderCollapse: 'collapse' }}>
                                <thead>
                                    <tr style={{ background: '#f9fafb', textAlign: 'left', borderBottom: '1px solid #e5e7eb', fontSize: '0.85rem', color: '#4b5563' }}>
                                        <th style={{ padding: '0.75rem 1.25rem' }}>Roll No</th>
                                        <th style={{ padding: '0.75rem 1.25rem' }}>Student Name</th>
                                        <th style={{ padding: '0.75rem 1.25rem' }}>Dept</th>
                                        <th style={{ padding: '0.75rem 1.25rem' }}>Specialization</th>
                                        <th style={{ padding: '0.75rem 1.25rem' }}>Clearance %</th>
                                        <th style={{ padding: '0.75rem 1.25rem' }}>Overall Status</th>
                                        <th style={{ padding: '0.75rem 1.25rem', textAlign: 'right' }}>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {loading ? (
                                        <tr><td colSpan="7" style={{ textAlign: 'center', padding: '3rem' }}>Loading students...</td></tr>
                                    ) : students.length === 0 ? (
                                        <tr><td colSpan="7" style={{ textAlign: 'center', padding: '3rem', color: '#6b7280' }}>No students found matching filters.</td></tr>
                                    ) : (
                                        students.map((s) => (
                                            <tr key={s.studentId} style={{ borderBottom: '1px solid #f3f4f6' }}>
                                                <td style={{ padding: '1rem 1.25rem', fontWeight: 700, color: '#1f2937' }}>
                                                    {s.universityId}
                                                </td>
                                                <td style={{ padding: '1rem 1.25rem' }}>{s.name}</td>
                                                <td style={{ padding: '1rem 1.25rem' }}>{s.department}</td>
                                                <td style={{ padding: '1rem 1.25rem', fontSize: '0.85rem', color: '#6b7280' }}>
                                                    {s.specialization || 'Regular Track'}
                                                </td>
                                                <td style={{ padding: '1rem 1.25rem' }}>
                                                    <span style={{ fontWeight: 700, color: s.clearancePercentage >= 100 ? '#059669' : '#8c1d40' }}>
                                                        {s.clearancePercentage}%
                                                    </span>
                                                </td>
                                                <td style={{ padding: '1rem 1.25rem' }}>
                                                    {getStatusBadge(s.overallStatus)}
                                                </td>
                                                <td style={{ padding: '1rem 1.25rem', textAlign: 'right', display: 'flex', gap: '0.5rem', justifyContent: 'flex-end' }}>
                                                    {s.overallStatus === 'PENDING_FINAL_APPROVAL' && (
                                                        <button 
                                                            className="btn-action-primary"
                                                            style={{ fontSize: '0.75rem', background: '#059669', padding: '0.35rem 0.65rem' }}
                                                            onClick={() => {
                                                                setFinalClearanceStudent(s);
                                                                setFinalRemarks('All institutional and academic clearances satisfied. Granted graduation conferral.');
                                                            }}
                                                        >
                                                            🎓 Grant Clearance
                                                        </button>
                                                    )}
                                                    <button 
                                                        className="btn-action-outline" 
                                                        style={{ fontSize: '0.75rem', padding: '0.35rem 0.65rem' }}
                                                        onClick={() => handleViewDetail(s)}
                                                    >
                                                        Audit Items
                                                    </button>
                                                    <button 
                                                        className="btn-action-outline" 
                                                        style={{ fontSize: '0.75rem', padding: '0.35rem 0.65rem' }}
                                                        onClick={() => handleDownloadPdf(s)}
                                                        disabled={downloadingPdfId === s.studentId}
                                                        title="Download Official Exit Requirement PDF"
                                                    >
                                                        {downloadingPdfId === s.studentId ? '⏳' : '📥 PDF'}
                                                    </button>
                                                </td>
                                            </tr>
                                        ))
                                    )}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            )}

            {/* TAB 2: RULES CONFIGURATOR */}
            {activeTab === 'rules' && (
                <div className="card" style={{ padding: '1.5rem' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.25rem' }}>
                        <div>
                            <h3 style={{ margin: 0 }}>University Exit Requirement Master Catalog</h3>
                            <p style={{ margin: '0.25rem 0 0 0', color: '#6b7280', fontSize: '0.85rem' }}>
                                These 10 criteria govern student graduation clearance across Academic, Department, and Central Administrative units.
                            </p>
                        </div>
                    </div>

                    <div className="table-responsive">
                        <table className="table" style={{ width: '100%', borderCollapse: 'collapse' }}>
                            <thead>
                                <tr style={{ background: '#f9fafb', textAlign: 'left', borderBottom: '1px solid #e5e7eb', fontSize: '0.85rem' }}>
                                    <th style={{ padding: '0.75rem' }}>Code</th>
                                    <th style={{ padding: '0.75rem' }}>Title</th>
                                    <th style={{ padding: '0.75rem' }}>Category</th>
                                    <th style={{ padding: '0.75rem' }}>Responsible Role</th>
                                    <th style={{ padding: '0.75rem' }}>Mandatory</th>
                                </tr>
                            </thead>
                            <tbody>
                                {requirements.map((r) => (
                                    <tr key={r.id} style={{ borderBottom: '1px solid #f3f4f6' }}>
                                        <td style={{ padding: '0.75rem', fontFamily: 'monospace', fontWeight: 600 }}>{r.requirementCode}</td>
                                        <td style={{ padding: '0.75rem', fontWeight: 600 }}>{r.title}</td>
                                        <td style={{ padding: '0.75rem' }}>
                                            <span style={{ padding: '0.2rem 0.5rem', background: '#fdf2f4', color: '#8c1d40', borderRadius: '4px', fontSize: '0.75rem', fontWeight: 600 }}>
                                                {r.category}
                                            </span>
                                        </td>
                                        <td style={{ padding: '0.75rem' }}>
                                            <span style={{ padding: '0.2rem 0.5rem', background: '#eff6ff', color: '#1d4ed8', borderRadius: '4px', fontSize: '0.75rem', fontWeight: 600 }}>
                                                {r.responsibleRole}
                                            </span>
                                        </td>
                                        <td style={{ padding: '0.75rem' }}>{r.isMandatory ? '✅ Yes' : 'Optional'}</td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
            )}

            {/* Checklist Detail Modal */}
            {selectedStudent && (
                <div className="modal-backdrop" onClick={() => setSelectedStudent(null)}>
                    <div className="exit-modal-card" style={{ maxWidth: '850px' }} onClick={(e) => e.stopPropagation()}>
                        <div className="modal-header">
                            <div>
                                <h3 style={{ margin: 0 }}>Student Graduation Exit Audit</h3>
                                <span style={{ fontSize: '0.85rem', color: '#6b7280' }}>
                                    {selectedStudent.name} ({selectedStudent.universityId}) &bull; {selectedStudent.department}
                                </span>
                            </div>
                            <button className="modal-close-btn" onClick={() => setSelectedStudent(null)}>&times;</button>
                        </div>

                        <div className="modal-body">
                            {detailLoading ? (
                                <p style={{ textAlign: 'center', padding: '2rem' }}>Loading checklist details...</p>
                            ) : (
                                <div>
                                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: '0.75rem', marginBottom: '1.25rem', background: '#fdf8f9', padding: '1rem', borderRadius: '8px' }}>
                                        <div>
                                            <strong>Clearance Completion:</strong> {studentDetail?.summary?.clearancePercentage || 0}%
                                            <div style={{ fontSize: '0.8rem', color: '#6b7280' }}>
                                                {studentDetail?.summary?.approvedCount} of {studentDetail?.summary?.totalRequirements} Met
                                            </div>
                                        </div>
                                        <div style={{ display: 'flex', gap: '0.5rem', alignItems: 'center' }}>
                                            <button 
                                                id="admin-download-exit-pdf-btn"
                                                className="btn-action-primary" 
                                                style={{ fontSize: '0.8rem', padding: '0.4rem 0.8rem', display: 'inline-flex', alignItems: 'center', gap: '0.35rem' }}
                                                onClick={() => handleDownloadPdf(selectedStudent)}
                                                disabled={downloadingPdfId === selectedStudent.studentId}
                                            >
                                                📥 {downloadingPdfId === selectedStudent.studentId ? 'Generating...' : 'Download Exit Requirement PDF'}
                                            </button>
                                            <button 
                                                id="admin-print-exit-report-btn"
                                                className="btn-action-outline" 
                                                style={{ fontSize: '0.8rem', padding: '0.4rem 0.8rem', display: 'inline-flex', alignItems: 'center', gap: '0.35rem' }}
                                                onClick={() => handlePrintPdf(selectedStudent)}
                                                disabled={downloadingPdfId === selectedStudent.studentId}
                                            >
                                                🖨️ Print
                                            </button>
                                            {getStatusBadge(studentDetail?.summary?.overallStatus)}
                                        </div>
                                    </div>

                                    {studentDetail?.summary?.certificateToken && (
                                        <div style={{ marginBottom: '1rem', padding: '0.75rem', background: '#ecfdf5', borderRadius: '6px', fontSize: '0.85rem', color: '#065f46' }}>
                                            📜 <strong>Conferral Certificate Code:</strong> {studentDetail.summary.certificateToken}
                                        </div>
                                    )}

                                    <div className="category-items-list">
                                        {(studentDetail?.clearances || []).map((item) => {
                                            const isApproved = item.status === 'APPROVED';

                                            return (
                                                <div key={item.id} className="requirement-row" style={{ padding: '1rem' }}>
                                                    <div className="req-left">
                                                        <div className="req-status-icon">{isApproved ? '🟢' : '⚪'}</div>
                                                        <div className="req-details">
                                                            <h4>
                                                                {item.requirement?.title}
                                                                <span style={{ fontSize: '0.75rem', padding: '0.1rem 0.4rem', borderRadius: '4px', background: '#f3f4f6', color: '#4b5563', fontWeight: 600 }}>
                                                                    {item.requirement?.responsibleRole}
                                                                </span>
                                                            </h4>
                                                            <p style={{ fontSize: '0.82rem' }}>{item.requirement?.description}</p>
                                                            
                                                            {item.submissionNotes && (
                                                                <div style={{ marginTop: '0.3rem', fontSize: '0.8rem', background: '#fefce8', padding: '0.3rem 0.6rem', borderRadius: '4px', color: '#713f12' }}>
                                                                    <strong>Student Submission:</strong> {item.submissionNotes}
                                                                </div>
                                                            )}

                                                            {item.remarks && (
                                                                <div style={{ marginTop: '0.2rem', fontSize: '0.8rem', color: '#047857' }}>
                                                                    <strong>Verifier Remarks:</strong> {item.remarks} ({item.verifiedBy || 'System'})
                                                                </div>
                                                            )}
                                                        </div>
                                                    </div>

                                                    <div className="req-right">
                                                        <span className={`badge-status badge-${item.status.toLowerCase()}`}>{item.status}</span>
                                                        <button 
                                                            className="btn-action-primary" 
                                                            style={{ fontSize: '0.75rem', padding: '0.3rem 0.6rem' }}
                                                            onClick={() => {
                                                                setReviewItem(item);
                                                                setReviewStatus(item.status === 'APPROVED' ? 'APPROVED' : 'APPROVED');
                                                                setReviewRemarks('Authorized by Super Administrator.');
                                                            }}
                                                        >
                                                            Admin Action
                                                        </button>
                                                    </div>
                                                </div>
                                            );
                                        })}
                                    </div>
                                </div>
                            )}
                        </div>

                        <div className="modal-footer" style={{ display: 'flex', justifyContent: 'space-between' }}>
                            <div>
                                {studentDetail?.summary?.overallStatus === 'PENDING_FINAL_APPROVAL' && (
                                    <button 
                                        className="btn-action-primary"
                                        style={{ background: '#059669' }}
                                        onClick={() => {
                                            setFinalClearanceStudent(selectedStudent);
                                            setFinalRemarks('Institutional graduation clearance endorsed by Super Administrator.');
                                        }}
                                    >
                                        🎓 Grant Official Graduation Clearance
                                    </button>
                                )}
                            </div>
                            <button className="btn-action-outline" onClick={() => setSelectedStudent(null)}>Close</button>
                        </div>
                    </div>
                </div>
            )}

            {/* Admin Review Action Modal */}
            {reviewItem && (
                <div className="modal-backdrop" onClick={() => setReviewItem(null)}>
                    <div className="exit-modal-card" onClick={(e) => e.stopPropagation()}>
                        <div className="modal-header">
                            <h3>Administrative Action on Requirement</h3>
                            <button className="modal-close-btn" onClick={() => setReviewItem(null)}>&times;</button>
                        </div>
                        <form onSubmit={handleSaveReview}>
                            <div className="modal-body">
                                <div>
                                    <strong>Requirement:</strong> {reviewItem.requirement?.title}
                                </div>
                                <div>
                                    <label style={{ display: 'block', fontWeight: 600, marginBottom: '0.25rem' }}>Action Decision *</label>
                                    <select 
                                        className="form-control" 
                                        value={reviewStatus} 
                                        onChange={(e) => setReviewStatus(e.target.value)}
                                        style={{ width: '100%', padding: '0.6rem', borderRadius: '6px', border: '1px solid #d1d5db' }}
                                    >
                                        <option value="APPROVED">✓ Grant Full Clearance / Approval</option>
                                        <option value="WAIVED">✓ Waive Requirement (Dean Exemption)</option>
                                        <option value="REJECTED">✗ Mark Deficient / Rejected (Requires Dues Payment)</option>
                                        <option value="PENDING">○ Reset to Pending</option>
                                    </select>
                                </div>
                                <div>
                                    <label style={{ display: 'block', fontWeight: 600, marginBottom: '0.25rem' }}>Official Remarks *</label>
                                    <textarea
                                        rows="3"
                                        required
                                        className="form-control"
                                        style={{ width: '100%', padding: '0.6rem', borderRadius: '6px', border: '1px solid #d1d5db' }}
                                        value={reviewRemarks}
                                        onChange={(e) => setReviewRemarks(e.target.value)}
                                    />
                                </div>
                            </div>
                            <div className="modal-footer">
                                <button type="button" className="btn-action-outline" onClick={() => setReviewItem(null)}>Cancel</button>
                                <button type="submit" className="btn-action-primary" disabled={actionLoading}>
                                    {actionLoading ? 'Saving...' : 'Apply Decision'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}

            {/* Grant Final Clearance Modal */}
            {finalClearanceStudent && (
                <div className="modal-backdrop" onClick={() => setFinalClearanceStudent(null)}>
                    <div className="exit-modal-card" onClick={(e) => e.stopPropagation()}>
                        <div className="modal-header">
                            <h3>Grant Final Graduation Clearance</h3>
                            <button className="modal-close-btn" onClick={() => setFinalClearanceStudent(null)}>&times;</button>
                        </div>
                        <form onSubmit={handleConfirmFinalClearance}>
                            <div className="modal-body">
                                <div style={{ background: '#ecfdf5', padding: '1rem', borderRadius: '8px', color: '#065f46', fontSize: '0.9rem' }}>
                                    🎓 You are issuing final institutional clearance for <strong>{finalClearanceStudent.name}</strong> ({finalClearanceStudent.universityId}).
                                    A unique graduation clearance token will be generated, certifying that all academic and non-academic requirements have been met.
                                </div>

                                <div>
                                    <label style={{ display: 'block', fontWeight: 600, marginBottom: '0.25rem' }}>Final Endorsement Remarks *</label>
                                    <textarea
                                        rows="3"
                                        required
                                        className="form-control"
                                        style={{ width: '100%', padding: '0.6rem', borderRadius: '6px', border: '1px solid #d1d5db' }}
                                        value={finalRemarks}
                                        onChange={(e) => setFinalRemarks(e.target.value)}
                                    />
                                </div>
                            </div>
                            <div className="modal-footer">
                                <button type="button" className="btn-action-outline" onClick={() => setFinalClearanceStudent(null)}>Cancel</button>
                                <button type="submit" className="btn-action-primary" style={{ background: '#059669' }} disabled={actionLoading}>
                                    {actionLoading ? 'Endorsing...' : 'Confirm Graduation Clearance'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}
        </div>
    );
}
