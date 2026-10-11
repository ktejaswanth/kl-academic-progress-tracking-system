import React, { useState } from 'react';
import api from '../api';
import './exit-report-preview.css';

export default function ExitRequirementReportPreview({ reportData, downloadUrl, onRefresh }) {
    const [downloading, setDownloading] = useState(false);
    const [printing, setPrinting] = useState(false);

    if (!reportData) return null;

    const { student, summary, categories = [], endorsement } = reportData;

    const handleDownloadPdf = async () => {
        if (!downloadUrl) return;
        try {
            setDownloading(true);
            const response = await api.get(downloadUrl, { responseType: 'blob' });
            const blob = new Blob([response.data], { type: 'application/pdf' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.setAttribute('download', `Exit_Requirement_${student?.rollNumber || 'Report'}.pdf`);
            document.body.appendChild(a);
            a.click();
            a.remove();
            window.URL.revokeObjectURL(url);
        } catch (err) {
            console.error('Failed to download PDF:', err);
            alert('Failed to download Exit Requirement PDF: ' + (err.response?.data?.message || err.message));
        } finally {
            setDownloading(false);
        }
    };

    const handlePrint = async () => {
        if (!downloadUrl) {
            window.print();
            return;
        }
        try {
            setPrinting(true);
            const response = await api.get(downloadUrl, { responseType: 'blob' });
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
            console.error('Failed to print PDF:', err);
            // Fallback to browser window print
            window.print();
        } finally {
            setPrinting(false);
        }
    };

    const progressPct = summary?.totalRequiredCredits > 0
        ? Math.min(100, Math.round((summary.totalObtainedCredits / summary.totalRequiredCredits) * 100))
        : 100;

    return (
        <div className="exit-report-wrapper">
            {/* Action Bar */}
            <div className="report-actions-bar">
                <div className="report-actions-title">
                    <span className="report-badge-icon">🎓</span>
                    <div>
                        <h3>Official Exit Requirement Audit Report</h3>
                        <span>10-Vertical DYOD Degree Audit • Verified Academic Record</span>
                    </div>
                </div>
                <div className="report-buttons-group">
                    {onRefresh && (
                        <button className="btn-report-print" onClick={onRefresh}>
                            🔄 Refresh
                        </button>
                    )}
                    <button 
                        className="btn-report-print" 
                        onClick={handlePrint}
                        disabled={printing}
                    >
                        🖨️ {printing ? 'Preparing Print...' : 'Print Report'}
                    </button>
                    <button 
                        className="btn-report-download" 
                        onClick={handleDownloadPdf}
                        disabled={downloading}
                    >
                        📥 {downloading ? 'Generating PDF...' : 'Download Official PDF'}
                    </button>
                </div>
            </div>

            {/* Document Content */}
            <div className="report-document">
                {/* University Header */}
                <div className="doc-header">
                    <div className="university-emblem">KL</div>
                    <h1>Koneru Lakshmaiah Education Foundation</h1>
                    <h2>(Deemed to be University estd. u/s. 3 of the UGC Act, 1956)</h2>
                    <h2>Green Fields, Vaddeswaram, Guntur District, Andhra Pradesh - 522302</h2>
                    <div className="doc-title-pill">
                        Student Exit Requirement Verification Report
                    </div>
                </div>

                {/* Student Profile Grid */}
                <div className="student-profile-section">
                    <div className="section-label-bar">
                        <span>👤 Student Academic Profile</span>
                    </div>
                    <div className="profile-info-grid">
                        <div className="info-item">
                            <span className="info-label">Student Name</span>
                            <span className="info-val highlight">{student?.studentName || '-'}</span>
                        </div>
                        <div className="info-item">
                            <span className="info-label">University ID / Roll No</span>
                            <span className="info-val highlight">{student?.rollNumber || '-'}</span>
                        </div>
                        <div className="info-item">
                            <span className="info-label">Programme</span>
                            <span className="info-val">{student?.programme || 'B. TECH'}</span>
                        </div>
                        <div className="info-item">
                            <span className="info-label">Branch & Department</span>
                            <span className="info-val">{student?.branch || student?.department || '-'}</span>
                        </div>
                        <div className="info-item">
                            <span className="info-label">Specialization Track</span>
                            <span className="info-val">{student?.specialization || 'General Track'}</span>
                        </div>
                        <div className="info-item">
                            <span className="info-label">Faculty Counsellor / Advisor</span>
                            <span className="info-val">{student?.counsellor || 'Department Faculty Mentor'}</span>
                        </div>
                        <div className="info-item">
                            <span className="info-label">Date of Admission</span>
                            <span className="info-val">{student?.dateOfAdmission || 'July 2023'}</span>
                        </div>
                        <div className="info-item">
                            <span className="info-label">Expected Graduation</span>
                            <span className="info-val">{student?.expectedGraduation || 'May 2027'}</span>
                        </div>
                    </div>
                </div>

                {/* Overall Status Banner */}
                <div className="overall-status-card">
                    <div className="status-left">
                        <div className={`status-badge-tag ${summary?.isEligible ? 'eligible' : 'in-progress'}`}>
                            {summary?.isEligible ? '✅ Eligible for Degree Conferral' : '⏳ In Progress towards Graduation'}
                        </div>
                        <div className="credit-progress-bar-container">
                            <div className="progress-track">
                                <div className="progress-fill" style={{ width: `${progressPct}%` }}></div>
                            </div>
                            <div style={{ fontSize: '0.75rem', marginTop: '0.3rem', color: '#94a3b8' }}>
                                Overall Completion: {progressPct}% ({summary?.totalObtainedCredits} / {summary?.totalRequiredCredits} Credits)
                            </div>
                        </div>
                    </div>
                    <div className="credit-counters-row">
                        <div className="counter-box">
                            <div className="counter-num req">{summary?.totalRequiredCredits || 0}</div>
                            <div className="counter-title">Required Credits</div>
                        </div>
                        <div className="counter-box">
                            <div className="counter-num earned">{summary?.totalObtainedCredits || 0}</div>
                            <div className="counter-title">Earned Credits</div>
                        </div>
                        <div className="counter-box">
                            <div className="counter-num rem">{summary?.totalRemainingCredits || 0}</div>
                            <div className="counter-title">Remaining Credits</div>
                        </div>
                    </div>
                </div>

                {/* Ten Categories Summary Matrix */}
                <div className="matrix-section">
                    <div className="section-label-bar">
                        <span>📊 Curriculum Verticals Summary (10 Categories)</span>
                    </div>
                    <table className="matrix-table">
                        <thead>
                            <tr>
                                <th>Category Code</th>
                                <th>Curriculum Classification</th>
                                <th style={{ textAlign: 'center' }}>Required</th>
                                <th style={{ textAlign: 'center' }}>Obtained</th>
                                <th style={{ textAlign: 'center' }}>Remaining</th>
                                <th style={{ textAlign: 'center' }}>Audit Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            {categories.map((cat) => {
                                const statusClass = cat.status === 'Complete' 
                                    ? 'complete' 
                                    : (cat.status === 'In Progress' ? 'in-progress' : 'pending');
                                return (
                                    <tr key={cat.categoryCode}>
                                        <td>
                                            <strong style={{ color: '#8c1d40' }}>{cat.categoryCode}</strong>
                                        </td>
                                        <td>{cat.description}</td>
                                        <td style={{ textAlign: 'center', fontWeight: 600 }}>{cat.requiredCredits}</td>
                                        <td style={{ textAlign: 'center', fontWeight: 700, color: '#047857' }}>{cat.obtainedCredits}</td>
                                        <td style={{ textAlign: 'center', fontWeight: 600, color: cat.remainingCredits > 0 ? '#b91c1c' : '#6b7280' }}>
                                            {cat.remainingCredits}
                                        </td>
                                        <td style={{ textAlign: 'center' }}>
                                            <span className={`status-pill-mini ${statusClass}`}>
                                                {cat.status}
                                            </span>
                                        </td>
                                    </tr>
                                );
                            })}
                        </tbody>
                    </table>
                </div>

                {/* Detailed Course Breakdown Across all 10 Categories */}
                <div className="categories-breakdown-section">
                    <div className="section-label-bar" style={{ marginBottom: '1.25rem' }}>
                        <span>📚 Detailed Course Records & Attempts by Category</span>
                    </div>

                    {categories.map((cat) => {
                        const statusClass = cat.status === 'Complete' 
                            ? 'complete' 
                            : (cat.status === 'In Progress' ? 'in-progress' : 'pending');

                        return (
                            <div className="category-card" key={cat.categoryCode}>
                                <div className="category-card-header">
                                    <div className="cat-header-left">
                                        <span className="cat-code-badge">{cat.categoryCode}</span>
                                        <span className="cat-title-text">{cat.description}</span>
                                    </div>
                                    <div className="cat-header-chips">
                                        <span className="credit-chip">Required: {cat.requiredCredits} Cr</span>
                                        <span className="credit-chip obtained">Earned: {cat.obtainedCredits} Cr</span>
                                        <span className={`status-pill-mini ${statusClass}`}>{cat.status}</span>
                                    </div>
                                </div>

                                {cat.courses && cat.courses.length > 0 ? (
                                    <table className="category-courses-table">
                                        <thead>
                                            <tr>
                                                <th style={{ width: '50px' }}>S.No</th>
                                                <th style={{ width: '130px' }}>Course Code</th>
                                                <th>Course Title</th>
                                                <th style={{ width: '70px', textAlign: 'center' }}>Credits</th>
                                                <th style={{ width: '90px', textAlign: 'center' }}>Attempt 1</th>
                                                <th style={{ width: '90px', textAlign: 'center' }}>Attempt 2</th>
                                                <th style={{ width: '90px', textAlign: 'center' }}>Attempt 3</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {cat.courses.map((c, idx) => (
                                                <tr key={c.courseCode || idx}>
                                                    <td>{c.sNo || idx + 1}</td>
                                                    <td className="course-code-cell">{c.courseCode}</td>
                                                    <td>{c.courseName}</td>
                                                    <td style={{ textAlign: 'center', fontWeight: 600 }}>{c.credits}</td>
                                                    <td style={{ textAlign: 'center' }}>
                                                        <span className="grade-pill grade-pass">{c.attempt1 || 'Pass'}</span>
                                                    </td>
                                                    <td style={{ textAlign: 'center', color: '#94a3b8' }}>{c.attempt2 || '-'}</td>
                                                    <td style={{ textAlign: 'center', color: '#94a3b8' }}>{c.attempt3 || '-'}</td>
                                                </tr>
                                            ))}
                                        </tbody>
                                    </table>
                                ) : (
                                    <div className="empty-courses-state">
                                        No courses recorded for <strong>{cat.categoryCode}</strong>. Remaining required: {cat.remainingCredits} credits.
                                    </div>
                                )}
                            </div>
                        );
                    })}
                </div>

                {/* Institutional Endorsement Section */}
                <div className="endorsement-section">
                    <div className="endorsement-box">
                        <div>
                            <div className="endorsement-token-title">Official Verification Security Token</div>
                            <div className="endorsement-token-value">
                                {endorsement?.token || `KLU-GRAD-${student?.rollNumber || 'VERIFIED'}`}
                            </div>
                        </div>
                        <div style={{ textAlign: 'right' }}>
                            <div className="endorsement-token-title">Verification Date</div>
                            <div style={{ fontWeight: 600, color: '#334155' }}>
                                {endorsement?.date || new Date().toLocaleDateString('en-GB')}
                            </div>
                        </div>
                    </div>

                    <div className="signatures-grid">
                        <div className="signature-block">
                            <div className="signature-line"></div>
                            <span className="signatory-title">Dean Academics</span>
                            <span className="signatory-sub">Curriculum Compliance</span>
                        </div>
                        <div className="signature-block">
                            <div className="signature-line"></div>
                            <span className="signatory-title">Head of Department</span>
                            <span className="signatory-sub">{student?.department || 'Department Office'}</span>
                        </div>
                        <div className="signature-block">
                            <div className="signature-line"></div>
                            <span className="signatory-title">Controller of Examinations</span>
                            <span className="signatory-sub">Examination & Records Cell</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
