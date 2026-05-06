import React from 'react';
import { Link, Route, Routes, useNavigate, useLocation } from 'react-router-dom';
import FacultyHome from './FacultyHome';
import ViewAllStudents from './ViewAllStudents';
import ViewStudentCourses_basedonStudentId from './ViewStudentCourses_basedonStudentId';
import ViewAllStudents_basedonCourseid from './ViewAllStudents_basedonCourseid';
import '../admin/admin.css';

export default function FacultyNavBar() {
    const navigate = useNavigate();
    const location = useLocation();
    const [sidebarOpen, setSidebarOpen] = React.useState(false);

    const facultyLogout = () => {
        sessionStorage.removeItem("isFaculty");
        navigate("/");
        window.location.reload();
    };

    const navItems = [
        { path: 'home', label: 'Faculty Dashboard', icon: '🏠' },
        { path: 'viewallstudents', label: 'All Students', icon: '👥' },
        { path: 'viewstudents-bycourse', label: 'Search by Course', icon: '📚' },
        { path: 'viewcourses-bystudent', label: 'Search by Student', icon: '🔍' },
    ];

    return (
        <div className="admin-layout">
            {/* Mobile Overlay */}
            {sidebarOpen && <div className="sidebar-overlay" onClick={() => setSidebarOpen(false)}></div>}
            
            <aside className={`sidebar ${sidebarOpen ? 'open' : ''}`}>
                <div className="sidebar-header">
                    <div className="brand-container">
                        <div className="admin-badge">KL</div>
                        <div className="brand-text">
                            <h3>CreditCore</h3>
                            <span>Faculty Portal</span>
                        </div>
                    </div>
                </div>
                
                <nav className="sidebar-nav">
                    <div className="nav-group">
                        <span className="group-label">Academic Tools</span>
                        {navItems.map((item) => (
                            <Link 
                                key={item.path} 
                                to={item.path} 
                                className={`nav-item ${location.pathname.includes(item.path) ? 'active' : ''}`}
                                onClick={() => setSidebarOpen(false)}
                            >
                                <span className="nav-icon">{item.icon}</span>
                                <span className="nav-label">{item.label}</span>
                                {location.pathname.includes(item.path) && <span className="active-indicator"></span>}
                            </Link>
                        ))}
                    </div>
                </nav>

                <div className="sidebar-footer">
                    <div className="admin-profile-mini">
                        <div className="user-avatar" style={{background: '#0369A1'}}>F</div>
                        <div className="user-info-mini">
                            <strong>Faculty Member</strong>
                            <span>Course Instructor</span>
                        </div>
                    </div>
                    <button onClick={facultyLogout} className="logout-button">
                        <span className="nav-icon">🚪</span>
                        <span className="nav-label">Logout</span>
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
                            Faculty / <span>{navItems.find(i => location.pathname.includes(i.path))?.label || 'Home'}</span>
                        </div>
                    </div>
                    <div className="user-info">
                        <span className="user-role">Authorized Faculty</span>
                        <div className="user-avatar" style={{background: '#0369A1'}}>F</div>
                    </div>
                </div>

                <div className="content-area animate-fade">
                    <Routes>
                        <Route index element={<FacultyHome/>}/>
                        <Route path="home" element={<FacultyHome/>}/>
                        <Route path="viewallstudents" element={<ViewAllStudents/>}/>
                        <Route path="viewcourses-bystudent" element={<ViewStudentCourses_basedonStudentId/>}/>
                        <Route path="viewstudents-bycourse" element={<ViewAllStudents_basedonCourseid/>}/>
                    </Routes>
                </div>
            </main>
        </div>
    );
}
