import React, { useState } from 'react';
import api from '../../api';
import './faculty.css';

export default function BulkUpload() {
    const [file, setFile] = useState(null);
    const [uploading, setUploading] = useState(false);
    const [credentials, setCredentials] = useState([]);
    const [error, setError] = useState('');
    const [message, setMessage] = useState('');

    const handleFileChange = (e) => {
        setFile(e.target.files[0]);
        setError('');
        setCredentials([]);
        setMessage('');
    };

    const handleUpload = async (e) => {
        e.preventDefault();
        if (!file) {
            setError('Please select a file');
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
            setMessage(`Successfully registered ${response.data.length} students!`);
            setFile(null);
            document.getElementById('excel-upload').value = '';
        } catch (err) {
            setError(err.response?.data || 'Upload failed. Please check the Excel format.');
        } finally {
            setUploading(false);
        }
    };

    return (
        <div className="bulk-upload-container">
            <header className="page-header">
                <h1>Bulk Student Identity Management</h1>
                <p>Register multiple students at once and generate secure auto-passwords.</p>
            </header>

            <div className="upload-card">
                <div className="format-guide">
                    <h3>Excel Template Guide</h3>
                    <p>Your file must contain exactly 3 columns:</p>
                    <div className="column-pills">
                        <span className="pill">NAME</span>
                        <span className="pill">ID NUMBER</span>
                        <span className="pill">MAIL ID</span>
                    </div>
                </div>

                <form onSubmit={handleUpload} className="upload-form">
                    <div className="file-drop-area">
                        <input 
                            type="file" 
                            id="excel-upload"
                            accept=".xlsx, .xls" 
                            onChange={handleFileChange} 
                        />
                        <label htmlFor="excel-upload">
                            <span className="icon">📁</span>
                            <span className="text">{file ? file.name : "Drag & drop or click to select Excel file"}</span>
                        </label>
                    </div>
                    <button type="submit" className="primary-btn" disabled={uploading || !file}>
                        {uploading ? "⚡ Processing Identity Data..." : "🚀 Upload & Generate Credentials"}
                    </button>
                </form>
                {error && <div className="alert error">{error}</div>}
                {message && <div className="alert success">{message}</div>}
            </div>

            {credentials.length > 0 && (
                <div className="results-card animate-fade-in">
                    <div className="results-header">
                        <h3>Generated Student Credentials</h3>
                        <p>Share these credentials with the respective students.</p>
                    </div>
                    <div className="table-wrapper">
                        <table className="modern-table">
                            <thead>
                                <tr>
                                    <th>Student Name</th>
                                    <th>ID Number</th>
                                    <th>Email ID</th>
                                    <th>Generated Password</th>
                                </tr>
                            </thead>
                            <tbody>
                                {credentials.map((student, index) => (
                                    <tr key={index}>
                                        <td><strong>{student.fullName}</strong></td>
                                        <td><code>{student.id}</code></td>
                                        <td>{student.email}</td>
                                        <td>
                                            <div className="password-cell">
                                                <span className="pass-text">{student.password}</span>
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
        </div>
    );
}
