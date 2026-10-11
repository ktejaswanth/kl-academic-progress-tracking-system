import React, { useState, useEffect } from 'react';
import api from '../../api';
import '../student/exit-requirements.css';
import './faculty.css';

export default function FacultyExitClearance() {
    const [stats, setStats] = useState(null);
    const [students, setStudents] = useState([]);
    const [loading, setLoading] = useState(true);
    const [search, setSearch] = useState('');
    const [statusFilter, setStatusFilter] = useState('ALL');

    // Detail Modal state
    const [selectedStudent, setSelectedStudent] = useState(null);
    const [studentDetail, setStudentDetail] = useState(null);
    const [detailLoading, setDetailLoading] = useState(false);

    // Review Modal state
    const [reviewItem, setReviewItem] = useState(null);
    const [reviewStatus, setReviewStatus] = useState('APPROVED');
    const [reviewRemarks, setReviewRemarks] = useState('');
    const [submittingReview, setSubmittingReview] = useState(false);

    // Bulk selection state
    const [selectedIds, setSelectedIds] = useState([]);

    const fetchData = async () => {
        try {
            setLoading(true);
            const [dashRes, rosterRes] = await Promise.all([
                api.get('/exit/faculty/dashboard'),
                api.get(`/exit/faculty/students?search=${encodeURIComponent(search)}&status=${statusFilter}`)
            ]);
            setStats(dashRes.data);
            setStudents(rosterRes.data);
        } catch (err) {
            console.error('Error loading faculty exit data:', err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchData();
    }, [statusFilter]);

    const handleSearchSubmit = (e) => {
        e.preventDefault();
        fetchData();
    };

    const handleViewDetail = async (student) => {
        setSelectedStudent(student);
        try {
            setDetailLoading(true);
            const res = await api.get(`/exit/faculty/student/${student.studentId}`);
            setStudentDetail(res.data);
        } catch (err) {
            alert('Failed to load student exit checklist: ' + err.message);
        } finally {
            setDetailLoading(false);
        }
    };

    // PDF downloading & printing states
    const [downloadingPdfId, setDownloadingPdfId] = useState(null);

    const handleDownloadPdf = async (student) => {
        if (!student) return;
        try {
            setDownloadingPdfId(student.studentId);
            const response = await api.get(`/exit/faculty/download-pdf/${student.studentId}`, { responseType: 'blob' });
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
            const response = await api.get(`/exit/faculty/download-pdf/${student.studentId}`, { responseType: 'blob' });
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

    const openReviewModal = (clearance) => {
        setReviewItem(clearance);
        setReviewStatus('APPROVED');
        setReviewRemarks('Approved by Faculty Advisor.');
    };

    const handleSaveReview = async (e) => {
        e.preventDefault();
        if (!reviewItem) return;
        try {
            setSubmittingReview(true);
            await api.post('/exit/faculty/review', {
                clearanceId: reviewItem.id.toString(),
                status: reviewStatus,
                remarks: reviewRemarks
            });
            setReviewItem(null);
            // Refresh detail
            if (selectedStudent) {
                const res = await api.get(`/exit/faculty/student/${selectedStudent.studentId}`);
                setStudentDetail(res.data);
            }
            await fetchData();
        } catch (err) {
            alert('Review failed: ' + (err.response?.data?.message || err.message));
        } finally {
            setSubmittingReview(false);
        }
    };

    const handleToggleSelectAll = (e) => {
        if (e.target.checked) {
            setSelectedIds(students.map(s => s.studentId));
        } else {
            setSelectedIds([]);
        }
    };

    const handleToggleStudent = (id) => {
        if (selectedIds.includes(id)) {
            setSelectedIds(selectedIds.filter(i => i !== id));
        } else {
            setSelectedIds([...selectedIds, id]);
        }
    };

    const getStatusBadge = (st) => {
        switch (st) {
            case 'CLEARED_FOR_GRADUATION':
                return <span className="badge-status badge-approved">🎓 Fully Cleared</span>;
            case 'PENDING_FINAL_APPROVAL':
                return <span className="badge-status badge-in_review">⏳ Pending Final Admin</span>;
            case 'IN_PROGRESS':
                return <span className="badge-status badge-submitted">⚡ In Progress</span>;
            default:
                return <span className="badge-status badge-pending">○ Not Started</span>;
        }
    };

    return (
        <div className="faculty-content animate-fade">
            <div className="page-header" style={{ marginBottom: '1.5rem' }}>
                <div>
                    <h2>Department Student Exit Clearance</h2>
                    <p style={{ color: '#6b7280', margin: '0.25rem 0 0 0' }}>
                        Review and approve departmental capstone defenses, lab equipment returns, and faculty advisor clearances for {stats?.department || 'CSE'} Department.
                    </p>
                </div>
            </div>

            {/* Metric KPI Cards */}
            <div className="stats-grid" style={{ marginBottom: '1.5rem' }}>
                <div className="stat-card">
                    <div className="stat-icon" style={{ background: '#fdf2f4', color: '#8c1d40' }}>👥</div>
                    <div className="stat-info">
                        <h3>{stats?.totalStudents || 0}</h3>
                        <p>Total Graduating Students</p>
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-icon" style={{ background: '#ecfdf5', color: '#10b981' }}>🎓</div>
                    <div className="stat-info">
                        <h3>{stats?.fullyCleared || 0}</h3>
                        <p>Graduation Cleared</p>
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-icon" style={{ background: '#fffbeb', color: '#f59e0b' }}>⏳</div>
                    <div className="stat-info">
                        <h3>{stats?.pendingFinalApproval || 0}</h3>
                        <p>Pending Final Admin Sign-off</p>
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-icon" style={{ background: '#eff6ff', color: '#2563eb' }}>📝</div>
                    <div className="stat-info">
                        <h3>{stats?.pendingFacultyActions || 0}</h3>
                        <p>Pending Faculty Reviews</p>
                    </div>
                </div>
            </div>

            {/* Filter and Search Controls */}
            <div className="card" style={{ padding: '1.25rem', marginBottom: '1.5rem' }}>
                <form onSubmit={handleSearchSubmit} style={{ display: 'flex', gap: '1rem', flexWrap: 'wrap', alignItems: 'center', justifyContent: 'space-between' }}>
                    <div style={{ display: 'flex', gap: '1rem', flex: 1, minWidth: '300px' }}>
                        <input
                            type="text"
                            className="form-control"
                            placeholder="Search by Roll No or Student Name..."
                            value={search}
                            onChange={(e) => setSearch(e.target.value)}
                            style={{ flex: 1, padding: '0.6rem 1rem', border: '1px solid #d1d5db', borderRadius: '8px' }}
                        />
                        <button type="submit" className="btn-action-primary">Search</button>
                    </div>

                    <div style={{ display: 'flex', gap: '0.5rem', alignItems: 'center' }}>
                        <label style={{ fontSize: '0.85rem', fontWeight: 600, color: '#4b5563' }}>Filter Status:</label>
                        <select
                            className="form-control"
                            value={statusFilter}
                            onChange={(e) => setStatusFilter(e.target.value)}
                            style={{ padding: '0.55rem 0.75rem', borderRadius: '8px', border: '1px solid #d1d5db' }}
                        >
                            <option value="ALL">All Statuses</option>
                            <option value="CLEARED_FOR_GRADUATION">Fully Cleared</option>
                            <option value="PENDING_FINAL_APPROVAL">Pending Final Approval</option>
                            <option value="IN_PROGRESS">In Progress</option>
                            <option value="NOT_STARTED">Not Started</option>
                        </select>
                    </div>
                </form>
            </div>

            {/* Student Roster Table */}
            <div className="card" style={{ padding: 0, overflow: 'hidden' }}>
                <div style={{ padding: '1rem 1.5rem', background: '#fafafa', borderBottom: '1px solid #e5e7eb', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <h3 style={{ margin: 0, fontSize: '1.05rem', color: '#1f2937' }}>
                        Graduating Students Roster ({students.length})
                    </h3>
                    {selectedIds.length > 0 && (
                        <span style={{ fontSize: '0.85rem', color: '#8c1d40', fontWeight: 600 }}>
                            {selectedIds.length} students selected
                        </span>
                    )}
                </div>

                <div className="table-responsive">
                    <table className="table" style={{ width: '100%', borderCollapse: 'collapse' }}>
                        <thead>
                            <tr style={{ background: '#f9fafb', textAlign: 'left', borderBottom: '1px solid #e5e7eb', fontSize: '0.85rem', color: '#4b5563' }}>
                                <th style={{ padding: '0.75rem 1.25rem', width: '40px' }}>
                                    <input type="checkbox" onChange={handleToggleSelectAll} checked={selectedIds.length === students.length && students.length > 0} />
                                </th>
                                <th style={{ padding: '0.75rem 1.25rem' }}>Roll No</th>
                                <th style={{ padding: '0.75rem 1.25rem' }}>Student Name</th>
                                <th style={{ padding: '0.75rem 1.25rem' }}>Specialization</th>
                                <th style={{ padding: '0.75rem 1.25rem' }}>Clearance Progress</th>
                                <th style={{ padding: '0.75rem 1.25rem' }}>Exit Status</th>
                                <th style={{ padding: '0.75rem 1.25rem', textAlign: 'right' }}>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {loading ? (
                                <tr>
                                    <td colSpan="7" style={{ textAlign: 'center', padding: '3rem' }}>Loading students...</td>
                                </tr>
                            ) : students.length === 0 ? (
                                <tr>
                                    <td colSpan="7" style={{ textAlign: 'center', padding: '3rem', color: '#6b7280' }}>
                                        No students found matching current filters.
                                    </td>
                                </tr>
                            ) : (
                                students.map((s) => (
                                    <tr key={s.studentId} style={{ borderBottom: '1px solid #f3f4f6' }}>
                                        <td style={{ padding: '1rem 1.25rem' }}>
                                            <input 
                                                type="checkbox" 
                                                checked={selectedIds.includes(s.studentId)}
                                                onChange={() => handleToggleStudent(s.studentId)}
                                            />
                                        </td>
                                        <td style={{ padding: '1rem 1.25rem', fontWeight: 700, color: '#1f2937' }}>
                                            {s.universityId}
                                        </td>
                                        <td style={{ padding: '1rem 1.25rem' }}>{s.name}</td>
                                        <td style={{ padding: '1rem 1.25rem', color: '#6b7280', fontSize: '0.85rem' }}>
                                            {s.specialization || 'Regular Track'}
                                        </td>
                                        <td style={{ padding: '1rem 1.25rem' }}>
                                            <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                                                <div style={{ flex: 1, background: '#e5e7eb', height: '6px', borderRadius: '3px', width: '80px', overflow: 'hidden' }}>
                                                    <div style={{ width: `${s.clearancePercentage}%`, background: '#8c1d40', height: '100%' }}></div>
                                                </div>
                                                <span style={{ fontSize: '0.8rem', fontWeight: 600 }}>{s.clearancePercentage}%</span>
                                            </div>
                                        </td>
                                        <td style={{ padding: '1rem 1.25rem' }}>
                                            {getStatusBadge(s.overallStatus)}
                                        </td>
                                        <td style={{ padding: '1rem 1.25rem', textAlign: 'right', display: 'flex', gap: '0.5rem', justifyContent: 'flex-end', alignItems: 'center' }}>
                                            <button 
                                                className="btn-action-primary" 
                                                style={{ fontSize: '0.8rem', padding: '0.35rem 0.75rem' }}
                                                onClick={() => handleViewDetail(s)}
                                            >
                                                Audit Checklist
                                            </button>
                                            <button 
                                                className="btn-action-outline" 
                                                style={{ fontSize: '0.8rem', padding: '0.35rem 0.65rem' }}
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

            {/* Checklist Detail Drawer/Modal */}
            {selectedStudent && (
                <div className="modal-backdrop" onClick={() => setSelectedStudent(null)}>
                    <div className="exit-modal-card" style={{ maxWidth: '800px' }} onClick={(e) => e.stopPropagation()}>
                        <div className="modal-header">
                            <div>
                                <h3 style={{ margin: 0 }}>Student Exit Clearance Checklist</h3>
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
                                            <strong>Overall Clearance:</strong> {studentDetail?.summary?.clearancePercentage || 0}%
                                            <div style={{ fontSize: '0.8rem', color: '#6b7280' }}>
                                                {studentDetail?.summary?.approvedCount} of {studentDetail?.summary?.totalRequirements} Requirements Met
                                            </div>
                                        </div>
                                        <div style={{ display: 'flex', gap: '0.5rem', alignItems: 'center' }}>
                                            <button 
                                                id="faculty-download-exit-pdf-btn"
                                                className="btn-action-primary" 
                                                style={{ fontSize: '0.8rem', padding: '0.4rem 0.8rem', display: 'inline-flex', alignItems: 'center', gap: '0.35rem' }}
                                                onClick={() => handleDownloadPdf(selectedStudent)}
                                                disabled={downloadingPdfId === selectedStudent.studentId}
                                            >
                                                📥 {downloadingPdfId === selectedStudent.studentId ? 'Generating...' : 'Download Exit Requirement PDF'}
                                            </button>
                                            <button 
                                                id="faculty-print-exit-report-btn"
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

                                    <div className="category-items-list">
                                        {(studentDetail?.clearances || []).map((item) => {
                                            const isFacultyAssigned = item.requirement?.responsibleRole === 'FACULTY';
                                            const isApproved = item.status === 'APPROVED';

                                            return (
                                                <div key={item.id} className="requirement-row" style={{ padding: '1rem', background: isFacultyAssigned ? '#ffffff' : '#fafafa' }}>
                                                    <div className="req-left">
                                                        <div className="req-status-icon">{isApproved ? '🟢' : '⚪'}</div>
                                                        <div className="req-details">
                                                            <h4>
                                                                {item.requirement?.title}
                                                                <span style={{ fontSize: '0.75rem', padding: '0.1rem 0.4rem', borderRadius: '4px', background: isFacultyAssigned ? '#eff6ff' : '#f3f4f6', color: isFacultyAssigned ? '#1d4ed8' : '#4b5563', fontWeight: 600 }}>
                                                                    {item.requirement?.responsibleRole}
                                                                </span>
                                                            </h4>
                                                            <p style={{ fontSize: '0.82rem' }}>{item.requirement?.description}</p>
                                                            
                                                            {item.submissionNotes && (
                                                                <div style={{ marginTop: '0.3rem', fontSize: '0.8rem', background: '#fefce8', padding: '0.3rem 0.6rem', borderRadius: '4px', color: '#713f12' }}>
                                                                    <strong>Student Note:</strong> {item.submissionNotes}
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
                                                        {isFacultyAssigned && (
                                                            <button 
                                                                className="btn-action-primary" 
                                                                style={{ fontSize: '0.75rem', padding: '0.3rem 0.6rem' }}
                                                                onClick={() => openReviewModal(item)}
                                                            >
                                                                Review
                                                            </button>
                                                        )}
                                                    </div>
                                                </div>
                                            );
                                        })}
                                    </div>
                                </div>
                            )}
                        </div>

                        <div className="modal-footer">
                            <button className="btn-action-primary" onClick={() => setSelectedStudent(null)}>Done</button>
                        </div>
                    </div>
                </div>
            )}

            {/* Individual Review Modal */}
            {reviewItem && (
                <div className="modal-backdrop" onClick={() => setReviewItem(null)}>
                    <div className="exit-modal-card" onClick={(e) => e.stopPropagation()}>
                        <div className="modal-header">
                            <h3>Faculty Requirement Evaluation</h3>
                            <button className="modal-close-btn" onClick={() => setReviewItem(null)}>&times;</button>
                        </div>
                        <form onSubmit={handleSaveReview}>
                            <div className="modal-body">
                                <div>
                                    <strong>Requirement:</strong> {reviewItem.requirement?.title}
                                </div>
                                {reviewItem.submissionNotes && (
                                    <div style={{ background: '#f9fafb', padding: '0.75rem', borderRadius: '6px', fontSize: '0.85rem' }}>
                                        <strong>Student Submission:</strong> {reviewItem.submissionNotes}
                                    </div>
                                )}
                                <div>
                                    <label style={{ display: 'block', fontWeight: 600, marginBottom: '0.25rem' }}>Decision *</label>
                                    <select 
                                        className="form-control" 
                                        value={reviewStatus} 
                                        onChange={(e) => setReviewStatus(e.target.value)}
                                        style={{ width: '100%', padding: '0.6rem', borderRadius: '6px', border: '1px solid #d1d5db' }}
                                    >
                                        <option value="APPROVED">✓ Approve & Clear Requirement</option>
                                        <option value="REJECTED">✗ Reject (Requires Student Correction)</option>
                                        <option value="WAIVED">✓ Waive Requirement</option>
                                    </select>
                                </div>
                                <div>
                                    <label style={{ display: 'block', fontWeight: 600, marginBottom: '0.25rem' }}>Evaluation Remarks *</label>
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
                                <button type="submit" className="btn-action-primary" disabled={submittingReview}>
                                    {submittingReview ? 'Saving...' : 'Confirm Evaluation'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}
        </div>
    );
}
