import React from 'react';
import { Routes, Route, Link, useNavigate, useLocation } from 'react-router-dom';
import FacultyDashboard from './FacultyDashboard';
import BulkUpload from './BulkUpload';
import './faculty.css';

export default function FacultyNavBar() {
    const navigate = useNavigate();
    const location = useLocation();

    const handleLogout = () => {
        localStorage.removeItem('user');
        localStorage.removeItem('token');
        navigate('/login');
    };

    const user = JSON.parse(localStorage.getItem('user') || '{}');

    return (
        <div className="faculty-layout">
            <aside className="faculty-sidebar">
                <div className="sidebar-logo">
                    <div className="logo-box">KL</div>
                    <span>Faculty Portal</span>
                </div>

                <nav className="sidebar-nav">
                    <Link to="/faculty/home" className={location.pathname === '/faculty/home' ? 'active' : ''}>
                        <span className="icon">📊</span> Dashboard
                    </Link>
                    <Link to="/faculty/upload" className={location.pathname === '/faculty/upload' ? 'active' : ''}>
                        <span className="icon">🚀</span> Bulk Upload
                    </Link>
                </nav>

                <div className="sidebar-footer">
                    <div className="user-profile">
                        <div className="avatar">{user.firstName?.[0]}{user.lastName?.[0]}</div>
                        <div className="info">
                            <strong>{user.firstName} {user.lastName}</strong>
                            <span>{user.department} Faculty</span>
                        </div>
                    </div>
                    <button onClick={handleLogout} className="logout-btn">
                        Logout
                    </button>
                </div>
            </aside>

            <main className="faculty-main">
                <Routes>
                    <Route path="home" element={<FacultyDashboard />} />
                    <Route path="upload" element={<BulkUpload />} />
                </Routes>
            </main>
        </div>
    );
}
