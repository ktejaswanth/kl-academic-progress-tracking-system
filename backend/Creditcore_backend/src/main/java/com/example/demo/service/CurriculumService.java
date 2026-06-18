package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@Transactional
public class CurriculumService {

    @Autowired
    private DegreeProgramRepository degreeProgramRepository;

    @Autowired
    private SpecializationRepository specializationRepository;

    @Autowired
    private HonorsProgramRepository honorsProgramRepository;

    @Autowired
    private CourseCatalogRepository courseCatalogRepository;

    @Autowired
    private CurriculumVersionRepository curriculumVersionRepository;

    @Autowired
    private ProgramRequirementRepository programRequirementRepository;

    @Autowired
    private CurriculumCourseRepository curriculumCourseRepository;

    public DegreeProgram createProgram(DegreeProgram program) {
        return degreeProgramRepository.save(program);
    }

    public DegreeProgram updateProgram(Long id, DegreeProgram updates) {
        DegreeProgram program = degreeProgramRepository.findById(id).orElseThrow(() -> new RuntimeException("Program not found"));
        program.setName(updates.getName());
        program.setBranch(updates.getBranch());
        program.setBatchStart(updates.getBatchStart());
        program.setBatchEnd(updates.getBatchEnd());
        program.setRegulation(updates.getRegulation());
        program.setDurationYears(updates.getDurationYears());
        return degreeProgramRepository.save(program);
    }

    public List<DegreeProgram> listPrograms() {
        return degreeProgramRepository.findAll();
    }

    public Specialization createSpecialization(Specialization specialization) {
        return specializationRepository.save(specialization);
    }

    public HonorsProgram createHonorsProgram(HonorsProgram honorsProgram) {
        return honorsProgramRepository.save(honorsProgram);
    }

    public CourseCatalog createCourse(CourseCatalog course) {
        return courseCatalogRepository.save(course);
    }

    public List<CourseCatalog> listCourses() {
        return courseCatalogRepository.findAll();
    }

    public CurriculumVersion createCurriculumVersion(CurriculumVersion version) {
        if (version.getEffectiveFrom() == null) {
            version.setEffectiveFrom(LocalDate.now());
        }
        return curriculumVersionRepository.save(version);
    }

    public ProgramRequirement createProgramRequirement(ProgramRequirement requirement) {
        return programRequirementRepository.save(requirement);
    }

    public CurriculumCourse createCurriculumCourse(CurriculumCourse curriculumCourse) {
        return curriculumCourseRepository.save(curriculumCourse);
    }

    public void deleteDegreeProgram(Long id) {
        degreeProgramRepository.deleteById(id);
    }

    public Optional<Specialization> getSpecialization(Long id) {
        return specializationRepository.findById(id);
    }

    public Specialization updateSpecialization(Long id, Specialization updates) {
        Specialization specialization = specializationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Specialization not found"));
        specialization.setCode(updates.getCode());
        specialization.setName(updates.getName());
        specialization.setDescription(updates.getDescription());
        specialization.setProgram(updates.getProgram() != null ? updates.getProgram() : specialization.getProgram());
        return specializationRepository.save(specialization);
    }

    public void deleteSpecialization(Long id) {
        specializationRepository.deleteById(id);
    }

    public Optional<HonorsProgram> getHonorsProgram(Long id) {
        return honorsProgramRepository.findById(id);
    }

    public HonorsProgram updateHonorsProgram(Long id, HonorsProgram updates) {
        HonorsProgram honorsProgram = honorsProgramRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Honors program not found"));
        honorsProgram.setCode(updates.getCode());
        honorsProgram.setName(updates.getName());
        honorsProgram.setCreditsRequired(updates.getCreditsRequired());
        honorsProgram.setResearchRequired(updates.getResearchRequired());
        honorsProgram.setProgram(updates.getProgram() != null ? updates.getProgram() : honorsProgram.getProgram());
        return honorsProgramRepository.save(honorsProgram);
    }

    public void deleteHonorsProgram(Long id) {
        honorsProgramRepository.deleteById(id);
    }

    public Optional<CourseCatalog> getCourse(Long id) {
        return courseCatalogRepository.findById(id);
    }

    public CourseCatalog updateCourse(Long id, CourseCatalog updates) {
        CourseCatalog course = courseCatalogRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Course not found"));
        course.setCourseCode(updates.getCourseCode());
        course.setCourseName(updates.getCourseName());
        course.setCredits(updates.getCredits());
        course.setCategory(updates.getCategory());
        course.setOfferedSemester(updates.getOfferedSemester());
        course.setMetadata(updates.getMetadata());
        return courseCatalogRepository.save(course);
    }

    public void deleteCourse(Long id) {
        courseCatalogRepository.deleteById(id);
    }

    public CurriculumVersion updateCurriculumVersion(Long id, CurriculumVersion updates) {
        CurriculumVersion version = curriculumVersionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Curriculum version not found"));
        version.setVersionName(updates.getVersionName());
        version.setRegulation(updates.getRegulation());
        version.setEffectiveFrom(updates.getEffectiveFrom());
        version.setProgram(updates.getProgram() != null ? updates.getProgram() : version.getProgram());
        return curriculumVersionRepository.save(version);
    }

    public void deleteCurriculumVersion(Long id) {
        curriculumVersionRepository.deleteById(id);
    }

    public List<ProgramRequirement> listProgramRequirementsByVersion(Long versionId) {
        return programRequirementRepository.findByCurriculumVersionId(versionId);
    }

    public ProgramRequirement updateProgramRequirement(Long id, ProgramRequirement updates) {
        ProgramRequirement requirement = programRequirementRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Program requirement not found"));
        requirement.setBucketName(updates.getBucketName());
        requirement.setRequiredCredits(updates.getRequiredCredits());
        requirement.setMandatoryCourseCodes(updates.getMandatoryCourseCodes());
        requirement.setAllowedElectives(updates.getAllowedElectives());
        requirement.setCurriculumVersion(updates.getCurriculumVersion() != null ? updates.getCurriculumVersion() : requirement.getCurriculumVersion());
        return programRequirementRepository.save(requirement);
    }

    public void deleteProgramRequirement(Long id) {
        programRequirementRepository.deleteById(id);
    }

    public Optional<CurriculumCourse> getCurriculumCourse(Long id) {
        return curriculumCourseRepository.findById(id);
    }

    public CurriculumCourse updateCurriculumCourse(Long id, CurriculumCourse updates) {
        CurriculumCourse curriculumCourse = curriculumCourseRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Curriculum course not found"));
        curriculumCourse.setBucketName(updates.getBucketName());
        curriculumCourse.setIsMandatory(updates.getIsMandatory());
        curriculumCourse.setMinYear(updates.getMinYear());
        curriculumCourse.setMaxYear(updates.getMaxYear());
        curriculumCourse.setCourse(updates.getCourse() != null ? updates.getCourse() : curriculumCourse.getCourse());
        curriculumCourse.setCurriculumVersion(updates.getCurriculumVersion() != null ? updates.getCurriculumVersion() : curriculumCourse.getCurriculumVersion());
        return curriculumCourseRepository.save(curriculumCourse);
    }

    public void deleteCurriculumCourse(Long id) {
        curriculumCourseRepository.deleteById(id);
    }

    public Optional<DegreeProgram> getProgram(Long id) {
        return degreeProgramRepository.findById(id);
    }

    public Optional<CurriculumVersion> getCurriculumVersion(Long id) {
        return curriculumVersionRepository.findById(id);
    }

    public List<Specialization> getSpecializationsByProgram(Long programId) {
        return specializationRepository.findByProgramId(programId);
    }

    public List<HonorsProgram> getHonorsProgramsByProgram(Long programId) {
        return honorsProgramRepository.findByProgramId(programId);
    }

    public List<CurriculumVersion> listCurriculumVersionsByProgram(Long programId) {
        return curriculumVersionRepository.findByProgramId(programId);
    }

    public List<CurriculumCourse> listCurriculumCoursesByVersion(Long versionId) {
        return curriculumCourseRepository.findByCurriculumVersionId(versionId);
    }
}
