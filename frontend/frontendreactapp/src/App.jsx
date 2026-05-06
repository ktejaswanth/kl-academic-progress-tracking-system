import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import Login from './pages/Login';
import ForgotPassword from './pages/ForgotPassword';
import ResetPassword from './pages/ResetPassword';
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
          <Route path="/forgot-password" element={<ForgotPassword />} />
          <Route path="/reset-password" element={<ResetPassword />} />
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