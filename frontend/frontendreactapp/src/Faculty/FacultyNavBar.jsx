import React from 'react'
import { Link, Route, Routes, useNavigate } from 'react-router-dom'
import FacultyHome from './FacultyHome'
import ViewAllStudents from './ViewAllStudents'
import ViewStudentCourses_basedonStudentId from './ViewStudentCourses_basedonStudentId'
import ViewAllStudents_basedonCourseid from './ViewAllStudents_basedonCourseid'
import '../admin/admin.css'


export default function FacultyNavBar() {

    const navigate = useNavigate()

    const facultyLogout = () =>{
        sessionStorage.removeItem("isFaculty")
        navigate("/")
        window.location.reload()
    }


  return (
    <div>
        <nav className='navbar'>
            <Link to="home">Home</Link>
            <Link to="viewallstudents">View All Students</Link>
            <Link to="viewstudents-bycourse">View Students by Course</Link>
            <Link to="viewcourses-bystudent">View Student Courses</Link>
            <button onClick={facultyLogout} className="logout-btn">Logout</button>
        </nav>

        <Routes>
            <Route index element={<FacultyHome/>}/>   {/* ✅ FIXED */}
            <Route path="home" element={<FacultyHome/>}/>
            <Route path="viewallstudents" element={<ViewAllStudents/>}/>
            <Route path="viewcourses-bystudent" element={<ViewStudentCourses_basedonStudentId/>}/>
            <Route path="viewstudents-bycourse" element={<ViewAllStudents_basedonCourseid/>}/>
        </Routes>
    </div>
  )
}
