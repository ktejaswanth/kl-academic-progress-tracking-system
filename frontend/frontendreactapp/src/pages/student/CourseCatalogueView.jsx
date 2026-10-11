import React, { useState, useEffect } from 'react';
import api from '../../api';
import './student.css';

export default function CourseCatalogueView() {
    const [courses, setCourses] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [filterCategory, setFilterCategory] = useState('');
    const [filterCredits, setFilterCredits] = useState('');

    useEffect(() => {
        const fetchCatalog = async () => {
            setLoading(true);
            try {
                const res = await api.get('/student-course-management/catalog', {
                    params: { search: searchTerm.trim() }
                });
                setCourses(res.data || []);
            } catch (err) {
                console.error('Failed to load catalogue', err);
            } finally {
                setLoading(false);
            }
        };

        const timer = setTimeout(fetchCatalog, 300);
        return () => clearTimeout(timer);
    }, [searchTerm]);

    const filteredList = courses.filter(c => {
        const matchesCategory = !filterCategory || c.category === filterCategory;
        const matchesCredits = !filterCredits || String(c.credits) === filterCredits;
        return matchesCategory && matchesCredits;
    });

    const categories = ['HAS', 'BSC', 'ESC', 'FCC', 'PCC', 'PEC', 'SDC', 'PRI', 'OEC', 'SIL'];

    return (
        <div className="student-course-catalogue animate-fade" style={{ maxWidth: '1400px', margin: '0 auto', paddingBottom: '3rem' }}>
            <div style={{ marginBottom: '2rem' }}>
                <h1 style={{ fontSize: '2rem', color: '#1E293B', margin: '0 0 6px', fontWeight: 800 }}>Master Course Catalogue</h1>
                <p style={{ color: '#64748B', margin: 0, fontSize: '0.95rem' }}>
                    Authoritative course inventory, syllabi offerings, academic credits, and prerequisites
                </p>
            </div>

            {/* Filter Bar */}
            <div className="glass-card" style={{ padding: '1.5rem', background: 'white', marginBottom: '2rem' }}>
                <div style={{ display: 'flex', flexWrap: 'wrap', gap: '12px', alignItems: 'center' }}>
                    <input
                        type="text"
                        placeholder="🔍 Search course code or title (e.g. 23CS1101, Python, Data Science)..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        style={{ padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', flex: 1, minWidth: '280px', outline: 'none' }}
                    />
                    <select
                        value={filterCategory}
                        onChange={(e) => setFilterCategory(e.target.value)}
                        style={{ padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none', background: 'white' }}
                    >
                        <option value="">All Categories ({categories.length})</option>
                        {categories.map(c => (
                            <option key={c} value={c}>{c}</option>
                        ))}
                    </select>
                    <select
                        value={filterCredits}
                        onChange={(e) => setFilterCredits(e.target.value)}
                        style={{ padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none', background: 'white' }}
                    >
                        <option value="">All Credits</option>
                        <option value="1">1 Credit</option>
                        <option value="2">2 Credits</option>
                        <option value="3">3 Credits</option>
                        <option value="4">4 Credits</option>
                    </select>
                    {(searchTerm || filterCategory || filterCredits) && (
                        <button
                            onClick={() => { setSearchTerm(''); setFilterCategory(''); setFilterCredits(''); }}
                            style={{ background: '#F1F5F9', border: 'none', padding: '10px 14px', borderRadius: '10px', cursor: 'pointer', color: '#64748B', fontWeight: 600 }}
                        >
                            Reset
                        </button>
                    )}
                </div>
            </div>

            {/* Courses Table */}
            {loading ? (
                <div style={{ display: 'flex', justifyContent: 'center', padding: '3rem', color: '#8B0000' }}>
                    <div className="spinner" style={{ width: '35px', height: '35px', borderTopColor: '#8B0000', borderWidth: '3px' }}></div>
                </div>
            ) : filteredList.length > 0 ? (
                <div className="glass-card" style={{ padding: '1.5rem', background: 'white' }}>
                    <div style={{ overflowX: 'auto', borderRadius: '12px', border: '1px solid #E2E8F0' }}>
                        <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '0.88rem' }}>
                            <thead>
                                <tr style={{ background: '#F8FAFC', borderBottom: '2px solid #E2E8F0', color: '#475569' }}>
                                    <th style={{ padding: '14px 14px' }}>Course Code</th>
                                    <th style={{ padding: '14px 14px', minWidth: '240px' }}>Course Title</th>
                                    <th style={{ padding: '14px 12px' }}>Category</th>
                                    <th style={{ padding: '14px 10px', textAlign: 'center' }}>Credits</th>
                                    <th style={{ padding: '14px 12px' }}>Offered Semester</th>
                                    <th style={{ padding: '14px 12px' }}>Prerequisites</th>
                                </tr>
                            </thead>
                            <tbody>
                                {filteredList.map((c, idx) => (
                                    <tr key={c.courseId || c.courseCode || idx} style={{ borderBottom: '1px solid #F1F5F9', background: idx % 2 === 0 ? 'white' : '#FCFDFD' }}>
                                        <td style={{ padding: '12px 14px' }}>
                                            <span style={{ fontWeight: 800, color: '#8B0000', fontFamily: 'monospace', fontSize: '0.92rem' }}>
                                                {c.courseCode}
                                            </span>
                                        </td>
                                        <td style={{ padding: '12px 14px' }}>
                                            <strong style={{ color: '#1E293B' }}>{c.courseName}</strong>
                                        </td>
                                        <td style={{ padding: '12px 12px' }}>
                                            <span style={{ background: '#EFF6FF', color: '#1D4ED8', padding: '3px 8px', borderRadius: '6px', fontWeight: 700, fontSize: '0.78rem' }}>
                                                {c.category || 'PCC'}
                                            </span>
                                        </td>
                                        <td style={{ padding: '12px 10px', textAlign: 'center', fontWeight: 700, color: '#059669' }}>
                                            {c.credits} Cr
                                        </td>
                                        <td style={{ padding: '12px 12px', color: '#64748B' }}>
                                            {c.offeredSemester || 'All Semesters'}
                                        </td>
                                        <td style={{ padding: '12px 12px', color: '#64748B', fontStyle: 'italic', fontSize: '0.82rem' }}>
                                            {c.prerequisites || 'None'}
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
            ) : (
                <div style={{ textAlign: 'center', padding: '3.5rem 1rem', background: '#F8FAFC', borderRadius: '16px', border: '1px dashed #CBD5E1' }}>
                    <span style={{ fontSize: '2.5rem' }}>🔍</span>
                    <h4 style={{ margin: '12px 0 6px', color: '#1E293B' }}>No courses found in catalogue</h4>
                    <p style={{ color: '#64748B', margin: 0, fontSize: '0.9rem' }}>Try searching with a different course code or keyword.</p>
                </div>
            )}
        </div>
    );
}
