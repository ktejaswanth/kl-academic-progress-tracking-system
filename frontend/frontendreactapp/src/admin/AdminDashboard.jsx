import React from 'react'

export default function AdminDashboard() {
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
        <h1 style={{ textAlign: 'center', color: '#333' }}>Admin Dashboard</h1>
        <p style={{ textAlign: 'center', color: '#666', fontSize: '16px', marginTop: '20px' }}>
          Welcome to the Admin Panel!
        </p>
        
        <div style={{
          marginTop: '30px',
          padding: '20px',
          backgroundColor: '#f5f5f5',
          borderRadius: '5px'
        }}>
          <h3 style={{ color: '#333', marginBottom: '15px' }}>Admin Functions:</h3>
          <ul style={{ lineHeight: '2', color: '#555' }}>
            <li>Add new students and faculty</li>
            <li>View all students and faculty members</li>
            <li>Manage user information</li>
            <li>Monitor system activities</li>
          </ul>
        </div>

        <div style={{
          marginTop: '20px',
          padding: '20px',
          backgroundColor: '#fff3cd',
          borderRadius: '5px',
          textAlign: 'center'
        }}>
          <p style={{ color: '#333', fontSize: '14px' }}>
            Use the navigation menu above to manage students and faculty
          </p>
        </div>
      </div>
    </div>
  )
}
