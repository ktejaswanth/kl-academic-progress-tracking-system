import React, { useState, useEffect, useRef } from 'react';
import { useParams, useSearchParams } from 'react-router-dom';
import api from '../../api';
import ExitRequirementReportPreview from '../../components/ExitRequirementReportPreview';
import './faculty.css';

export default function FacultyExitReports() {
    const { studentId: paramStudentId } = useParams();
    const [searchParams, setSearchParams] = useSearchParams();
    const initialRoll = paramStudentId || searchParams.get('studentId') || '2300080412';

    const [searchInput, setSearchInput] = useState(initialRoll);
    const [suggestions, setSuggestions] = useState([]);
    const [showSuggestions, setShowSuggestions] = useState(false);
    const [searchingSuggestions, setSearchingSuggestions] = useState(false);

    const [currentRoll, setCurrentRoll] = useState(initialRoll);
    const [reportData, setReportData] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');

    const searchBoxRef = useRef(null);

    // Fetch report data for a given student identifier
    const fetchReport = async (identifier) => {
        if (!identifier || !identifier.trim()) return;
        const cleanId = identifier.trim();
        try {
            setLoading(true);
            setError('');
            setShowSuggestions(false);
            const res = await api.get(`/exit/faculty/report/${cleanId}`);
            setReportData(res.data);
            setCurrentRoll(res.data?.student?.rollNumber || cleanId);
            setSearchParams({ studentId: cleanId });
        } catch (err) {
            console.error('Failed to fetch faculty exit report:', err);
            setError(err.response?.data?.error || err.message || `No academic exit records found for student: ${cleanId}`);
            setReportData(null);
        } finally {
            setLoading(false);
        }
    };

    // Auto-load student on initial mount
    useEffect(() => {
        if (initialRoll) {
            fetchReport(initialRoll);
        }
    }, [paramStudentId]);

    // Handle debounced search suggestions
    useEffect(() => {
        if (!searchInput || searchInput.trim().length < 2) {
            setSuggestions([]);
            return;
        }

        const timer = setTimeout(async () => {
            try {
                setSearchingSuggestions(true);
                const res = await api.get(`/exit/search-students?query=${encodeURIComponent(searchInput.trim())}`);
                setSuggestions(res.data || []);
                setShowSuggestions(true);
            } catch (err) {
                console.error('Error fetching suggestions:', err);
            } finally {
                setSearchingSuggestions(false);
            }
        }, 300);

        return () => clearTimeout(timer);
    }, [searchInput]);

    // Close suggestions on outside click
    useEffect(() => {
        const handleClickOutside = (e) => {
            if (searchBoxRef.current && !searchBoxRef.current.contains(e.target)) {
                setShowSuggestions(false);
            }
        };
        document.addEventListener('mousedown', handleClickOutside);
        return () => document.removeEventListener('mousedown', handleClickOutside);
    }, []);

    const handleSearchSubmit = (e) => {
        e.preventDefault();
        fetchReport(searchInput);
    };

    const handleSelectSuggestion = (s) => {
        const roll = s.rollNumber || s.id;
        setSearchInput(roll);
        setShowSuggestions(false);
        fetchReport(roll);
    };

    return (
        <div className="faculty-content" style={{ padding: '2rem' }}>
            {/* Header */}
            <div style={{ marginBottom: '1.5rem' }}>
                <h1 style={{ fontSize: '1.75rem', fontWeight: 800, color: '#0f172a', margin: 0 }}>
                    Student Exit Requirement Reports
                </h1>
                <p style={{ color: '#64748b', margin: '0.35rem 0 0 0', fontSize: '0.95rem' }}>
                    Audit academic progress, verify 10 curriculum verticals, and generate official 6-page graduation reports for advisees.
                </p>
            </div>

            {/* Student Search Panel */}
            <div 
                style={{
                    background: '#ffffff',
                    border: '1px solid #e2e8f0',
                    borderRadius: '12px',
                    padding: '1.25rem 1.5rem',
                    marginBottom: '1.5rem',
                    boxShadow: '0 2px 8px -2px rgba(0,0,0,0.05)'
                }}
            >
                <form onSubmit={handleSearchSubmit} style={{ display: 'flex', gap: '1rem', alignItems: 'flex-start', flexWrap: 'wrap' }}>
                    <div ref={searchBoxRef} style={{ position: 'relative', flex: '1 1 320px' }}>
                        <label style={{ display: 'block', fontSize: '0.8rem', fontWeight: 700, color: '#475569', marginBottom: '0.4rem', textTransform: 'uppercase' }}>
                            Search Student by ID / Roll Number
                        </label>
                        <div style={{ position: 'relative' }}>
                            <input
                                type="text"
                                className="form-control"
                                placeholder="Enter Student ID (e.g. 2300080412)..."
                                value={searchInput}
                                onChange={(e) => setSearchInput(e.target.value)}
                                onFocus={() => suggestions.length > 0 && setShowSuggestions(true)}
                                style={{
                                    width: '100%',
                                    padding: '0.65rem 1rem',
                                    borderRadius: '8px',
                                    border: '1px solid #cbd5e1',
                                    fontSize: '0.95rem',
                                    fontWeight: 500
                                }}
                            />
                            {searchingSuggestions && (
                                <span style={{ position: 'absolute', right: '12px', top: '50%', transform: 'translateY(-50%)', fontSize: '0.8rem', color: '#94a3b8' }}>
                                    Searching...
                                </span>
                            )}
                        </div>

                        {/* Suggestions Dropdown */}
                        {showSuggestions && suggestions.length > 0 && (
                            <div
                                style={{
                                    position: 'absolute',
                                    top: '100%',
                                    left: 0,
                                    right: 0,
                                    background: '#ffffff',
                                    border: '1px solid #cbd5e1',
                                    borderRadius: '8px',
                                    marginTop: '4px',
                                    boxShadow: '0 10px 25px -5px rgba(0,0,0,0.1)',
                                    zIndex: 50,
                                    maxHeight: '260px',
                                    overflowY: 'auto'
                                }}
                            >
                                {suggestions.map((s) => (
                                    <div
                                        key={s.id}
                                        onClick={() => handleSelectSuggestion(s)}
                                        style={{
                                            padding: '0.65rem 1rem',
                                            cursor: 'pointer',
                                            borderBottom: '1px solid #f1f5f9',
                                            display: 'flex',
                                            justifyContent: 'space-between',
                                            alignItems: 'center',
                                            fontSize: '0.9rem'
                                        }}
                                        onMouseEnter={(e) => e.currentTarget.style.background = '#f8fafc'}
                                        onMouseLeave={(e) => e.currentTarget.style.background = '#ffffff'}
                                    >
                                        <div>
                                            <strong style={{ color: '#8c1d40' }}>{s.rollNumber}</strong>
                                            <span style={{ marginLeft: '0.75rem', color: '#1e293b' }}>
                                                {s.firstName} {s.lastName}
                                            </span>
                                        </div>
                                        <span style={{ fontSize: '0.75rem', background: '#e2e8f0', color: '#475569', padding: '0.2rem 0.5rem', borderRadius: '4px' }}>
                                            {s.department}
                                        </span>
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>

                    <div style={{ alignSelf: 'flex-end', display: 'flex', gap: '0.75rem' }}>
                        <button
                            type="submit"
                            disabled={loading || !searchInput.trim()}
                            style={{
                                background: '#8c1d40',
                                color: '#ffffff',
                                border: 'none',
                                padding: '0.65rem 1.5rem',
                                borderRadius: '8px',
                                fontWeight: 600,
                                fontSize: '0.95rem',
                                cursor: 'pointer',
                                display: 'inline-flex',
                                alignItems: 'center',
                                gap: '0.5rem',
                                boxShadow: '0 2px 6px rgba(140, 29, 64, 0.25)'
                            }}
                        >
                            {loading ? 'Searching...' : '🔍 Fetch Report'}
                        </button>
                    </div>
                </form>

                {/* Quick Roll Suggestion Chips */}
                <div style={{ marginTop: '0.75rem', display: 'flex', alignItems: 'center', gap: '0.5rem', flexWrap: 'wrap' }}>
                    <span style={{ fontSize: '0.8rem', color: '#64748b' }}>Quick Sample:</span>
                    <button
                        type="button"
                        onClick={() => {
                            setSearchInput('2300080412');
                            fetchReport('2300080412');
                        }}
                        style={{
                            background: '#f1f5f9',
                            border: '1px solid #cbd5e1',
                            borderRadius: '9999px',
                            padding: '0.2rem 0.75rem',
                            fontSize: '0.8rem',
                            cursor: 'pointer',
                            color: '#1e293b',
                            fontWeight: 600
                        }}
                    >
                        2300080412 (RONGALA DEVISREE - AIDS)
                    </button>
                </div>
            </div>

            {/* Error Notification */}
            {error && (
                <div 
                    style={{
                        background: '#fef2f2',
                        border: '1px solid #fecaca',
                        borderRadius: '8px',
                        padding: '1rem 1.25rem',
                        color: '#b91c1c',
                        marginBottom: '1.5rem',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'space-between'
                    }}
                >
                    <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
                        <span style={{ fontSize: '1.25rem' }}>⚠️</span>
                        <span>{error}</span>
                    </div>
                    <button
                        onClick={() => setError('')}
                        style={{ background: 'none', border: 'none', color: '#b91c1c', cursor: 'pointer', fontWeight: 700 }}
                    >
                        &times;
                    </button>
                </div>
            )}

            {/* Loading Indicator */}
            {loading && (
                <div 
                    style={{
                        padding: '3rem',
                        textAlign: 'center',
                        background: '#ffffff',
                        borderRadius: '12px',
                        border: '1px solid #e2e8f0',
                        color: '#64748b'
                    }}
                >
                    <div style={{ fontSize: '2rem', marginBottom: '0.75rem', animation: 'spin 1s linear infinite' }}>⏳</div>
                    <h3 style={{ margin: 0, color: '#1e293b' }}>Retrieving Academic Exit Records</h3>
                    <p style={{ margin: '0.5rem 0 0 0', fontSize: '0.9rem' }}>
                        Computing 10 curriculum verticals and course attempts for Roll No: <strong>{searchInput}</strong>...
                    </p>
                </div>
            )}

            {/* Preview Component */}
            {!loading && reportData && (
                <ExitRequirementReportPreview
                    reportData={reportData}
                    downloadUrl={`/exit/faculty/download-pdf/${currentRoll}`}
                    onRefresh={() => fetchReport(currentRoll)}
                />
            )}
        </div>
    );
}
