import React, { useEffect, useState } from 'react';
import api from '../../api';

export default function StudentProfile() {
    const [profile, setProfile] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    
    // Change password fields
    const [newPassword, setNewPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [pwError, setPwError] = useState('');
    const [pwSuccess, setPwSuccess] = useState('');
    const [updating, setUpdating] = useState(false);

    useEffect(() => {
        const fetchProfile = async () => {
            try {
                const response = await api.get('/student/profile');
                setProfile(response.data);
            } catch (err) {
                setError('Failed to fetch profile details.');
            } finally {
                setLoading(false);
            }
        };
        fetchProfile();
    }, []);

    const handleChangePassword = async (e) => {
        e.preventDefault();
        setPwError('');
        setPwSuccess('');

        if (!newPassword || newPassword.length < 6) {
            setPwError('New password must be at least 6 characters long.');
            return;
        }

        if (newPassword !== confirmPassword) {
            setPwError('Passwords do not match.');
            return;
        }

        setUpdating(true);
        try {
            await api.post('/auth/change-password', { newPassword });
            setPwSuccess('Password changed successfully!');
            setNewPassword('');
            setConfirmPassword('');
        } catch (err) {
            setPwError(err.response?.data || 'Failed to change password. Please try again.');
        } finally {
            setUpdating(false);
        }
    };

    if (loading) {
        return (
            <div className="loader-container" style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', height: '60vh' }}>
                <div className="loader"></div>
                <p style={{ marginTop: '1rem', color: '#64748B', fontWeight: 500 }}>Loading Profile Information...</p>
            </div>
        );
    }

    if (error) {
        return <div className="alert error" style={{ margin: '2rem' }}>⚠️ {error}</div>;
    }

    return (
        <div className="profile-container animate-fade">
            <header className="page-header" style={{ marginBottom: '2rem' }}>
                <h1>My Profile</h1>
                <p>Manage your academic identity, tracks, and security credentials.</p>
            </header>

            <div className="profile-grid">
                {/* Academic Identity Details */}
                <div className="profile-card info-card">
                    <div className="card-header">
                        <span className="card-icon">👤</span>
                        <h3>Academic Identity</h3>
                    </div>
                    
                    <div className="info-list">
                        <div className="info-item">
                            <span className="info-label">Full Name</span>
                            <span className="info-value">{profile?.firstName} {profile?.lastName}</span>
                        </div>
                        <div className="info-item">
                            <span className="info-label">Student ID</span>
                            <span className="info-value"><code>{profile?.username}</code></span>
                        </div>
                        <div className="info-item">
                            <span className="info-label">Email Address</span>
                            <span className="info-value">{profile?.email}</span>
                        </div>
                        <div className="info-item">
                            <span className="info-label">Department</span>
                            <span className="info-value-pill dept">{profile?.department || 'N/A'}</span>
                        </div>
                        <div className="info-item">
                            <span className="info-label">Academic Track (Sub-Dept)</span>
                            <span className="info-value-pill sub-dept">{profile?.subDepartment || 'N/A'}</span>
                        </div>
                        <div className="info-item">
                            <span className="info-label">Specialization Type</span>
                            <span className="info-value">{profile?.specializationType || 'NONE'}</span>
                        </div>
                        <div className="info-item">
                            <span className="info-label">Specialization Name</span>
                            <span className="info-value">{profile?.specializationName || 'N/A'}</span>
                        </div>
                    </div>
                </div>

                {/* Password & Security */}
                <div className="profile-card security-card">
                    <div className="card-header">
                        <span className="card-icon">🔒</span>
                        <h3>Security Settings</h3>
                    </div>
                    <p className="section-desc">Keep your account secure by changing your password periodically.</p>
                    
                    <form onSubmit={handleChangePassword} className="security-form">
                        <div className="form-group">
                            <label>New Password</label>
                            <input 
                                type="password" 
                                className="input-field" 
                                placeholder="Enter new password"
                                value={newPassword}
                                onChange={(e) => setNewPassword(e.target.value)}
                                required
                            />
                        </div>
                        
                        <div className="form-group">
                            <label>Confirm Password</label>
                            <input 
                                type="password" 
                                className="input-field" 
                                placeholder="Re-type new password"
                                value={confirmPassword}
                                onChange={(e) => setConfirmPassword(e.target.value)}
                                required
                            />
                        </div>

                        {pwError && <div className="alert error mini-alert">⚠️ {pwError}</div>}
                        {pwSuccess && <div className="alert success mini-alert">✅ {pwSuccess}</div>}

                        <button type="submit" className="btn-primary update-btn" disabled={updating}>
                            {updating ? "Saving..." : "Change Password"}
                        </button>
                    </form>
                </div>
            </div>

            <style>{`
                .profile-container {
                    max-width: 1100px;
                    margin: 0 auto;
                    padding-bottom: 4rem;
                }
                .profile-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(450px, 1fr));
                    gap: 2rem;
                }
                @media (max-width: 768px) {
                    .profile-grid { grid-template-columns: 1fr; }
                }

                .profile-card {
                    background: white;
                    border-radius: 24px;
                    padding: 2.5rem;
                    box-shadow: 0 10px 30px rgba(0,0,0,0.03);
                    border: 1px solid #EDF2F7;
                    display: flex;
                    flex-direction: column;
                }
                .card-header {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    margin-bottom: 2rem;
                    border-bottom: 1px solid #F1F5F9;
                    padding-bottom: 1rem;
                }
                .card-icon {
                    font-size: 1.8rem;
                }
                .card-header h3 {
                    font-size: 1.4rem;
                    color: #0F172A;
                    margin: 0;
                }

                .info-list {
                    display: flex;
                    flex-direction: column;
                    gap: 1.25rem;
                }
                .info-item {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 4px 0;
                    border-bottom: 1px dashed #F1F5F9;
                }
                .info-item:last-child {
                    border-bottom: none;
                }
                .info-label {
                    color: #64748B;
                    font-weight: 600;
                    font-size: 0.95rem;
                }
                .info-value {
                    color: #0F172A;
                    font-weight: 700;
                    font-size: 0.95rem;
                }
                .info-value code {
                    font-family: 'JetBrains Mono', monospace;
                    font-weight: 700;
                }
                .info-value-pill {
                    font-size: 0.75rem;
                    font-weight: 800;
                    padding: 4px 12px;
                    border-radius: 6px;
                    text-transform: uppercase;
                }
                .info-value-pill.dept {
                    background: #EFF6FF;
                    color: #2563EB;
                    border: 1px solid #DBEAFE;
                }
                .info-value-pill.sub-dept {
                    background: #FFF1F2;
                    color: #E11D48;
                    border: 1px solid #FFE4E6;
                }

                .section-desc {
                    color: #64748B;
                    font-size: 0.95rem;
                    margin-bottom: 2rem;
                    line-height: 1.5;
                }

                .security-form {
                    display: flex;
                    flex-direction: column;
                    gap: 1.5rem;
                }
                .security-form .form-group {
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                }
                .security-form label {
                    font-weight: 600;
                    color: #475569;
                    font-size: 0.9rem;
                }

                .mini-alert {
                    padding: 10px 14px;
                    font-size: 0.85rem;
                    margin: 0;
                    border-radius: 8px;
                }
                
                .update-btn {
                    margin-top: 1rem;
                    padding: 12px;
                    font-size: 1rem;
                    font-weight: 700;
                }
            `}</style>
        </div>
    );
}
