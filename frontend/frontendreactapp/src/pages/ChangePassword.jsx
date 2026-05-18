import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import api from '../api';
import './login.css'; // Reusing visual background animations and page structure

export default function ChangePassword() {
    const { user, updateUser, logout } = useAuth();
    const navigate = useNavigate();
    const [newPassword, setNewPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [error, setError] = useState('');
    const [message, setMessage] = useState('');
    const [loading, setLoading] = useState(false);

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError('');
        setMessage('');

        if (!newPassword || newPassword.length < 6) {
            setError('Password must be at least 6 characters long.');
            return;
        }

        if (newPassword !== confirmPassword) {
            setError('Passwords do not match.');
            return;
        }

        setLoading(true);
        try {
            await api.post('/auth/change-password', { newPassword });
            
            setMessage('Password updated successfully! Redirecting...');
            
            // Update auth state so forcePasswordChange is cleared
            updateUser({ forcePasswordChange: false });

            // Navigate to respective homes after 1.5 seconds
            setTimeout(() => {
                if (user?.role === 'SUPER_ADMIN') {
                    navigate('/super_admin/home');
                } else if (user?.role === 'FACULTY') {
                    navigate('/faculty/home');
                } else if (user?.role === 'STUDENT') {
                    navigate('/student/home');
                } else {
                    navigate('/login');
                }
            }, 1500);
        } catch (err) {
            setError(err.response?.data || 'Failed to update password. Please try again.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="login-page">
            <div className="login-visual">
                <div className="visual-content">
                    <h1>Secure <span className="highlight">Your Profile</span></h1>
                    <p>Setup a new strong password to verify your identity and protect your academic records.</p>
                </div>
                <div className="visual-overlay"></div>
            </div>
            
            <div className="login-form-container animate-fade">
                <div className="login-card">
                    <div className="logo-section">
                        <div className="logo-icon">KL</div>
                        <h2>Reset Password</h2>
                        <p>Hello, {user?.firstName || 'User'}! Please update your initial password to secure your account.</p>
                    </div>

                    <form onSubmit={handleSubmit}>
                        <div className="form-group">
                            <label>New Password</label>
                            <input 
                                type="password" 
                                className="input-field"
                                placeholder="Min. 6 characters"
                                value={newPassword}
                                onChange={(e) => setNewPassword(e.target.value)}
                                required
                            />
                        </div>
                        <div className="form-group">
                            <label>Confirm New Password</label>
                            <input 
                                type="password" 
                                className="input-field"
                                placeholder="Confirm your password"
                                value={confirmPassword}
                                onChange={(e) => setConfirmPassword(e.target.value)}
                                required
                            />
                        </div>
                        
                        {error && <div className="login-error">⚠️ {error}</div>}
                        {message && <div style={{ color: '#10B981', fontWeight: 600, marginTop: '1rem', textAlign: 'center' }}>🎉 {message}</div>}

                        <button type="submit" className="btn-primary login-btn" disabled={loading}>
                            {loading ? "Updating..." : "Update & Continue"}
                        </button>
                    </form>

                    <div className="login-footer" style={{ marginTop: '2rem' }}>
                        <p>Want to sign out? <button onClick={logout} style={{ background: 'none', border: 'none', color: '#E11D48', fontWeight: 600, cursor: 'pointer', textDecoration: 'underline' }}>Logout</button></p>
                    </div>
                </div>
            </div>
        </div>
    );
}
