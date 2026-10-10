import React from 'react';
import { Routes, Route, Link, useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import FacultyDashboard from './FacultyDashboard';
import BulkUpload from './BulkUpload';
import UploadCourses from './UploadCourses';
import FacultyStudentDetail from './FacultyStudentDetail';
import FacultyExitClearance from './FacultyExitClearance';
import FacultyExitReports from './FacultyExitReports';
import AddStudent from '../../admin/AddStudent';
import './faculty.css';

export default function FacultyNavBar() {
    const { logout } = useAuth();
    const navigate = useNavigate();
    const location = useLocation();

    const handleLogout = () => {
        logout();
        navigate('/login');
    };

    const user = JSON.parse(localStorage.getItem('user') || '{}');

    const getPageTitle = () => {
        if (location.pathname.includes('/faculty/exit-reports')) return 'Student Exit Requirement';
        if (location.pathname.includes('/faculty/exit-clearance')) return 'Exit Clearance';
        if (location.pathname.includes('/faculty/upload-courses')) return 'Upload Courses';
        if (location.pathname.includes('/faculty/upload')) return 'Register Students (Bulk)';
        if (location.pathname.includes('/faculty/addstudent')) return 'Add Student';
        return 'Dashboard';
    };

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
                    <Link to="/faculty/exit-reports" className={location.pathname.includes('/faculty/exit-reports') ? 'active' : ''}>
                        <span className="icon">📋</span> Student Exit Requirement
                    </Link>
                    <Link to="/faculty/exit-clearance" className={location.pathname.includes('/faculty/exit-clearance') ? 'active' : ''}>
                        <span className="icon">🎓</span> Exit Clearance
                    </Link>
                    <Link to="/faculty/upload" className={location.pathname === '/faculty/upload' ? 'active' : ''}>
                        <span className="icon">🚀</span> Register Students (Bulk)
                    </Link>
                    <Link to="/faculty/addstudent" className={location.pathname === '/faculty/addstudent' ? 'active' : ''}>
                        <span className="icon">👤</span> Add Student (Single)
                    </Link>
                    <Link to="/faculty/upload-courses" className={location.pathname === '/faculty/upload-courses' ? 'active' : ''}>
                        <span className="icon">📚</span> Upload Courses
                    </Link>
                </nav>

                <div className="sidebar-footer">
                    <div className="user-profile">
                        <div className="avatar">{user.firstName?.[0] || 'F'}{user.lastName?.[0] || 'A'}</div>
                        <div className="info">
                            <strong>{user.firstName} {user.lastName}</strong>
                            <span>{user.department} Faculty</span>
                        </div>
                    </div>
                    <button onClick={handleLogout} className="logout-btn">
                        🚪 Logout
                    </button>
                </div>
            </aside>

            <main className="faculty-main">
                <div className="faculty-top-bar">
                    <div className="breadcrumb">
                        Faculty / <span>{getPageTitle()}</span>
                    </div>
                    <div className="user-info">
                        <span className="user-role">{user.department ? `${user.department} Faculty` : 'Faculty'}</span>
                        <div className="user-avatar">{user.firstName?.[0] || 'F'}{user.lastName?.[0] || 'A'}</div>
                        <button onClick={handleLogout} className="topbar-logout-btn" title="Logout">
                            <span>🚪 Logout</span>
                        </button>
                    </div>
                </div>

                <Routes>
                    <Route path="home" element={<FacultyDashboard />} />
                    <Route path="exit-reports" element={<FacultyExitReports />} />
                    <Route path="exit-reports/:studentId" element={<FacultyExitReports />} />
                    <Route path="exit-clearance" element={<FacultyExitClearance />} />
                    <Route path="exit-clearance/:studentId" element={<FacultyExitClearance />} />
                    <Route path="upload" element={<BulkUpload />} />
                    <Route path="addstudent" element={<AddStudent />} />
                    <Route path="upload-courses" element={<UploadCourses />} />
                    <Route path="student/:studentId" element={<FacultyStudentDetail />} />
                </Routes>
            </main>
        </div>
    );
}
