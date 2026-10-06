import api from '../api';
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';

export default function AddStudent() {
    const navigate = useNavigate();
    const [formdata, setFormData] = useState({
        studentId: "",
        academicYear: "Y23",
        firstName: "",
        lastName: "",
        email: "",
        department: "CSE",
        subDepartment: "REGULAR",
        specializationType: "NONE",
        specializationName: "",
        password: "",
        isActive: true
    });
    const [message, setMessage] = useState("");
    const [error, setError] = useState("");
    const [loading, setLoading] = useState(false);

    const handleChange = (e) => {
        const { name, value, type, checked } = e.target;
        setFormData({ ...formdata, [name]: type === 'checkbox' ? checked : value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);
        setMessage("");
        setError("");

        try {
            await api.post("/admin/students", {
                ...formdata,
                username: formdata.studentId,
                role: 'STUDENT'
            });
            
            setMessage("Student account created successfully! Redirecting to student directory...");
            setTimeout(() => {
                navigate("/super_admin/viewallstudents");
            }, 1200);
        } catch (err) {
            setError(err.response?.data || "Failed to create student. Please check the details.");
            setLoading(false);
        }
    };

    return (
        <div className="admin-page-container">
            <header className="page-header">
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <div>
                        <h1>Manual Student Registration</h1>
                        <p>Create a single student record with academic and specialization details.</p>
                    </div>
                    <button 
                        type="button" 
                        onClick={() => navigate('/super_admin/viewallstudents')} 
                        className="btn-outline"
                    >
                        👥 View All Students
                    </button>
                </div>
            </header>

            <div className="upload-card">
                <form className="modern-form" onSubmit={handleSubmit}>
                    <div className="form-grid">
                        <div className="form-group">
                            <label>Student ID (Username) *</label>
                            <input 
                                type="text" 
                                name="studentId" 
                                value={formdata.studentId} 
                                className="input-field"
                                required 
                                onChange={handleChange}
                                placeholder="e.g. 2300030001"
                            />
                        </div>
                        <div className="form-group">
                            <label>Academic Year *</label>
                            <select 
                                name="academicYear" 
                                className="input-field" 
                                value={formdata.academicYear} 
                                onChange={handleChange}
                            >
                                <option value="Y23">Y23</option>
                                <option value="Y24">Y24</option>
                                <option value="Y25">Y25</option>
                                <option value="Y26">Y26</option>
                            </select>
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
                            <label>Student Email Address *</label>
                            <input 
                                type="email" 
                                name="email" 
                                value={formdata.email} 
                                className="input-field"
                                required 
                                onChange={handleChange}
                                placeholder="student@kluniversity.in"
                            />
                        </div>
                        <div className="form-group">
                            <label>Department *</label>
                            <select 
                                name="department" 
                                className="input-field" 
                                value={formdata.department} 
                                onChange={handleChange}
                            >
                                <option value="CSE">Computer Science (CSE)</option>
                                <option value="AIDS">AI & Data Science (AIDS)</option>
                                <option value="ECE">Electronics (ECE)</option>
                                <option value="EEE">Electrical (EEE)</option>
                                <option value="MECH">Mechanical (MECH)</option>
                                <option value="CIVIL">Civil (CIVIL)</option>
                            </select>
                        </div>
                        <div className="form-group">
                            <label>Add-on</label>
                            <select name="subDepartment" className="input-field" value={formdata.subDepartment} onChange={handleChange}>
                                <option value="REGULAR">Regular (None)</option>
                                <option value="HONOR">Honors</option>
                                <option value="HTE">HTE</option>
                                <option value="HTR">HTR</option>
                                <option value="HTI">HTI</option>
                            </select>
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
                                placeholder="e.g. Artificial Intelligence"
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
                            {loading ? "⚡ Creating Student..." : "✅ Register Student Account"}
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
                    padding: 1rem 1.25rem;
                    border-radius: 12px;
                    margin-bottom: 1.5rem;
                    font-weight: 600;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }
                .alert.success { background: #DCFCE7; color: #15803D; border: 1px solid #BBF7D0; }
                .alert.error { background: #FEE2E2; color: #B91C1C; border: 1px solid #FECACA; }
            `}</style>
        </div>
    );
}
