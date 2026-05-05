import axios from 'axios'
import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import './style.css'

export default function AdminLogin() 
{
  const navigate = useNavigate()

  const [formdata , setFormdata] = useState({
    username : "",
    password : ""
  })
  const [error, setError] = useState("")

  function handleChange(event)
  {
    const {name, value} = event.target
    setFormdata({...formdata,[name]:value})
  }

  const handleSubmit = async (e) => 
  {
    e.preventDefault()
    setError("")
    try{
      const res = await axios.post("http://localhost:3843/adminapi/login",formdata)
      if(res.status==200)
      {
        sessionStorage.setItem("isAdmin", "true")
        sessionStorage.setItem("adminUsername", formdata.username)
        sessionStorage.setItem("adminData", JSON.stringify(res.data))
        navigate("home")
        window.location.reload()
      }
      else{
        setError("Login Failed")
      }
    }
    catch(err)
    {
      setError(err.response?.data || "Login failed. Please check your credentials.")
    }
  }


  return (
    <div className="login-container">
        <h2 className="login-title">Admin Login</h2>
        {error && <div style={{color: 'red', marginBottom: '15px', textAlign: 'center'}}>{error}</div>}

        <form onSubmit={handleSubmit}>

          <div className="form-group">
            <label>UserName</label>
            <input type="text" name = 'username' onChange={handleChange} required/>
          </div>

            <div className="form-group">
            <label>Password</label>
            <input type="password" name = "password" onChange={handleChange} required/>
            </div>

            <button type="submit" className="login-btn">Login</button>
        </form>
    </div>
  )
}
