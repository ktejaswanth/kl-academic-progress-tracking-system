import React from 'react';
import { Link, Route, Routes, useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import AdminDashboard from './AdminDashboard';
import AddStudent from './AddStudent';
import BulkUpload from '../pages/faculty/BulkUpload';
import ViewAllStudents from './ViewAllStudents';
import AddFaculty from './AddFaculty';
import ViewAllFaculty from './ViewAllFaculty';
import AddAdmin from './AddAdmin';
import ViewAllAdmins from './ViewAllAdmins';
import CurriculumAdmin from '../pages/admin/CurriculumAdmin';
import UploadCourses from '../pages/faculty/UploadCourses';
import FacultyStudentDetail from '../pages/faculty/FacultyStudentDetail';
import ManageIssues from './ManageIssues';
import StudentLookupView from '../components/StudentLookupView';
import CurriculumUpload from './CurriculumUpload';
import CurriculumReview from './CurriculumReview';
import CurriculumRepository from './CurriculumRepository';
import AdminExitManagement from './AdminExitManagement';
import AdminExitReports from './AdminExitReports';
import './admin.css';

export default function AdminNavBar() {
    const { logout } = useAuth();
    const navigate = useNavigate();
    const location = useLocation();
    const [sidebarOpen, setSidebarOpen] = React.useState(false);

    const handleLogout = () => {
        logout();
        navigate('/login');
    };

    const navGroups = [
        {
            label: 'Main Menu',
            items: [
                { path: '/super_admin/home', label: 'Dashboard', icon: '📊' },
                { path: '/super_admin/exit-requirement-reports', label: 'Exit Requirement Reports', icon: '📋' },
                { path: '/super_admin/exit-requirements', label: 'Exit Clearances', icon: '🎓' },
                { path: '/super_admin/student-lookup', label: 'Student Lookup', icon: '🔍' },
                { path: '/super_admin/upload-courses', label: 'Upload Courses', icon: '📚' },
            ]
        },
        {
            label: 'Student Management',
            items: [
                { path: '/super_admin/addstudent', label: 'Add Student', icon: '👤' },
                { path: '/super_admin/viewallstudents', label: 'View Students', icon: '👥' },
                { path: '/super_admin/bulk-upload', label: 'Bulk Upload (Excel)', icon: '📁' },
                { path: '/super_admin/student-issues', label: 'Student Issues', icon: '⚠️' },
            ]
        },
        {
            label: 'Curriculum Management',
            items: [
                { path: '/super_admin/curriculum-upload', label: 'Upload Curriculum', icon: '📄' },
                { path: '/super_admin/curriculum-repository', label: 'Curriculum Repository', icon: '📚' },
                { path: '/super_admin/curriculum-management', label: 'Curriculum Setup', icon: '⚙️' },
            ]
        },
        {
            label: 'Faculty Management',
            items: [
                { path: '/super_admin/addfaculty', label: 'Add Faculty', icon: '👨‍🏫' },
                { path: '/super_admin/viewallfaculty', label: 'View Faculty', icon: '🏢' },
            ]
        },
        {
            label: 'Admin Management',
            items: [
                { path: '/super_admin/addadmin', label: 'Add Admin', icon: '🛡️' },
                { path: '/super_admin/viewalladmins', label: 'View Admins', icon: '📋' },
            ]
        },
        {
            label: 'Account',
            items: [
                { path: '/change-password', label: 'Change Password', icon: '🔐' },
            ]
        }
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
                            <span>Super Admin</span>
                        </div>
                    </div>
                </div>
                
                <nav className="sidebar-nav">
                    {navGroups.map((group) => (
                        <div className="nav-group" key={group.label}>
                            <span className="group-label">{group.label}</span>
                            {group.items.map((item) => (
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
                    ))}
                </nav>

                <div className="sidebar-footer">
                    <div className="admin-profile-mini">
                        <div className="user-avatar">SA</div>
                        <div className="user-info-mini">
                            <strong>Administrator</strong>
                            <span>System Control</span>
                        </div>
                    </div>
                    <button onClick={handleLogout} className="logout-button">
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
                            Admin / <span>{navGroups.flatMap(g => g.items).find(i => location.pathname.includes(i.path))?.label || 'Dashboard'}</span>
                        </div>
                    </div>
                    <div className="user-info">
                        <span className="user-role">System Administrator</span>
                        <div className="user-avatar">SA</div>
                        <button onClick={handleLogout} className="topbar-logout-btn" title="Sign Out">
                            <span>🚪 Logout</span>
                        </button>
                    </div>
                </div>

                <div className="content-area animate-fade">
                    <Routes>
                        <Route path="home" element={<AdminDashboard />} />
                        <Route path="exit-requirement-reports" element={<AdminExitReports />} />
                        <Route path="exit-requirements" element={<AdminExitManagement />} />
                        <Route path="addstudent" element={<AddStudent />} />
                        <Route path="bulk-upload" element={<BulkUpload />} />
                        <Route path="upload-courses" element={<UploadCourses />} />
                        <Route path="student/:studentId" element={<FacultyStudentDetail />} />
                        <Route path="viewallstudents" element={<ViewAllStudents />} />
                        <Route path="student-issues" element={<ManageIssues />} />
                        <Route path="student-lookup" element={<StudentLookupView endpointPrefix="/admin" />} />
                        <Route path="student-lookup/:studentId" element={<StudentLookupView endpointPrefix="/admin" />} />
                        <Route path="curriculum-management" element={<CurriculumAdmin />} />
                        <Route path="curriculum-upload" element={<CurriculumUpload />} />
                        <Route path="curriculum-review/:importId" element={<CurriculumReview />} />
                        <Route path="curriculum-repository" element={<CurriculumRepository />} />
                        <Route path="addfaculty" element={<AddFaculty />} />
                        <Route path="viewallfaculty" element={<ViewAllFaculty />} />
                        <Route path="addadmin" element={<AddAdmin />} />
                        <Route path="viewalladmins" element={<ViewAllAdmins />} />
                        <Route index element={<AdminDashboard />} />
                    </Routes>
                </div>
            </main>
        </div>
    );
}
