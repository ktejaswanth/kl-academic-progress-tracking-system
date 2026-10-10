import React, { useState, useMemo, useEffect } from 'react';
import { useSearchParams } from 'react-router-dom';
import { useStudentData } from './StudentDataContext';
import './student.css';

export default function MyCourses() {
    const { courses, loading, error, dashboardData } = useStudentData();
    const [searchParams] = useSearchParams();
    const tabParam = searchParams.get('tab');
    const [activeTab, setActiveTab] = useState(tabParam || 'all'); // 'all' | 'current' | 'completed' | 'failed'
    const [searchTerm, setSearchTerm] = useState('');
    const [filterCategory, setFilterCategory] = useState('');
    const [filterSemester, setFilterSemester] = useState('');

    useEffect(() => {
        if (tabParam) {
            setActiveTab(tabParam);
        }
    }, [tabParam]);

    // Pre-calculate buckets mapping for quick lookup of assigned requirement bucket
    const bucketMap = useMemo(() => {
        const map = {};
        if (dashboardData?.buckets) {
            dashboardData.buckets.forEach(b => {
                if (b.courses) {
                    b.courses.forEach(c => {
                        map[c.courseCode] = b.bucketName || b.bucketCode;
                    });
                }
            });
        }
        return map;
    }, [dashboardData]);

    // Categorize courses
    const categorizedCourses = useMemo(() => {
        const all = courses || [];
        const completed = all.filter(c => c.status === 'COMPLETED' || (c.grade && c.grade !== 'F' && c.grade !== '-'));
        const failed = all.filter(c => c.status === 'FAILED' || c.grade === 'F');
        const current = all.filter(c => c.status === 'REGISTERED' || c.status === 'IN_PROGRESS' || (!c.grade && c.status !== 'COMPLETED'));

        return { all, completed, failed, current };
    }, [courses]);

    // Apply active tab selection
    const activeList = useMemo(() => {
        if (activeTab === 'completed') return categorizedCourses.completed;
        if (activeTab === 'failed') return categorizedCourses.failed;
        if (activeTab === 'current') return categorizedCourses.current;
        return categorizedCourses.all;
    }, [activeTab, categorizedCourses]);

    // Apply filters
    const filteredCourses = useMemo(() => {
        return activeList.filter(c => {
            const matchesSearch = !searchTerm ||
                c.courseCode?.toLowerCase().includes(searchTerm.toLowerCase()) ||
                c.courseName?.toLowerCase().includes(searchTerm.toLowerCase());
            const matchesCat = !filterCategory || c.category === filterCategory;
            const matchesSem = !filterSemester || c.semester === filterSemester;
            return matchesSearch && matchesCat && matchesSem;
        });
    }, [activeList, searchTerm, filterCategory, filterSemester]);

    const categories = useMemo(() => {
        const set = new Set();
        courses.forEach(c => { if (c.category) set.add(c.category); });
        return Array.from(set).sort();
    }, [courses]);

    const semesters = useMemo(() => {
        const set = new Set();
        courses.forEach(c => { if (c.semester) set.add(c.semester); });
        return Array.from(set).sort();
    }, [courses]);

    if (loading) {
        return (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '60vh', color: '#8B0000' }}>
                <div className="spinner" style={{ width: '40px', height: '40px', borderTopColor: '#8B0000', borderWidth: '3px' }}></div>
            </div>
        );
    }

    return (
        <div className="student-courses-view animate-fade" style={{ maxWidth: '1400px', margin: '0 auto', paddingBottom: '3rem' }}>
            {/* Header with Read-Only Notice */}
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '2rem', flexWrap: 'wrap', gap: '15px' }}>
                <div>
                    <h1 style={{ fontSize: '2rem', color: '#1E293B', margin: '0 0 6px', fontWeight: 800 }}>My Academic Courses</h1>
                    <p style={{ color: '#64748B', margin: 0, fontSize: '0.95rem' }}>
                        Complete official course enrolment history, attempt logs, and assigned requirement buckets
                    </p>
                </div>
                <div style={{ background: '#FFF5F5', border: '1px solid #FED7D7', padding: '8px 16px', borderRadius: '12px', display: 'flex', alignItems: 'center', gap: '8px', color: '#8B0000', fontSize: '0.85rem', fontWeight: 600 }}>
                    <span>🔒</span>
                    <span>Student View is Read-Only. Modifications must be authorized by Faculty or Admin.</span>
                </div>
            </div>

            {/* Sub-Views Tabs: All, Current, Completed, Failed/Reattempts */}
            <div style={{ display: 'flex', gap: '8px', borderBottom: '2px solid #E2E8F0', marginBottom: '1.8rem', flexWrap: 'wrap' }}>
                <button
                    onClick={() => setActiveTab('all')}
                    style={{
                        padding: '12px 20px',
                        fontWeight: 700,
                        fontSize: '0.95rem',
                        border: 'none',
                        background: 'transparent',
                        cursor: 'pointer',
                        color: activeTab === 'all' ? '#8B0000' : '#64748B',
                        borderBottom: activeTab === 'all' ? '3px solid #8B0000' : '3px solid transparent',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '8px'
                    }}
                >
                    📜 All Courses ({categorizedCourses.all.length})
                </button>
                <button
                    onClick={() => setActiveTab('completed')}
                    style={{
                        padding: '12px 20px',
                        fontWeight: 700,
                        fontSize: '0.95rem',
                        border: 'none',
                        background: 'transparent',
                        cursor: 'pointer',
                        color: activeTab === 'completed' ? '#8B0000' : '#64748B',
                        borderBottom: activeTab === 'completed' ? '3px solid #8B0000' : '3px solid transparent',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '8px'
                    }}
                >
                    ✅ Completed Courses ({categorizedCourses.completed.length})
                </button>
                <button
                    onClick={() => setActiveTab('current')}
                    style={{
                        padding: '12px 20px',
                        fontWeight: 700,
                        fontSize: '0.95rem',
                        border: 'none',
                        background: 'transparent',
                        cursor: 'pointer',
                        color: activeTab === 'current' ? '#8B0000' : '#64748B',
                        borderBottom: activeTab === 'current' ? '3px solid #8B0000' : '3px solid transparent',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '8px'
                    }}
                >
                    ⏳ Current / In-Progress ({categorizedCourses.current.length})
                </button>
                <button
                    onClick={() => setActiveTab('failed')}
                    style={{
                        padding: '12px 20px',
                        fontWeight: 700,
                        fontSize: '0.95rem',
                        border: 'none',
                        background: 'transparent',
                        cursor: 'pointer',
                        color: activeTab === 'failed' ? '#8B0000' : '#64748B',
                        borderBottom: activeTab === 'failed' ? '3px solid #8B0000' : '3px solid transparent',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '8px'
                    }}
                >
                    ⚠️ Failed / Reattempts ({categorizedCourses.failed.length})
                </button>
            </div>

            {/* Filter and Search Controls */}
            <div className="glass-card" style={{ padding: '1.8rem', background: 'white' }}>
                <div style={{ display: 'flex', flexWrap: 'wrap', gap: '12px', alignItems: 'center', marginBottom: '1.5rem' }}>
                    <input
                        type="text"
                        placeholder="🔍 Search course code or title..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        style={{ padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', minWidth: '240px', outline: 'none' }}
                    />
                    <select
                        value={filterCategory}
                        onChange={(e) => setFilterCategory(e.target.value)}
                        style={{ padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none', background: 'white' }}
                    >
                        <option value="">All Requirement Categories</option>
                        {categories.map(c => (
                            <option key={c} value={c}>{c}</option>
                        ))}
                    </select>
                    <select
                        value={filterSemester}
                        onChange={(e) => setFilterSemester(e.target.value)}
                        style={{ padding: '10px 14px', borderRadius: '10px', border: '1px solid #CBD5E1', outline: 'none', background: 'white' }}
                    >
                        <option value="">All Semesters</option>
                        {semesters.map(s => (
                            <option key={s} value={s}>{s}</option>
                        ))}
                    </select>
                    {(searchTerm || filterCategory || filterSemester) && (
                        <button
                            onClick={() => { setSearchTerm(''); setFilterCategory(''); setFilterSemester(''); }}
                            style={{ background: '#F1F5F9', border: 'none', padding: '10px 14px', borderRadius: '10px', cursor: 'pointer', color: '#64748B', fontWeight: 600 }}
                        >
                            Reset Filters
                        </button>
                    )}
                </div>

                {/* Course List Table */}
                {filteredCourses.length > 0 ? (
                    <div style={{ overflowX: 'auto', borderRadius: '12px', border: '1px solid #E2E8F0' }}>
                        <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '0.88rem' }}>
                            <thead>
                                <tr style={{ background: '#F8FAFC', borderBottom: '2px solid #E2E8F0', color: '#475569' }}>
                                    <th style={{ padding: '14px 14px' }}>Course Code</th>
                                    <th style={{ padding: '14px 14px', minWidth: '200px' }}>Course Title</th>
                                    <th style={{ padding: '14px 12px' }}>Category</th>
                                    <th style={{ padding: '14px 12px' }}>Assigned Bucket</th>
                                    <th style={{ padding: '14px 10px', textAlign: 'center' }}>Credits</th>
                                    <th style={{ padding: '14px 10px' }}>Semester</th>
                                    <th style={{ padding: '14px 10px' }}>Academic Year</th>
                                    <th style={{ padding: '14px 10px', textAlign: 'center' }}>Grade</th>
                                    <th style={{ padding: '14px 12px', textAlign: 'center' }}>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {filteredCourses.map((c, idx) => {
                                    const assignedBucket = bucketMap[c.courseCode] || (c.category ? `${c.category} Basket` : 'Core Basket');
                                    const isPass = c.status === 'COMPLETED' || ['O', 'A+', 'A', 'B+', 'B', 'C', 'P'].includes(c.grade);
                                    return (
                                        <tr key={c.id || c.courseCode || idx} style={{ borderBottom: '1px solid #F1F5F9', background: idx % 2 === 0 ? 'white' : '#FCFDFD' }}>
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
                                            <td style={{ padding: '12px 12px', color: '#475569', fontSize: '0.82rem' }}>
                                                {assignedBucket}
                                            </td>
                                            <td style={{ padding: '12px 10px', textAlign: 'center', fontWeight: 700, color: '#059669' }}>
                                                {c.credits} Cr
                                            </td>
                                            <td style={{ padding: '12px 10px', color: '#64748B' }}>
                                                {c.semester || '-'}
                                            </td>
                                            <td style={{ padding: '12px 10px', color: '#64748B', fontSize: '0.82rem' }}>
                                                {c.academicYear || '-'}
                                            </td>
                                            <td style={{ padding: '12px 10px', textAlign: 'center' }}>
                                                <span style={{
                                                    padding: '3px 8px',
                                                    borderRadius: '6px',
                                                    fontWeight: 800,
                                                    fontSize: '0.82rem',
                                                    background: c.grade === 'F' ? '#FEE2E2' : isPass ? '#ECFDF5' : '#F1F5F9',
                                                    color: c.grade === 'F' ? '#DC2626' : isPass ? '#059669' : '#475569'
                                                }}>
                                                    {c.grade || '-'}
                                                </span>
                                            </td>
                                            <td style={{ padding: '12px 12px', textAlign: 'center' }}>
                                                <span style={{
                                                    padding: '4px 10px',
                                                    borderRadius: '12px',
                                                    fontSize: '0.75rem',
                                                    fontWeight: 700,
                                                    background: c.status === 'COMPLETED' ? '#DCFCE7' : c.status === 'FAILED' ? '#FEE2E2' : '#FEF3C7',
                                                    color: c.status === 'COMPLETED' ? '#166534' : c.status === 'FAILED' ? '#991B1B' : '#92400E'
                                                }}>
                                                    {c.status || 'COMPLETED'}
                                                </span>
                                            </td>
                                        </tr>
                                    );
                                })}
                            </tbody>
                        </table>
                    </div>
                ) : (
                    <div style={{ textAlign: 'center', padding: '3.5rem 1rem', background: '#F8FAFC', borderRadius: '12px', border: '1px dashed #CBD5E1' }}>
                        <span style={{ fontSize: '2.5rem' }}>📚</span>
                        <h4 style={{ margin: '12px 0 6px', color: '#1E293B' }}>No courses match your filter</h4>
                        <p style={{ color: '#64748B', margin: 0, fontSize: '0.9rem' }}>Try clearing your search query or selecting a different tab.</p>
                    </div>
                )}
            </div>
        </div>
    );
}
