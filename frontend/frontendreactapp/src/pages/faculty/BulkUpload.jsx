import React, { useState } from 'react';
import api from '../../api';
import * as XLSX from 'xlsx';
import './faculty.css';

export default function BulkUpload() {
    const [file, setFile] = useState(null);
    const [uploading, setUploading] = useState(false);
    const [credentials, setCredentials] = useState([]);
    const [error, setError] = useState('');
    const [message, setMessage] = useState('');


    const handleFileChange = (e) => {
        const selectedFile = e.target.files[0];
        setFile(selectedFile);
        setError('');
        setCredentials([]);
        setMessage('');
    };

    const handleUpload = async (e) => {
        e.preventDefault();
        if (!file) {
            setError('Please select an Excel file first.');
            return;
        }

        setUploading(true);
        setError('');
        setCredentials([]);

        const formData = new FormData();
        formData.append('file', file);

        try {
            const response = await api.post('/faculty/upload-students', formData, {
                headers: { 'Content-Type': 'multipart/form-data' }
            });
            setCredentials(response.data);
            setMessage(`Successfully processed ${response.data.length} students!`);
            setFile(null);
            if (document.getElementById('excel-upload')) {
                document.getElementById('excel-upload').value = '';
            }
        } catch (err) {
            setError(err.response?.data || 'Upload failed. Please ensure the Excel follows the 7-column template.');
        } finally {
            setUploading(false);
        }
    };

    const downloadExcel = () => {
        const exportData = credentials.map(c => ({
            "Student Name": c.fullName,
            "ID Number": c.id,
            "Email ID": c.email,
            "Department": c.department,
            "Sub-Department": c.subDepartment,
            "Specialization Type": c.specializationType,
            "Specialization Name": c.specializationName,
            "Password": c.password
        }));
        const worksheet = XLSX.utils.json_to_sheet(exportData);
        const workbook = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(workbook, worksheet, "Credentials");
        XLSX.writeFile(workbook, `Student_Credentials_${new Date().getTime()}.xlsx`);
    };

    const downloadDemoSheet = () => {
        const demoData = [
            {
                "NAME": "John Doe",
                "ID NUMBER": "2100030001",
                "MAIL ID": "johndoe@kluniversity.in",
                "DEPARTMENT": "CSE",
                "SUB DEPT": "Software Engineering",
                "SPEC. TYPE": "Specialization",
                "SPEC. NAME": "Cloud Computing"
            }
        ];
        const worksheet = XLSX.utils.json_to_sheet(demoData);
        const workbook = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(workbook, worksheet, "Template");
        XLSX.writeFile(workbook, "Bulk_Student_Registration_Template.xlsx");
    };

    return (
        <div className="bulk-upload-container">
            <header className="page-header">
                <h1>Bulk Student Identity Management</h1>
                <p>Register multiple students at once and generate secure auto-passwords.</p>
            </header>

            <div className="upload-card">
                <div className="format-guide">
                    <div className="guide-actions" style={{ marginBottom: '1.5rem', display: 'flex', gap: '15px', alignItems: 'center', justifyContent: 'space-between' }}>
                        <h3 style={{ margin: 0 }}>
                            <span style={{ fontSize: '1.5rem' }}>📋</span>
                            Excel Template Guide
                        </h3>
                        <button
                            type="button"
                            onClick={downloadDemoSheet}
                            className="demo-download-btn"
                        >
                            📥 Download Demo Excel Template
                        </button>
                    </div>
                    <p>Ensure your Excel file has these exact columns in order:</p>
                    <div className="column-pills">
                        <span className="pill">NAME</span>
                        <span className="pill">ID NUMBER</span>
                        <span className="pill">MAIL ID</span>
                        <span className="pill">DEPARTMENT</span>
                        <span className="pill">SUB DEPT</span>
                        <span className="pill">SPEC. TYPE</span>
                        <span className="pill">SPEC. NAME</span>
                    </div>
                </div>

                <form onSubmit={handleUpload} className="upload-form">
                    <div className={`file-drop-area ${file ? 'has-file' : ''}`}>
                        <input
                            type="file"
                            id="excel-upload"
                            accept=".xlsx, .xls"
                            onChange={handleFileChange}
                        />
                        <div className="drop-content">
                            <span className="icon">{file ? '📄' : '📁'}</span>
                            <span className="text">
                                {file ? file.name : "Drag & drop or click to select Excel file"}
                            </span>
                            {!file && <span className="sub-text">Supported formats: .xlsx, .xls</span>}
                        </div>
                    </div>

                    <button type="submit" className="primary-btn" disabled={uploading || !file}>
                        {uploading ? (
                            <><span className="spinner"></span> Processing...</>
                        ) : (
                            <>🚀 Upload & Generate Credentials</>
                        )}
                    </button>
                </form>

                {error && <div className="alert error"><span>⚠️</span> {error}</div>}
                {message && <div className="alert success"><span>✅</span> {message}</div>}
            </div>

            {credentials.length > 0 && (
                <div className="results-card">
                    <div className="results-header">
                        <div className="results-info">
                            <h3>Generated Student Credentials</h3>
                            <p>Share these credentials with the respective students.</p>
                        </div>
                        <button onClick={downloadExcel} className="download-btn-premium">
                            📥 Download Credentials (Excel)
                        </button>
                    </div>
                    <div className="table-wrapper">
                        <table className="modern-table">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>ID Number</th>
                                    <th>Email</th>
                                    <th>Dept / Sub-Dept</th>
                                    <th>Specialization</th>
                                    <th>Password</th>
                                </tr>
                            </thead>
                            <tbody>
                                {credentials.map((student, index) => (
                                    <tr key={index}>
                                        <td><strong>{student.fullName}</strong></td>
                                        <td><code>{student.id}</code></td>
                                        <td>{student.email}</td>
                                        <td>
                                            <div className="dept-cell">
                                                <span className="main-dept">{student.department || 'REGULAR'}</span>
                                                <span className="sub-dept">{student.subDepartment || 'N/A'}</span>
                                            </div>
                                        </td>
                                        <td>
                                            <div className="spec-cell">
                                                <span className="spec-type">{student.specializationType || 'NONE'}</span>
                                                <span className="spec-name">{student.specializationName || 'N/A'}</span>
                                            </div>
                                        </td>
                                        <td>
                                            <div className="password-cell">
                                                <code className="pass-text">{student.password}</code>
                                                <button
                                                    className="copy-btn"
                                                    onClick={() => navigator.clipboard.writeText(student.password)}
                                                    title="Copy Password"
                                                >
                                                    📋
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
            )}

            <style>{`
                .bulk-upload-container {
                    animation: fadeIn 0.5s ease-out;
                    max-width: 1000px;
                    margin: 0 auto;
                    padding-bottom: 4rem;
                }
                @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }

                .upload-card {
                    background: white;
                    border-radius: 24px;
                    padding: 2.5rem;
                    box-shadow: 0 10px 30px rgba(0,0,0,0.04);
                    border: 1px solid #EDF2F7;
                    margin-bottom: 2.5rem;
                }

                .format-guide {
                    background: #F8FAFC;
                    padding: 1.5rem 2rem;
                    border-radius: 20px;
                    margin-bottom: 2rem;
                    border: 1px solid #E2E8F0;
                }
                .format-guide h3 { 
                    color: #0F172A; 
                    margin-bottom: 1rem; 
                    font-size: 1.2rem;
                    font-weight: 700;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }
                .format-guide p { color: #64748B; margin-bottom: 1.25rem; font-size: 0.95rem; }

                .column-pills {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 8px;
                }
                .pill {
                    background: white;
                    color: #E11D48;
                    padding: 8px 12px;
                    border-radius: 10px;
                    font-size: 0.7rem;
                    font-weight: 800;
                    border: 1px solid #E2E8F0;
                    text-transform: uppercase;
                    letter-spacing: 0.05em;
                }

                .demo-download-btn {
                    background: #FFF1F2;
                    color: #E11D48;
                    border: 1px solid #FECACA;
                    padding: 10px 18px;
                    border-radius: 10px;
                    font-weight: 700;
                    font-size: 0.85rem;
                    cursor: pointer;
                    transition: all 0.2s;
                    display: flex;
                    align-items: center;
                    gap: 8px;
                }
                .demo-download-btn:hover {
                    background: #E11D48;
                    color: white;
                    border-color: #E11D48;
                    transform: translateY(-2px);
                }

                .file-drop-area {
                    position: relative;
                    border: 2px dashed #CBD5E1;
                    border-radius: 20px;
                    padding: 3rem 2rem;
                    text-align: center;
                    transition: all 0.3s ease;
                    background: #FBFBFF;
                    margin-bottom: 1.5rem;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    justify-content: center;
                }
                .file-drop-area:hover {
                    border-color: #E11D48;
                    background: #FFF1F2;
                }
                .file-drop-area.has-file {
                    border-color: #10B981;
                    background: #ECFDF5;
                }
                .file-drop-area input {
                    position: absolute;
                    width: 100%;
                    height: 100%;
                    top: 0; left: 0;
                    opacity: 0;
                    cursor: pointer;
                    z-index: 10;
                }
                .file-drop-area .icon { font-size: 3.5rem; display: block; margin-bottom: 1rem; transition: transform 0.3s; }
                .file-drop-area:hover .icon { transform: scale(1.1); }
                .file-drop-area .text { color: #1E293B; font-weight: 600; font-size: 1.1rem; display: block; }
                .file-drop-area .sub-text { color: #94A3B8; font-size: 0.85rem; margin-top: 0.5rem; }

                .primary-btn {
                    width: 100%;
                    padding: 1.1rem;
                    border-radius: 14px;
                    background: linear-gradient(135deg, #E11D48 0%, #BE123C 100%);
                    color: white;
                    border: none;
                    font-weight: 700;
                    font-size: 1.05rem;
                    cursor: pointer;
                    transition: all 0.3s;
                    box-shadow: 0 8px 16px rgba(225, 29, 72, 0.2);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 10px;
                }
                .primary-btn:hover:not(:disabled) {
                    transform: translateY(-2px);
                    box-shadow: 0 12px 24px rgba(225, 29, 72, 0.3);
                }
                .primary-btn:disabled { opacity: 0.6; cursor: not-allowed; }

                .results-card {
                    background: white;
                    border-radius: 24px;
                    padding: 2rem;
                    box-shadow: 0 10px 40px rgba(0,0,0,0.04);
                    border: 1px solid #EDF2F7;
                    margin-top: 2rem;
                }
                .results-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 2rem;
                    padding-bottom: 1.5rem;
                    border-bottom: 1px solid #F1F5F9;
                    gap: 20px;
                    flex-wrap: wrap;
                }
                .results-info h3 { font-size: 1.3rem; color: #0F172A; margin-bottom: 0.4rem; }
                .results-info p { color: #64748B; font-size: 0.95rem; }

                .download-btn-premium {
                    background: #1E293B;
                    color: white;
                    border: none;
                    padding: 12px 24px;
                    border-radius: 12px;
                    font-weight: 700;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    transition: all 0.3s;
                    white-space: nowrap;
                }
                .download-btn-premium:hover { background: #0F172A; transform: translateY(-2px); }

                .password-cell {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    background: #F8FAFC;
                    padding: 6px 10px;
                    border-radius: 8px;
                    border: 1px solid #E2E8F0;
                    width: fit-content;
                }
                .password-cell code { font-family: 'JetBrains Mono', monospace; font-weight: 600; color: #1E293B; }
                .copy-btn {
                    background: white;
                    border: 1px solid #E2E8F0;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 0.9rem;
                    padding: 2px 6px;
                    transition: all 0.2s;
                }
                .copy-btn:hover { background: #F1F5F9; border-color: #CBD5E1; }

                .alert {
                    padding: 1rem 1.5rem;
                    border-radius: 14px;
                    margin-top: 1.5rem;
                    font-weight: 600;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }
                .alert.success { background: #ECFDF5; color: #065F46; border: 1px solid #A7F3D0; }
                .alert.error { background: #FEF2F2; color: #991B1B; border: 1px solid #FECACA; }

                .spinner {
                    width: 18px;
                    height: 18px;
                    border: 2px solid rgba(255,255,255,0.3);
                    border-radius: 50%;
                    border-top-color: white;
                    animation: spin 0.8s linear infinite;
                }
                @keyframes spin { to { transform: rotate(360deg); } }

                /* Modern Table Styling */
                .modern-table { width: 100%; border-collapse: collapse; text-align: left; }
                .modern-table th { padding: 1rem; color: #64748B; font-weight: 700; font-size: 0.8rem; text-transform: uppercase; border-bottom: 1px solid #E2E8F0; }
                .modern-table td { padding: 1.2rem 1rem; border-bottom: 1px solid #F1F5F9; vertical-align: middle; }
                .modern-table tr:hover { background: #FBFBFF; }
            `}</style>
        </div>
    );
}
