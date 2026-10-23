import React, { useState } from 'react';
import { Link, Route, Routes, useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { StudentDataProvider } from './StudentDataContext';

import StudentDashboard from './StudentDashboard';
import AcademicProgressView from './AcademicProgressView';
import MyCourses from './MyCourses';
import DegreeRequirementsView from './DegreeRequirementsView';
import MyDegreePathView from './MyDegreePathView';
import SpecializationMinorView from './SpecializationMinorView';
import GraduationEligibilityView from './GraduationEligibilityView';
import RecommendedCoursesView from './RecommendedCoursesView';
import CourseCatalogueView from './CourseCatalogueView';
import SemesterPerformanceView from './SemesterPerformanceView';
import NotificationsView from './NotificationsView';
import ReportsView from './ReportsView';
import StudentProfile from './StudentProfile';
import ReportIssue from './ReportIssue';
import StudentExitRequirements from './StudentExitRequirements';

import '../../admin/admin.css';

export default function StudentNavBar() {
    const { logout } = useAuth();
    const navigate = useNavigate();
    const location = useLocation();
    const [sidebarOpen, setSidebarOpen] = useState(false);

    const handleLogout = () => {
        logout();
        navigate('/login');
    };

    const isCurrent = (path) => location.pathname === path || location.pathname.startsWith(`${path}/`);

    const navItems = [
        { path: '/student/home', label: 'Dashboard', icon: '📊' },
        { path: '/student/progress', label: 'Academic Progress', icon: '📈' },
        { path: '/student/courses', label: 'My Courses', icon: '📚' },
        { path: '/student/requirements', label: 'Degree Requirements', icon: '📋' },
        { path: '/student/degree-path', label: 'My Degree Path', icon: '🗺️' },
        { path: '/student/specialization', label: 'Specialization / Minor', icon: '⭐' },
        { path: '/student/graduation-readiness', label: 'Graduation Eligibility', icon: '🎓' },
        { path: '/student/recommended-courses', label: 'Recommended Courses', icon: '🎯' },
        { path: '/student/catalogue', label: 'Course Catalogue', icon: '📖' },
        { path: '/student/semester-performance', label: 'Semester Performance', icon: '🏆' },
        { path: '/student/notifications', label: 'Notifications', icon: '🔔' },
        { path: '/student/reports', label: 'Reports & Downloads', icon: '📄' },
        { path: '/student/profile', label: 'Profile', icon: '👤' },
    ];

    return (
        <StudentDataProvider>
            <div className="admin-layout">
                {sidebarOpen && <div className="sidebar-overlay" onClick={() => setSidebarOpen(false)}></div>}

                <aside className={`sidebar ${sidebarOpen ? 'open' : ''}`} style={{ width: '280px', overflowY: 'auto' }}>
                    <div className="sidebar-header" style={{ borderBottom: '1px solid #E2E8F0', paddingBottom: '1.2rem' }}>
                        <div className="brand-container">
                            <div className="admin-badge" style={{ background: '#8B0000', color: 'white', fontWeight: 900 }}>KL</div>
                            <div className="brand-text">
                                <h3 style={{ margin: 0, fontSize: '1.2rem', color: '#0F172A', fontWeight: 800 }}>CreditCore</h3>
                                <span style={{ color: '#64748B', fontSize: '0.8rem', fontWeight: 600 }}>Student Portal</span>
                            </div>
                        </div>
                    </div>

                    <nav className="sidebar-nav" style={{ padding: '1rem 0' }}>
                        {navItems.map((item) => (
                            <Link
                                key={item.path}
                                to={item.path}
                                className={`nav-item ${isCurrent(item.path) ? 'active' : ''}`}
                                onClick={() => setSidebarOpen(false)}
                            >
                                <span className="nav-icon">{item.icon}</span>
                                <span className="nav-label">{item.label}</span>
                                {isCurrent(item.path) && <span className="active-indicator"></span>}
                            </Link>
                        ))}
                    </nav>

                    <div className="sidebar-footer" style={{ borderTop: '1px solid #E2E8F0', paddingTop: '1.2rem', marginTop: 'auto' }}>
                        <button onClick={handleLogout} className="logout-button" style={{ width: '100%' }}>
                            <span className="nav-icon">🚪</span>
                            <span className="nav-label">Sign Out</span>
                        </button>
                    </div>
                </aside>

                <main className="admin-main">
                    <div className="top-bar">
                        <div className="top-bar-left">
                            <button className="menu-toggle" onClick={() => setSidebarOpen(!sidebarOpen)}>
                                ☰
                            </button>
                            <div className="breadcrumb">
                                Student Portal / <span>{navItems.find(i => isCurrent(i.path))?.label || 'Dashboard'}</span>
                            </div>
                        </div>
                        <div className="user-info">
                            <span className="user-role">Student Account</span>
                            <div className="user-avatar" style={{ background: '#8B0000', color: 'white' }}>ST</div>
                            <button onClick={handleLogout} className="topbar-logout-btn" title="Sign Out">
                                <span>🚪 Logout</span>
                            </button>
                        </div>
                    </div>

                    <div className="content-area animate-fade" style={{ padding: '2rem' }}>
                        <Routes>
                            <Route path="home" element={<StudentDashboard />} />
                            <Route path="progress" element={<AcademicProgressView />} />
                            <Route path="courses" element={<MyCourses />} />
                            <Route path="requirements" element={<DegreeRequirementsView />} />
                            <Route path="degree-path" element={<MyDegreePathView />} />
                            <Route path="specialization" element={<SpecializationMinorView />} />
                            <Route path="graduation-readiness" element={<GraduationEligibilityView />} />
                            <Route path="recommended-courses" element={<RecommendedCoursesView />} />
                            <Route path="catalogue" element={<CourseCatalogueView />} />
                            <Route path="semester-performance" element={<SemesterPerformanceView />} />
                            <Route path="notifications" element={<NotificationsView />} />
                            <Route path="reports" element={<ReportsView />} />
                            <Route path="profile" element={<StudentProfile />} />
                            <Route path="exit-requirements" element={<StudentExitRequirements />} />
                            <Route path="issues" element={<ReportIssue />} />
                            <Route index element={<StudentDashboard />} />
                        </Routes>
                    </div>
                </main>
            </div>
        </StudentDataProvider>
    );
}
