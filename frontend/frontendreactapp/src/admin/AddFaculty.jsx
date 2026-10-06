import api from '../api';
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';

export default function AddFaculty() {
    const navigate = useNavigate();
    const [formdata, setFormData] = useState({
        empId: "",
        username: "",
        firstName: "",
        lastName: "",
        email: "",
        department: "CSE",
        designation: "Assistant Professor",
        cabinNo: "",
        contactNo: "",
        password: "",
        isActive: true
    });
    const [message, setMessage] = useState("");
    const [error, setError] = useState("");
    const [loading, setLoading] = useState(false);

    const handleChange = (e) => {
        const { name, value, type, checked } = e.target;
        const val = type === 'checkbox' ? checked : value;
        
        // Auto-sync username with empId if username is empty or identical
        if (name === "empId" && (!formdata.username || formdata.username === formdata.empId)) {
            setFormData(prev => ({ ...prev, empId: val, username: val }));
        } else {
            setFormData(prev => ({ ...prev, [name]: val }));
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);
        setMessage("");
        setError("");

        try {
            await api.post("/admin/faculty", {
                ...formdata,
                username: formdata.username || formdata.empId,
                role: 'FACULTY'
            });
            
            setMessage("Faculty account created successfully! Redirecting to faculty directory...");
            setTimeout(() => {
                navigate("/super_admin/viewallfaculty");
            }, 1200);
        } catch (err) {
            setError(err.response?.data || "Failed to create faculty account.");
            setLoading(false);
        }
    };

    return (
        <div className="admin-page-container">
            <header className="page-header">
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <div>
                        <h1>Faculty Recruitment</h1>
                        <p>Onboard new faculty members with complete academic and contact credentials.</p>
                    </div>
                    <button 
                        type="button" 
                        onClick={() => navigate('/super_admin/viewallfaculty')} 
                        className="btn-outline"
                    >
                        👨‍🏫 View All Faculty
                    </button>
                </div>
            </header>

            <div className="upload-card">
                <form className="modern-form" onSubmit={handleSubmit}>
                    <div className="form-grid">
                        <div className="form-group">
                            <label>Employee ID *</label>
                            <input 
                                type="text" 
                                name="empId" 
                                value={formdata.empId} 
                                className="input-field"
                                required 
                                onChange={handleChange}
                                placeholder="e.g. EMP32856"
                            />
                        </div>
                        <div className="form-group">
                            <label>Portal Username *</label>
                            <input 
                                type="text" 
                                name="username" 
                                value={formdata.username} 
                                className="input-field"
                                required 
                                onChange={handleChange}
                                placeholder="Login username"
                            />
                        </div>
                        <div className="form-group">
                            <label>First Name *</label>
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
                            <label>Last Name *</label>
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
                            <label>Faculty Email Address *</label>
                            <input 
                                type="email" 
                                name="email" 
                                value={formdata.email} 
                                className="input-field"
                                required 
                                onChange={handleChange}
                                placeholder="faculty@kluniversity.in"
                            />
                        </div>
                        <div className="form-group">
                            <label>Department *</label>
                            <select name="department" className="input-field" value={formdata.department} onChange={handleChange}>
                                <option value="CSE">Computer Science (CSE)</option>
                                <option value="AIDS">AI & Data Science (AIDS)</option>
                                <option value="ECE">Electronics (ECE)</option>
                                <option value="EEE">Electrical (EEE)</option>
                                <option value="MECH">Mechanical (MECH)</option>
                                <option value="CIVIL">Civil (CIVIL)</option>
                            </select>
                        </div>
                        <div className="form-group">
                            <label>Designation *</label>
                            <select name="designation" className="input-field" value={formdata.designation} onChange={handleChange}>
                                <option value="Assistant Professor">Assistant Professor</option>
                                <option value="Associate Professor">Associate Professor</option>
                                <option value="Professor">Professor</option>
                                <option value="HOD">Head of Department (HOD)</option>
                                <option value="Dean">Dean / Academic Director</option>
                            </select>
                        </div>
                        <div className="form-group">
                            <label>Cabin Number</label>
                            <input 
                                type="text" 
                                name="cabinNo" 
                                value={formdata.cabinNo} 
                                className="input-field"
                                onChange={handleChange}
                                placeholder="e.g. C-302, Block-L"
                            />
                        </div>
                        <div className="form-group">
                            <label>Contact Number</label>
                            <input 
                                type="tel" 
                                name="contactNo" 
                                value={formdata.contactNo} 
                                className="input-field"
                                onChange={handleChange}
                                placeholder="e.g. +91 9876543210"
                            />
                        </div>
                        <div className="form-group">
                            <label>Account Status</label>
                            <select 
                                name="isActive" 
                                className="input-field" 
                                value={formdata.isActive} 
                                onChange={(e) => setFormData({...formdata, isActive: e.target.value === 'true'})}
                            >
                                <option value="true">Active</option>
                                <option value="false">Inactive</option>
                            </select>
                        </div>
                        <div className="form-group full-width">
                            <label>Initial Security Password *</label>
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

                    {message && <div className="alert success"><span>✅</span> {message}</div>}
                    {error && <div className="alert error"><span>⚠️</span> {error}</div>}

                    <div className="form-actions">
                        <button type="submit" className="btn-primary" disabled={loading}>
                            {loading ? "⚡ Processing..." : "✅ Register Faculty Member"}
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
                }

                .btn-outline {
                    background: white;
                    color: #0F172A;
                    border: 1.5px solid #CBD5E1;
                    padding: 0.6rem 1.2rem;
                    border-radius: 10px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.2s;
                }
                .btn-outline:hover {
                    background: #F1F5F9;
                    border-color: #94A3B8;
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
                    padding: 1.25rem;
                    border-radius: 16px;
                    margin-bottom: 1.5rem;
                    font-weight: 600;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }
                .alert.success { background: #DCFCE7; color: #15803D; border: 1px solid #BBF7D0; }
                .alert.error { background: #FEE2E2; color: #B91C1C; border: 1px solid #FECACA; }

                @media (max-width: 768px) {
                    .form-grid { grid-template-columns: 1fr; }
                }
            `}</style>
        </div>
    );
}
