import React, { useState } from 'react';
import api from '../api';
import './login.css';

export default function ForgotPassword() {
    const [email, setEmail] = useState('');
    const [message, setMessage] = useState('');
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);
        setMessage('');
        setError('');
        try {
            const response = await api.post(`/auth/forgot-password?email=${email}`);
            setMessage("A reset link has been simulated in the backend logs. In production, this would be an email.");
        } catch (err) {
            setError(err.response?.data || "Failed to initiate password reset.");
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
                        <h2>Recover Password</h2>
                        <p>Enter your email to receive a reset link</p>
                    </div>

                    <form onSubmit={handleSubmit}>
                        <div className="form-group">
                            <label>Email Address</label>
                            <input 
                                type="email" 
                                className="input-field"
                                placeholder="name@university.edu"
                                value={email}
                                onChange={(e) => setEmail(e.target.value)}
                                required
                            />
                        </div>

                        {message && <div className="alert success">{message}</div>}
                        {error && <div className="alert error">{error}</div>}

                        <button type="submit" className="btn-primary login-btn" disabled={loading}>
                            {loading ? "Processing..." : "Send Reset Link"}
                        </button>
                    </form>

                    <div className="login-footer">
                        <p><a href="/login">Back to Login</a></p>
                    </div>
                </div>
            </div>
        </div>
    );
}
