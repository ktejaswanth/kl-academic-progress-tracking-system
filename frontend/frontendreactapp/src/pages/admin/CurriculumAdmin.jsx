import React, { useState, useEffect } from 'react';
import api from '../../api';
import './admin.css';

export default function CurriculumAdmin() {
    // Tab Navigation state
    const [activeTab, setActiveTab] = useState('bulk'); // 'bulk' | 'builder' | 'master'

    // Master States
    const [stats, setStats] = useState({});
    const [buckets, setBuckets] = useState([]);
    const [paths, setPaths] = useState([]);
    const [courses, setCourses] = useState([]);
    const [mappings, setMappings] = useState([]);

    // Selection & Loading states
    const [loading, setLoading] = useState(false);
    const [message, setMessage] = useState('');
    const [error, setError] = useState('');

    // Tab 1: Bulk Upload State
    const [uploadType, setUploadType] = useState('courses'); // 'courses' | 'requirements' | 'mappings'
    const [selectedFile, setSelectedFile] = useState(null);
    const [uploadConsole, setUploadConsole] = useState(null); // stores parsed upload feedback

    // Tab 2: Interactive Builder State
    const [selectedPathId, setSelectedPathId] = useState('');
    const [selectedPathObj, setSelectedPathObj] = useState(null);
    const [pathRequirements, setPathRequirements] = useState([]);
    const [pathSearchQuery, setPathSearchQuery] = useState('');

    // Accordion expand/collapse
    const [expandedAccordion, setExpandedAccordion] = useState('requirements'); // 'requirements' | 'mappings'

    // Form states
    const [pathForm, setPathForm] = useState({
        deptCode: 'CSE',
        typeCode: 'REGULAR',
        addonCode: 'NONE',
        addonName: '',
        totalCredits: 160
    });

    const [requirementForm, setRequirementForm] = useState({
        bucketId: '',
        requiredCredits: 4,
        minCourses: '',
        isMandatory: true
    });

    const [mappingForm, setMappingForm] = useState({
        courseId: '',
        bucketId: '',
        isMandatory: false
    });

    // Tab 3: Master settings forms
    const [newBucketForm, setNewBucketForm] = useState({
        bucketCode: '',
        bucketName: '',
        bucketCategory: 'Professional Core',
        description: ''
    });

    // Load initial data
    useEffect(() => {
        fetchStats();
        fetchBuckets();
        fetchPaths();
        fetchCourses();
        fetchMappings();
    }, []);

    // Watch path selection changes
    useEffect(() => {
        if (selectedPathId) {
            const foundPath = paths.find(p => p.id === Number(selectedPathId));
            setSelectedPathObj(foundPath || null);
            fetchPathRequirements(selectedPathId);
        } else {
            setSelectedPathObj(null);
            setPathRequirements([]);
        }
    }, [selectedPathId, paths]);

    // --- API Calls ---
    const fetchStats = async () => {
        try {
            const res = await api.get('/dyod/master/stats');
            setStats(res.data || {});
        } catch (err) {
            console.error('Error fetching stats', err);
        }
    };

    const fetchBuckets = async () => {
        try {
            const res = await api.get('/dyod/master/buckets');
            setBuckets(res.data || []);
        } catch (err) {
            console.error('Error fetching buckets', err);
        }
    };

    const fetchPaths = async () => {
        try {
            const res = await api.get('/dyod/master/paths');
            setPaths(res.data || []);
        } catch (err) {
            console.error('Error fetching paths', err);
        }
    };

    const fetchCourses = async () => {
        try {
            const res = await api.get('/admin/curriculum/courses');
            setCourses(res.data || []);
        } catch (err) {
            console.error('Error fetching course catalog', err);
        }
    };

    const fetchMappings = async () => {
        try {
            const res = await api.get('/dyod/master/mappings');
            setMappings(res.data || []);
        } catch (err) {
            console.error('Error fetching course bucket mappings', err);
        }
    };

    const fetchPathRequirements = async (pathId) => {
        try {
            const res = await api.get(`/dyod/master/paths/${pathId}/requirements`);
            setPathRequirements(res.data || []);
        } catch (err) {
            console.error('Error fetching requirements for path', err);
        }
    };

    // --- Upload Handlers ---
    const handleFileChange = (e) => {
        setSelectedFile(e.target.files[0] || null);
        setUploadConsole(null);
        setError('');
        setMessage('');
    };

    const handleUploadSubmit = async (e) => {
        e.preventDefault();
        if (!selectedFile) {
            setError('Please select an Excel sheet first.');
            return;
        }

        setLoading(true);
        setError('');
        setMessage('');
        setUploadConsole(null);

        const formData = new FormData();
        formData.append('file', selectedFile);

        try {
            const res = await api.post(`/dyod/upload/${uploadType}`, formData, {
                headers: { 'Content-Type': 'multipart/form-data' }
            });
            
            setUploadConsole(res.data);
            
            // Check if errors exist in result
            if (res.data.failed && res.data.failed > 0) {
                setError(`Completed with ${res.data.failed} failed rows. Review the console logs below.`);
            } else if (res.data.errors && res.data.errors.length > 0) {
                setError(`Completed with errors. Review the console logs below.`);
            } else {
                setMessage('File uploaded and processed successfully!');
            }

            // Refresh tables
            fetchStats();
            fetchPaths();
            fetchCourses();
            fetchMappings();
            fetchBuckets();
            setSelectedFile(null);
            
            const fileInput = document.getElementById('dyod-excel-upload');
            if (fileInput) fileInput.value = '';
        } catch (err) {
            setError(err.response?.data?.error || 'Upload failed. Please ensure columns match the template exactly.');
        } finally {
            setLoading(false);
        }
    };

    const handleDownloadTemplate = async (type) => {
        setError('');
        setMessage('');
        try {
            const res = await api.get(`/dyod/upload/template/${type}`, {
                responseType: 'blob'
            });
            const blob = new Blob([res.data], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
            const url = window.URL.createObjectURL(blob);
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', `${type}_template.xlsx`);
            document.body.appendChild(link);
            link.click();
            link.parentNode.removeChild(link);
        } catch (err) {
            setError('Failed to download template. Please try again.');
        }
    };

    // --- Interactive Path Actions ---
    const handleGeneratePath = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError('');
        setMessage('');

        try {
            const params = {
                deptCode: pathForm.deptCode,
                typeCode: pathForm.typeCode,
                addonCode: pathForm.addonCode,
                addonName: pathForm.addonName || '',
                totalCredits: pathForm.totalCredits
            };
            const res = await api.post('/dyod/master/paths/generate', null, { params });
            setMessage(`Degree Path "${res.data.pathCode}" generated successfully.`);
            setPathForm({
                deptCode: 'CSE',
                typeCode: 'REGULAR',
                addonCode: 'NONE',
                addonName: '',
                totalCredits: 160
            });
            fetchPaths();
            fetchStats();
        } catch (err) {
            setError(err.response?.data?.message || 'Could not generate path. Check code rules or verify if it already exists.');
        } finally {
            setLoading(false);
        }
    };

    const handleDeletePath = async (id, code) => {
        if (!window.confirm(`Are you sure you want to delete the path "${code}"? This will delete all requirements and mapped student records.`)) return;
        setError('');
        setMessage('');
        try {
            await api.delete(`/dyod/master/paths/${id}`);
            setMessage('Degree path deleted successfully.');
            if (selectedPathId === String(id)) {
                setSelectedPathId('');
            }
            fetchPaths();
            fetchStats();
        } catch (err) {
            setError('Could not delete degree path.');
        }
    };

    // --- Path Requirements Actions ---
    const handleAddRequirement = async (e) => {
        e.preventDefault();
        if (!selectedPathId) return;
        setLoading(true);
        setError('');
        setMessage('');

        try {
            const reqData = {
                bucket: { id: Number(requirementForm.bucketId) },
                requiredCredits: Number(requirementForm.requiredCredits),
                minCourses: requirementForm.minCourses ? Number(requirementForm.minCourses) : null,
                isMandatory: requirementForm.isMandatory
            };
            await api.post(`/dyod/master/paths/${selectedPathId}/requirements`, reqData);
            setMessage('Bucket requirement added successfully.');
            setRequirementForm({
                bucketId: '',
                requiredCredits: 4,
                minCourses: '',
                isMandatory: true
            });
            fetchPathRequirements(selectedPathId);
            fetchStats();
        } catch (err) {
            setError(err.response?.data?.message || 'Could not add requirement. This bucket might already be configured for this path.');
        } finally {
            setLoading(false);
        }
    };

    const handleDeleteRequirement = async (reqId) => {
        if (!window.confirm('Delete this bucket requirement from the degree path?')) return;
        setError('');
        setMessage('');
        try {
            await api.delete(`/dyod/master/paths/requirements/${reqId}`);
            setMessage('Requirement deleted.');
            fetchPathRequirements(selectedPathId);
            fetchStats();
        } catch (err) {
            setError('Could not delete requirement.');
        }
    };

    // --- Course Mappings Actions ---
    const handleAddMapping = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError('');
        setMessage('');

        try {
            const params = {
                courseId: Number(mappingForm.courseId),
                bucketId: Number(mappingForm.bucketId),
                pathId: selectedPathId ? Number(selectedPathId) : null,
                isMandatory: mappingForm.isMandatory
            };

            await api.post('/dyod/master/mappings', null, { params });
            setMessage('Course mapping added successfully.');
            setMappingForm({
                courseId: '',
                bucketId: '',
                isMandatory: false
            });
            fetchMappings();
            fetchStats();
        } catch (err) {
            setError(err.response?.data?.message || 'Could not add course mapping.');
        } finally {
            setLoading(false);
        }
    };

    const handleDeleteMapping = async (id) => {
        if (!window.confirm('Remove this course bucket mapping?')) return;
        setError('');
        setMessage('');
        try {
            await api.delete(`/dyod/master/mappings/${id}`);
            setMessage('Course mapping removed.');
            fetchMappings();
            fetchStats();
        } catch (err) {
            setError('Could not delete mapping.');
        }
    };

    // --- Master Data Actions ---
    const handleCreateBucket = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError('');
        setMessage('');

        try {
            await api.post('/dyod/master/buckets', newBucketForm);
            setMessage(`Bucket "${newBucketForm.bucketCode}" created successfully.`);
            setNewBucketForm({
                bucketCode: '',
                bucketName: '',
                bucketCategory: 'Professional Core',
                description: ''
            });
            fetchBuckets();
            fetchStats();
        } catch (err) {
            setError('Could not create bucket. Ensure code is unique.');
        } finally {
            setLoading(false);
        }
    };

    // Filter paths in builder sidebar
    const filteredPaths = paths.filter(p => 
        p.pathCode.toLowerCase().includes(pathSearchQuery.toLowerCase()) ||
        p.department?.deptCode.toLowerCase().includes(pathSearchQuery.toLowerCase())
    );

    // Mappings filter for the active path
    const activePathMappings = mappings.filter(m => 
        selectedPathId ? m.degreePath?.id === Number(selectedPathId) : m.degreePath === null
    );

    return (
        <div className="curriculum-admin-container">
            <header className="page-header-premium">
                <h1>DYOD Curriculum Administration</h1>
                <p>Configure degree path requirements, course-bucket links, and process bulk imports via Excel.</p>
            </header>

            {/* Main Tabs Navigation */}
            <div className="tabs-navigation">
                <button 
                    className={`tab-trigger ${activeTab === 'bulk' ? 'active' : ''}`}
                    onClick={() => { setActiveTab('bulk'); setError(''); setMessage(''); }}
                >
                    📤 Bulk Excel Uploads
                </button>
                <button 
                    className={`tab-trigger ${activeTab === 'builder' ? 'active' : ''}`}
                    onClick={() => { setActiveTab('builder'); setError(''); setMessage(''); }}
                >
                    🛠️ Curriculum Builder
                </button>
                <button 
                    className={`tab-trigger ${activeTab === 'master' ? 'active' : ''}`}
                    onClick={() => { setActiveTab('master'); setError(''); setMessage(''); }}
                >
                    ⚙️ Master Settings & Stats
                </button>
            </div>

            {/* Global alert notifications */}
            {message && <div className="alert-premium success"><span>✅</span> {message}</div>}
            {error && <div className="alert-premium error"><span>⚠️</span> {error}</div>}

            {/* TAB 1: BULK EXCEL UPLOADS */}
            {activeTab === 'bulk' && (
                <div className="tab-content animate-fade">
                    <div className="admin-card-glass">
                        <h2 className="admin-card-title">Select Upload Target</h2>
                        <div className="bulk-upload-cards-grid">
                            {/* Card 1: Course Catalog */}
                            <div 
                                className={`upload-type-card ${uploadType === 'courses' ? 'selected' : ''}`}
                                onClick={() => { setUploadType('courses'); setSelectedFile(null); setUploadConsole(null); }}
                            >
                                <span className="card-icon">📚</span>
                                <h3>Course Catalog</h3>
                                <p>Bulk import the master course directory, including lecture hours (L-T-P-S) and prerequisite logic.</p>
                                <div className="pill-group">
                                    <span className="col-pill">Course Code</span>
                                    <span className="col-pill">Course Name</span>
                                    <span className="col-pill">L-T-P-S</span>
                                    <span className="col-pill">Credits</span>
                                    <span className="col-pill">Prerequisites</span>
                                </div>
                            </div>

                            {/* Card 2: Path Requirements */}
                            <div 
                                className={`upload-type-card ${uploadType === 'requirements' ? 'selected' : ''}`}
                                onClick={() => { setUploadType('requirements'); setSelectedFile(null); setUploadConsole(null); }}
                            >
                                <span className="card-icon">🗂️</span>
                                <h3>Path Requirements</h3>
                                <p>Load the bucket credit targets required to satisfy each degree path (Regular, Honors, HTE, etc.).</p>
                                <div className="pill-group">
                                    <span className="col-pill">Degree Path Code</span>
                                    <span className="col-pill">Bucket Code</span>
                                    <span className="col-pill">Required Credits</span>
                                </div>
                            </div>

                            {/* Card 3: Course Bucket Mappings */}
                            <div 
                                className={`upload-type-card ${uploadType === 'mappings' ? 'selected' : ''}`}
                                onClick={() => { setUploadType('mappings'); setSelectedFile(null); setUploadConsole(null); }}
                            >
                                <span className="card-icon">🔗</span>
                                <h3>Course-Bucket Mappings</h3>
                                <p>Assign individual catalog courses to specific buckets. Supports universal or path-specific links.</p>
                                <div className="pill-group">
                                    <span className="col-pill">Course Code</span>
                                    <span className="col-pill">Bucket Code</span>
                                    <span className="col-pill">Path Code (Optional)</span>
                                </div>
                            </div>
                        </div>

                        {/* Template Download Button */}
                        <div className="template-download-wrapper">
                            <button 
                                type="button" 
                                className="btn-premium-secondary"
                                onClick={() => handleDownloadTemplate(uploadType)}
                            >
                                📥 Download formatted template for {uploadType.toUpperCase()}
                            </button>
                        </div>
                    </div>

                    <div className="admin-card-glass">
                        <h2 className="admin-card-title">Upload Excel Sheet</h2>
                        <form onSubmit={handleUploadSubmit}>
                            <div className={`premium-dropzone ${selectedFile ? 'has-file' : ''}`}>
                                <input 
                                    type="file" 
                                    id="dyod-excel-upload"
                                    className="file-input-hidden" 
                                    accept=".xlsx, .xls"
                                    onChange={handleFileChange}
                                />
                                <div className="dropzone-icon">{selectedFile ? '📄' : '📁'}</div>
                                <div className="dropzone-text">
                                    {selectedFile ? selectedFile.name : "Drag & drop your Excel file here, or click to select"}
                                </div>
                                <div className="dropzone-subtext">
                                    {selectedFile 
                                        ? `Size: ${(selectedFile.size / 1024).toFixed(1)} KB` 
                                        : "Only .xlsx and .xls formats are supported"}
                                </div>
                            </div>

                            <button 
                                type="submit" 
                                className="btn-premium-primary" 
                                style={{ width: '100%' }}
                                disabled={loading || !selectedFile}
                            >
                                {loading ? (
                                    <><span className="spinner-premium"></span> Importing Data...</>
                                ) : (
                                    <>🚀 Process & Import Upload</>
                                )}
                            </button>
                        </form>

                        {/* Feedback Console Output */}
                        {uploadConsole && (
                            <div className="upload-feedback-console">
                                <div className="console-header">
                                    <div className="console-title">
                                        <span>🖥️</span> System Bulk Import Console
                                    </div>
                                    <div>STATUS: COMPLETED</div>
                                </div>
                                {uploadType === 'courses' ? (
                                    <>
                                        <div className="console-line success">✅ Added: {uploadConsole.added} course catalogs</div>
                                        <div className="console-line warning">🔄 Updated: {uploadConsole.updated} course catalogs</div>
                                        <div className="console-line error">❌ Failed: {uploadConsole.failed} records</div>
                                    </>
                                ) : (
                                    <>
                                        <div className="console-line success">✅ Processed: {uploadConsole.processed} rows</div>
                                        <div className="console-line error">❌ Failed: {uploadConsole.failed} rows</div>
                                    </>
                                )}

                                {uploadConsole.errors && uploadConsole.errors.length > 0 && (
                                    <div>
                                        <div style={{ color: '#94a3b8', marginTop: '10px', fontWeight: 'bold' }}>Console Error Logs:</div>
                                        <ul className="error-details-list">
                                            {uploadConsole.errors.map((err, idx) => (
                                                <li key={idx}>⚠️ {err}</li>
                                            ))}
                                        </ul>
                                    </div>
                                )}
                            </div>
                        )}
                    </div>
                </div>
            )}

            {/* TAB 2: INTERACTIVE BUILDER */}
            {activeTab === 'builder' && (
                <div className="tab-content animate-fade">
                    <div className="builder-layout-grid">
                        
                        {/* Sidebar: Path Selection & Generation */}
                        <div className="sidebar-panel">
                            
                            {/* Path Search & List */}
                            <div className="admin-card-glass" style={{ padding: '1.5rem' }}>
                                <h3 className="admin-card-title" style={{ fontSize: '1.1rem', marginBottom: '1rem' }}>
                                    🎯 Select Degree Path
                                </h3>
                                <input 
                                    type="text" 
                                    className="admin-input" 
                                    placeholder="Search paths (e.g. CSE-HTE)..."
                                    value={pathSearchQuery}
                                    onChange={(e) => setPathSearchQuery(e.target.value)}
                                    style={{ marginBottom: '1rem' }}
                                />
                                <div className="interactive-list-group">
                                    {filteredPaths.length ? filteredPaths.map(p => (
                                        <div 
                                            key={p.id} 
                                            className={`list-item-selectable ${Number(selectedPathId) === p.id ? 'selected' : ''}`}
                                            onClick={() => setSelectedPathId(String(p.id))}
                                        >
                                            <div className="list-item-title">{p.pathCode}</div>
                                            <div className="list-item-subtitle">
                                                {p.department?.deptCode} • {p.degreeType?.typeCode} • {p.addonType?.addonCode} {p.addonName && `(${p.addonName})`}
                                            </div>
                                            <div style={{ fontSize: '0.75rem', color: 'var(--slate-700)', display: 'flex', justifyContent: 'space-between', marginTop: '4px' }}>
                                                <span>Credits: {p.totalCredits}</span>
                                                <button 
                                                    className="btn-delete-icon" 
                                                    onClick={(e) => { e.stopPropagation(); handleDeletePath(p.id, p.pathCode); }}
                                                    title="Delete Path"
                                                >
                                                    🗑️
                                                </button>
                                            </div>
                                        </div>
                                    )) : <div style={{ color: 'var(--slate-700)', padding: '10px', fontSize: '0.9rem' }}>No paths matching query.</div>}
                                </div>
                            </div>

                            {/* Create Path form */}
                            <div className="admin-card-glass" style={{ padding: '1.5rem' }}>
                                <h3 className="admin-card-title" style={{ fontSize: '1.1rem', marginBottom: '1rem' }}>
                                    ✨ Generate Path
                                </h3>
                                <form onSubmit={handleGeneratePath}>
                                    <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                                        <div>
                                            <label className="admin-label">Department</label>
                                            <select 
                                                className="admin-select"
                                                value={pathForm.deptCode}
                                                onChange={(e) => setPathForm({ ...pathForm, deptCode: e.target.value })}
                                            >
                                                <option value="CSE">CSE</option>
                                                <option value="AIDS">AIDS</option>
                                                <option value="CSIT">CSIT</option>
                                                <option value="EEE">EEE</option>
                                                <option value="MECH">MECH</option>
                                                <option value="CIVIL">CIVIL</option>
                                                <option value="ECE">ECE</option>
                                            </select>
                                        </div>
                                        <div>
                                            <label className="admin-label">Degree Type</label>
                                            <select 
                                                className="admin-select"
                                                value={pathForm.typeCode}
                                                onChange={(e) => setPathForm({ ...pathForm, typeCode: e.target.value })}
                                            >
                                                <option value="REGULAR">REGULAR</option>
                                                <option value="HONORS">HONORS</option>
                                                <option value="HTE">HTE</option>
                                                <option value="HTI">HTI</option>
                                                <option value="HTR">HTR</option>
                                            </select>
                                        </div>
                                        <div>
                                            <label className="admin-label">Add-on Type</label>
                                            <select 
                                                className="admin-select"
                                                value={pathForm.addonCode}
                                                onChange={(e) => setPathForm({ ...pathForm, addonCode: e.target.value })}
                                            >
                                                <option value="NONE">NONE</option>
                                                <option value="SPECIALIZATION">SPECIALIZATION</option>
                                                <option value="MINOR">MINOR</option>
                                                <option value="DOUBLE_MAJOR">DOUBLE MAJOR</option>
                                            </select>
                                        </div>
                                        {pathForm.addonCode !== 'NONE' && (
                                            <div>
                                                <label className="admin-label">Add-on Name</label>
                                                <input 
                                                    type="text" 
                                                    className="admin-input" 
                                                    placeholder="e.g. Data Science"
                                                    value={pathForm.addonName}
                                                    onChange={(e) => setPathForm({ ...pathForm, addonName: e.target.value })}
                                                    required
                                                />
                                            </div>
                                        )}
                                        <div>
                                            <label className="admin-label">Required Credits</label>
                                            <input 
                                                type="number" 
                                                className="admin-input" 
                                                value={pathForm.totalCredits}
                                                onChange={(e) => setPathForm({ ...pathForm, totalCredits: Number(e.target.value) })}
                                                min="100" 
                                                max="300"
                                            />
                                        </div>
                                        <button 
                                            type="submit" 
                                            className="btn-premium-primary" 
                                            disabled={loading}
                                            style={{ marginTop: '10px' }}
                                        >
                                            Create Path
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        {/* Right Panel: Selected Path Configurations */}
                        <div className="main-panel">
                            {selectedPathId ? (
                                <div className="accordion-wrapper">
                                    {/* Display Header */}
                                    <div className="admin-card-glass" style={{ background: 'linear-gradient(135deg, #0f172a 0%, #1e293b 100%)', color: 'white', padding: '1.75rem' }}>
                                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                                            <div>
                                                <span style={{ fontSize: '0.8rem', color: '#38bdf8', fontWeight: 'bold', textTransform: 'uppercase' }}>Active Path</span>
                                                <h2 style={{ fontSize: '1.75rem', fontWeight: 800, margin: '4px 0' }}>{selectedPathObj?.pathCode}</h2>
                                                <p style={{ color: '#94a3b8', fontSize: '0.9rem', margin: 0 }}>
                                                    {selectedPathObj?.department?.deptName} ({selectedPathObj?.regulation?.regCode} Regulation)
                                                </p>
                                            </div>
                                            <div style={{ textAlign: 'right' }}>
                                                <div style={{ fontSize: '2rem', fontWeight: 800, color: 'white' }}>{selectedPathObj?.totalCredits}</div>
                                                <div style={{ fontSize: '0.75rem', color: '#94a3b8', textTransform: 'uppercase', fontWeight: 'bold' }}>Target Credits</div>
                                            </div>
                                        </div>
                                    </div>

                                    {/* SECTION 1: BUCKET REQUIREMENTS */}
                                    <div className="accordion-section">
                                        <div 
                                            className="accordion-header"
                                            onClick={() => setExpandedAccordion(expandedAccordion === 'requirements' ? '' : 'requirements')}
                                        >
                                            <span>🗂️ Bucket Credit Requirements ({pathRequirements.length})</span>
                                            <span>{expandedAccordion === 'requirements' ? '▲' : '▼'}</span>
                                        </div>
                                        {expandedAccordion === 'requirements' && (
                                            <div className="accordion-body">
                                                {/* Form */}
                                                <form onSubmit={handleAddRequirement} className="admin-card-glass" style={{ background: '#f8fafc', padding: '1.25rem', marginBottom: '1.5rem' }}>
                                                    <h4 style={{ margin: '0 0 1rem 0' }}>Add Bucket Target</h4>
                                                    <div className="form-grid-2">
                                                        <div>
                                                            <label className="admin-label">Select Bucket</label>
                                                            <select 
                                                                className="admin-select"
                                                                value={requirementForm.bucketId}
                                                                onChange={(e) => setRequirementForm({ ...requirementForm, bucketId: e.target.value })}
                                                                required
                                                            >
                                                                <option value="">-- Choose Bucket --</option>
                                                                {buckets.map(b => (
                                                                    <option key={b.id} value={b.id}>{b.bucketCode} - {b.bucketName}</option>
                                                                ))}
                                                            </select>
                                                        </div>
                                                        <div>
                                                            <label className="admin-label">Required Credits</label>
                                                            <input 
                                                                type="number" 
                                                                className="admin-input" 
                                                                value={requirementForm.requiredCredits}
                                                                onChange={(e) => setRequirementForm({ ...requirementForm, requiredCredits: e.target.value })}
                                                                min="0"
                                                                required
                                                            />
                                                        </div>
                                                        <div>
                                                            <label className="admin-label">Min Courses (Optional)</label>
                                                            <input 
                                                                type="number" 
                                                                className="admin-input" 
                                                                value={requirementForm.minCourses}
                                                                onChange={(e) => setRequirementForm({ ...requirementForm, minCourses: e.target.value })}
                                                                min="1"
                                                            />
                                                        </div>
                                                        <div style={{ display: 'flex', alignItems: 'center' }}>
                                                            <label className="checkbox-label">
                                                                <input 
                                                                    type="checkbox"
                                                                    checked={requirementForm.isMandatory}
                                                                    onChange={(e) => setRequirementForm({ ...requirementForm, isMandatory: e.target.checked })}
                                                                />
                                                                Is Mandatory Bucket
                                                            </label>
                                                        </div>
                                                    </div>
                                                    <button type="submit" className="btn-premium-primary" disabled={loading}>
                                                        Add Target
                                                    </button>
                                                </form>

                                                {/* Table */}
                                                <div className="table-container-premium">
                                                    <table className="table-premium">
                                                        <thead>
                                                            <tr>
                                                                <th>Bucket Code</th>
                                                                <th>Bucket Name</th>
                                                                <th>Required Credits</th>
                                                                <th>Min Courses</th>
                                                                <th>Type</th>
                                                                <th>Action</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            {pathRequirements.length ? pathRequirements.map(req => (
                                                                <tr key={req.id}>
                                                                    <td><code>{req.bucket?.bucketCode}</code></td>
                                                                    <td>{req.bucket?.bucketName}</td>
                                                                    <td><strong>{req.requiredCredits}</strong> credits</td>
                                                                    <td>{req.minCourses || 'No Limit'}</td>
                                                                    <td>
                                                                        <span className={`status-badge ${req.isMandatory ? 'mandatory' : 'optional'}`}>
                                                                            {req.isMandatory ? 'MANDATORY' : 'OPTIONAL'}
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        <button 
                                                                            type="button" 
                                                                            className="btn-delete-icon"
                                                                            onClick={() => handleDeleteRequirement(req.id)}
                                                                        >
                                                                            🗑️
                                                                        </button>
                                                                    </td>
                                                                </tr>
                                                            )) : (
                                                                <tr>
                                                                    <td colSpan="6" style={{ textAlign: 'center', color: 'var(--slate-700)' }}>
                                                                        No requirements configured for this degree path.
                                                                    </td>
                                                                </tr>
                                                            )}
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        )}
                                    </div>

                                    {/* SECTION 2: COURSE MAPPINGS */}
                                    <div className="accordion-section">
                                        <div 
                                            className="accordion-header"
                                            onClick={() => setExpandedAccordion(expandedAccordion === 'mappings' ? '' : 'mappings')}
                                        >
                                            <span>🔗 Path-Specific Course Bucket Mappings ({activePathMappings.length})</span>
                                            <span>{expandedAccordion === 'mappings' ? '▲' : '▼'}</span>
                                        </div>
                                        {expandedAccordion === 'mappings' && (
                                            <div className="accordion-body">
                                                {/* Form */}
                                                <form onSubmit={handleAddMapping} className="admin-card-glass" style={{ background: '#f8fafc', padding: '1.25rem', marginBottom: '1.5rem' }}>
                                                    <h4 style={{ margin: '0 0 1rem 0' }}>Map Course to Bucket</h4>
                                                    <div className="form-grid-2">
                                                        <div>
                                                            <label className="admin-label">Select Course</label>
                                                            <select 
                                                                className="admin-select"
                                                                value={mappingForm.courseId}
                                                                onChange={(e) => setMappingForm({ ...mappingForm, courseId: e.target.value })}
                                                                required
                                                            >
                                                                <option value="">-- Choose Course --</option>
                                                                {courses.map(c => (
                                                                    <option key={c.id} value={c.id}>{c.courseCode} - {c.courseName}</option>
                                                                ))}
                                                            </select>
                                                        </div>
                                                        <div>
                                                            <label className="admin-label">Map to Bucket</label>
                                                            <select 
                                                                className="admin-select"
                                                                value={mappingForm.bucketId}
                                                                onChange={(e) => setMappingForm({ ...mappingForm, bucketId: e.target.value })}
                                                                required
                                                            >
                                                                <option value="">-- Choose Bucket --</option>
                                                                {buckets.map(b => (
                                                                    <option key={b.id} value={b.id}>{b.bucketCode} - {b.bucketName}</option>
                                                                ))}
                                                            </select>
                                                        </div>
                                                        <div style={{ display: 'flex', alignItems: 'center' }}>
                                                            <label className="checkbox-label">
                                                                <input 
                                                                    type="checkbox"
                                                                    checked={mappingForm.isMandatory}
                                                                    onChange={(e) => setMappingForm({ ...mappingForm, isMandatory: e.target.checked })}
                                                                />
                                                                Is Mandatory Course in Bucket
                                                            </label>
                                                        </div>
                                                    </div>
                                                    <button type="submit" className="btn-premium-primary" disabled={loading}>
                                                        Add Mapping
                                                    </button>
                                                </form>

                                                {/* Table */}
                                                <div className="table-container-premium">
                                                    <table className="table-premium">
                                                        <thead>
                                                            <tr>
                                                                <th>Course Code</th>
                                                                <th>Course Name</th>
                                                                <th>Credits</th>
                                                                <th>Mapped Bucket</th>
                                                                <th>Scope</th>
                                                                <th>Action</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            {activePathMappings.length ? activePathMappings.map(map => (
                                                                <tr key={map.id}>
                                                                    <td><code>{map.course?.courseCode}</code></td>
                                                                    <td>{map.course?.courseName}</td>
                                                                    <td>{map.course?.credits}</td>
                                                                    <td><code>{map.bucket?.bucketCode}</code></td>
                                                                    <td>
                                                                        <span className={`status-badge ${map.isMandatory ? 'mandatory' : 'optional'}`}>
                                                                            {map.isMandatory ? 'MANDATORY' : 'ELECTIVE'}
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        <button 
                                                                            type="button" 
                                                                            className="btn-delete-icon"
                                                                            onClick={() => handleDeleteMapping(map.id)}
                                                                        >
                                                                            🗑️
                                                                        </button>
                                                                    </td>
                                                                </tr>
                                                            )) : (
                                                                <tr>
                                                                    <td colSpan="6" style={{ textAlign: 'center', color: 'var(--slate-700)' }}>
                                                                        No course mappings found for this degree path.
                                                                    </td>
                                                                </tr>
                                                            )}
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        )}
                                    </div>
                                </div>
                            ) : (
                                <div className="admin-card-glass" style={{ textAlign: 'center', padding: '5rem 2rem', color: 'var(--slate-700)' }}>
                                    <span style={{ fontSize: '3.5rem', display: 'block', marginBottom: '1.5rem' }}>👉</span>
                                    <h3>No Degree Path Selected</h3>
                                    <p>Select an active degree path from the sidebar list, or generate a new path to build its bucket rules.</p>
                                </div>
                            )}
                        </div>

                    </div>
                </div>
            )}

            {/* TAB 3: MASTER DATA SETTINGS */}
            {activeTab === 'master' && (
                <div className="tab-content animate-fade">
                    {/* Dashboard Mini-stats grid */}
                    <div className="stats-cards-grid">
                        <div className="mini-stats-card">
                            <div className="count">{stats.buckets || 0}</div>
                            <div className="label">Buckets</div>
                        </div>
                        <div className="mini-stats-card">
                            <div className="count">{stats.degreePaths || 0}</div>
                            <div className="label">Paths</div>
                        </div>
                        <div className="mini-stats-card">
                            <div className="count">{stats.courses || 0}</div>
                            <div className="label">Catalog Courses</div>
                        </div>
                        <div className="mini-stats-card">
                            <div className="count">{stats.courseMappings || 0}</div>
                            <div className="label">Mappings</div>
                        </div>
                        <div className="mini-stats-card">
                            <div className="count">{stats.departments || 0}</div>
                            <div className="label">Departments</div>
                        </div>
                    </div>

                    <div className="form-grid-2">
                        {/* Add Bucket Form */}
                        <div className="admin-card-glass">
                            <h2 className="admin-card-title">🆕 Create Bucket Master</h2>
                            <form onSubmit={handleCreateBucket}>
                                <div style={{ display: 'flex', flexDirection: 'column', gap: '15px' }}>
                                    <div>
                                        <label className="admin-label">Bucket Code</label>
                                        <input 
                                            type="text" 
                                            className="admin-input" 
                                            placeholder="e.g. PCC-CORE, PE-1, HAS-CORE"
                                            value={newBucketForm.bucketCode}
                                            onChange={(e) => setNewBucketForm({ ...newBucketForm, bucketCode: e.target.value.toUpperCase().trim() })}
                                            required
                                        />
                                    </div>
                                    <div>
                                        <label className="admin-label">Bucket Name</label>
                                        <input 
                                            type="text" 
                                            className="admin-input" 
                                            placeholder="e.g. Professional Core Courses"
                                            value={newBucketForm.bucketName}
                                            onChange={(e) => setNewBucketForm({ ...newBucketForm, bucketName: e.target.value })}
                                            required
                                        />
                                    </div>
                                    <div>
                                        <label className="admin-label">Category Grouping</label>
                                        <select 
                                            className="admin-select"
                                            value={newBucketForm.bucketCategory}
                                            onChange={(e) => setNewBucketForm({ ...newBucketForm, bucketCategory: e.target.value })}
                                        >
                                            <option value="Humanities">Humanities</option>
                                            <option value="Basic Sciences">Basic Sciences</option>
                                            <option value="Engineering Sciences">Engineering Sciences</option>
                                            <option value="Professional Core">Professional Core</option>
                                            <option value="Program Electives">Program Electives</option>
                                            <option value="Open Electives">Open Electives</option>
                                            <option value="Honors">Honors</option>
                                            <option value="Minor">Minor</option>
                                            <option value="Skill Development">Skill Development</option>
                                            <option value="Project & Research">Project & Research</option>
                                            <option value="Audit">Audit</option>
                                        </select>
                                    </div>
                                    <div>
                                        <label className="admin-label">Description (Optional)</label>
                                        <textarea 
                                            className="admin-textarea" 
                                            rows="2"
                                            placeholder="Provide detail about the bucket constraints"
                                            value={newBucketForm.description}
                                            onChange={(e) => setNewBucketForm({ ...newBucketForm, description: e.target.value })}
                                        />
                                    </div>
                                    <button type="submit" className="btn-premium-primary" disabled={loading}>
                                        Save Bucket
                                    </button>
                                </div>
                            </form>
                        </div>

                        {/* List of Buckets */}
                        <div className="admin-card-glass" style={{ display: 'flex', flexDirection: 'column' }}>
                            <h2 className="admin-card-title">📂 Bucket Master List ({buckets.length})</h2>
                            <div className="table-container-premium" style={{ flexGrow: 1, maxHeight: '420px', overflowY: 'auto' }}>
                                <table className="table-premium">
                                    <thead>
                                        <tr>
                                            <th>Code</th>
                                            <th>Bucket Name</th>
                                            <th>Category</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {buckets.map(b => (
                                            <tr key={b.id}>
                                                <td><code>{b.bucketCode}</code></td>
                                                <td>{b.bucketName}</td>
                                                <td>{b.bucketCategory}</td>
                                            </tr>
                                        ))}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
