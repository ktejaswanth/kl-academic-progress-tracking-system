import React, { useEffect, useState } from 'react';
import api from '../api';

export default function CurriculumAdmin() {
    const [programs, setPrograms] = useState([]);
    const [catalogCourses, setCatalogCourses] = useState([]);
    const [versions, setVersions] = useState([]);
    const [curriculumCourses, setCurriculumCourses] = useState([]);
    const [requirements, setRequirements] = useState([]);
    const [selectedProgramId, setSelectedProgramId] = useState('');
    const [selectedVersionId, setSelectedVersionId] = useState('');
    const [message, setMessage] = useState('');
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);

    const [programForm, setProgramForm] = useState({
        name: '',
        branch: '',
        batchStart: '',
        batchEnd: '',
        regulation: '',
        durationYears: 4
    });

    const [versionForm, setVersionForm] = useState({
        versionName: '',
        regulation: '',
        effectiveFrom: ''
    });

    const [requirementForm, setRequirementForm] = useState({
        bucketName: '',
        requiredCredits: 0,
        mandatoryCourseCodes: '',
        allowedElectives: ''
    });

    const [courseCatalogForm, setCourseCatalogForm] = useState({
        courseCode: '',
        courseName: '',
        credits: 3,
        category: '',
        offeredSemester: '',
        metadata: ''
    });

    const [curriculumCourseForm, setCurriculumCourseForm] = useState({
        courseId: '',
        bucketName: '',
        isMandatory: true,
        minYear: 1,
        maxYear: 4
    });

    useEffect(() => {
        fetchPrograms();
        fetchCatalogCourses();
    }, []);

    useEffect(() => {
        if (selectedProgramId) {
            fetchCurriculumVersions(selectedProgramId);
        }
    }, [selectedProgramId]);

    useEffect(() => {
        if (selectedVersionId) {
            fetchCurriculumCourses(selectedVersionId);
            fetchRequirements(selectedVersionId);
        } else {
            setRequirements([]);
        }
    }, [selectedVersionId]);

    const fetchPrograms = async () => {
        try {
            const response = await api.get('/admin/curriculum/programs');
            setPrograms(response.data || []);
        } catch {
            setError('Unable to load programs.');
        }
    };

    const fetchCatalogCourses = async () => {
        try {
            const response = await api.get('/admin/curriculum/courses');
            setCatalogCourses(response.data || []);
        } catch {
            // ignore if courses endpoint not present yet
        }
    };

    const fetchCurriculumVersions = async (programId) => {
        try {
            const response = await api.get(`/admin/curriculum/programs/${programId}/curriculum-versions`);
            setVersions(response.data || []);
        } catch {
            setError('Unable to load curriculum versions.');
        }
    };

    const fetchCurriculumCourses = async (versionId) => {
        try {
            const response = await api.get(`/admin/curriculum/curriculum-versions/${versionId}/courses`);
            setCurriculumCourses(response.data || []);
        } catch {
            setError('Unable to load curriculum courses.');
        }
    };

    const fetchRequirements = async (versionId) => {
        try {
            const response = await api.get(`/admin/curriculum/curriculum-versions/${versionId}/requirements`);
            setRequirements(response.data || []);
        } catch {
            setError('Unable to load curriculum requirements.');
        }
    };

    const handleProgramChange = (e) => {
        const { name, value } = e.target;
        setProgramForm({ ...programForm, [name]: value });
    };

    const handleVersionChange = (e) => {
        const { name, value } = e.target;
        setVersionForm({ ...versionForm, [name]: value });
    };

    const handleRequirementChange = (e) => {
        const { name, value } = e.target;
        setRequirementForm({ ...requirementForm, [name]: value });
    };

    const handleCatalogCourseChange = (e) => {
        const { name, value } = e.target;
        setCourseCatalogForm({ ...courseCatalogForm, [name]: value });
    };

    const handleCurriculumCourseChange = (e) => {
        const { name, value, type, checked } = e.target;
        setCurriculumCourseForm({
            ...curriculumCourseForm,
            [name]: type === 'checkbox' ? checked : value
        });
    };

    const handleSubmitProgram = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError('');
        setMessage('');

        try {
            await api.post('/admin/curriculum/programs', programForm);
            setMessage('Program created successfully.');
            setProgramForm({ name: '', branch: '', batchStart: '', batchEnd: '', regulation: '', durationYears: 4 });
            fetchPrograms();
        } catch (err) {
            setError(err.response?.data || 'Could not create program.');
        } finally {
            setLoading(false);
        }
    };

    const handleSubmitVersion = async (e) => {
        e.preventDefault();
        if (!selectedProgramId) {
            setError('Select a program first.');
            return;
        }
        setLoading(true);
        setError('');
        setMessage('');

        try {
            await api.post('/admin/curriculum/curriculum-versions', {
                ...versionForm,
                program: { id: selectedProgramId }
            });
            setMessage('Curriculum version created.');
            setVersionForm({ versionName: '', regulation: '', effectiveFrom: '' });
            fetchCurriculumVersions(selectedProgramId);
        } catch (err) {
            setError(err.response?.data || 'Could not create curriculum version.');
        } finally {
            setLoading(false);
        }
    };

    const handleSubmitRequirement = async (e) => {
        e.preventDefault();
        if (!selectedVersionId) {
            setError('Select a curriculum version first.');
            return;
        }
        setLoading(true);
        setError('');
        setMessage('');

        try {
            await api.post(`/admin/curriculum/curriculum-versions/${selectedVersionId}/requirements`, {
                ...requirementForm,
                mandatoryCourseCodes: requirementForm.mandatoryCourseCodes.split(',').map((code) => code.trim()).filter(Boolean),
                allowedElectives: requirementForm.allowedElectives.split(',').map((code) => code.trim()).filter(Boolean)
            });
            setMessage('Requirement added to curriculum version.');
            setRequirementForm({ bucketName: '', requiredCredits: 0, mandatoryCourseCodes: '', allowedElectives: '' });
        } catch (err) {
            setError(err.response?.data || 'Could not add requirement.');
        } finally {
            setLoading(false);
        }
    };

    const handleSubmitCatalogCourse = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError('');
        setMessage('');

        try {
            await api.post('/admin/curriculum/courses', {
                ...courseCatalogForm,
                metadata: courseCatalogForm.metadata || '{}'
            });
            setMessage('Course catalog entry created.');
            setCourseCatalogForm({ courseCode: '', courseName: '', credits: 3, category: '', offeredSemester: '', metadata: '' });
            fetchCatalogCourses();
        } catch (err) {
            setError(err.response?.data || 'Could not create course catalog entry.');
        } finally {
            setLoading(false);
        }
    };

    const handleSubmitCurriculumCourse = async (e) => {
        e.preventDefault();
        if (!selectedVersionId) {
            setError('Select a curriculum version first.');
            return;
        }
        setLoading(true);
        setError('');
        setMessage('');

        try {
            await api.post(`/admin/curriculum/curriculum-versions/${selectedVersionId}/courses`, {
                curriculumVersion: { id: selectedVersionId },
                course: { id: curriculumCourseForm.courseId },
                bucketName: curriculumCourseForm.bucketName,
                isMandatory: curriculumCourseForm.isMandatory,
                minYear: Number(curriculumCourseForm.minYear),
                maxYear: Number(curriculumCourseForm.maxYear)
            });
            setMessage('Curriculum course added.');
            setCurriculumCourseForm({ courseId: '', bucketName: '', isMandatory: true, minYear: 1, maxYear: 4 });
            fetchCurriculumCourses(selectedVersionId);
            fetchRequirements(selectedVersionId);
        } catch (err) {
            setError(err.response?.data || 'Could not add curriculum course.');
        } finally {
            setLoading(false);
        }
    };

    // const deleteProgram = async (programId) => {
    //     if (!window.confirm('Delete this program and all related curriculum data?')) return;
    //     try {
    //         await api.delete(`/admin/curriculum/programs/${programId}`);
    //         setMessage('Program deleted successfully.');
    //         fetchPrograms();
    //         if (selectedProgramId === String(programId)) {
    //             setSelectedProgramId('');
    //             setSelectedVersionId('');
    //             setVersions([]);
    //             setCurriculumCourses([]);
    //             setRequirements([]);
    //         }
    //     } catch (err) {
    //         setError(err.response?.data || 'Could not delete program.');
    //     }
    // };

    // const deleteVersion = async (versionId) => {
    //     if (!window.confirm('Delete this curriculum version?')) return;
    //     try {
    //         await api.delete(`/admin/curriculum/curriculum-versions/${versionId}`);
    //         setMessage('Curriculum version deleted successfully.');
    //         fetchCurriculumVersions(selectedProgramId);
    //         setSelectedVersionId('');
    //         setCurriculumCourses([]);
    //         setRequirements([]);
    //     } catch (err) {
    //         setError(err.response?.data || 'Could not delete version.');
    //     }
    // };

    // const deleteCatalogCourse = async (courseId) => {
    //     if (!window.confirm('Delete this catalog course?')) return;
    //     try {
    //         await api.delete(`/admin/curriculum/courses/${courseId}`);
    //         setMessage('Course deleted successfully.');
    //         fetchCatalogCourses();
    //     } catch (err) {
    //         setError(err.response?.data || 'Could not delete course.');
    //     }
    // };

    const deleteCurriculumCourse = async (courseId) => {
        if (!window.confirm('Delete this curriculum course mapping?')) return;
        try {
            await api.delete(`/admin/curriculum/curriculum-versions/${selectedVersionId}/courses/${courseId}`);
            setMessage('Curriculum course deleted successfully.');
            fetchCurriculumCourses(selectedVersionId);
        } catch (err) {
            setError(err.response?.data || 'Could not delete curriculum course.');
        }
    };

    const deleteRequirement = async (requirementId) => {
        if (!window.confirm('Delete this curriculum requirement?')) return;
        try {
            await api.delete(`/admin/curriculum/curriculum-versions/${selectedVersionId}/requirements/${requirementId}`);
            setMessage('Requirement deleted successfully.');
            fetchRequirements(selectedVersionId);
        } catch (err) {
            setError(err.response?.data || 'Could not delete requirement.');
        }
    };

    return (
        <div className="admin-page-container">
            <header className="page-header">
                <h1>Curriculum Management</h1>
                <p>Define degree programs, curriculum versions, required buckets, and linked course offerings.</p>
            </header>

            <div className="upload-card">
                <div className="section-grid">
                    <section className="section-card">
                        <h2>Create Degree Program</h2>
                        <form className="modern-form" onSubmit={handleSubmitProgram}>
                            <div className="form-grid">
                                <div className="form-group">
                                    <label>Program Name</label>
                                    <input name="name" value={programForm.name} className="input-field" onChange={handleProgramChange} required />
                                </div>
                                <div className="form-group">
                                    <label>Branch</label>
                                    <input name="branch" value={programForm.branch} className="input-field" onChange={handleProgramChange} required />
                                </div>
                                <div className="form-group">
                                    <label>Batch Start</label>
                                    <input name="batchStart" value={programForm.batchStart} className="input-field" onChange={handleProgramChange} required />
                                </div>
                                <div className="form-group">
                                    <label>Batch End</label>
                                    <input name="batchEnd" value={programForm.batchEnd} className="input-field" onChange={handleProgramChange} required />
                                </div>
                                <div className="form-group">
                                    <label>Regulation</label>
                                    <input name="regulation" value={programForm.regulation} className="input-field" onChange={handleProgramChange} />
                                </div>
                                <div className="form-group">
                                    <label>Duration Years</label>
                                    <input type="number" name="durationYears" value={programForm.durationYears} className="input-field" onChange={handleProgramChange} min="1" />
                                </div>
                            </div>
                            <button className="btn-primary" type="submit" disabled={loading}>Create Program</button>
                        </form>
                    </section>

                    <section className="section-card">
                        <h2>Program / Version Selection</h2>
                        <div className="form-grid">
                            <div className="form-group">
                                <label>Select Program</label>
                                <select className="input-field" value={selectedProgramId} onChange={(e) => setSelectedProgramId(e.target.value)}>
                                    <option value="">Choose program</option>
                                    {programs.map((program) => (
                                        <option key={program.id} value={program.id}>{program.name} ({program.branch})</option>
                                    ))}
                                </select>
                            </div>
                            <div className="form-group">
                                <label>Select Version</label>
                                <select className="input-field" value={selectedVersionId} onChange={(e) => setSelectedVersionId(e.target.value)}>
                                    <option value="">Choose version</option>
                                    {versions.map((version) => (
                                        <option key={version.id} value={version.id}>{version.versionName}</option>
                                    ))}
                                </select>
                            </div>
                        </div>

                        <h3>Current Programs</h3>
                        <ul className="compact-list">
                            {programs.map((program) => (
                                <li key={program.id}>{program.name} • {program.branch} • {program.batchStart}-{program.batchEnd}</li>
                            ))}
                        </ul>
                    </section>
                </div>

                <div className="section-grid">
                    <section className="section-card">
                        <h2>Create Curriculum Version</h2>
                        <form className="modern-form" onSubmit={handleSubmitVersion}>
                            <div className="form-grid">
                                <div className="form-group">
                                    <label>Version Name</label>
                                    <input name="versionName" value={versionForm.versionName} className="input-field" onChange={handleVersionChange} required />
                                </div>
                                <div className="form-group">
                                    <label>Effective From</label>
                                    <input type="date" name="effectiveFrom" value={versionForm.effectiveFrom} className="input-field" onChange={handleVersionChange} required />
                                </div>
                                <div className="form-group">
                                    <label>Regulation</label>
                                    <input name="regulation" value={versionForm.regulation} className="input-field" onChange={handleVersionChange} />
                                </div>
                            </div>
                            <button className="btn-primary" type="submit" disabled={loading}>Add Version</button>
                        </form>
                    </section>

                    <section className="section-card">
                        <h2>Add Curriculum Requirement</h2>
                        <form className="modern-form" onSubmit={handleSubmitRequirement}>
                            <div className="form-grid">
                                <div className="form-group">
                                    <label>Bucket Name</label>
                                    <input name="bucketName" value={requirementForm.bucketName} className="input-field" onChange={handleRequirementChange} required />
                                </div>
                                <div className="form-group">
                                    <label>Required Credits</label>
                                    <input type="number" name="requiredCredits" value={requirementForm.requiredCredits} className="input-field" onChange={handleRequirementChange} min="0" required />
                                </div>
                                <div className="form-group full-width">
                                    <label>Mandatory Course Codes</label>
                                    <input name="mandatoryCourseCodes" value={requirementForm.mandatoryCourseCodes} className="input-field" onChange={handleRequirementChange} placeholder="comma-separated codes" />
                                </div>
                                <div className="form-group full-width">
                                    <label>Allowed Electives</label>
                                    <input name="allowedElectives" value={requirementForm.allowedElectives} className="input-field" onChange={handleRequirementChange} placeholder="comma-separated codes" />
                                </div>
                            </div>
                            <button className="btn-primary" type="submit" disabled={loading}>Add Requirement</button>
                        </form>
                    </section>
                </div>

                <div className="section-grid">
                    <section className="section-card">
                        <h2>Create Course Catalog Entry</h2>
                        <form className="modern-form" onSubmit={handleSubmitCatalogCourse}>
                            <div className="form-grid">
                                <div className="form-group">
                                    <label>Course Code</label>
                                    <input name="courseCode" value={courseCatalogForm.courseCode} className="input-field" onChange={handleCatalogCourseChange} required />
                                </div>
                                <div className="form-group">
                                    <label>Course Name</label>
                                    <input name="courseName" value={courseCatalogForm.courseName} className="input-field" onChange={handleCatalogCourseChange} required />
                                </div>
                                <div className="form-group">
                                    <label>Credits</label>
                                    <input type="number" name="credits" value={courseCatalogForm.credits} className="input-field" onChange={handleCatalogCourseChange} min="1" required />
                                </div>
                                <div className="form-group">
                                    <label>Category</label>
                                    <input name="category" value={courseCatalogForm.category} className="input-field" onChange={handleCatalogCourseChange} />
                                </div>
                                <div className="form-group">
                                    <label>Offered Semester</label>
                                    <input name="offeredSemester" value={courseCatalogForm.offeredSemester} className="input-field" onChange={handleCatalogCourseChange} />
                                </div>
                                <div className="form-group full-width">
                                    <label>Metadata (JSON)</label>
                                    <input name="metadata" value={courseCatalogForm.metadata} className="input-field" onChange={handleCatalogCourseChange} placeholder='{"lab": true}' />
                                </div>
                            </div>
                            <button className="btn-primary" type="submit" disabled={loading}>Create Course</button>
                        </form>
                    </section>

                    <section className="section-card">
                        <h2>Add Course to Curriculum</h2>
                        <form className="modern-form" onSubmit={handleSubmitCurriculumCourse}>
                            <div className="form-grid">
                                <div className="form-group">
                                    <label>Select Catalog Course</label>
                                    <select name="courseId" value={curriculumCourseForm.courseId} className="input-field" onChange={handleCurriculumCourseChange} required>
                                        <option value="">Choose course</option>
                                        {catalogCourses.map((course) => (
                                            <option key={course.id} value={course.id}>{course.courseCode} - {course.courseName}</option>
                                        ))}
                                    </select>
                                </div>
                                <div className="form-group">
                                    <label>Bucket Name</label>
                                    <input name="bucketName" value={curriculumCourseForm.bucketName} className="input-field" onChange={handleCurriculumCourseChange} required />
                                </div>
                                <div className="form-group">
                                    <label>Min Year</label>
                                    <input type="number" name="minYear" value={curriculumCourseForm.minYear} className="input-field" onChange={handleCurriculumCourseChange} min="1" required />
                                </div>
                                <div className="form-group">
                                    <label>Max Year</label>
                                    <input type="number" name="maxYear" value={curriculumCourseForm.maxYear} className="input-field" onChange={handleCurriculumCourseChange} min="1" required />
                                </div>
                                <div className="form-group full-width checkbox-group">
                                    <label>
                                        <input type="checkbox" name="isMandatory" checked={curriculumCourseForm.isMandatory} onChange={handleCurriculumCourseChange} />
                                        {' '}Is Mandatory
                                    </label>
                                </div>
                            </div>
                            <button className="btn-primary" type="submit" disabled={loading}>Add Curriculum Course</button>
                        </form>
                    </section>
                </div>

                {message && <div className="alert success">{message}</div>}
                {error && <div className="alert error">{error}</div>}

                <section className="section-card">
                    <h2>Current Curriculum Courses</h2>
                    <div className="compact-list">
                        {curriculumCourses.length ? curriculumCourses.map((item) => (
                            <div key={item.id} className="list-item">
                                <div>
                                    {item.course?.courseCode} — {item.course?.courseName} <span>({item.bucketName})</span>
                                </div>
                                <button className="btn-secondary" type="button" onClick={() => deleteCurriculumCourse(item.id)}>
                                    Delete
                                </button>
                            </div>
                        )) : <p>No curriculum courses loaded for this version.</p>}
                    </div>
                </section>

                <section className="section-card">
                    <h2>Current Curriculum Requirements</h2>
                    <div className="compact-list">
                        {requirements.length ? requirements.map((req) => (
                            <div key={req.id} className="list-item">
                                <div>
                                    {req.bucketName} — {req.requiredCredits} credits
                                </div>
                                <button className="btn-secondary" type="button" onClick={() => deleteRequirement(req.id)}>
                                    Delete
                                </button>
                            </div>
                        )) : <p>No requirements loaded for this version.</p>}
                    </div>
                </section>
            </div>
        </div>
    );
}
