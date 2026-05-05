import React from 'react'
import { Link, Route, Routes, useNavigate } from 'react-router-dom'
import StudentHome from './StudentHome'
import ViewMyRegisteredCourses from './ViewMyRegisteredCourses'
import ViewComplusoryCoursesToDo from './ViewComplusoryCoursesToDo'
import ViewAllFacultiesTeaching_basedonCourseName from './ViewAllFacultiesTeaching_basedonCourseName'
import ViewMyCreditsGained from './ViewMyCreditsGained'
import '../admin/admin.css'


export default function StudentNavBar() {

    const navigate = useNavigate()

    const studentLogout = () =>{
        sessionStorage.removeItem("isStudent")
        navigate("/")
        window.location.reload()
    }


  return (
    <div>
        <nav className='navbar'>
            <Link to="home">Home</Link>
            <Link to="myregisteredcourses">My Registered Courses</Link>
            <Link to="compulsorycourses">Compulsory Courses</Link>
            <Link to="faculty-by-course">Faculty by Course</Link>
            <Link to="mycredits">My Credits</Link>
            <button onClick={studentLogout} className="logout-btn">Logout</button>
        </nav>

        <Routes>
            <Route index element={<StudentHome/>}/>   {/* ✅ FIXED */}
            <Route path="home" element={<StudentHome/>}/>
            <Route path="myregisteredcourses" element={<ViewMyRegisteredCourses/>}/>
            <Route path="compulsorycourses" element={<ViewComplusoryCoursesToDo/>}/>
            <Route path="faculty-by-course" element={<ViewAllFacultiesTeaching_basedonCourseName/>}/>
            <Route path="mycredits" element={<ViewMyCreditsGained/>}/>
        </Routes>
    </div>
  )
}
