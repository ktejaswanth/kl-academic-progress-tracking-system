import axios from 'axios'
import React, { useEffect, useState } from 'react'

export default function ViewAllStudents() {
  const [data,setData] = useState([])
   const [error,setError] = useState("")

   const fetchStudents = async () => {
       try
       {
        const response = await axios.get("http://localhost:1236/adminapi/viewallstudents")
        setData(response.data)
       }
       catch(err)
       {
          setError(err.message)
       }
   }

    useEffect(() => {
        fetchStudents()
    }, []);  // empty dependency (input) - runs only once
       
  return (
    <div>
      <h3 style={{textAlign:"center"}}><u>View All Students</u></h3>
      {
        error && <p style={{textAlign:"center",color:"red"}}>{error}</p>
      }
      <table border={1}>
        <thead>
          <tr>
            <th>ID</th>
            <th>NAME</th>
            <th>GENDER</th>
            <th>DEPARTMENT</th>
            <th>EMAIL</th>
            <th>CONTACT</th>
          </tr>
        </thead>
        <tbody>
          {
               data.map( (student,index) => (
                   <tr key={index}>
                    <td>{student.id}</td>
                    <td>{student.name}</td>
                    <td>{student.gender}</td>
                    <td>{student.department}</td>
                    <td>{student.email}</td>
                    <td>{student.contact}</td>
                   </tr>
               ))
          }
        </tbody>
      </table>
    </div>
  )
}
