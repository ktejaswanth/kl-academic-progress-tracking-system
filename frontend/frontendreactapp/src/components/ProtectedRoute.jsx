import React from 'react';
import { Navigate } from 'react-router-dom';

const ProtectedRoute = ({ children, allowedRoles }) => {
    const user = JSON.parse(localStorage.getItem('user'));
    
    if (!user) {
        return <Navigate to="/login" replace />;
    }

    if (allowedRoles && !allowedRoles.includes(user.role)) {
        // Redirect to their default home if they try to access something they shouldn't
        if (user.role === 'SUPER_ADMIN') return <Navigate to="/super_admin/home" replace />;
        if (user.role === 'FACULTY') return <Navigate to="/faculty/home" replace />;
        if (user.role === 'STUDENT') return <Navigate to="/student/home" replace />;
        
        return <Navigate to="/login" replace />;
    }

    return children;
};

export default ProtectedRoute;
