import React from 'react';
import { Link, Route, Routes, useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import StudentDashboard from './StudentDashboard';
import StudentProfile from './StudentProfile';
import '../../admin/admin.css'; // Reusing layout styles

export default function StudentNavBar() {
    const { logout } = useAuth();
    const navigate = useNavigate();
    const location = useLocation();

    const handleLogout = () => {
        logout();
        navigate('/login');
    };

    const navItems = [
        { path: '/student/home', label: 'Progress Dashboard', icon: '📈' },
        { path: '/student/courses', label: 'My Courses', icon: '📚' },
        { path: '/student/profile', label: 'My Profile', icon: '👤' },
    ];

    return (
        <div className="admin-layout">
            <aside className="sidebar">
                <div className="sidebar-header">
                    <div className="admin-badge">KL</div>
                    <h3>Student Portal</h3>
                </div>
                
                <nav className="sidebar-nav">
                    {navItems.map((item) => (
                        <Link 
                            key={item.path} 
                            to={item.path} 
                            className={`nav-item ${location.pathname.includes(item.path) ? 'active' : ''}`}
                        >
                            <span className="nav-icon">{item.icon}</span>
                            <span className="nav-label">{item.label}</span>
                        </Link>
                    ))}
                </nav>

                <div className="sidebar-footer">
                    <button onClick={handleLogout} className="logout-button">
                        <span className="nav-icon">🚪</span>
                        <span className="nav-label">Logout</span>
                    </button>
                </div>
            </aside>

            <main className="admin-main">
                <div className="top-bar">
                    <div className="breadcrumb">
                        Student / <span>{navItems.find(i => location.pathname.includes(i.path))?.label || 'Dashboard'}</span>
                    </div>
                    <div className="user-info">
                        <span className="user-role">Regular Track</span>
                        <div className="user-avatar">ST</div>
                    </div>
                </div>

                <div className="content-area animate-fade">
                    <Routes>
                        <Route path="home" element={<StudentDashboard />} />
                        <Route path="courses" element={<div>Coming Soon: Detailed Course View</div>} />
                        <Route path="profile" element={<StudentProfile />} />
                        <Route index element={<StudentDashboard />} />
                    </Routes>
                </div>
            </main>
        </div>
    );
}
