import api from '../api'
import React, { useEffect, useState } from 'react'

export default function ViewAllStudents() {
  const [data, setData] = useState([])
  const [error, setError] = useState("")

  const fetchStudents = async () => {
    try {
      const response = await api.get("/api/admin/students")
      setData(response.data)
    } catch (err) {
      setError(err.message)
    }
  }

  useEffect(() => {
    fetchStudents()
  }, [])

  return (
    <div>
      <h3 style={{ textAlign: "center" }}><u>View All Students</u></h3>
      {error && <p style={{ textAlign: "center", color: "red" }}>{error}</p>}
      <table border={1} style={{ margin: "auto", width: "90%" }}>
        <thead>
          <tr>
            <th>ID (Username)</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Email</th>
            <th>Department</th>
          </tr>
        </thead>
        <tbody>
          {data.map((student, index) => (
            <tr key={index}>
              <td>{student.username}</td>
              <td>{student.firstName}</td>
              <td>{student.lastName}</td>
              <td>{student.email}</td>
              <td>{student.department}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
