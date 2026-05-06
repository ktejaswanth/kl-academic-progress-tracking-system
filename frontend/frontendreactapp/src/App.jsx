import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import Login from './pages/Login';
import BulkUpload from './pages/faculty/BulkUpload';
import AdminNavBar from './admin/AdminNavBar';
// import StudentNavBar from './student/StudentNavBar';

function App() {
  return (
    <Router>
      <AuthProvider>
        <Routes>
          {/* Public Routes */}
          <Route path="/login" element={<Login />} />
          <Route path="/" element={<Navigate to="/login" />} />

          {/* Super Admin Routes */}
          <Route path="/super_admin/*" element={<AdminNavBar />} />

          {/* Faculty Routes */}
          <Route path="/faculty/upload" element={<BulkUpload />} />

          {/* Student Routes */}
          {/* <Route path="/student/*" element={<StudentNavBar />} /> */}

          {/* Catch-all */}
          <Route path="*" element={<Navigate to="/login" />} />
        </Routes>
      </AuthProvider>
    </Router>
  );
}

export default App;