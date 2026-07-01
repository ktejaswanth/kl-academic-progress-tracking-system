import React, { useState } from 'react';
import api from '../../api';
import './faculty.css';

export default function UploadCourses() {
    const [file, setFile] = useState(null);
    const [uploading, setUploading] = useState(false);
    const [results, setResults] = useState(null);
    const [error, setError] = useState('');
    const [message, setMessage] = useState('');

    const handleFileChange = (e) => {
        const selectedFile = e.target.files[0];
        setFile(selectedFile);
        setError('');
        setResults(null);
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
        setResults(null);

        const formData = new FormData();
        formData.append('file', file);

        try {
            const response = await api.post('/dyod/courses/bulk-upload', formData, {
                headers: { 'Content-Type': 'multipart/form-data' }
            });
            setResults(response.data);
            setMessage(`Bulk upload processing completed successfully!`);
            setFile(null);
            if (document.getElementById('courses-excel-upload')) {
                document.getElementById('courses-excel-upload').value = '';
            }
        } catch (err) {
            setError(err.response?.data?.error || 'Upload failed. Please ensure your Excel matches the template columns.');
        } finally {
            setUploading(false);
        }
    };

    const downloadTemplate = async () => {
        try {
            const response = await api.get('/dyod/courses/template', { responseType: 'blob' });
            const url = window.URL.createObjectURL(new Blob([response.data]));
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', 'completed_courses_template.xlsx');
            document.body.appendChild(link);
            link.click();
            link.parentNode.removeChild(link);
        } catch (err) {
            setError('Failed to download Excel template.');
        }
    };

    return (
        <div className="bulk-upload-container animate-fade">
            <header className="page-header" style={{ marginBottom: '2.5rem' }}>
                <h1 style={{ fontSize: '2.2rem', color: '#2D3436' }}>Upload Student Course Records</h1>
                <p style={{ color: '#636E72' }}>Bulk upload completed academic courses for students via Excel template.</p>
            </header>

            <div className="upload-card">
                <div className="format-guide">
                    <div className="guide-actions" style={{ marginBottom: '1.5rem', display: 'flex', gap: '15px', alignItems: 'center', justifyContent: 'space-between' }}>
                        <h3 style={{ margin: 0 }}>
                            <span style={{ fontSize: '1.5rem' }}>📋</span>
                            Template Guideline
                        </h3>
                        <button
                            type="button"
                            onClick={downloadTemplate}
                            className="demo-download-btn"
                        >
                            📥 Download Course Upload Template
                        </button>
                    </div>
                    <p>Excel template columns MUST follow this schema:</p>
                    <div className="column-pills">
                        <span className="pill">University ID</span>
                        <span className="pill">Student Name</span>
                        <span className="pill">Course Code</span>
                        <span className="pill">LTPS</span>
                        <span className="pill">Course Name</span>
                        <span className="pill">Bucket Group</span>
                        <span className="pill">Course Type</span>
                        <span className="pill">Academic Year</span>
                        <span className="pill">Semester</span>
                        <span className="pill">Study Year</span>
                        <span className="pill">Section</span>
                        <span className="pill">Register Date</span>
                        <span className="pill">Course Ref</span>
                        <span className="pill">Offered To</span>
                        <span className="pill">Offered By</span>
                        <span className="pill">Branch</span>
                    </div>
                </div>

                <form onSubmit={handleUpload} className="upload-form">
                    <div className={`file-drop-area ${file ? 'has-file' : ''}`}>
                        <input
                            type="file"
                            id="courses-excel-upload"
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
                            <><span className="spinner"></span> Processing uploads...</>
                        ) : (
                            <>🚀 Run Bulk Upload & Evaluate</>
                        )}
                    </button>
                </form>

                {error && <div className="alert error"><span>⚠️</span> {error}</div>}
                {message && <div className="alert success"><span>✅</span> {message}</div>}
            </div>

            {results && (
                <div className="results-card animate-fade">
                    <div className="results-header">
                        <h3>Upload Summary</h3>
                        <div style={{ display: 'flex', gap: '15px', marginTop: '10px' }}>
                            <span className="status-tag success">Added: {results.added}</span>
                            <span className="status-tag warning">Skipped (Duplicate): {results.skipped}</span>
                            <span className="status-tag danger">Failed: {results.failed}</span>
                        </div>
                    </div>

                    {results.errors && results.errors.length > 0 && (
                        <div className="errors-log-container" style={{ marginTop: '1.5rem' }}>
                            <h4 style={{ color: '#991B1B', marginBottom: '8px' }}>Processing Errors:</h4>
                            <div className="errors-log" style={{
                                maxHeight: '200px',
                                overflowY: 'auto',
                                background: '#FEF2F2',
                                padding: '1rem',
                                borderRadius: '10px',
                                border: '1px solid #FECACA',
                                fontFamily: 'monospace',
                                fontSize: '0.9rem',
                                color: '#991B1B'
                            }}>
                                {results.errors.map((err, idx) => (
                                    <div key={idx} style={{ marginBottom: '4px' }}>• {err}</div>
                                ))}
                            </div>
                        </div>
                    )}
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
                .status-tag {
                    padding: 6px 12px;
                    border-radius: 8px;
                    font-weight: 700;
                    font-size: 0.85rem;
                }
                .status-tag.success { background: #ECFDF5; color: #065F46; border: 1px solid #A7F3D0; }
                .status-tag.warning { background: #FFFBEB; color: #B45309; border: 1px solid #FDE68A; }
                .status-tag.danger { background: #FEF2F2; color: #991B1B; border: 1px solid #FECACA; }

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
            `}</style>
        </div>
    );
}
