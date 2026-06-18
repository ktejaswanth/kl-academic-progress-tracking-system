import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import './login.css';

const defaultProfile = {
    degreeType: '',
    specialization: '',
    honorsType: '',
    branch: '',
    batch: '',
    currentYear: '2',
    section: '',
    honorsOption: '',
    extensionType: '',
    phoneNumber: '',
    address: ''
};

export default function ProfileSetup() {
    const [profile, setProfile] = useState(defaultProfile);
    const [error, setError] = useState('');
    const [success, setSuccess] = useState('');
    const [loading, setLoading] = useState(false);
    const navigate = useNavigate();

    const stored = localStorage.getItem('firstLoginUser');
    const user = stored ? JSON.parse(stored) : null;

    const handleChange = (e) => {
        setProfile({ ...profile, [e.target.name]: e.target.value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!user) {
            setError('Please verify your student account first.');
            return;
        }
        setLoading(true);
        setError('');
        setSuccess('');

        try {
            await api.post('/onboarding/profile-setup', {
                studentId: user.userId,
                ...profile,
                currentYear: Number(profile.currentYear)
            });
            setSuccess('Profile setup completed. Redirecting to next step...');
            setTimeout(() => {
                const yearValue = Number(profile.currentYear);
                if (yearValue === 2) {
                    navigate('/second-year-selection');
                } else {
                    navigate('/login');
                }
            }, 1200);
        } catch (err) {
            setError(err.response?.data || 'Unable to save profile.');
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
                        <h2>Set Up Your Student Profile</h2>
                        <p>Complete your onboarding information for curriculum planning.</p>
                    </div>
                    <form onSubmit={handleSubmit}>
                        <div className="form-grid">
                            <div className="form-group">
                                <label>Degree Type</label>
                                <input
                                    type="text"
                                    name="degreeType"
                                    className="input-field"
                                    value={profile.degreeType}
                                    onChange={handleChange}
                                    required
                                />
                            </div>
                            <div className="form-group">
                                <label>Specialization</label>
                                <input
                                    type="text"
                                    name="specialization"
                                    className="input-field"
                                    value={profile.specialization}
                                    onChange={handleChange}
                                />
                            </div>
                            <div className="form-group">
                                <label>Honors Type</label>
                                <input
                                    type="text"
                                    name="honorsType"
                                    className="input-field"
                                    value={profile.honorsType}
                                    onChange={handleChange}
                                />
                            </div>
                            <div className="form-group">
                                <label>Branch</label>
                                <input
                                    type="text"
                                    name="branch"
                                    className="input-field"
                                    value={profile.branch}
                                    onChange={handleChange}
                                    required
                                />
                            </div>
                            <div className="form-group">
                                <label>Batch</label>
                                <input
                                    type="text"
                                    name="batch"
                                    className="input-field"
                                    value={profile.batch}
                                    onChange={handleChange}
                                    required
                                />
                            </div>
                            <div className="form-group">
                                <label>Current Year</label>
                                <select
                                    name="currentYear"
                                    className="input-field"
                                    value={profile.currentYear}
                                    onChange={handleChange}
                                    required
                                >
                                    <option value="">Select your year</option>
                                    <option value="1">1st Year</option>
                                    <option value="2">2nd Year</option>
                                    <option value="3">3rd Year</option>
                                    <option value="4">4th Year</option>
                                </select>
                            </div>
                            <div className="form-group">
                                <label>Section</label>
                                <input
                                    type="text"
                                    name="section"
                                    className="input-field"
                                    value={profile.section}
                                    onChange={handleChange}
                                />
                            </div>
                            <div className="form-group">
                                <label>Honors / Minor Option</label>
                                <input
                                    type="text"
                                    name="honorsOption"
                                    className="input-field"
                                    value={profile.honorsOption}
                                    onChange={handleChange}
                                />
                            </div>
                            <div className="form-group">
                                <label>Extension Type</label>
                                <input
                                    type="text"
                                    name="extensionType"
                                    className="input-field"
                                    value={profile.extensionType}
                                    onChange={handleChange}
                                />
                            </div>
                            <div className="form-group">
                                <label>Phone Number</label>
                                <input
                                    type="tel"
                                    name="phoneNumber"
                                    className="input-field"
                                    value={profile.phoneNumber}
                                    onChange={handleChange}
                                />
                            </div>
                            <div className="form-group full-width">
                                <label>Address</label>
                                <textarea
                                    name="address"
                                    className="input-field"
                                    rows="3"
                                    value={profile.address}
                                    onChange={handleChange}
                                />
                            </div>
                        </div>
                        {error && <div className="login-error">{error}</div>}
                        {success && <div className="login-success">{success}</div>}
                        <button type="submit" className="btn-primary login-btn" disabled={loading}>
                            {loading ? 'Saving profile...' : 'Complete Profile'}
                        </button>
                    </form>
                </div>
            </div>
        </div>
    );
}
