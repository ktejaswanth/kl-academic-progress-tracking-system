import React, { useState } from 'react';
import api from '../../api';
import { useStudentData } from './StudentDataContext';
import './student.css';

export default function ReportsView() {
    const { dashboardData } = useStudentData();
    const [downloading, setDownloading] = useState('');
    const [message, setMessage] = useState('');

    const student = dashboardData?.student || {};
    const rollNumber = student.studentId || student.username || 'student';

    const triggerDownload = (blob, filename) => {
        const url = window.URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = url;
        link.setAttribute('download', filename);
        document.body.appendChild(link);
        link.click();
        link.parentNode.removeChild(link);
    };

    // Download Official 6-Page Student Exit Requirement PDF
    const handleDownloadExitPdf = async () => {
        setDownloading('exit-pdf');
        setMessage('');
        try {
            const res = await api.get('/exit/student/download-pdf', { responseType: 'blob' });
            triggerDownload(new Blob([res.data], { type: 'application/pdf' }), `Student_exit_requirement_${rollNumber}.pdf`);
            setMessage('6-Page Exit Requirement PDF downloaded successfully!');
        } catch (err) {
            console.error('PDF error', err);
            setMessage('Failed to download Exit PDF. Please try again or consult admin.');
        } finally {
            setDownloading('');
        }
    };

    // Download Academic Progress Report (Excel)
    const handleDownloadExcel = async () => {
        setDownloading('progress-excel');
        setMessage('');
        try {
            const res = await api.get('/reports/student/me/excel', { responseType: 'blob' });
            triggerDownload(new Blob([res.data], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }), `Academic_Progress_Report_${rollNumber}.xlsx`);
            setMessage('Academic Progress Report (Excel) downloaded successfully!');
        } catch (err) {
            console.error('Excel error', err);
            setMessage('Failed to download Excel report.');
        } finally {
            setDownloading('');
        }
    };

    // Download Course History Text/CSV
    const handleDownloadCourseHistory = async () => {
        setDownloading('course-history');
        setMessage('');
        try {
            const res = await api.get('/student/courses');
            const data = res.data || [];
            const header = 'Course Code,Course Name,Credits,Category,Semester,Grade,Status\n';
            const rows = data.map(c => `"${c.courseCode}","${c.courseName}",${c.credits},"${c.category || ''}","${c.semester || ''}","${c.grade || ''}","${c.status || ''}"`).join('\n');
            const blob = new Blob([header + rows], { type: 'text/csv;charset=utf-8;' });
            triggerDownload(blob, `Course_History_${rollNumber}.csv`);
            setMessage('Course History Report downloaded successfully!');
        } catch (err) {
            console.error('Course history error', err);
            setMessage('Failed to download Course History.');
        } finally {
            setDownloading('');
        }
    };

    // Download Graduation Eligibility Audit Report (Official PDF)
    const handleDownloadEligibilityReport = async () => {
        setDownloading('eligibility-summary');
        setMessage('');
        try {
            const res = await api.get('/reports/student/me/eligibility-pdf', { responseType: 'blob' });
            triggerDownload(new Blob([res.data], { type: 'application/pdf' }), `Graduation_Eligibility_Audit_${rollNumber}.pdf`);
            setMessage('Graduation Eligibility Audit Report downloaded successfully!');
        } catch (err) {
            console.error('Eligibility report error', err);
            setMessage('Failed to download Eligibility Audit Report.');
        } finally {
            setDownloading('');
        }
    };

    const reports = [
        {
            id: 'exit-pdf',
            title: 'Official Student Exit Requirement Report (6-Page PDF)',
            desc: 'Complete authoritative 6-page PDF documenting HAS, BSC, ESC, FCC, PCC, PEC, SDC, PRI, OEC, SIL categories and institutional degree clearance.',
            icon: '📄',
            badge: 'OFFICIAL 6-PAGE TEMPLATE',
            action: handleDownloadExitPdf,
            btnText: 'Download Official PDF'
        },
        {
            id: 'progress-excel',
            title: 'Academic Progress Report (Excel)',
            desc: 'Comprehensive spreadsheet breakdown of all degree buckets, category completions, and semester progress audits.',
            icon: '📊',
            badge: 'EXCEL SPREADSHEET',
            action: handleDownloadExcel,
            btnText: 'Download Excel Report'
        },
        {
            id: 'course-history',
            title: 'Complete Course History Transcript (CSV)',
            desc: 'Tabular export of every completed and registered course, attempt history, obtained credits, and semester results.',
            icon: '📜',
            badge: 'DATA EXPORT',
            action: handleDownloadCourseHistory,
            btnText: 'Export Course History'
        },
        {
            id: 'eligibility-summary',
            title: 'Graduation Eligibility Audit Report',
            desc: 'Verification report certifying degree clearance eligibility, cumulative GPA standing, and curriculum bucket compliance.',
            icon: '🎓',
            badge: 'INSTITUTIONAL AUDIT',
            action: handleDownloadEligibilityReport,
            btnText: 'Generate Eligibility Report'
        }
    ];

    return (
        <div className="student-reports animate-fade" style={{ maxWidth: '1400px', margin: '0 auto', paddingBottom: '3rem' }}>
            <div style={{ marginBottom: '2rem' }}>
                <h1 style={{ fontSize: '2rem', color: '#1E293B', margin: '0 0 6px', fontWeight: 800 }}>Academic Reports & Documents</h1>
                <p style={{ color: '#64748B', margin: 0, fontSize: '0.95rem' }}>
                    Generate and download authenticated institutional records, transcripts, and official exit clearance certificates
                </p>
            </div>

            {message && (
                <div style={{
                    padding: '14px 20px',
                    borderRadius: '12px',
                    background: message.includes('Failed') ? '#FEE2E2' : '#DCFCE7',
                    color: message.includes('Failed') ? '#991B1B' : '#166534',
                    border: message.includes('Failed') ? '1px solid #FECACA' : '1px solid #BBF7D0',
                    marginBottom: '2rem',
                    fontWeight: 600,
                    display: 'flex',
                    alignItems: 'center',
                    gap: '10px'
                }}>
                    <span>{message.includes('Failed') ? '⚠️' : '✅'}</span>
                    <span>{message}</span>
                </div>
            )}

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(320px, 1fr))', gap: '1.5rem' }}>
                {reports.map((r) => (
                    <div key={r.id} className="glass-card" style={{ padding: '2rem', background: 'white', display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
                        <div>
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '12px' }}>
                                <span style={{ fontSize: '2.4rem' }}>{r.icon}</span>
                                <span style={{ background: '#FFF5F5', color: '#8B0000', padding: '4px 10px', borderRadius: '12px', fontSize: '0.75rem', fontWeight: 800 }}>
                                    {r.badge}
                                </span>
                            </div>

                            <h3 style={{ margin: '0 0 8px', color: '#1E293B', fontSize: '1.25rem' }}>{r.title}</h3>
                            <p style={{ color: '#64748B', fontSize: '0.9rem', lineHeight: '1.5', margin: '0 0 1.5rem' }}>
                                {r.desc}
                            </p>
                        </div>

                        <button
                            onClick={r.action}
                            disabled={downloading === r.id}
                            style={{
                                width: '100%',
                                padding: '12px',
                                background: '#8B0000',
                                color: 'white',
                                border: 'none',
                                borderRadius: '10px',
                                cursor: 'pointer',
                                fontWeight: 700,
                                fontSize: '0.92rem',
                                display: 'flex',
                                justifyContent: 'center',
                                alignItems: 'center',
                                gap: '8px',
                                boxShadow: '0 4px 12px rgba(139, 0, 0, 0.2)'
                            }}
                        >
                            {downloading === r.id ? 'Generating...' : `📥 ${r.btnText}`}
                        </button>
                    </div>
                ))}
            </div>
        </div>
    );
}
