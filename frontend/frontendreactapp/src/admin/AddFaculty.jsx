import api from '../api';
import React, { useState } from 'react';

export default function AddFaculty() {
    const [formdata, setFormData] = useState({
        username: "",
        firstName: "",
        lastName: "",
        email: "",
        department: "CSE",
        designation: "Assistant Professor",
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
            const response = await api.post("/admin/faculty", {
                ...formdata,
                role: 'FACULTY'
            });
            
            setMessage("Faculty account created successfully!");
            setFormData({
                username: "",
                firstName: "",
                lastName: "",
                email: "",
                department: "CSE",
                designation: "Assistant Professor",
                password: ""
            });
        } catch (err) {
            setError(err.response?.data || "Failed to create faculty account.");
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="admin-page-container">
            <header className="page-header">
                <h1>Faculty Recruitment</h1>
                <p>Onboard new faculty members to the academic audit system.</p>
            </header>

            <div className="upload-card">
                <form className="modern-form" onSubmit={handleSubmit}>
                    <div className="form-grid">
                        <div className="form-group">
                            <label>Employee ID / Username</label>
                            <input 
                                type="text" 
                                name="username" 
                                value={formdata.username} 
                                className="input-field"
                                required 
                                onChange={handleChange}
                                placeholder="e.g. EMP123"
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
                                placeholder="faculty@university.edu"
                            />
                        </div>
                        <div className="form-group">
                            <label>Department</label>
                            <select name="department" className="input-field" value={formdata.department} onChange={handleChange}>
                                <option value="CSE">CSE</option>
                                <option value="ECE">ECE</option>
                                <option value="EEE">EEE</option>
                                <option value="MECH">Mechanical</option>
                                <option value="CIVIL">Civil</option>
                            </select>
                        </div>
                        <div className="form-group">
                            <label>Designation</label>
                            <select name="designation" className="input-field" value={formdata.designation} onChange={handleChange}>
                                <option value="Assistant Professor">Assistant Professor</option>
                                <option value="Associate Professor">Associate Professor</option>
                                <option value="Professor">Professor</option>
                                <option value="HOD">Head of Department</option>
                            </select>
                        </div>
                        <div className="form-group">
                            <label>Security Password</label>
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
                            {loading ? "Processing..." : "Register Faculty Member"}
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
