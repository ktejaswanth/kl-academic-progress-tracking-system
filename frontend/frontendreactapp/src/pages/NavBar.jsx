import React from 'react'
import { Link, Route, Routes } from 'react-router-dom'
import AdminLogin from './AdminLogin'
import './style.css'
import StudentLogin from './StudentLogin';
import FacultyLogin from './FacultyLogin';

export default function NavBar() {
  return (
    <div>
      <nav className="navbar">
          <Link to="/">Home</Link>
          <Link to="/adminlogin">Admin Login</Link>
          <Link to="/studentlogin">Student Login</Link>
          <Link to="/facultylogin">Faculty Login</Link>
        </nav>

      <div className="content">
        <Routes>
          <Route path="/" element={<h2>Home Page</h2>}  />
          <Route path="/adminlogin" element={<AdminLogin/>}/>
          <Route path="/studentlogin" element={<StudentLogin/>}/>
          <Route path="/facultylogin" element={<FacultyLogin/>}/>
          <Route path="*" element={<h3>Page Not Found</h3>} />
        </Routes>
      </div>
    </div>
  );
}