import React from 'react';
import { useStudentData } from './StudentDataContext';
import './student.css';

export default function MyDegreePathView() {
    const { dashboardData, loading } = useStudentData();

    if (loading) {
        return (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '60vh', color: '#8B0000' }}>
                <div className="spinner" style={{ width: '40px', height: '40px', borderTopColor: '#8B0000', borderWidth: '3px' }}></div>
            </div>
        );
    }

    const student = dashboardData?.student || {};
    const degreePath = dashboardData?.degreePath || {};
    const status = dashboardData?.degreeStatus || {};
    const department = student.department || degreePath.departmentName || degreePath.department || 'Not assigned';
    const degreeName = student.subDepartment || student.degreeType || degreePath.degreeTypeName || 'Not assigned';
    const specializationType = student.specializationType || student.addonType || degreePath.addonTypeName || degreePath.addonType;
    const specializationName = student.specializationName || student.addonName || degreePath.addonName || degreePath.specializationName;
    const hasSpecialization = specializationName && !['N/A', 'NONE'].includes(String(specializationName).toUpperCase());
    const totalRequiredCredits = Number(status.totalRequiredCredits ?? degreePath.totalRequiredCredits ?? 0);
    const totalEarnedCredits = Number(status.totalEarnedCredits ?? 0);
    const calculatedPercentage = totalRequiredCredits > 0 ? Math.round((totalEarnedCredits / totalRequiredCredits) * 100) : 0;
    const completionPercentage = Math.max(0, Math.min(100, Number(status.completionPercentage ?? calculatedPercentage)));

    const rawDept = student.department || degreePath.department || 'Not Available';
    const departmentDisplay = student.departmentName || (rawDept !== 'Not Available' ? `${rawDept} Department` : 'Not Available');
    const curriculumDisplay = student.curriculum || degreePath.curriculum || 'Y23 Regulation';
    const degreeTypeDisplay = student.degreeType || degreePath.degreeTypeName || 'Regular';
    const rawSpec = student.specialization || degreePath.specialization || student.addonName || degreePath.addonName;
    const specializationDisplay = (rawSpec && rawSpec !== 'N/A' && rawSpec !== 'NONE' && rawSpec !== 'Not Available')
        ? rawSpec
        : 'Not Available';

    const pathNodes = [
        { label: 'Programme', value: 'B.Tech (Bachelor of Technology)', icon: '🎓', desc: 'Core 4-Year Undergraduate Degree' },
        { label: 'Department', value: departmentDisplay, icon: '🏛️', desc: 'Primary Engineering Discipline' },
        { label: 'Curriculum Version', value: curriculumDisplay, icon: '📚', desc: 'Institutional Academic Framework' },
        { label: 'Degree Type', value: degreeTypeDisplay, icon: '📜', desc: 'Degree Classification Track' },
        { label: 'Specialization / Minor', value: specializationDisplay, icon: '⭐', desc: 'Discipline-Specific Concentration' },
    ];

    const displayPathNodes = pathNodes.map((node, index) => {
        if (index === 0) return { ...node, value: degreePath.programName || student.program || node.value };
        if (index === 1) return { ...node, value: department };
        if (index === 2) return { ...node, value: student.academicYear || student.curriculum || degreePath.curriculumVersion || 'Not assigned' };
        if (index === 3) return { ...node, value: degreeName, desc: 'Student degree classification' };
        return {
            ...node,
            label: specializationType || 'Specialization / Minor',
            value: hasSpecialization ? specializationName : 'Not selected',
            desc: hasSpecialization ? 'Student specialization selection' : 'No specialization is assigned'
        };
    });

    return (
        <div className="student-degree-path animate-fade" style={{ maxWidth: '1400px', margin: '0 auto', paddingBottom: '3rem' }}>
            <div style={{ marginBottom: '2rem' }}>
                <h1 style={{ fontSize: '2rem', color: '#1E293B', margin: '0 0 6px', fontWeight: 800 }}>My Academic Degree Path</h1>
                <p style={{ color: '#64748B', margin: 0, fontSize: '0.95rem' }}>
                    Authoritative hierarchical degree structure and credit allocation applicable to your matriculation
                </p>
            </div>

            {/* Hierarchical Flow Stepper */}
            <div className="glass-card" style={{ padding: '2.5rem', background: 'white', marginBottom: '2.5rem' }}>
                <h3 style={{ margin: '0 0 1.8rem', color: '#1E293B', fontSize: '1.25rem' }}>Academic Degree Structure Flow</h3>

                <div style={{ display: 'flex', flexDirection: 'column', gap: '1.2rem', position: 'relative' }}>
                    {displayPathNodes.map((node, idx) => (
                        <div key={idx} style={{ display: 'flex', alignItems: 'flex-start', gap: '20px' }}>
                            {/* Step Indicator */}
                            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                                <div style={{
                                    width: '46px',
                                    height: '46px',
                                    borderRadius: '50%',
                                    background: idx === pathNodes.length - 1 ? '#8B0000' : '#FFF5F5',
                                    color: idx === pathNodes.length - 1 ? 'white' : '#8B0000',
                                    display: 'flex',
                                    alignItems: 'center',
                                    justifyContent: 'center',
                                    fontSize: '1.2rem',
                                    border: '2px solid #8B0000',
                                    fontWeight: 800
                                }}>
                                    {node.icon}
                                </div>
                                {idx < pathNodes.length - 1 && (
                                    <div style={{ width: '3px', height: '40px', background: '#E2E8F0', margin: '4px 0' }}></div>
                                )}
                            </div>

                            {/* Node Content */}
                            <div style={{ background: '#F8FAFC', padding: '16px 20px', borderRadius: '14px', border: '1px solid #E2E8F0', flex: 1 }}>
                                <span style={{ fontSize: '0.75rem', fontWeight: 700, color: '#8B0000', textTransform: 'uppercase', letterSpacing: '0.5px' }}>
                                    Level {idx + 1}: {node.label}
                                </span>
                                <h4 style={{ margin: '4px 0 2px', color: '#0F172A', fontSize: '1.15rem' }}>{node.value}</h4>
                                <p style={{ margin: 0, fontSize: '0.85rem', color: '#64748B' }}>{node.desc}</p>
                            </div>
                        </div>
                    ))}
                </div>
            </div>

            {/* Path Credit Specifications */}
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '1.5rem' }}>
                <div className="glass-card" style={{ padding: '2rem', background: 'white' }}>
                    <span style={{ fontSize: '0.8rem', fontWeight: 700, color: '#64748B', textTransform: 'uppercase' }}>Total Path Credits</span>
                    <h3 style={{ margin: '6px 0', fontSize: '2.2rem', color: '#8B0000' }}>
                        {totalRequiredCredits} <span style={{ fontSize: '1rem', color: '#64748B' }}>Credits</span>
                    </h3>
                    <p style={{ margin: 0, fontSize: '0.88rem', color: '#475569' }}>
                        Required for regular degree conferral under this curriculum.
                    </p>
                </div>

                <div className="glass-card" style={{ padding: '2rem', background: 'white' }}>
                    <span style={{ fontSize: '0.8rem', fontWeight: 700, color: '#64748B', textTransform: 'uppercase' }}>Credits Satisfied</span>
                    <h3 style={{ margin: '6px 0', fontSize: '2.2rem', color: '#059669' }}>
                        {totalEarnedCredits} <span style={{ fontSize: '1rem', color: '#64748B' }}>Credits</span>
                    </h3>
                    <p style={{ margin: 0, fontSize: '0.88rem', color: '#475569' }}>
                        Successfully completed and audited towards your graduation requirement.
                    </p>
                </div>

                <div className="glass-card" style={{ padding: '2rem', background: 'white' }}>
                    <span style={{ fontSize: '0.8rem', fontWeight: 700, color: '#64748B', textTransform: 'uppercase' }}>Degree Completion</span>
                    <h3 style={{ margin: '6px 0', fontSize: '2.2rem', color: '#8B0000' }}>
                        {completionPercentage}%
                    </h3>
                    <div style={{ width: '100%', height: '8px', background: '#E2E8F0', borderRadius: '6px', overflow: 'hidden', margin: '10px 0' }}>
                        <div style={{ width: `${completionPercentage}%`, height: '100%', background: 'linear-gradient(90deg, #8B0000, #D4AF37)', borderRadius: '6px' }}></div>
                    </div>
                    <p style={{ margin: 0, fontSize: '0.88rem', color: '#475569' }}>
                        Live progress calculated from credits earned against your degree requirement.
                    </p>
                </div>

                <div className="glass-card" style={{ padding: '2rem', background: 'white' }}>
                    <span style={{ fontSize: '0.8rem', fontWeight: 700, color: '#64748B', textTransform: 'uppercase' }}>Path Clearance Status</span>
                    <h3 style={{ margin: '6px 0', fontSize: '1.4rem', color: status.isDegreeEligible ? '#059669' : '#D97706' }}>
                        {status.isDegreeEligible ? '✅ PATH COMPLIANT' : '⏳ IN PROGRESS'}
                    </h3>
                    <p style={{ margin: 0, fontSize: '0.88rem', color: '#475569' }}>
                        Subject to passing all mandatory course clusters and minimum CGPA criteria.
                    </p>
                </div>
            </div>
        </div>
    );
}
