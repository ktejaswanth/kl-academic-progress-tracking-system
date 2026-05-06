import api from '../api'
import React, { useEffect, useState } from 'react'

export default function ViewAllFaculty() {
  const [data, setData] = useState([])
  const [error, setError] = useState("")

  const fetchFaculty = async () => {
    try {
      const response = await api.get("/api/admin/faculty")
      setData(response.data)
    } catch (err) {
      setError(err.message)
    }
  }

  useEffect(() => {
    fetchFaculty()
  }, [])

  return (
    <div>
      <h3 style={{ textAlign: "center" }}><u>View All Faculty</u></h3>
      {error && <p style={{ textAlign: "center", color: "red" }}>{error}</p>}
      <table border={1} style={{ margin: "auto", width: "90%" }}>
        <thead>
          <tr>
            <th>Username</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Email</th>
            <th>Department</th>
          </tr>
        </thead>
        <tbody>
          {data.map((faculty, index) => (
            <tr key={index}>
              <td>{faculty.username}</td>
              <td>{faculty.firstName}</td>
              <td>{faculty.lastName}</td>
              <td>{faculty.email}</td>
              <td>{faculty.department}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}