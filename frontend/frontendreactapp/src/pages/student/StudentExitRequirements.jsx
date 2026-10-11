import React, { useState, useEffect } from 'react';
import api from '../../api';
import ExitRequirementReportPreview from '../../components/ExitRequirementReportPreview';
import './exit-requirements.css';

export default function StudentExitRequirements() {
    const [data, setData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    // Modal & preview states
    const [activeModal, setActiveModal] = useState(null); // 'submit', 'survey', 'certificate'
    const [selectedClearance, setSelectedClearance] = useState(null);
    const [submissionNotes, setSubmissionNotes] = useState('');
    const [attachmentUrl, setAttachmentUrl] = useState('');
    const [submitting, setSubmitting] = useState(false);

    // 10-Category Academic Report Preview
    const [showReportPreview, setShowReportPreview] = useState(false);
    const [academicReportData, setAcademicReportData] = useState(null);
    const [loadingAcademicReport, setLoadingAcademicReport] = useState(false);

    // PDF downloading & printing states
    const [pdfDownloading, setPdfDownloading] = useState(false);

    // Survey form states
    const [surveyForm, setSurveyForm] = useState({
        overallSatisfaction: '5/5 - Highly Satisfied',
        curriculumQuality: '5/5',
        facultySupport: '5/5',
        careerPlan: 'Industry Employment (Campus Placed)',
        feedback: 'The DYOD curriculum gave me immense flexibility to specialize in cutting-edge domains.'
    });

    const handleDownloadPdf = async () => {
        try {
            setPdfDownloading(true);
            const response = await api.get('/exit/student/download-pdf', { responseType: 'blob' });
            const blob = new Blob([response.data], { type: 'application/pdf' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.setAttribute('download', `Exit_Requirement_${data?.universityId || 'Student'}.pdf`);
            document.body.appendChild(a);
            a.click();
            a.remove();
            window.URL.revokeObjectURL(url);
        } catch (err) {
            alert('Failed to download Exit Requirement PDF: ' + (err.response?.data?.message || err.message));
        } finally {
            setPdfDownloading(false);
        }
    };

    const handlePrintPdf = async () => {
        try {
            setPdfDownloading(true);
            const response = await api.get('/exit/student/download-pdf', { responseType: 'blob' });
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
            setPdfDownloading(false);
        }
    };

    const fetchStatus = async () => {
        try {
            setLoading(true);
            const res = await api.get('/exit/student/my-status');
            setData(res.data);
            setError('');
        } catch (err) {
            console.error('Error fetching exit status:', err);
            setError(err.response?.data?.error || err.message || 'Failed to load exit clearance requirements.');
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchStatus();
    }, []);

    const openSubmitModal = (clearance) => {
        setSelectedClearance(clearance);
        setSubmissionNotes(clearance.submissionNotes || '');
        setAttachmentUrl(clearance.attachmentUrl || '');
        setActiveModal('submit');
    };

    const handleSubmitRequirement = async (e) => {
        e.preventDefault();
        if (!selectedClearance) return;
        try {
            setSubmitting(true);
            await api.post(`/exit/student/submit/${selectedClearance.id}`, {
                notes: submissionNotes,
                attachmentUrl: attachmentUrl
            });
            setActiveModal(null);
            await fetchStatus();
        } catch (err) {
            alert('Failed to submit requirement: ' + (err.response?.data?.message || err.message));
        } finally {
            setSubmitting(false);
        }
    };

    const handleSubmitSurvey = async (e) => {
        e.preventDefault();
        try {
            setSubmitting(true);
            await api.post('/exit/student/submit-survey', surveyForm);
            setActiveModal(null);
            await fetchStatus();
        } catch (err) {
            alert('Failed to submit survey: ' + (err.response?.data?.message || err.message));
        } finally {
            setSubmitting(false);
        }
    };

    if (loading) {
        return (
            <div className="exit-container" style={{ textAlign: 'center', padding: '4rem 1rem' }}>
                <div style={{ fontSize: '2.5rem', marginBottom: '1rem' }}>🎓</div>
                <h3>Loading Graduation Exit Requirements...</h3>
                <p style={{ color: '#6b7280' }}>Auditing academic rules and institutional clearances...</p>
            </div>
        );
    }

    if (error) {
        return (
            <div className="exit-container">
                <div className="card" style={{ background: '#fef2f2', border: '1px solid #fee2e2', color: '#991b1b', padding: '1.5rem' }}>
                    <h4>Unable to Load Exit Requirements</h4>
                    <p>{error}</p>
                    <button className="btn-action-primary" onClick={fetchStatus}>Retry</button>
                </div>
            </div>
        );
    }

    const summary = data?.summary || {};
    const clearances = data?.clearances || [];

    // Group clearances by category
    const categories = [
        { key: 'ACADEMIC', title: 'Academic & DYOD Credit Audit', icon: '📚' },
        { key: 'DEPARTMENT', title: 'Department & Faculty Clearances', icon: '🔬' },
        { key: 'ADMINISTRATIVE', title: 'Institutional & No-Dues Clearances', icon: '🏛️' },
        { key: 'CAREER_ALUMNI', title: 'Career Outcomes & Exit Feedback', icon: '🚀' }
    ];

    const getStatusBadge = (status) => {
        switch (status) {
            case 'APPROVED':
                return <span className="badge-status badge-approved">✓ Cleared</span>;
            case 'SUBMITTED':
                return <span className="badge-status badge-submitted">⏱ In Review</span>;
            case 'IN_REVIEW':
                return <span className="badge-status badge-in_review">🔍 In Review</span>;
            case 'REJECTED':
                return <span className="badge-status badge-rejected">✗ Needs Action</span>;
            case 'WAIVED':
                return <span className="badge-status badge-waived">✓ Waived</span>;
            default:
                return <span className="badge-status badge-pending">○ Pending</span>;
        }
    };

    const getOverallBadge = (st) => {
        switch (st) {
            case 'CLEARED_FOR_GRADUATION':
                return <div className="exit-status-pill status-cleared">🎓 Cleared for Graduation</div>;
            case 'PENDING_FINAL_APPROVAL':
                return <div className="exit-status-pill status-pending-approval">⏳ Pending Final Endorsement</div>;
            default:
                return <div className="exit-status-pill status-in-progress">⚡ In Progress ({summary.clearancePercentage || 0}%)</div>;
        }
    };

    const handleToggleAcademicReport = async () => {
        if (!showReportPreview && !academicReportData) {
            try {
                setLoadingAcademicReport(true);
                const res = await api.get('/exit/student/report');
                setAcademicReportData(res.data);
            } catch (err) {
                console.error('Failed to load academic report:', err);
                alert('Failed to load report data: ' + (err.response?.data?.error || err.message));
            } finally {
                setLoadingAcademicReport(false);
            }
        }
        setShowReportPreview(!showReportPreview);
    };

    return (
        <div className="exit-container animate-fade">
            {/* Hero Card */}
            <div className="exit-hero-card">
                <div className="exit-hero-content">
                    <div className="exit-hero-text">
                        <h1>Student Exit & Graduation Clearance</h1>
                        <p>
                            Student: <strong>{data?.studentName}</strong> ({data?.universityId}) &bull; {data?.department} Department
                        </p>
                    </div>
                    <div>
                        {getOverallBadge(summary.overallStatus)}
                    </div>
                </div>

                <div style={{ marginTop: '1.5rem', display: 'flex', gap: '0.85rem', flexWrap: 'wrap', alignItems: 'center' }}>
                    <button 
                        id="btn-download-exit-pdf"
                        className="btn-action-primary" 
                        style={{ background: '#ffffff', color: '#8c1d40', fontWeight: 600, display: 'inline-flex', alignItems: 'center', gap: '0.5rem', boxShadow: '0 4px 12px rgba(0,0,0,0.12)' }}
                        onClick={handleDownloadPdf}
                        disabled={pdfDownloading}
                    >
                        📥 {pdfDownloading ? 'Generating Official PDF...' : 'Download Exit Requirement PDF'}
                    </button>
                    <button 
                        id="btn-print-exit-report"
                        className="btn-action-outline" 
                        style={{ background: 'rgba(255,255,255,0.15)', color: '#ffffff', borderColor: 'rgba(255,255,255,0.4)', fontWeight: 600, display: 'inline-flex', alignItems: 'center', gap: '0.5rem' }}
                        onClick={handlePrintPdf}
                        disabled={pdfDownloading}
                    >
                        🖨️ Print Report
                    </button>
                    <button 
                        id="btn-toggle-report-preview"
                        className="btn-action-primary" 
                        style={{ background: '#fef3c7', color: '#92400e', fontWeight: 600, display: 'inline-flex', alignItems: 'center', gap: '0.5rem' }}
                        onClick={handleToggleAcademicReport}
                        disabled={loadingAcademicReport}
                    >
                        📋 {loadingAcademicReport ? 'Loading 10-Vertical Audit...' : (showReportPreview ? 'Hide 10-Vertical Report' : 'Preview 10-Vertical Academic Report')}
                    </button>
                    {summary.overallStatus === 'CLEARED_FOR_GRADUATION' && (
                        <button 
                            id="btn-view-graduation-cert"
                            className="btn-action-primary" 
                            style={{ background: '#ecfdf5', color: '#065f46', fontWeight: 600, display: 'inline-flex', alignItems: 'center', gap: '0.5rem' }}
                            onClick={() => setActiveModal('certificate')}
                        >
                            📜 View Clearance Certificate
                        </button>
                    )}
                </div>
            </div>

            {/* 10-Vertical Academic Report Preview */}
            {showReportPreview && academicReportData && (
                <ExitRequirementReportPreview
                    reportData={academicReportData}
                    downloadUrl="/exit/student/download-pdf"
                    onRefresh={async () => {
                        const res = await api.get('/exit/student/report');
                        setAcademicReportData(res.data);
                    }}
                />
            )}

            {/* Quick Metrics */}
            <div className="exit-stats-grid">
                <div className="exit-stat-card">
                    <div className="exit-stat-icon">🎯</div>
                    <div className="exit-stat-info">
                        <h4>{summary.clearancePercentage || 0}%</h4>
                        <span>Clearance Completion</span>
                    </div>
                </div>
                <div className="exit-stat-card">
                    <div className="exit-stat-icon">✅</div>
                    <div className="exit-stat-info">
                        <h4>{summary.approvedCount || 0} / {summary.totalRequirements || clearances.length}</h4>
                        <span>Requirements Cleared</span>
                    </div>
                </div>
                <div className="exit-stat-card">
                    <div className="exit-stat-icon">⏳</div>
                    <div className="exit-stat-info">
                        <h4>{Math.max(0, (summary.totalRequirements || clearances.length) - (summary.approvedCount || 0))}</h4>
                        <span>Pending Clearances</span>
                    </div>
                </div>
            </div>

            {/* Progress Meter */}
            <div className="clearance-meter-box">
                <div className="meter-header">
                    <span>Overall Clearance Progress</span>
                    <span>{summary.clearancePercentage || 0}% Cleared</span>
                </div>
                <div className="meter-bar">
                    <div className="meter-fill" style={{ width: `${summary.clearancePercentage || 0}%` }}></div>
                </div>
            </div>

            {/* Categorized Requirements */}
            {categories.map((cat) => {
                const items = clearances.filter(c => c.requirement?.category === cat.key);
                if (items.length === 0) return null;
                const catApproved = items.filter(c => c.status === 'APPROVED' || c.status === 'WAIVED').length;

                return (
                    <div key={cat.key} className="exit-category-section">
                        <div className="category-header">
                            <div className="category-title">
                                <span>{cat.icon}</span>
                                <span>{cat.title}</span>
                            </div>
                            <span className="category-badge">
                                {catApproved} of {items.length} Cleared
                            </span>
                        </div>

                        <div className="category-items-list">
                            {items.map((item) => {
                                const isApproved = item.status === 'APPROVED' || item.status === 'WAIVED';
                                const isSurvey = item.requirement?.requirementCode === 'EXIT_SURVEY';

                                return (
                                    <div key={item.id} className="requirement-row">
                                        <div className="req-left">
                                            <div className="req-status-icon">
                                                {isApproved ? '🟢' : item.status === 'SUBMITTED' ? '🟡' : '⚪'}
                                            </div>
                                            <div className="req-details">
                                                <h4>
                                                    {item.requirement?.title}
                                                    {item.requirement?.isMandatory && <span className="mandatory-star">*</span>}
                                                </h4>
                                                <p>{item.requirement?.description}</p>
                                                
                                                {/* Verification remarks */}
                                                {item.remarks && (
                                                    <div style={{ marginTop: '0.4rem', fontSize: '0.82rem', color: isApproved ? '#065f46' : '#b45309', background: isApproved ? '#ecfdf5' : '#fffbeb', padding: '0.3rem 0.6rem', borderRadius: '4px', display: 'inline-block' }}>
                                                        💬 {item.remarks}
                                                    </div>
                                                )}

                                                <div className="req-meta">
                                                    <span>Verified by: <strong>{item.verifiedBy || item.requirement?.responsibleRole || 'Pending'}</strong></span>
                                                    {item.verifiedAt && <span>Date: <strong>{new Date(item.verifiedAt).toLocaleDateString()}</strong></span>}
                                                </div>
                                            </div>
                                        </div>

                                        <div className="req-right">
                                            {getStatusBadge(item.status)}

                                            {/* Action buttons */}
                                            {!isApproved && isSurvey && (
                                                <button className="btn-action-primary" onClick={() => setActiveModal('survey')}>
                                                    ✍️ Complete Survey
                                                </button>
                                            )}

                                            {!isApproved && !isSurvey && item.requirement?.responsibleRole !== 'SYSTEM_AUTO' && (
                                                <button className="btn-action-outline" onClick={() => openSubmitModal(item)}>
                                                    {item.status === 'SUBMITTED' ? 'Edit Details' : 'Submit Proof / Notes'}
                                                </button>
                                            )}
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    </div>
                );
            })}

            {/* Submission Modal */}
            {activeModal === 'submit' && selectedClearance && (
                <div className="modal-backdrop" onClick={() => setActiveModal(null)}>
                    <div className="exit-modal-card" onClick={(e) => e.stopPropagation()}>
                        <div className="modal-header">
                            <h3>Submit Exit Clearance Information</h3>
                            <button className="modal-close-btn" onClick={() => setActiveModal(null)}>&times;</button>
                        </div>
                        <form onSubmit={handleSubmitRequirement}>
                            <div className="modal-body">
                                <div>
                                    <label style={{ fontWeight: 600, display: 'block', marginBottom: '0.25rem', color: '#374151' }}>
                                        Requirement
                                    </label>
                                    <div style={{ padding: '0.6rem 0.8rem', background: '#f3f4f6', borderRadius: '6px', fontSize: '0.9rem' }}>
                                        {selectedClearance.requirement?.title}
                                    </div>
                                </div>

                                <div>
                                    <label style={{ fontWeight: 600, display: 'block', marginBottom: '0.25rem', color: '#374151' }}>
                                        Submission Remarks / No-Dues Proof Notes *
                                    </label>
                                    <textarea
                                        rows="4"
                                        required
                                        className="form-control"
                                        style={{ width: '100%', padding: '0.6rem', borderRadius: '6px', border: '1px solid #d1d5db' }}
                                        placeholder="E.g., Returned IoT sensor kit to Microprocessor Lab on 12/03. Cleared with Lab Assistant Mr. Sharma."
                                        value={submissionNotes}
                                        onChange={(e) => setSubmissionNotes(e.target.value)}
                                    />
                                </div>

                                <div>
                                    <label style={{ fontWeight: 600, display: 'block', marginBottom: '0.25rem', color: '#374151' }}>
                                        Document / Receipt Link (Optional)
                                    </label>
                                    <input
                                        type="text"
                                        className="form-control"
                                        style={{ width: '100%', padding: '0.6rem', borderRadius: '6px', border: '1px solid #d1d5db' }}
                                        placeholder="Drive link, receipt token, or document reference"
                                        value={attachmentUrl}
                                        onChange={(e) => setAttachmentUrl(e.target.value)}
                                    />
                                </div>
                            </div>
                            <div className="modal-footer">
                                <button type="button" className="btn-action-outline" onClick={() => setActiveModal(null)}>Cancel</button>
                                <button type="submit" className="btn-action-primary" disabled={submitting}>
                                    {submitting ? 'Submitting...' : 'Submit for Review'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}

            {/* Exit Survey Modal */}
            {activeModal === 'survey' && (
                <div className="modal-backdrop" onClick={() => setActiveModal(null)}>
                    <div className="exit-modal-card" onClick={(e) => e.stopPropagation()}>
                        <div className="modal-header">
                            <h3>University Academic Exit Survey</h3>
                            <button className="modal-close-btn" onClick={() => setActiveModal(null)}>&times;</button>
                        </div>
                        <form onSubmit={handleSubmitSurvey}>
                            <div className="modal-body">
                                <div>
                                    <label style={{ fontWeight: 600, display: 'block', marginBottom: '0.4rem', color: '#374151' }}>
                                        Overall Educational Experience Satisfaction *
                                    </label>
                                    <select
                                        className="form-control"
                                        style={{ width: '100%', padding: '0.6rem', borderRadius: '6px', border: '1px solid #d1d5db' }}
                                        value={surveyForm.overallSatisfaction}
                                        onChange={(e) => setSurveyForm({ ...surveyForm, overallSatisfaction: e.target.value })}
                                    >
                                        <option value="5/5 - Outstanding">5/5 - Outstanding (Exceeded Expectations)</option>
                                        <option value="4/5 - Very Good">4/5 - Very Good</option>
                                        <option value="3/5 - Satisfactory">3/5 - Satisfactory</option>
                                        <option value="2/5 - Fair">2/5 - Fair</option>
                                    </select>
                                </div>

                                <div>
                                    <label style={{ fontWeight: 600, display: 'block', marginBottom: '0.4rem', color: '#374151' }}>
                                        DYOD Flexible Curriculum & Track Relevance *
                                    </label>
                                    <select
                                        className="form-control"
                                        style={{ width: '100%', padding: '0.6rem', borderRadius: '6px', border: '1px solid #d1d5db' }}
                                        value={surveyForm.curriculumQuality}
                                        onChange={(e) => setSurveyForm({ ...surveyForm, curriculumQuality: e.target.value })}
                                    >
                                        <option value="5/5 - Extremely Relevant">5/5 - Extremely Relevant to Industry Needs</option>
                                        <option value="4/5 - Well Structured">4/5 - Well Structured & Practical</option>
                                        <option value="3/5 - Moderate">3/5 - Moderate</option>
                                    </select>
                                </div>

                                <div>
                                    <label style={{ fontWeight: 600, display: 'block', marginBottom: '0.4rem', color: '#374151' }}>
                                        Immediate Post-Graduation Career Plan *
                                    </label>
                                    <select
                                        className="form-control"
                                        style={{ width: '100%', padding: '0.6rem', borderRadius: '6px', border: '1px solid #d1d5db' }}
                                        value={surveyForm.careerPlan}
                                        onChange={(e) => setSurveyForm({ ...surveyForm, careerPlan: e.target.value })}
                                    >
                                        <option value="Campus Placement">Industry Employment (Campus Placement)</option>
                                        <option value="Off-Campus Placement">Industry Employment (Off-Campus / Direct)</option>
                                        <option value="Higher Studies (MS/M.Tech)">Higher Studies (MS / M.Tech in India or Abroad)</option>
                                        <option value="Entrepreneurship / Startup">Entrepreneurship / Startup Venture</option>
                                        <option value="Competitive Exams (GATE/Civil Services)">Competitive Exams (GATE / Civil Services)</option>
                                    </select>
                                </div>

                                <div>
                                    <label style={{ fontWeight: 600, display: 'block', marginBottom: '0.4rem', color: '#374151' }}>
                                        Suggestions & Feedback for Department *
                                    </label>
                                    <textarea
                                        rows="3"
                                        required
                                        className="form-control"
                                        style={{ width: '100%', padding: '0.6rem', borderRadius: '6px', border: '1px solid #d1d5db' }}
                                        value={surveyForm.feedback}
                                        onChange={(e) => setSurveyForm({ ...surveyForm, feedback: e.target.value })}
                                    />
                                </div>
                            </div>
                            <div className="modal-footer">
                                <button type="button" className="btn-action-outline" onClick={() => setActiveModal(null)}>Cancel</button>
                                <button type="submit" className="btn-action-primary" disabled={submitting}>
                                    {submitting ? 'Submitting...' : 'Submit Exit Survey'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}

            {/* Certificate Modal */}
            {activeModal === 'certificate' && (
                <div className="modal-backdrop" onClick={() => setActiveModal(null)}>
                    <div className="exit-modal-card" style={{ maxWidth: '640px' }} onClick={(e) => e.stopPropagation()}>
                        <div className="modal-header">
                            <h3>Graduation Clearance Certificate</h3>
                            <button className="modal-close-btn" onClick={() => setActiveModal(null)}>&times;</button>
                        </div>
                        <div className="modal-body" style={{ padding: '2rem' }}>
                            <div className="clearance-certificate-card">
                                <div className="certificate-seal">🎓</div>
                                <div className="certificate-title">KONERU LAKSHMAIAH UNIVERSITY</div>
                                <div className="certificate-subtitle">OFFICE OF ACADEMIC COMPLIANCE & EXAMINATIONS</div>
                                
                                <div style={{ fontSize: '1.2rem', fontWeight: 700, margin: '1rem 0 0.5rem 0', color: '#1f2937' }}>
                                    OFFICIAL GRADUATION EXIT CLEARANCE PASS
                                </div>

                                <p style={{ fontSize: '0.9rem', color: '#4b5563', lineHeight: 1.6, maxWidth: '480px', margin: '0 auto 1.5rem auto' }}>
                                    This certifies that student <strong>{data?.studentName}</strong> (Roll No: <strong>{data?.universityId}</strong>) 
                                    has successfully satisfied all academic credit requirements under the 
                                    Design Your Own Degree (DYOD) curriculum, completed all departmental capstone obligations, 
                                    and secured full institutional no-dues clearance.
                                </p>

                                <div className="certificate-token-box">
                                    VERIFICATION CODE: {summary.certificateToken || 'KLU-GRAD-VERIFIED-2026'}
                                </div>

                                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', textAlign: 'left', fontSize: '0.85rem', color: '#374151', background: '#f9fafb', padding: '1rem', borderRadius: '8px' }}>
                                    <div><strong>Department:</strong> {data?.department}</div>
                                    <div><strong>Status:</strong> CLEARED FOR CONFERRAL</div>
                                    <div><strong>Cleared On:</strong> {summary.finalApprovedAt ? new Date(summary.finalApprovedAt).toLocaleDateString() : new Date().toLocaleDateString()}</div>
                                    <div><strong>Endorsed By:</strong> {summary.finalApprovedBy || 'Registrar / Dean Academics'}</div>
                                </div>
                            </div>
                        </div>
                        <div className="modal-footer">
                            <button className="btn-action-outline" onClick={() => window.print()}>🖨️ Print Certificate</button>
                            <button className="btn-action-primary" onClick={() => setActiveModal(null)}>Close</button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
