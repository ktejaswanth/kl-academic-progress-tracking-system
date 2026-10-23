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
    const [coursesSubmenuOpen, setCoursesSubmenuOpen] = useState(true);
    const [reqSubmenuOpen, setReqSubmenuOpen] = useState(true);

    const handleLogout = () => {
        logout();
        navigate('/login');
    };

    const isCurrent = (path) => location.pathname === path || location.pathname.startsWith(`${path}/`);

    const navItems = [
        { path: '/student/home', label: 'Dashboard', icon: '📊' },
        { path: '/student/progress', label: 'Academic Progress', icon: '📈' },
        {
            path: '/student/courses',
            label: 'My Courses',
            icon: '📚',
            isParent: true,
            isOpen: coursesSubmenuOpen,
            toggle: () => setCoursesSubmenuOpen(!coursesSubmenuOpen),
            subItems: [
                { path: '/student/courses?tab=current', label: 'Current Courses' },
                { path: '/student/courses?tab=completed', label: 'Completed Courses' },
                { path: '/student/courses?tab=all', label: 'Course History' },
                { path: '/student/courses?tab=failed', label: 'Failed / Reattempts' },
            ]
        },
        {
            path: '/student/requirements',
            label: 'Degree Requirements',
            icon: '📋',
            isParent: true,
            isOpen: reqSubmenuOpen,
            toggle: () => setReqSubmenuOpen(!reqSubmenuOpen),
            subItems: [
                { path: '/student/requirements?tab=all', label: 'All Requirements' },
                { path: '/student/requirements?tab=completed', label: 'Completed Requirements' },
                { path: '/student/requirements?tab=remaining', label: 'Remaining Requirements' },
            ]
        },
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
                    <div className="sidebar-header" style={{ borderBottom: '1px solid rgba(255,255,255,0.12)', paddingBottom: '1.2rem' }}>
                        <div className="brand-container">
                            <div className="admin-badge" style={{ background: '#FFD700', color: '#8B0000', fontWeight: 900 }}>KL</div>
                            <div className="brand-text">
                                <h3 style={{ margin: 0, fontSize: '1.2rem', color: 'white' }}>CreditCore</h3>
                                <span style={{ color: 'rgba(255,255,255,0.7)', fontSize: '0.8rem' }}>Student Portal</span>
                            </div>
                        </div>
                    </div>

                    <nav className="sidebar-nav" style={{ padding: '1rem 0' }}>
                        {navItems.map((item) => {
                            if (item.isParent) {
                                const activeParent = location.pathname.startsWith(item.path);
                                return (
                                    <div key={item.label} style={{ marginBottom: '4px' }}>
                                        <div
                                            onClick={() => {
                                                navigate(item.path);
                                                item.toggle();
                                            }}
                                            className={`nav-item ${activeParent ? 'active' : ''}`}
                                            style={{ cursor: 'pointer', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}
                                        >
                                            <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                                                <span className="nav-icon">{item.icon}</span>
                                                <span className="nav-label">{item.label}</span>
                                            </div>
                                            <span style={{ fontSize: '0.7rem', opacity: 0.8 }}>
                                                {item.isOpen ? '▼' : '▶'}
                                            </span>
                                        </div>

                                        {item.isOpen && (
                                            <div style={{ paddingLeft: '2.5rem', display: 'flex', flexDirection: 'column', gap: '4px', margin: '4px 0' }}>
                                                {item.subItems.map(sub => (
                                                    <Link
                                                        key={sub.label}
                                                        to={sub.path}
                                                        style={{
                                                            padding: '6px 12px',
                                                            borderRadius: '6px',
                                                            fontSize: '0.82rem',
                                                            color: 'rgba(255,255,255,0.85)',
                                                            textDecoration: 'none',
                                                            display: 'block',
                                                            transition: 'all 0.15s ease'
                                                        }}
                                                        onMouseEnter={(e) => { e.currentTarget.style.background = 'rgba(255,255,255,0.15)'; e.currentTarget.style.color = 'white'; }}
                                                        onMouseLeave={(e) => { e.currentTarget.style.background = 'transparent'; e.currentTarget.style.color = 'rgba(255,255,255,0.85)'; }}
                                                    >
                                                        • {sub.label}
                                                    </Link>
                                                ))}
                                            </div>
                                        )}
                                    </div>
                                );
                            }

                            return (
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
                            );
                        })}
                    </nav>

                    <div className="sidebar-footer" style={{ borderTop: '1px solid rgba(255,255,255,0.12)', paddingTop: '1.2rem', marginTop: 'auto' }}>
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
