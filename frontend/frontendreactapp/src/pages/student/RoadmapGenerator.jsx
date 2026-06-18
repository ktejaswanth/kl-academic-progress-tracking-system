import React, { useEffect, useState } from 'react';
import api from '../../api';

export default function RoadmapGenerator() {
    const [roadmap, setRoadmap] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        const fetchRoadmap = async () => {
            try {
                const response = await api.get('/student/roadmap');
                setRoadmap(response.data || []);
            } catch (err) {
                setError(err.response?.data || 'Unable to load roadmap.');
            } finally {
                setLoading(false);
            }
        };
        fetchRoadmap();
    }, []);

    if (loading) {
        return <div>Loading roadmap...</div>;
    }

    if (error) {
        return <div className="card">{error}</div>;
    }

    return (
        <div className="card">
            <h2>Academic Roadmap</h2>
            <p>Recommended sequence of remaining courses by semester.</p>
            {roadmap.length ? (
                <div className="roadmap-list">
                    {roadmap.map((semester) => (
                        <div key={semester.term} className="roadmap-term">
                            <h3>{semester.term}</h3>
                            <ul>
                                {semester.courses.map((course) => (
                                    <li key={course.courseId}>{course.courseCode} - {course.courseName}</li>
                                ))}
                            </ul>
                        </div>
                    ))}
                </div>
            ) : (
                <p>No roadmap data available yet.</p>
            )}
        </div>
    );
}
