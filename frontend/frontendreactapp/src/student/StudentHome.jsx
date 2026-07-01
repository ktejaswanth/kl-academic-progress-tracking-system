import React, { useEffect } from 'react'

export default function StudentHome() {
  useEffect(() => {
  }, [])

  return (
    <div style={{ padding: '20px' }}>
      <div style={{
        backgroundColor: 'white',
        borderRadius: '10px',
        padding: '30px',
        boxShadow: '0 2px 10px rgba(0,0,0,0.1)',
        maxWidth: '600px',
        margin: '50px auto'
      }}>
        <h1 style={{ textAlign: 'center', color: '#333' }}>Student Dashboard</h1>
        <p style={{ textAlign: 'center', color: '#666', fontSize: '16px', marginTop: '20px' }}>
          Welcome to the Student Portal! 
        </p>
        
        <div style={{
          marginTop: '30px',
          padding: '20px',
          backgroundColor: '#f5f5f5',
          borderRadius: '5px'
        }}>
          <h3 style={{ color: '#333', marginBottom: '15px' }}>Quick Links:</h3>
          <ul style={{ lineHeight: '2', color: '#555' }}>
            <li>View your registered courses</li>
            <li>Check compulsory courses to complete</li>
            <li>View faculty information by course</li>
            <li>Track your earned credits</li>
          </ul>
        </div>

        <div style={{
          marginTop: '20px',
          padding: '20px',
          backgroundColor: '#f0f8e8',
          borderRadius: '5px',
          textAlign: 'center'
        }}>
          <p style={{ color: '#333', fontSize: '14px' }}>
            Use the navigation menu above to access your academic information and course details
          </p>
        </div>
      </div>
    </div>
  )
}
