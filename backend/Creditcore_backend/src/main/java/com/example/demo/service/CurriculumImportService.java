package com.example.demo.service;

import com.example.demo.dto.curriculum.*;
import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.example.demo.service.ai.GeminiService;
import com.example.demo.service.pdf.PdfExtractorService;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class CurriculumImportService {

    private static final Logger log = LoggerFactory.getLogger(CurriculumImportService.class);

    @Autowired private CurriculumImportRepository importRepository;
    @Autowired private PdfExtractorService pdfExtractorService;
    @Autowired private GeminiService geminiService;
    @Autowired private CurriculumValidator validator;

    // Master data repositories
    @Autowired private DepartmentMasterRepository departmentRepo;
    @Autowired private RegulationMasterRepository regulationRepo;
    @Autowired private DegreeTypeMasterRepository degreeTypeRepo;
    @Autowired private AddonTypeMasterRepository addonTypeRepo;
    @Autowired private BucketMasterRepository bucketRepo;
    @Autowired private CourseCatalogRepository courseRepo;
    @Autowired private DegreePathRepository degreePathRepo;
    @Autowired private PathBucketRequirementRepository pathReqRepo;
    @Autowired private CourseBucketMappingRepository courseBucketRepo;

    private final Gson gson = new Gson();

    // =================== UPLOAD ===================

    public CurriculumImportSummary uploadPdf(MultipartFile file, CurriculumUploadRequest request) {
        try {
            log.info("Uploading curriculum PDF: {}", file.getOriginalFilename());

            // Extract text from PDF
            String extractedText = pdfExtractorService.extractText(file);
            log.info("Extracted {} characters from PDF", extractedText.length());

            // Create import record
            CurriculumImport importRecord = new CurriculumImport();
            importRecord.setCurriculumName(request.getCurriculumName());
            importRecord.setDepartment(request.getDepartment());
            importRecord.setRegulation(request.getRegulation());
            importRecord.setAcademicYear(request.getAcademicYear());
            importRecord.setPdfFileName(file.getOriginalFilename());
            importRecord.setStatus("UPLOADED");
            importRecord.setExtractedText(extractedText);

            importRecord = importRepository.save(importRecord);
            log.info("Created curriculum import record with ID: {}", importRecord.getId());

            return toSummary(importRecord);
        } catch (Exception e) {
            log.error("Failed to upload curriculum PDF", e);
            throw new RuntimeException("Failed to process PDF: " + e.getMessage());
        }
    }

    // =================== ANALYZE ===================

    public CurriculumImportSummary analyzeCurriculum(Long importId) {
        CurriculumImport importRecord = importRepository.findById(importId)
                .orElseThrow(() -> new RuntimeException("Import not found: " + importId));

        try {
            importRecord.setStatus("ANALYZING");
            importRepository.save(importRecord);

            log.info("Starting AI analysis for import ID: {}", importId);

            // Call Gemini AI
            String rawJson = geminiService.analyzeRaw(
                    importRecord.getExtractedText(),
                    importRecord.getDepartment(),
                    importRecord.getRegulation()
            );

            // Parse and validate
            CurriculumAnalysisResult result = geminiService.parseResult(rawJson);
            List<String> validationErrors = validator.validate(result);

            // Update import record
            importRecord.setAiAnalysisJson(rawJson);
            importRecord.setStatus("ANALYZED");
            importRecord.setAnalyzedAt(LocalDateTime.now());
            importRecord.setCoursesFound(result.getCourses() != null ? result.getCourses().size() : 0);
            importRecord.setBucketsFound(result.getBucketRequirements() != null ?
                    (int) result.getBucketRequirements().stream()
                            .map(ParsedBucketRequirement::getBucketCode)
                            .distinct().count() : 0);
            importRecord.setDegreeTypesFound(result.getDegreeTypes() != null ? result.getDegreeTypes().size() : 0);
            importRecord.setSpecializationsFound(result.getSpecializations() != null ? result.getSpecializations().size() : 0);
            importRecord.setMinorsFound(result.getMinors() != null ? result.getMinors().size() : 0);
            importRecord.setDoubleMajorsFound(result.getDoubleMajors() != null ? result.getDoubleMajors().size() : 0);
            importRecord.setValidationErrors(gson.toJson(validationErrors));

            importRepository.save(importRecord);
            log.info("AI analysis complete for import ID: {}. Courses: {}, Buckets: {}",
                    importId, importRecord.getCoursesFound(), importRecord.getBucketsFound());

            return toSummary(importRecord);

        } catch (Exception e) {
            log.error("AI analysis failed for import ID: {}", importId, e);
            importRecord.setStatus("FAILED");
            importRecord.setValidationErrors(gson.toJson(List.of("FATAL: " + e.getMessage())));
            importRepository.save(importRecord);
            throw new RuntimeException("AI analysis failed: " + e.getMessage());
        }
    }

    // =================== REVIEW / QUERY ===================

    public CurriculumImportSummary getSummary(Long importId) {
        CurriculumImport importRecord = importRepository.findById(importId)
                .orElseThrow(() -> new RuntimeException("Import not found: " + importId));
        return toSummary(importRecord);
    }

    public CurriculumAnalysisResult getAnalysisDetail(Long importId) {
        CurriculumImport importRecord = importRepository.findById(importId)
                .orElseThrow(() -> new RuntimeException("Import not found: " + importId));

        if (importRecord.getAiAnalysisJson() == null || importRecord.getAiAnalysisJson().isBlank()) {
            throw new RuntimeException("No analysis available for import ID: " + importId);
        }

        return geminiService.parseResult(importRecord.getAiAnalysisJson());
    }

    public List<CurriculumImportSummary> listImports() {
        return importRepository.findAllByOrderByCreatedAtDesc().stream()
                .map(this::toSummary)
                .collect(Collectors.toList());
    }

    // =================== EDIT ===================

    public CurriculumImportSummary updateAnalysis(Long importId, CurriculumAnalysisResult editedResult) {
        CurriculumImport importRecord = importRepository.findById(importId)
                .orElseThrow(() -> new RuntimeException("Import not found: " + importId));

        // Re-validate
        List<String> validationErrors = validator.validate(editedResult);

        // Update
        importRecord.setAiAnalysisJson(gson.toJson(editedResult));
        importRecord.setCoursesFound(editedResult.getCourses() != null ? editedResult.getCourses().size() : 0);
        importRecord.setBucketsFound(editedResult.getBucketRequirements() != null ?
                (int) editedResult.getBucketRequirements().stream()
                        .map(ParsedBucketRequirement::getBucketCode)
                        .distinct().count() : 0);
        importRecord.setDegreeTypesFound(editedResult.getDegreeTypes() != null ? editedResult.getDegreeTypes().size() : 0);
        importRecord.setSpecializationsFound(editedResult.getSpecializations() != null ? editedResult.getSpecializations().size() : 0);
        importRecord.setMinorsFound(editedResult.getMinors() != null ? editedResult.getMinors().size() : 0);
        importRecord.setDoubleMajorsFound(editedResult.getDoubleMajors() != null ? editedResult.getDoubleMajors().size() : 0);
        importRecord.setValidationErrors(gson.toJson(validationErrors));

        importRepository.save(importRecord);
        return toSummary(importRecord);
    }

    // =================== APPROVE (TRANSACTIONAL) ===================

    @Transactional
    public CurriculumImportSummary approveCurriculum(Long importId, String approvedBy) {
        CurriculumImport importRecord = importRepository.findById(importId)
                .orElseThrow(() -> new RuntimeException("Import not found: " + importId));

        if (!"ANALYZED".equals(importRecord.getStatus())) {
            throw new RuntimeException("Can only approve imports with ANALYZED status. Current: " + importRecord.getStatus());
        }

        CurriculumAnalysisResult result = geminiService.parseResult(importRecord.getAiAnalysisJson());

        log.info("Starting approval transaction for import ID: {}", importId);

        // 1. Upsert Department
        DepartmentMaster dept = upsertDepartment(result.getDepartment(),
                result.getDepartmentFullName() != null ? result.getDepartmentFullName() : result.getDepartment());

        // 2. Upsert Regulation
        RegulationMaster reg = upsertRegulation(result.getRegulation());

        // 3. Upsert Degree Types
        Map<String, DegreeTypeMaster> degreeTypes = new HashMap<>();
        if (result.getDegreeTypes() != null) {
            for (String typeCode : result.getDegreeTypes()) {
                degreeTypes.put(typeCode, upsertDegreeType(typeCode));
            }
        }

        // 4. Upsert Addon Types
        Map<String, AddonTypeMaster> addonTypes = new HashMap<>();
        addonTypes.put("NONE", upsertAddonType("NONE", "No Add-on"));
        if (result.getAddonTypes() != null) {
            for (String addon : result.getAddonTypes()) {
                addonTypes.put(addon, upsertAddonType(addon, addon));
            }
        }

        // 5. Upsert Buckets
        Map<String, BucketMaster> buckets = new HashMap<>();
        if (result.getBucketRequirements() != null) {
            for (ParsedBucketRequirement req : result.getBucketRequirements()) {
                if (req.getBucketCode() != null && !buckets.containsKey(req.getBucketCode())) {
                    buckets.put(req.getBucketCode(), upsertBucket(req));
                }
            }
        }

        // Also extract bucket codes from courses
        if (result.getCourses() != null) {
            for (ParsedCourse course : result.getCourses()) {
                String bucketCode = course.getSubCategory();
                if (bucketCode != null && !bucketCode.isBlank() && !buckets.containsKey(bucketCode)) {
                    BucketMaster existing = bucketRepo.findByBucketCode(bucketCode).orElse(null);
                    if (existing != null) {
                        buckets.put(bucketCode, existing);
                    } else {
                        BucketMaster newBucket = new BucketMaster();
                        newBucket.setBucketCode(bucketCode);
                        newBucket.setBucketName(bucketCode);
                        newBucket.setBucketCategory(course.getCategory());
                        newBucket.setDescription("Auto-created from curriculum import");
                        buckets.put(bucketCode, bucketRepo.save(newBucket));
                    }
                }
            }
        }

        // 6. Upsert Courses
        Map<String, CourseCatalog> courses = new HashMap<>();
        if (result.getCourses() != null) {
            for (ParsedCourse pc : result.getCourses()) {
                if (pc.getCourseCode() != null && !pc.getCourseCode().isBlank()) {
                    courses.put(pc.getCourseCode(), upsertCourse(pc));
                }
            }
        }

        // 7. Generate Degree Paths
        Map<String, DegreePath> paths = new HashMap<>();
        if (result.getDegreePaths() != null) {
            for (ParsedDegreePath pdp : result.getDegreePaths()) {
                DegreeTypeMaster dt = degreeTypes.get(pdp.getDegreeType());
                AddonTypeMaster at = addonTypes.getOrDefault(pdp.getAddonType(), addonTypes.get("NONE"));
                if (dt != null) {
                    DegreePath path = upsertDegreePath(dept, dt, at, reg, pdp);
                    paths.put(path.getPathCode(), path);
                }
            }
        }

        // 8. Insert Path Bucket Requirements
        if (result.getBucketRequirements() != null) {
            for (ParsedBucketRequirement req : result.getBucketRequirements()) {
                BucketMaster bucket = buckets.get(req.getBucketCode());
                if (bucket == null) continue;

                // Find matching paths for this requirement's degree type
                for (Map.Entry<String, DegreePath> entry : paths.entrySet()) {
                    DegreePath path = entry.getValue();
                    boolean matchesDegreeType = req.getDegreeType() == null ||
                            req.getDegreeType().equalsIgnoreCase("ALL") ||
                            (path.getDegreeType() != null &&
                             path.getDegreeType().getTypeCode().equalsIgnoreCase(req.getDegreeType()));

                    if (matchesDegreeType) {
                        upsertPathBucketRequirement(path, bucket, req);
                    }
                }
            }
        }

        // 9. Insert Course Bucket Mappings
        if (result.getCourses() != null) {
            for (ParsedCourse pc : result.getCourses()) {
                if (pc.getCourseCode() == null || pc.getSubCategory() == null) continue;
                CourseCatalog course = courses.get(pc.getCourseCode());
                BucketMaster bucket = buckets.get(pc.getSubCategory());
                if (course != null && bucket != null) {
                    upsertCourseBucketMapping(course, bucket, pc);
                }
            }
        }

        // 10. Update import record
        importRecord.setStatus("APPROVED");
        importRecord.setApprovedAt(LocalDateTime.now());
        importRecord.setApprovedBy(approvedBy);
        importRepository.save(importRecord);

        log.info("Curriculum import ID: {} approved successfully. Courses: {}, Buckets: {}, Paths: {}",
                importId, courses.size(), buckets.size(), paths.size());

        return toSummary(importRecord);
    }

    // =================== REJECT ===================

    public CurriculumImportSummary rejectCurriculum(Long importId) {
        CurriculumImport importRecord = importRepository.findById(importId)
                .orElseThrow(() -> new RuntimeException("Import not found: " + importId));
        importRecord.setStatus("REJECTED");
        importRepository.save(importRecord);
        return toSummary(importRecord);
    }

    // =================== DELETE ===================

    public void deleteImport(Long importId) {
        importRepository.deleteById(importId);
    }

    // =================== UPSERT HELPERS ===================

    private DepartmentMaster upsertDepartment(String deptCode, String deptName) {
        return departmentRepo.findAll().stream()
                .filter(d -> d.getDeptCode().equalsIgnoreCase(deptCode))
                .findFirst()
                .orElseGet(() -> {
                    DepartmentMaster d = new DepartmentMaster();
                    d.setDeptCode(deptCode);
                    d.setDeptName(deptName);
                    return departmentRepo.save(d);
                });
    }

    private RegulationMaster upsertRegulation(String regCode) {
        return regulationRepo.findAll().stream()
                .filter(r -> r.getRegCode().equalsIgnoreCase(regCode))
                .findFirst()
                .orElseGet(() -> {
                    RegulationMaster r = new RegulationMaster();
                    r.setRegCode(regCode);
                    r.setRegName(regCode + " Regulation");
                    try {
                        r.setEffectiveYear(Integer.parseInt(regCode.replaceAll("[^0-9]", "")));
                    } catch (NumberFormatException e) {
                        r.setEffectiveYear(null);
                    }
                    return regulationRepo.save(r);
                });
    }

    private DegreeTypeMaster upsertDegreeType(String typeCode) {
        return degreeTypeRepo.findAll().stream()
                .filter(dt -> dt.getTypeCode().equalsIgnoreCase(typeCode))
                .findFirst()
                .orElseGet(() -> {
                    DegreeTypeMaster dt = new DegreeTypeMaster();
                    dt.setTypeCode(typeCode);
                    dt.setTypeName(typeCode);
                    dt.setDescription("Auto-created from curriculum import");
                    return degreeTypeRepo.save(dt);
                });
    }

    private AddonTypeMaster upsertAddonType(String addonCode, String addonName) {
        return addonTypeRepo.findAll().stream()
                .filter(a -> a.getAddonCode().equalsIgnoreCase(addonCode))
                .findFirst()
                .orElseGet(() -> {
                    AddonTypeMaster a = new AddonTypeMaster();
                    a.setAddonCode(addonCode);
                    a.setAddonName(addonName);
                    return addonTypeRepo.save(a);
                });
    }

    private BucketMaster upsertBucket(ParsedBucketRequirement req) {
        return bucketRepo.findByBucketCode(req.getBucketCode())
                .orElseGet(() -> {
                    BucketMaster b = new BucketMaster();
                    b.setBucketCode(req.getBucketCode());
                    b.setBucketName(req.getBucketName() != null ? req.getBucketName() : req.getBucketCode());
                    b.setBucketCategory(req.getBucketCategory());
                    b.setDescription("Auto-created from curriculum import");
                    return bucketRepo.save(b);
                });
    }

    private CourseCatalog upsertCourse(ParsedCourse pc) {
        Optional<CourseCatalog> existing = courseRepo.findAll().stream()
                .filter(c -> c.getCourseCode().equalsIgnoreCase(pc.getCourseCode()))
                .findFirst();

        if (existing.isPresent()) {
            CourseCatalog course = existing.get();
            // Update existing course with new data
            course.setCourseName(pc.getCourseName());
            course.setCredits(pc.getCredits() != null ? (int) Math.round(pc.getCredits()) : 0);
            course.setCategory(pc.getCategory());
            // Store LTPS info as metadata JSON
            String metadata = String.format(
                    "{\"L\":%d,\"T\":%d,\"P\":%d,\"S\":%d,\"mode\":\"%s\",\"acronym\":\"%s\"}",
                    pc.getLectureHours() != null ? pc.getLectureHours() : 0,
                    pc.getTutorialHours() != null ? pc.getTutorialHours() : 0,
                    pc.getPracticalHours() != null ? pc.getPracticalHours() : 0,
                    pc.getSkillHours() != null ? pc.getSkillHours() : 0,
                    pc.getMode() != null ? pc.getMode() : "",
                    pc.getAcronym() != null ? pc.getAcronym() : ""
            );
            course.setMetadata(metadata);
            return courseRepo.save(course);
        } else {
            CourseCatalog course = new CourseCatalog();
            course.setCourseCode(pc.getCourseCode());
            course.setCourseName(pc.getCourseName() != null ? pc.getCourseName() : pc.getCourseCode());
            course.setCredits(pc.getCredits() != null ? (int) Math.round(pc.getCredits()) : 0);
            course.setCategory(pc.getCategory());
            String metadata = String.format(
                    "{\"L\":%d,\"T\":%d,\"P\":%d,\"S\":%d,\"mode\":\"%s\",\"acronym\":\"%s\"}",
                    pc.getLectureHours() != null ? pc.getLectureHours() : 0,
                    pc.getTutorialHours() != null ? pc.getTutorialHours() : 0,
                    pc.getPracticalHours() != null ? pc.getPracticalHours() : 0,
                    pc.getSkillHours() != null ? pc.getSkillHours() : 0,
                    pc.getMode() != null ? pc.getMode() : "",
                    pc.getAcronym() != null ? pc.getAcronym() : ""
            );
            course.setMetadata(metadata);
            return courseRepo.save(course);
        }
    }

    private DegreePath upsertDegreePath(DepartmentMaster dept, DegreeTypeMaster degreeType,
                                         AddonTypeMaster addonType, RegulationMaster reg,
                                         ParsedDegreePath pdp) {
        String pathCode = dept.getDeptCode() + "-" + degreeType.getTypeCode();
        if (addonType != null && !"NONE".equalsIgnoreCase(addonType.getAddonCode())) {
            pathCode += "-" + addonType.getAddonCode();
        }

        final String finalPathCode = pathCode;
        return degreePathRepo.findAll().stream()
                .filter(p -> p.getPathCode().equalsIgnoreCase(finalPathCode))
                .findFirst()
                .orElseGet(() -> {
                    DegreePath path = new DegreePath();
                    path.setPathCode(finalPathCode);
                    path.setDepartment(dept);
                    path.setDegreeType(degreeType);
                    path.setAddonType(addonType);
                    path.setRegulation(reg);
                    path.setAddonName(pdp.getAddonName());
                    path.setTotalCredits(pdp.getTotalCredits() != null ? pdp.getTotalCredits() : 0);
                    path.setIsActive(true);
                    return degreePathRepo.save(path);
                });
    }

    private void upsertPathBucketRequirement(DegreePath path, BucketMaster bucket,
                                              ParsedBucketRequirement req) {
        boolean exists = pathReqRepo.findAll().stream()
                .anyMatch(r -> r.getDegreePath().getId().equals(path.getId()) &&
                              r.getBucket().getId().equals(bucket.getId()));
        if (!exists) {
            PathBucketRequirement pbr = new PathBucketRequirement();
            pbr.setDegreePath(path);
            pbr.setBucket(bucket);
            pbr.setRequiredCredits(req.getMinCredits() != null ? req.getMinCredits() : 0);
            pbr.setMinCourses(req.getMinCourses());
            pbr.setIsMandatory(true);
            pathReqRepo.save(pbr);
        }
    }

    private void upsertCourseBucketMapping(CourseCatalog course, BucketMaster bucket, ParsedCourse pc) {
        boolean exists = courseBucketRepo.findAll().stream()
                .anyMatch(m -> m.getCourse().getId().equals(course.getId()) &&
                              m.getBucket().getId().equals(bucket.getId()) &&
                              m.getDegreePath() == null);
        if (!exists) {
            CourseBucketMapping mapping = new CourseBucketMapping();
            mapping.setCourse(course);
            mapping.setBucket(bucket);
            mapping.setIsMandatory(pc.getIsMandatory() != null ? pc.getIsMandatory() : false);
            mapping.setDegreePath(null); // Global mapping, not path-specific
            courseBucketRepo.save(mapping);
        }
    }

    // =================== MAPPER ===================

    private CurriculumImportSummary toSummary(CurriculumImport record) {
        CurriculumImportSummary summary = new CurriculumImportSummary();
        summary.setId(record.getId());
        summary.setCurriculumName(record.getCurriculumName());
        summary.setDepartment(record.getDepartment());
        summary.setRegulation(record.getRegulation());
        summary.setAcademicYear(record.getAcademicYear());
        summary.setPdfFileName(record.getPdfFileName());
        summary.setStatus(record.getStatus());
        summary.setCoursesFound(record.getCoursesFound());
        summary.setBucketsFound(record.getBucketsFound());
        summary.setDegreeTypesFound(record.getDegreeTypesFound());
        summary.setSpecializationsFound(record.getSpecializationsFound());
        summary.setMinorsFound(record.getMinorsFound());
        summary.setDoubleMajorsFound(record.getDoubleMajorsFound());
        summary.setCreatedAt(record.getCreatedAt());
        summary.setAnalyzedAt(record.getAnalyzedAt());
        summary.setApprovedAt(record.getApprovedAt());
        summary.setApprovedBy(record.getApprovedBy());

        if (record.getValidationErrors() != null && !record.getValidationErrors().isBlank()) {
            try {
                summary.setValidationErrors(
                        gson.fromJson(record.getValidationErrors(), new TypeToken<List<String>>(){}.getType()));
            } catch (Exception e) {
                summary.setValidationErrors(List.of(record.getValidationErrors()));
            }
        }

        return summary;
    }
}
