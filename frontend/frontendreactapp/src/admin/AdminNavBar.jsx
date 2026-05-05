import React from 'react'
import { Link, Route, Routes, useNavigate } from 'react-router-dom'
import AddStudent from './AddStudent'
import ViewAllStudents from './ViewAllStudents'
import AddFaculty from './AddFaculty'
import ViewAllFaculty from './ViewAllFaculty'
import AdminDashboard from './AdminDashboard'
import './admin.css'


export default function AdminNavBar() {

    const navigate = useNavigate()

    const adminLogout = () =>{
        sessionStorage.removeItem("isAdmin")
        navigate("/")
        window.location.reload()

    }


  return (
    <div>

        <nav className='navbar'>
            <Link to="home">Home</Link>
            <Link to="addstudent">Add Student</Link>
            <Link to="viewallstudents">View All Students</Link>
            <Link to="addfaculty">Add Faculty</Link>
            <Link to="viewallfaculty">View All Faculty</Link>
            <button onClick={adminLogout} className="logout-btn">Logout</button>
        </nav>

        <Routes>
            <Route path="home" element={<AdminDashboard/>}/>
            <Route path="addstudent" element={<AddStudent/>}/>
            <Route path="viewallstudents" element={<ViewAllStudents/>}/>
            <Route path="addfaculty" element={<AddFaculty/>}/>
            <Route path="viewallfaculty" element={<ViewAllFaculty/>}/>
            <Route index element={<AdminDashboard/>}/>
        </Routes>
    </div>
  )
}
