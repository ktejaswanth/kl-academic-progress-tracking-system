import React, { useState } from 'react';
import api from '../../api';
import './faculty.css'; // I'll create this later

export default function BulkUpload() {
    const [file, setFile] = useState(null);
    const [uploading, setUploading] = useState(false);
    const [result, setResult] = useState(null);
    const [error, setError] = useState('');

    const handleFileChange = (e) => {
        setFile(e.target.files[0]);
        setError('');
        setResult(null);
    };

    const handleUpload = async (e) => {
        e.preventDefault();
        if (!file) {
            setError('Please select a file');
            return;
        }

        setUploading(true);
        setError('');
        
        const formData = new FormData();
        formData.append('file', file);

        try {
            const response = await api.post('/api/faculty/upload-students', formData, {
                headers: { 'Content-Type': 'multipart/form-data' }
            });
            setResult(response.data);
            setFile(null);
            // Reset file input
            document.getElementById('excel-upload').value = '';
        } catch (err) {
            setError(err.response?.data || 'Upload failed');
        } finally {
            setUploading(false);
        }
    };

    const downloadCredentials = async (uploadId) => {
        try {
            const response = await api.get(`/api/faculty/download-credentials/${uploadId}`, {
                responseType: 'blob'
            });
            const url = window.URL.createObjectURL(new Blob([response.data]));
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', `credentials_${uploadId}.xlsx`);
            document.body.appendChild(link);
            link.click();
            link.remove();
        } catch (err) {
            alert('Error downloading credentials');
        }
    };

    return (
        <div className="bulk-upload-container">
            <h1>Bulk Student Upload</h1>
            <p>Upload an Excel sheet to automatically create student accounts and generate credentials.</p>

            <div className="upload-section">
                <form onSubmit={handleUpload}>
                    <div className="file-input-wrapper">
                        <input 
                            type="file" 
                            id="excel-upload"
                            accept=".xlsx, .xls" 
                            onChange={handleFileChange} 
                        />
                        <label htmlFor="excel-upload">
                            {file ? file.name : "Click to select Excel file"}
                        </label>
                    </div>
                    <button type="submit" disabled={uploading || !file}>
                        {uploading ? "Processing..." : "Start Bulk Upload"}
                    </button>
                </form>
                {error && <p className="error-text">{error}</p>}
            </div>

            {result && (
                <div className="upload-result">
                    <div className="stats-grid">
                        <div className="stat-card">
                            <span className="stat-label">Total Records</span>
                            <span className="stat-value">{result.totalRecords}</span>
                        </div>
                        <div className="stat-card success">
                            <span className="stat-label">Successful</span>
                            <span className="stat-value">{result.successCount}</span>
                        </div>
                        <div className="stat-card failed">
                            <span className="stat-label">Failed</span>
                            <span className="stat-value">{result.failedCount}</span>
                        </div>
                    </div>

                    <div className="actions">
                        {result.successCount > 0 && (
                            <button onClick={() => downloadCredentials(result.id)} className="download-btn">
                                📥 Download Generated Credentials
                            </button>
                        )}
                        {result.failedCount > 0 && (
                            <button className="download-btn failed">
                                ⚠️ Download Failed Records
                            </button>
                        )}
                    </div>
                </div>
            )}

            <div className="format-guide">
                <h3>Excel Format Guide:</h3>
                <p>Your Excel sheet must have the following columns in order:</p>
                <code>First Name | Last Name | ID Number | Email | Department | Degree Type</code>
                <p className="note">Note: Department/Degree Type must be one of: HTE, HTR, HTI, HONOR, REGULAR</p>
            </div>
        </div>
    );
}
