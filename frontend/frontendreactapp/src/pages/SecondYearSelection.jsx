import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import './login.css';

export default function SecondYearSelection() {
    const [programs, setPrograms] = useState([]);
    const [versions, setVersions] = useState([]);
    const [specializations, setSpecializations] = useState([]);
    const [honorsPrograms, setHonorsPrograms] = useState([]);
    const [selection, setSelection] = useState({
        programId: '',
        versionId: '',
        specializationId: '',
        honorsId: '',
        extensionType: ''
    });
    const [error, setError] = useState('');
    const [success, setSuccess] = useState('');
    const [loading, setLoading] = useState(false);
    const navigate = useNavigate();

    useEffect(() => {
        const fetchPrograms = async () => {
            try {
                const response = await api.get('/onboarding/curriculum/programs');
                setPrograms(response.data || []);
            } catch {
                setError('Unable to load programs. Please try again later.');
            }
        };
        fetchPrograms();
    }, []);

    useEffect(() => {
        const fetchProgramDetails = async () => {
            if (!selection.programId) {
                setVersions([]);
                setSpecializations([]);
                setHonorsPrograms([]);
                return;
            }
            try {
                const [versionsResp, specializationsResp, honorsResp] = await Promise.all([
                    api.get(`/onboarding/curriculum/programs/${selection.programId}/curriculum-versions`),
                    api.get(`/onboarding/curriculum/programs/${selection.programId}/specializations`),
                    api.get(`/onboarding/curriculum/programs/${selection.programId}/honors`)
                ]);
                setVersions(versionsResp.data || []);
                setSpecializations(specializationsResp.data || []);
                setHonorsPrograms(honorsResp.data || []);
            } catch {
                setError('Unable to load curriculum options for selected program.');
            }
        };
        fetchProgramDetails();
    }, [selection.programId]);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setSelection((prev) => ({
            ...prev,
            [name]: value
        }));
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError('');
        setSuccess('');

        const stored = localStorage.getItem('firstLoginUser');
        const user = stored ? JSON.parse(stored) : null;
        if (!user?.userId) {
            setError('Student identity not found. Please verify your account again.');
            return;
        }

        if (!selection.programId || !selection.versionId) {
            setError('Please select a program and curriculum version.');
            return;
        }

        setLoading(true);
        try {
            await api.post('/onboarding/selection', {
                student: { id: user.userId },
                program: { id: Number(selection.programId) },
                curriculumVersion: { id: Number(selection.versionId) },
                specialization: selection.specializationId ? { id: Number(selection.specializationId) } : null,
                honorsProgram: selection.honorsId ? { id: Number(selection.honorsId) } : null,
                extensionType: selection.extensionType || null
            });
            setSuccess('Selection saved successfully. You can now login to continue.');
            setTimeout(() => navigate('/login'), 1400);
        } catch (err) {
            setError(err.response?.data || 'Failed to save selection.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="login-page">
            <div className="login-form-container animate-fade">
                <div className="login-card">
                    <div className="logo-section">
                        <div className="logo-icon">KL</div>
                        <h2>2nd Year Curriculum Selection</h2>
                        <p>Select your program track, curriculum version, and any honors or specialization options.</p>
                    </div>
                    <form onSubmit={handleSubmit}>
                        <div className="form-group">
                            <label>Program</label>
                            <select
                                name="programId"
                                className="input-field"
                                value={selection.programId}
                                onChange={handleChange}
                                required
                            >
                                <option value="">Choose program</option>
                                {programs.map((program) => (
                                    <option key={program.id} value={program.id}>
                                        {program.name} ({program.branch})
                                    </option>
                                ))}
                            </select>
                        </div>
                        <div className="form-group">
                            <label>Curriculum Version</label>
                            <select
                                name="versionId"
                                className="input-field"
                                value={selection.versionId}
                                onChange={handleChange}
                                required
                                disabled={!versions.length}
                            >
                                <option value="">Choose version</option>
                                {versions.map((version) => (
                                    <option key={version.id} value={version.id}>
                                        {version.versionName} {version.regulation ? `(${version.regulation})` : ''}
                                    </option>
                                ))}
                            </select>
                        </div>
                        <div className="form-group">
                            <label>Specialization (optional)</label>
                            <select
                                name="specializationId"
                                className="input-field"
                                value={selection.specializationId}
                                onChange={handleChange}
                                disabled={!specializations.length}
                            >
                                <option value="">No specialization</option>
                                {specializations.map((spec) => (
                                    <option key={spec.id} value={spec.id}>{spec.name}</option>
                                ))}
                            </select>
                        </div>
                        <div className="form-group">
                            <label>Honors Program (optional)</label>
                            <select
                                name="honorsId"
                                className="input-field"
                                value={selection.honorsId}
                                onChange={handleChange}
                                disabled={!honorsPrograms.length}
                            >
                                <option value="">No honors</option>
                                {honorsPrograms.map((honors) => (
                                    <option key={honors.id} value={honors.id}>{honors.name}</option>
                                ))}
                            </select>
                        </div>
                        <div className="form-group">
                            <label>Extension Type (optional)</label>
                            <input
                                type="text"
                                name="extensionType"
                                className="input-field"
                                value={selection.extensionType}
                                onChange={handleChange}
                                placeholder="e.g. Internship, Research, Extra Elective"
                            />
                        </div>
                        {error && <div className="login-error">{error}</div>}
                        {success && <div className="login-success">{success}</div>}
                        <button type="submit" className="btn-primary login-btn" disabled={loading}>
                            {loading ? 'Saving selection...' : 'Save Selection'}
                        </button>
                    </form>
                </div>
            </div>
        </div>
    );
}
