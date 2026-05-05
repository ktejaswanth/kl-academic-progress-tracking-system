import { BrowserRouter as Router } from "react-router-dom"
import { useEffect, useState } from "react"

import NavBar from "./pages/NavBar"
import AdminNavBar from "./admin/AdminNavBar"
import FacultyNavBar from "./Faculty/FacultyNavBar"
import StudentNavBar from "./student/StudentNavBar"

function App() {
  const [isAdmin, setIsAdmin] = useState(false)
  const [isFaculty, setIsFaculty] = useState(false)
  const [isStudent, setIsStudent] = useState(false)

  useEffect(() => {
    setIsAdmin(sessionStorage.getItem("isAdmin") === "true")
    setIsFaculty(sessionStorage.getItem("isFaculty") === "true")
    setIsStudent(sessionStorage.getItem("isStudent") === "true")
  }, [])

  return (
    <Router>
      <div>
        <h1 style={{ textAlign: "center" }}>Welcome to Credit Core</h1>

        {/* Role-based rendering */}
        {isAdmin ? (
          <AdminNavBar />
        ) : isFaculty ? (
          <FacultyNavBar />
        ) : isStudent ? (
          <StudentNavBar />
        ) : (
          <NavBar />
        )}
      </div>
    </Router>
  )
}

export default App