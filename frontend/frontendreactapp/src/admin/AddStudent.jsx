import api from '../api';
import React, { useState } from 'react';

export default function AddStudent() {
    const [formdata, setFormData] = useState({
        username: "",
        firstName: "",
        lastName: "",
        email: "",
        department: "REGULAR",
        password: ""
    });
    const [message, setMessage] = useState("");
    const [error, setError] = useState("");
    const [loading, setLoading] = useState(false);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData({ ...formdata, [name]: value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);
        setMessage("");
        setError("");

        try {
            const response = await api.post("/admin/students", {
                ...formdata,
                role: 'STUDENT'
            });
            
            setMessage("Student account created successfully!");
            setFormData({
                username: "",
                firstName: "",
                lastName: "",
                email: "",
                department: "REGULAR",
                password: ""
            });
        } catch (err) {
            setError(err.response?.data || "Failed to create student. Please check the details.");
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="admin-page-container">
            <header className="page-header">
                <h1>Manual Student Registration</h1>
                <p>Create a single student account manually.</p>
            </header>

            <div className="upload-card">
                <form className="modern-form" onSubmit={handleSubmit}>
                    <div className="form-grid">
                        <div className="form-group">
                            <label>Student ID (Username)</label>
                            <input 
                                type="text" 
                                name="username" 
                                value={formdata.username} 
                                className="input-field"
                                required 
                                onChange={handleChange}
                                placeholder="e.g. 2100030001"
                            />
                        </div>
                        <div className="form-group">
                            <label>First Name</label>
                            <input 
                                type="text" 
                                name="firstName" 
                                value={formdata.firstName} 
                                className="input-field"
                                required 
                                onChange={handleChange}
                                placeholder="Enter first name"
                            />
                        </div>
                        <div className="form-group">
                            <label>Last Name</label>
                            <input 
                                type="text" 
                                name="lastName" 
                                value={formdata.lastName} 
                                className="input-field"
                                required 
                                onChange={handleChange}
                                placeholder="Enter last name"
                            />
                        </div>
                        <div className="form-group">
                            <label>Email Address</label>
                            <input 
                                type="email" 
                                name="email" 
                                value={formdata.email} 
                                className="input-field"
                                required 
                                onChange={handleChange}
                                placeholder="student@university.edu"
                            />
                        </div>
                        <div className="form-group">
                            <label>Department / Type</label>
                            <select name="department" className="input-field" value={formdata.department} onChange={handleChange}>
                                <option value="REGULAR">Regular</option>
                                <option value="HONOR">Honors</option>
                                <option value="HTE">HTE</option>
                                <option value="HTR">HTR</option>
                            </select>
                        </div>
                        <div className="form-group">
                            <label>Initial Password</label>
                            <input 
                                type="password" 
                                name="password" 
                                value={formdata.password} 
                                className="input-field"
                                required 
                                onChange={handleChange}
                                placeholder="••••••••"
                            />
                        </div>
                    </div>

                    {message && <div className="alert success">{message}</div>}
                    {error && <div className="alert error">{error}</div>}

                    <div className="form-actions" style={{ marginTop: '2rem' }}>
                        <button type="submit" className="btn-primary" disabled={loading}>
                            {loading ? "Creating..." : "Create Student Account"}
                        </button>
                    </div>
                </form>
            </div>

            <style>{`
                .form-grid {
                    display: grid;
                    grid-template-columns: repeat(2, 1fr);
                    gap: 1.5rem;
                }

                @media (max-width: 768px) {
                    .form-grid { grid-template-columns: 1fr; }
                }

                .modern-form {
                    max-width: 800px;
                    margin: 0 auto;
                }

                .form-group label {
                    display: block;
                    margin-bottom: 0.5rem;
                    font-weight: 600;
                    color: var(--text-main);
                    font-size: 0.9rem;
                }

                .form-actions {
                    text-align: center;
                }

                .btn-primary {
                    min-width: 250px;
                }
            `}</style>
        </div>
    );
}
