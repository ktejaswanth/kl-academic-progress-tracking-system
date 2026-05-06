import api from '../api'
import React, { useState } from 'react'

export default function AddStudent() {
  const [formdata,setFormData] = useState({
       id:"",
       name:"",
       gender:"",
       department:"",
       email:"",
       contact:"",
       password:""
   })
   const [message,setMessage] = useState("")
   const [error,setError] = useState("")

  const handleChange = (e) => {
    const {name,value} = e.target
    setFormData({...formdata,[name]:value})
  }

    const handleSubmit = async (e) => {
      try
      {
       e.preventDefault()
       const response = await api.post("/adminapi/addstudent",formdata)
       if(response.status === 201)
       {
        setError("")
        setMessage(response.data)
        setFormData({
       id:"",
       name:"",
       gender:"",
       department:"",
       email:"",
       contact:"",
       password:""
   })
       }

      }
      catch(err)
      {
         setMessage("")
         setError(err.message)
         setFormData({
       id:"",
       name:"",
       gender:"",
       department:"",
       email:"",
       contact:"",
       password:""
   })
      }
    }

  return (
    <div className="form-container">

    {
      message && <p style={{color:"green",textAlign:"center"}}>{message}</p>
    }
    {
      error && <p style={{color:"red",textAlign:"center"}}>{error}</p>
    }
  
      <h3 style={{textAlign:"center"}}><u>Add Student</u></h3>
      <form className="add-form" onSubmit={handleSubmit}>
        <label>ID</label>
        <input type="number" name="id" value={formdata.id} required onChange={handleChange}/>
        <br/>
        <label>Name</label>
        <input type="text" name="name" value={formdata.name} required onChange={handleChange}/>
        <br/>
        <label>Gender</label>
        <select name="gender" required onChange={handleChange}>
          <option value="">---Select---</option>
          <option value="Male">Male</option>
          <option value="Female">Female</option>
          <option value="Others">Others</option>
        </select>
        <br/>
        <label>Department</label>
        <select name="department" required onChange={handleChange}>
          <option value="">---Select---</option>
          <option value="CSE">CSE</option>
          <option value="ECE">ECE</option>
          <option value="EEE">EEE</option>
          <option value="Others">Others</option>
        </select>
        <br/>
        <label>Email</label>
        <input type="email" name="email" value={formdata.email} required onChange={handleChange}/>
        <br/>
        <label>Contact</label>
        <input type="number" name="contact" value={formdata.contact} required onChange={handleChange}/>
        <br/>
        <label>Password</label>
        <input type="password" name="password" value={formdata.password} required onChange={handleChange}/>
        <br/>
        <input type="submit" value="Add"/>
        <input type="reset" value="Clear"/>
      </form>
    </div>
  )
}
