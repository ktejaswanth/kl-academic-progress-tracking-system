import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import './curriculum-import.css';

export default function CurriculumUpload() {
    const navigate = useNavigate();
    const [file, setFile] = useState(null);
    const [dragActive, setDragActive] = useState(false);
    const [formData, setFormData] = useState({
        curriculumName: '',
        department: 'CSE',
        regulation: 'Y23',
        academicYear: '2023-2027'
    });
    const [loading, setLoading] = useState(false);
    const [loadingMessage, setLoadingMessage] = useState('');
    const [error, setError] = useState(null);

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData(prev => ({ ...prev, [name]: value }));
    };

    const handleDrag = (e) => {
        e.preventDefault();
        e.stopPropagation();
        if (e.type === "dragenter" || e.type === "dragover") {
            setDragActive(true);
        } else if (e.type === "dragleave") {
            setDragActive(false);
        }
    };

    const handleDrop = (e) => {
        e.preventDefault();
        e.stopPropagation();
        setDragActive(false);
        if (e.dataTransfer.files && e.dataTransfer.files[0]) {
            const droppedFile = e.dataTransfer.files[0];
            if (droppedFile.type === "application/pdf") {
                setFile(droppedFile);
                setError(null);
            } else {
                setError("Only PDF files are supported.");
            }
        }
    };

    const handleFileChange = (e) => {
        if (e.target.files && e.target.files[0]) {
            const selectedFile = e.target.files[0];
            if (selectedFile.type === "application/pdf") {
                setFile(selectedFile);
                setError(null);
            } else {
                setError("Only PDF files are supported.");
            }
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!file) {
            setError("Please upload a curriculum PDF file.");
            return;
        }
        if (!formData.curriculumName.trim()) {
            setError("Please enter a curriculum name.");
            return;
        }

        setLoading(true);
        setError(null);
        setLoadingMessage("Extracting text from PDF and establishing import session...");

        const uploadData = new FormData();
        uploadData.append('file', file);
        uploadData.append('curriculumName', formData.curriculumName);
        uploadData.append('department', formData.department);
        uploadData.append('regulation', formData.regulation);
        uploadData.append('academicYear', formData.academicYear);

        try {
            // 1. Upload PDF
            const uploadRes = await api.post('/curriculum/upload', uploadData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            });
            const importId = uploadRes.data.id;

            // 2. Trigger Gemini AI analysis
            setLoadingMessage("Gemini AI is parsing course rules, extracting buckets & credits (this may take up to 1-2 minutes)...");
            const analyzeRes = await api.post(`/curriculum/${importId}/analyze`);
            
            setLoading(false);
            // Navigate to review screen
            navigate(`/super_admin/curriculum-review/${importId}`);
        } catch (err) {
            setLoading(false);
            console.error("Curriculum upload failed:", err);
            setError(err.response?.data?.error || "Failed to parse curriculum. Please try again.");
        }
    };

    return (
        <div className="curriculum-import-container">
            <div className="import-header-card">
                <div className="import-header-title">
                    <h1>AI Curriculum Import Engine</h1>
                    <p>Upload a curriculum handbook PDF. Gemini AI will automatically extract and parse the department, courses, credit rules, degree paths, and program requirements.</p>
                </div>
            </div>

            {error && (
                <div className="validation-list" style={{ marginBottom: '20px' }}>
                    <h3>⚠️ Upload Error</h3>
                    <ul>
                        <li>{error}</li>
                    </ul>
                </div>
            )}

            <form onSubmit={handleSubmit} onDragEnter={handleDrag}>
                <div className="import-form-grid">
                    <div className="form-group">
                        <label htmlFor="curriculumName">Curriculum Name</label>
                        <input
                            type="text"
                            id="curriculumName"
                            name="curriculumName"
                            placeholder="e.g. Y23 B.Tech CSE"
                            value={formData.curriculumName}
                            onChange={handleInputChange}
                        />
                    </div>
                    <div className="form-group">
                        <label htmlFor="department">Department</label>
                        <select
                            id="department"
                            name="department"
                            value={formData.department}
                            onChange={handleInputChange}
                        >
                            <option value="CSE">Computer Science (CSE)</option>
                            <option value="AIDS">Artificial Intelligence (AIDS)</option>
                            <option value="CSIT">Information Technology (CSIT)</option>
                            <option value="EEE">Electrical (EEE)</option>
                            <option value="ECE">Electronics (ECE)</option>
                            <option value="MECH">Mechanical (MECH)</option>
                            <option value="CIVIL">Civil (CIVIL)</option>
                        </select>
                    </div>
                    <div className="form-group">
                        <label htmlFor="regulation">Regulation</label>
                        <select
                            id="regulation"
                            name="regulation"
                            value={formData.regulation}
                            onChange={handleInputChange}
                        >
                            <option value="Y23">Y23</option>
                            <option value="Y24">Y24</option>
                            <option value="Y25">Y25</option>
                            <option value="Y26">Y26</option>
                        </select>
                    </div>
                    <div className="form-group">
                        <label htmlFor="academicYear">Academic Year</label>
                        <input
                            type="text"
                            id="academicYear"
                            name="academicYear"
                            placeholder="e.g. 2023-2027"
                            value={formData.academicYear}
                            onChange={handleInputChange}
                        />
                    </div>
                </div>

                <div 
                    className={`upload-dropzone ${dragActive ? 'active' : ''}`}
                    onDragEnter={handleDrag}
                    onDragOver={handleDrag}
                    onDragLeave={handleDrag}
                    onDrop={handleDrop}
                    onClick={() => document.getElementById('pdfFile').click()}
                >
                    <input
                        type="file"
                        id="pdfFile"
                        style={{ display: 'none' }}
                        accept=".pdf"
                        onChange={handleFileChange}
                    />
                    <div className="upload-icon">📄</div>
                    <div className="upload-text">
                        {file ? (
                            <h3>Selected: {file.name}</h3>
                        ) : (
                            <h3>Drag & drop curriculum PDF here, or click to browse</h3>
                        )}
                        <p>Support only PDF format. Max file size: 20MB.</p>
                    </div>
                </div>

                <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '12px' }}>
                    <button 
                        type="button" 
                        className="btn-secondary" 
                        onClick={() => navigate('/super_admin/curriculum-repository')}
                    >
                        View Repository
                    </button>
                    <button type="submit" className="btn-primary">
                        Upload & Analyze
                    </button>
                </div>
            </form>

            {loading && (
                <div className="loading-overlay">
                    <div className="spinner"></div>
                    <h2 style={{ color: '#60a5fa', marginBottom: '8px' }}>Processing Curriculum</h2>
                    <p style={{ color: '#94a3b8', fontSize: '14px', maxWidth: '400px', textAlign: 'center' }}>
                        {loadingMessage}
                    </p>
                </div>
            )}
        </div>
    );
}
