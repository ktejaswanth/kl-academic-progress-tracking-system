import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import api from '../../api';

const StudentDataContext = createContext(null);

export function StudentDataProvider({ children }) {
    const [dashboardData, setDashboardData] = useState(null);
    const [courses, setCourses] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    const fetchAllData = useCallback(async () => {
        setLoading(true);
        setError('');
        try {
            // Fetch unified student dashboard data and student courses in parallel
            const [dashRes, coursesRes] = await Promise.all([
                api.get('/student/progress/dashboard').catch(async () => {
                    // Fallback to legacy endpoint if unified is unavailable
                    const legacy = await api.get('/dyod/progress/student/me');
                    return { data: legacy.data };
                }),
                api.get('/student/courses').catch(() => ({ data: [] }))
            ]);

            setDashboardData(dashRes.data || null);
            setCourses(coursesRes.data || []);
        } catch (err) {
            console.error('Failed to load student academic data:', err);
            setError('Could not load academic data. Please ensure your degree path is assigned.');
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        fetchAllData();
    }, [fetchAllData]);

    const value = {
        dashboardData,
        courses,
        loading,
        error,
        refreshData: fetchAllData
    };

    return (
        <StudentDataContext.Provider value={value}>
            {children}
        </StudentDataContext.Provider>
    );
}

export function useStudentData() {
    const context = useContext(StudentDataContext);
    if (!context) {
        throw new Error('useStudentData must be used within a StudentDataProvider');
    }
    return context;
}
