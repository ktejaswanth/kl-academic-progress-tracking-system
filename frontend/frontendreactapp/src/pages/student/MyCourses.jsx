import React, { useEffect, useState } from 'react';
import api from '../../api';
import './student.css';

export default function MyCourses() {
    const [courses, setCourses] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [searchTerm, setSearchTerm] = useState('');

    useEffect(() => {
        const fetchCourses = async () => {
            try {
                const response = await api.get('/dyod/courses/student/me');
                setCourses(response.data);
            } catch (err) {
                setError('Failed to retrieve completed courses.');
            } finally {
                setLoading(false);
            }
        };
        fetchCourses();
    }, []);

    if (loading) return (
        <div className="student-loader-container">
            <div className="premium-loader"></div>
            <p>Gathering Academic Record Summary...</p>
        </div>
    );

    if (error) return (
        <div className="student-dashboard">
            <div className="alert error">{error}</div>
        </div>
    );

    const filteredCourses = courses.filter(course => 
        course.courseCode.toLowerCase().includes(searchTerm.toLowerCase()) ||
        course.courseName.toLowerCase().includes(searchTerm.toLowerCase())
    );

    const totalCredits = courses.reduce((acc, curr) => acc + curr.credits, 0);

    return (
        <div className="student-dashboard animate-fade">
            <header className="student-hero">
                <div className="hero-content">
                    <span className="welcome-tag">Completed Courses</span>
                    <h1>Academic History</h1>
                    <p>Detailed breakdown of your completed course credits</p>
                </div>
                <div className="hero-stats">
                    <div className="hero-stat-card">
                        <span className="label">Total Courses</span>
                        <span className="value">{courses.length}</span>
                    </div>
                    <div className="hero-stat-card">
                        <span className="label">Total Credits</span>
                        <span className="value" style={{ color: '#FFD700' }}>{totalCredits}</span>
                    </div>
                </div>
            </header>

            <div className="glass-card search-filter-card" style={{ marginBottom: '2rem', padding: '1.5rem' }}>
                <div className="search-bar-wrapper">
                    <input 
                        type="text" 
                        placeholder="🔍 Search completed courses by code or name..." 
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="premium-input"
                        style={{ width: '100%', padding: '12px 20px', fontSize: '1rem', border: '1px solid #E9ECEF', borderRadius: '14px', outline: 'none' }}
                    />
                </div>
            </div>

            <section className="history-section">
                <div className="transcript-card">
                    {filteredCourses.length > 0 ? (
                        <table className="transcript-table">
                            <thead>
                                <tr>
                                    <th>Course Code</th>
                                    <th>Course Name</th>
                                    <th>LTPS</th>
                                    <th>Credits</th>
                                    <th>Bucket Group</th>
                                    <th>Course Type</th>
                                    <th>Academic Year</th>
                                    <th>Semester</th>
                                    <th>Study Year</th>
                                    <th>Register Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                {filteredCourses.map((course) => (
                                    <tr key={course.id} className="course-row">
                                        <td><span className="code-pill">{course.courseCode}</span></td>
                                        <td><strong>{course.courseName}</strong></td>
                                        <td>{course.ltps}</td>
                                        <td>{course.credits} LPU</td>
                                        <td><span className="cat-tag">{course.bucketGroup}</span></td>
                                        <td>{course.courseType}</td>
                                        <td>{course.academicYear}</td>
                                        <td>{course.semester}</td>
                                        <td>{course.studyYear}</td>
                                        <td>{course.registerDate ? new Date(course.registerDate).toLocaleDateString() : 'N/A'}</td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    ) : (
                        <div style={{ padding: '3rem', textAlign: 'center', color: '#636E72' }}>
                            {searchTerm ? 'No completed courses matching your search.' : 'You have not added any completed courses yet.'}
                        </div>
                    )}
                </div>
            </section>
        </div>
    );
}
