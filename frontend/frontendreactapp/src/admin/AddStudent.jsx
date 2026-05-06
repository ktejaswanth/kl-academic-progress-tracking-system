import api from '../api';
import React, { useState } from 'react';

export default function AddStudent() {
    const [formdata, setFormData] = useState({
        username: "",
        firstName: "",
        lastName: "",
        email: "",
        department: "REGULAR",
        subDepartment: "",
        specializationType: "NONE",
        specializationName: "",
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
                subDepartment: "",
                specializationType: "NONE",
                specializationName: "",
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
                            <label>Department</label>
                            <select name="department" className="input-field" value={formdata.department} onChange={handleChange}>
                                <option value="REGULAR">Regular</option>
                                <option value="HONOR">Honors</option>
                                <option value="HTE">HTE</option>
                                <option value="HTR">HTR</option>
                                <option value="HTI">HTI</option>
                            </select>
                        </div>
                        <div className="form-group">
                            <label>Sub-Department</label>
                            <input 
                                type="text" 
                                name="subDepartment" 
                                value={formdata.subDepartment} 
                                className="input-field"
                                onChange={handleChange}
                                placeholder="e.g. AI & ML"
                            />
                        </div>
                        <div className="form-group">
                            <label>Specialization Type</label>
                            <select name="specializationType" className="input-field" value={formdata.specializationType} onChange={handleChange}>
                                <option value="NONE">None</option>
                                <option value="MINOR">Minor</option>
                                <option value="DOUBLE_MAJOR">Double Major</option>
                                <option value="SPECIALIZATION">Specialization</option>
                            </select>
                        </div>
                        <div className="form-group">
                            <label>Specialization Name</label>
                            <input 
                                type="text" 
                                name="specializationName" 
                                value={formdata.specializationName} 
                                className="input-field"
                                onChange={handleChange}
                                placeholder="e.g. Data Science"
                            />
                        </div>
                        <div className="form-group full-width">
                            <label>Initial Password</label>
                            <div className="password-input-wrapper">
                                <input 
                                    type="text" 
                                    name="password" 
                                    value={formdata.password} 
                                    className="input-field"
                                    required 
                                    onChange={handleChange}
                                    placeholder="••••••••"
                                />
                                <button 
                                    type="button" 
                                    className="btn-generate" 
                                    onClick={() => setFormData({...formdata, password: Math.random().toString(36).slice(-8).toUpperCase()})}
                                >
                                    ✨ Auto-Generate
                                </button>
                            </div>
                        </div>
                    </div>

                    {message && <div className="alert success">{message}</div>}
                    {error && <div className="alert error">{error}</div>}

                    <div className="form-actions">
                        <button type="submit" className="btn-primary" disabled={loading}>
                            {loading ? "⚡ Creating Profile..." : "✅ Create Student Account"}
                        </button>
                    </div>
                </form>
            </div>

            <style>{`
                .form-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                    gap: 1.5rem;
                    margin-bottom: 2rem;
                }
                @media (max-width: 768px) {
                    .form-grid { grid-template-columns: 1fr; }
                }

                .modern-form {
                    max-width: 900px;
                    margin: 0 auto;
                }

                .form-group {
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                }
                .form-group label {
                    font-weight: 600;
                    color: #475569;
                    font-size: 0.9rem;
                    margin-left: 4px;
                }
                .full-width { grid-column: 1 / -1; }
                
                .password-input-wrapper {
                    display: flex;
                    gap: 12px;
                }
                .btn-generate {
                    background: #F8FAFC;
                    color: #E11D48;
                    border: 1px solid #E2E8F0;
                    padding: 0 20px;
                    border-radius: 10px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.2s;
                    white-space: nowrap;
                }
                .btn-generate:hover {
                    background: #FFF1F2;
                    border-color: #E11D48;
                    transform: scale(1.02);
                }

                .form-actions {
                    margin-top: 3rem;
                    display: flex;
                    justify-content: flex-end;
                    padding-top: 2rem;
                    border-top: 1px dashed #E2E8F0;
                }
                .form-actions .btn-primary {
                    min-width: 250px;
                    padding: 1rem 2rem;
                    font-size: 1.1rem;
                }

                .alert {
                    padding: 1rem;
                    border-radius: 12px;
                    margin-bottom: 1.5rem;
                    font-weight: 500;
                }
                .alert.success { background: #DCFCE7; color: #15803D; border: 1px solid #BBF7D0; }
                .alert.error { background: #FEE2E2; color: #B91C1C; border: 1px solid #FECACA; }
            `}</style>
        </div>
    );
}
