import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import Login from './pages/Login';
import ForgotPassword from './pages/ForgotPassword';
import ResetPassword from './pages/ResetPassword';
import ChangePassword from './pages/ChangePassword';
import FirstLogin from './pages/FirstLogin';
import CreatePassword from './pages/CreatePassword';
import ProfileSetup from './pages/ProfileSetup';
import SecondYearSelection from './pages/SecondYearSelection';
import AdminNavBar from './admin/AdminNavBar';
import StudentNavBar from './pages/student/StudentNavBar';
import FacultyNavBar from './pages/faculty/FacultyNavBar';
import ProtectedRoute from './components/ProtectedRoute';

function App() {
  return (
    <Router>
      <AuthProvider>
        <Routes>
          {/* Public Routes */}
          <Route path="/login" element={<Login />} />
          <Route path="/first-login" element={<FirstLogin />} />
          <Route path="/create-password" element={<CreatePassword />} />
          <Route path="/profile-setup" element={<ProfileSetup />} />
          <Route path="/second-year-selection" element={<SecondYearSelection />} />
          <Route path="/forgot-password" element={<ForgotPassword />} />
          <Route path="/reset-password" element={<ResetPassword />} />
          <Route 
            path="/change-password" 
            element={
              <ProtectedRoute allowedRoles={['SUPER_ADMIN', 'FACULTY', 'STUDENT']}>
                <ChangePassword />
              </ProtectedRoute>
            } 
          />
          <Route path="/" element={<Navigate to="/login" />} />

          {/* Super Admin Routes */}
          <Route 
            path="/super_admin/*" 
            element={
              <ProtectedRoute allowedRoles={['SUPER_ADMIN']}>
                <AdminNavBar />
              </ProtectedRoute>
            } 
          />

          {/* Faculty Routes */}
          <Route 
            path="/faculty/*" 
            element={
              <ProtectedRoute allowedRoles={['FACULTY']}>
                <FacultyNavBar />
              </ProtectedRoute>
            } 
          />

          {/* Student Routes */}
          <Route 
            path="/student/*" 
            element={
              <ProtectedRoute allowedRoles={['STUDENT']}>
                <StudentNavBar />
              </ProtectedRoute>
            } 
          />

          {/* Catch-all */}
          <Route path="*" element={<Navigate to="/login" />} />
        </Routes>
      </AuthProvider>
    </Router>
  );
}

export default App;