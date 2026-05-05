import axios from 'axios'
import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import './style.css'

export default function FacultyLogin() {
  const navigate = useNavigate()

  const [formdata,setFormdata] = useState({
    email:"",
    password:""
  })
  const [error, setError] = useState("")

  function handleChange(e) {
     const {name,value} =  e.target
     setFormdata({...formdata,[name]:value})                
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError("")
    try {
       const response = await axios.post("http://localhost:3843/facultyapi/login",formdata)
        if(response.status==200) {
           sessionStorage.setItem("isFaculty", "true")
           sessionStorage.setItem("facultyEmail", formdata.email)
           sessionStorage.setItem("facultyData", JSON.stringify(response.data))
           navigate("home")
           window.location.reload()
        } else {
          setError("Login Failed")
        }
    }
    catch(err) {
       setError(err.response?.data || "Login failed. Please check your credentials.")
    }
  }   // ✅ THIS BRACE WAS MISSING

  return (
     <div className="login-container">
        <h2 className="login-title">Faculty Login</h2>
        {error && <div style={{color: 'red', marginBottom: '15px', textAlign: 'center'}}>{error}</div>}
        <form onSubmit={handleSubmit} className="login-form">
            <div className="form-group">
                <label>Email</label>
                <input type="email" name='email' onChange={handleChange} required/>
            </div>
            <div className="form-group">
                <label>Password</label>
                <input type="password" name='password' onChange={handleChange} required/>
            </div>
             <button type="submit" className="login-btn">Login</button>
        </form>
    </div>
  )
}