import React, { useState, useEffect } from 'react';
import api from '../../api';
import './faculty.css';

export default function UploadCourses() {
    const [file, setFile] = useState(null);
    const [selectedBatch, setSelectedBatch] = useState('Y23');
    const [customBatch, setCustomBatch] = useState('');
    const [isCustom, setIsCustom] = useState(false);
    const [availableBatches, setAvailableBatches] = useState([]);
    const [uploading, setUploading] = useState(false);
    const [elapsedSeconds, setElapsedSeconds] = useState(0);
    const [results, setResults] = useState(null);
    const [error, setError] = useState('');
    const [message, setMessage] = useState('');

    const presetBatches = ['Y23', 'Y24', 'Y25', 'Y26', 'Y27'];

    const activeBatch = isCustom ? (customBatch.trim() || 'Y23') : selectedBatch;
    const targetTableName = `${activeBatch.toLowerCase().startsWith('y') ? activeBatch.toLowerCase() : 'y' + activeBatch.toLowerCase()}_students_courses`;

    useEffect(() => {
        fetchAvailableBatches();
    }, []);

    useEffect(() => {
        let interval;
        if (uploading) {
            setElapsedSeconds(0);
            interval = setInterval(() => {
                setElapsedSeconds(prev => prev + 1);
            }, 1000);
        } else {
            clearInterval(interval);
        }
        return () => clearInterval(interval);
    }, [uploading]);

    const fetchAvailableBatches = async () => {
        try {
            const res = await api.get('/dyod/courses/batches');
            if (res.data && Array.isArray(res.data)) {
                setAvailableBatches(res.data);
            }
        } catch (err) {
            console.warn('Could not fetch existing batches:', err);
        }
    };

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
            setError('Please select an Excel or CSV file first.');
            return;
        }

        setUploading(true);
        setError('');
        setResults(null);
        setMessage('');

        const formData = new FormData();
        formData.append('file', file);
        formData.append('batch', activeBatch);

        try {
            const response = await api.post('/dyod/courses/bulk-upload', formData, {
                headers: { 'Content-Type': 'multipart/form-data' }
            });
            setResults(response.data);
            setMessage(response.data?.message || `Bulk upload completed successfully!`);
            setFile(null);
            if (document.getElementById('courses-excel-upload')) {
                document.getElementById('courses-excel-upload').value = '';
            }
            fetchAvailableBatches();
        } catch (err) {
            const errMsg = err.response?.data?.error || err.message || 'Upload failed. Please verify file format and columns.';
            setError(errMsg);
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
            <header className="page-header" style={{ marginBottom: '2rem' }}>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap', gap: '15px' }}>
                    <div>
                        <h1 style={{ fontSize: '2.2rem', color: '#1E293B', fontWeight: '800', margin: 0 }}>
                            Upload Student Course Records
                        </h1>
                        <p style={{ color: '#64748B', marginTop: '6px', fontSize: '1rem' }}>
                            High-volume ingestion engine with dynamic batch routing. Supports up to 1,000,000 rows.
                        </p>
                    </div>
                    <div style={{
                        background: 'linear-gradient(135deg, #EEF2FF 0%, #E0E7FF 100%)',
                        border: '1px solid #C7D2FE',
                        padding: '10px 18px',
                        borderRadius: '14px',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '10px'
                    }}>
                        <span style={{ fontSize: '1.4rem' }}>⚡</span>
                        <div>
                            <div style={{ fontSize: '0.75rem', fontWeight: '800', color: '#4338CA', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
                                Engine Capacity
                            </div>
                            <div style={{ fontSize: '0.9rem', fontWeight: '700', color: '#1E1B4B' }}>
                                Up to 1,000,000 Rows/Batch
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            {/* Target Batch Selector Card */}
            <div className="batch-selection-card">
                <div className="batch-header">
                    <div>
                        <h3 style={{ margin: 0, fontSize: '1.2rem', fontWeight: '700', color: '#0F172A', display: 'flex', alignItems: 'center', gap: '10px' }}>
                            <span>🏷️</span> Step 1: Select Academic Batch
                        </h3>
                        <p style={{ margin: '4px 0 0 0', color: '#64748B', fontSize: '0.9rem' }}>
                            Choose the student batch. Records will automatically route to table <code className="table-code">{targetTableName}</code>.
                        </p>
                    </div>
                    <span className="batch-pill-active">
                        Target Table: <strong>{targetTableName}</strong>
                    </span>
                </div>

                <div className="batch-options-grid">
                    {presetBatches.map(b => (
                        <button
                            key={b}
                            type="button"
                            className={`batch-btn ${!isCustom && selectedBatch === b ? 'active' : ''}`}
                            onClick={() => { setSelectedBatch(b); setIsCustom(false); }}
                        >
                            <span className="batch-label">{b}</span>
                            <span className="batch-sub">Batch {b}</span>
                        </button>
                    ))}
                    <button
                        type="button"
                        className={`batch-btn ${isCustom ? 'active' : ''}`}
                        onClick={() => setIsCustom(true)}
                    >
                        <span className="batch-label">Custom</span>
                        <span className="batch-sub">Other Batch</span>
                    </button>
                </div>

                {isCustom && (
                    <div className="custom-batch-input-row">
                        <label htmlFor="custom-batch-input">Enter Custom Batch Code:</label>
                        <input
                            id="custom-batch-input"
                            type="text"
                            placeholder="e.g. Y21, Y22, Y28"
                            value={customBatch}
                            onChange={(e) => setCustomBatch(e.target.value.toUpperCase())}
                            maxLength={10}
                        />
                        <span className="batch-hint">Will create & route to table: <strong>{targetTableName}</strong></span>
                    </div>
                )}

                {/* Existing Batches in Database */}
                {availableBatches.length > 0 && (
                    <div className="existing-batches-row">
                        <span className="existing-label">Existing Batch Tables:</span>
                        <div className="existing-badges">
                            {availableBatches.map(b => (
                                <span key={b.tableName} className="existing-badge">
                                    <strong>{b.batch}</strong>: {b.count?.toLocaleString() || 0} rows
                                </span>
                            ))}
                        </div>
                    </div>
                )}
            </div>

            {/* Upload Card */}
            <div className="upload-card">
                <div className="format-guide">
                    <div className="guide-actions" style={{ marginBottom: '1.25rem', display: 'flex', gap: '15px', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap' }}>
                        <h3 style={{ margin: 0 }}>
                            <span style={{ fontSize: '1.4rem' }}>📋</span>
                            Step 2: Excel / CSV Schema Guideline
                        </h3>
                        <button
                            type="button"
                            onClick={downloadTemplate}
                            className="demo-download-btn"
                        >
                            📥 Download Course Upload Template (.xlsx)
                        </button>
                    </div>
                    <p style={{ margin: '0 0 1rem 0' }}>File columns MUST follow or include this standard schema (Auto-detects headers):</p>
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
                            accept=".xlsx, .xls, .csv"
                            onChange={handleFileChange}
                        />
                        <div className="drop-content">
                            <span className="icon">{file ? '📄' : '📁'}</span>
                            <span className="text">
                                {file ? file.name : "Drag & drop or click to select course file"}
                            </span>
                            <span className="sub-text">
                                Supported formats: <strong>.xlsx, .xls, .csv</strong> &bull; Fast streaming ingestion for large batches
                            </span>
                        </div>
                    </div>

                    <button type="submit" className="primary-btn" disabled={uploading || !file}>
                        {uploading ? (
                            <>
                                <span className="spinner"></span>
                                Streaming into {targetTableName}... ({elapsedSeconds}s elapsed)
                            </>
                        ) : (
                            <>
                                🚀 Run Bulk Upload into {targetTableName}
                            </>
                        )}
                    </button>
                </form>

                {error && <div className="alert error"><span>⚠️</span> {error}</div>}
                {message && <div className="alert success"><span>✅</span> {message}</div>}
            </div>

            {/* Results Card */}
            {results && (
                <div className="results-card animate-fade">
                    <div className="results-header">
                        <div>
                            <h3 style={{ margin: 0, fontSize: '1.3rem', color: '#0F172A' }}>Batch Processing Summary</h3>
                            <p style={{ margin: '4px 0 0 0', color: '#64748B', fontSize: '0.9rem' }}>
                                Destination Table: <code className="table-code">{results.tableName}</code> (Batch: {results.batch})
                            </p>
                        </div>
                        <div style={{ display: 'flex', gap: '10px', flexWrap: 'wrap' }}>
                            <span className="status-tag success">Total: {results.total?.toLocaleString()}</span>
                            <span className="status-tag success">Processed: {results.added?.toLocaleString()}</span>
                            {results.speedRowsPerSec > 0 && (
                                <span className="status-tag speed">⚡ {results.speedRowsPerSec?.toLocaleString()} rows/sec</span>
                            )}
                            {results.executionTimeMs > 0 && (
                                <span className="status-tag time">⏱️ {(results.executionTimeMs / 1000).toFixed(2)}s</span>
                            )}
                            {results.failed > 0 && (
                                <span className="status-tag danger">Failed: {results.failed?.toLocaleString()}</span>
                            )}
                        </div>
                    </div>

                    {results.errors && results.errors.length > 0 && (
                        <div className="errors-log-container" style={{ marginTop: '1.5rem' }}>
                            <h4 style={{ color: '#991B1B', marginBottom: '8px' }}>Processing Notices / Errors:</h4>
                            <div className="errors-log" style={{
                                maxHeight: '200px',
                                overflowY: 'auto',
                                background: '#FEF2F2',
                                padding: '1rem',
                                borderRadius: '10px',
                                border: '1px solid #FECACA',
                                fontFamily: 'monospace',
                                fontSize: '0.85rem',
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
                    animation: fadeIn 0.4s ease-out;
                    max-width: 1040px;
                    margin: 0 auto;
                    padding-bottom: 4rem;
                }
                @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

                .batch-selection-card {
                    background: white;
                    border-radius: 20px;
                    padding: 1.75rem 2rem;
                    box-shadow: 0 4px 20px rgba(0,0,0,0.03);
                    border: 1px solid #E2E8F0;
                    margin-bottom: 1.5rem;
                }
                .batch-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    flex-wrap: wrap;
                    gap: 15px;
                    margin-bottom: 1.25rem;
                }
                .table-code {
                    background: #F1F5F9;
                    color: #0F172A;
                    padding: 2px 8px;
                    border-radius: 6px;
                    font-weight: 700;
                    font-size: 0.9em;
                }
                .batch-pill-active {
                    background: #EFF6FF;
                    color: #1D4ED8;
                    border: 1px solid #BFDBFE;
                    padding: 6px 14px;
                    border-radius: 20px;
                    font-size: 0.85rem;
                }

                .batch-options-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
                    gap: 12px;
                    margin-bottom: 1rem;
                }
                .batch-btn {
                    background: #F8FAFC;
                    border: 2px solid #E2E8F0;
                    border-radius: 14px;
                    padding: 12px 10px;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    justify-content: center;
                    cursor: pointer;
                    transition: all 0.2s ease;
                }
                .batch-btn:hover {
                    border-color: #E11D48;
                    background: #FFF1F2;
                    transform: translateY(-2px);
                }
                .batch-btn.active {
                    background: #FFF1F2;
                    border-color: #E11D48;
                    box-shadow: 0 4px 12px rgba(225, 29, 72, 0.15);
                }
                .batch-btn .batch-label {
                    font-size: 1.25rem;
                    font-weight: 800;
                    color: #0F172A;
                }
                .batch-btn.active .batch-label {
                    color: #E11D48;
                }
                .batch-btn .batch-sub {
                    font-size: 0.75rem;
                    color: #64748B;
                    margin-top: 2px;
                    font-weight: 600;
                }

                .custom-batch-input-row {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    background: #F8FAFC;
                    padding: 12px 16px;
                    border-radius: 12px;
                    border: 1px solid #E2E8F0;
                    margin-top: 10px;
                    flex-wrap: wrap;
                }
                .custom-batch-input-row label {
                    font-size: 0.9rem;
                    font-weight: 700;
                    color: #334155;
                }
                .custom-batch-input-row input {
                    padding: 8px 12px;
                    border: 1px solid #CBD5E1;
                    border-radius: 8px;
                    font-weight: 700;
                    font-size: 0.95rem;
                    width: 140px;
                    text-transform: uppercase;
                }
                .custom-batch-input-row input:focus {
                    outline: none;
                    border-color: #E11D48;
                    box-shadow: 0 0 0 3px rgba(225, 29, 72, 0.1);
                }
                .batch-hint {
                    font-size: 0.85rem;
                    color: #64748B;
                }

                .existing-batches-row {
                    margin-top: 1.25rem;
                    padding-top: 1rem;
                    border-top: 1px solid #F1F5F9;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    flex-wrap: wrap;
                }
                .existing-label {
                    font-size: 0.85rem;
                    font-weight: 700;
                    color: #64748B;
                }
                .existing-badges {
                    display: flex;
                    gap: 8px;
                    flex-wrap: wrap;
                }
                .existing-badge {
                    background: #F1F5F9;
                    border: 1px solid #E2E8F0;
                    padding: 4px 10px;
                    border-radius: 12px;
                    font-size: 0.8rem;
                    color: #334155;
                }

                .upload-card {
                    background: white;
                    border-radius: 24px;
                    padding: 2.25rem;
                    box-shadow: 0 10px 30px rgba(0,0,0,0.04);
                    border: 1px solid #EDF2F7;
                    margin-bottom: 2rem;
                }

                .format-guide {
                    background: #F8FAFC;
                    padding: 1.5rem 1.75rem;
                    border-radius: 18px;
                    margin-bottom: 1.75rem;
                    border: 1px solid #E2E8F0;
                }
                .format-guide h3 { 
                    color: #0F172A; 
                    font-size: 1.15rem;
                    font-weight: 700;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }
                .format-guide p { color: #64748B; font-size: 0.9rem; }

                .column-pills {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 7px;
                }
                .pill {
                    background: white;
                    color: #E11D48;
                    padding: 6px 11px;
                    border-radius: 8px;
                    font-size: 0.72rem;
                    font-weight: 800;
                    border: 1px solid #E2E8F0;
                    text-transform: uppercase;
                    letter-spacing: 0.04em;
                }

                .demo-download-btn {
                    background: #FFF1F2;
                    color: #E11D48;
                    border: 1px solid #FECACA;
                    padding: 9px 16px;
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
                    padding: 2.75rem 2rem;
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
                .file-drop-area .icon { font-size: 3.2rem; display: block; margin-bottom: 0.75rem; transition: transform 0.3s; }
                .file-drop-area:hover .icon { transform: scale(1.1); }
                .file-drop-area .text { color: #1E293B; font-weight: 700; font-size: 1.05rem; display: block; }
                .file-drop-area .sub-text { color: #94A3B8; font-size: 0.85rem; margin-top: 0.4rem; }

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
                    margin-bottom: 1.5rem;
                    padding-bottom: 1.25rem;
                    border-bottom: 1px solid #F1F5F9;
                    gap: 15px;
                    flex-wrap: wrap;
                }
                .status-tag {
                    padding: 6px 12px;
                    border-radius: 8px;
                    font-weight: 700;
                    font-size: 0.85rem;
                }
                .status-tag.success { background: #ECFDF5; color: #065F46; border: 1px solid #A7F3D0; }
                .status-tag.speed { background: #EEF2FF; color: #4338CA; border: 1px solid #C7D2FE; }
                .status-tag.time { background: #F1F5F9; color: #334155; border: 1px solid #CBD5E1; }
                .status-tag.danger { background: #FEF2F2; color: #991B1B; border: 1px solid #FECACA; }

                .alert {
                    padding: 1rem 1.25rem;
                    border-radius: 12px;
                    margin-top: 1.25rem;
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
