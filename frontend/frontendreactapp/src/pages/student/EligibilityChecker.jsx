import React, { useEffect, useState } from 'react';
import api from '../../api';

export default function EligibilityChecker() {
    const [eligibility, setEligibility] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        const fetchEligibility = async () => {
            try {
                const response = await api.get('/student/eligibility');
                setEligibility(response.data);
            } catch (err) {
                setError(err.response?.data || 'Unable to load eligibility status.');
            } finally {
                setLoading(false);
            }
        };
        fetchEligibility();
    }, []);

    if (loading) {
        return <div>Loading eligibility...</div>;
    }

    if (error) {
        return <div className="card">{error}</div>;
    }

    return (
        <div className="card">
            <h2>Eligibility Status</h2>
            <p>Current academic eligibility snapshot for required courses and graduation progress.</p>
            <div className="section">
                <h3>Overall Status</h3>
                <p>{eligibility.completed ? 'Eligible' : 'Not Eligible'}</p>
                <p>{eligibility.missingCourseCount} missing courses</p>
            </div>
            <div className="section">
                <h3>Missing Courses</h3>
                {eligibility.missingCourses?.length ? (
                    <ul>
                        {eligibility.missingCourses.map((course) => (
                            <li key={course.courseId}>{course.courseCode} - {course.courseName}</li>
                        ))}
                    </ul>
                ) : (
                    <p>No missing courses detected.</p>
                )}
            </div>
            <div className="section">
                <h3>Next Suggested Courses</h3>
                {eligibility.suggestedCourses?.length ? (
                    <ul>
                        {eligibility.suggestedCourses.map((course) => (
                            <li key={course.courseId}>{course.courseCode} - {course.courseName}</li>
                        ))}
                    </ul>
                ) : (
                    <p>No suggestions available yet.</p>
                )}
            </div>
        </div>
    );
}
