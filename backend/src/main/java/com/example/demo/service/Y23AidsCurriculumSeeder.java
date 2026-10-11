package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Service
@Transactional
public class Y23AidsCurriculumSeeder {

    private static final Logger log = LoggerFactory.getLogger(Y23AidsCurriculumSeeder.class);

    @Autowired private DepartmentMasterRepository departmentRepo;
    @Autowired private RegulationMasterRepository regulationRepo;
    @Autowired private DegreeTypeMasterRepository degreeTypeRepo;
    @Autowired private AddonTypeMasterRepository addonTypeRepo;
    @Autowired private CurriculumVersionRepository curriculumVersionRepo;
    @Autowired private BucketMasterRepository bucketRepo;
    @Autowired private CourseCatalogRepository courseCatalogRepo;
    @Autowired private CurriculumCourseRepository curriculumCourseRepo;
    @Autowired private CurriculumCourseMappingRepository curriculumMappingRepo;
    @Autowired private DegreePathRepository degreePathRepo;
    @Autowired private PathBucketRequirementRepository pathReqRepo;

    public Map<String, Object> seedY23AidsCurriculum() {
        log.info("Starting Y23 curriculum seeding (CSE + AIDS)...");

        // 1. Departments
        DepartmentMaster cseDept = departmentRepo.findByDeptCode("CSE")
                .orElseGet(() -> {
                    DepartmentMaster d = new DepartmentMaster();
                    d.setDeptCode("CSE");
                    d.setDeptName("Computer Science and Engineering");
                    return departmentRepo.save(d);
                });

        DepartmentMaster aidsDept = departmentRepo.findByDeptCode("AIDS")
                .orElseGet(() -> {
                    DepartmentMaster d = new DepartmentMaster();
                    d.setDeptCode("AIDS");
                    d.setDeptName("Artificial Intelligence and Data Science");
                    return departmentRepo.save(d);
                });

        // 2. Regulation
        RegulationMaster y23Reg = regulationRepo.findByRegCode("Y23")
                .orElseGet(() -> {
                    RegulationMaster r = new RegulationMaster();
                    r.setRegCode("Y23");
                    r.setRegName("Year 2023 Regulation");
                    r.setEffectiveYear(2023);
                    return regulationRepo.save(r);
                });

        // 3. Curriculum Versions
        CurriculumVersion y23CseVer = curriculumVersionRepo.findByCurriculumCode("Y23-CSE")
                .orElseGet(() -> {
                    CurriculumVersion cv = new CurriculumVersion();
                    cv.setCurriculumCode("Y23-CSE");
                    cv.setVersionName("Y23 B.Tech. CSE Curriculum");
                    cv.setProgramName("B.Tech. - Computer Science and Engineering");
                    cv.setDepartment(cseDept);
                    cv.setRegulationMaster(y23Reg);
                    cv.setRegulation("Y23");
                    cv.setStatus("ACTIVE");
                    cv.setAcademicYear("2023-2024");
                    cv.setEffectiveFrom(LocalDate.of(2023, 7, 1));
                    cv.setPublishedAt(LocalDateTime.now());
                    return curriculumVersionRepo.save(cv);
                });

        CurriculumVersion y23AidsVer = curriculumVersionRepo.findByCurriculumCode("Y23-AIDS")
                .orElseGet(() -> {
                    CurriculumVersion cv = new CurriculumVersion();
                    cv.setCurriculumCode("Y23-AIDS");
                    cv.setVersionName("Y23 B.Tech. AIDS Curriculum");
                    cv.setProgramName("B.Tech. - Artificial Intelligence and Data Science");
                    cv.setDepartment(aidsDept);
                    cv.setRegulationMaster(y23Reg);
                    cv.setRegulation("Y23");
                    cv.setStatus("ACTIVE");
                    cv.setAcademicYear("2023-2024");
                    cv.setEffectiveFrom(LocalDate.of(2023, 7, 1));
                    cv.setPublishedAt(LocalDateTime.now());
                    return curriculumVersionRepo.save(cv);
                });

        // 4. Master Degree Types
        Map<String, DegreeTypeMaster> degreeTypes = new HashMap<>();
        degreeTypes.put("REGULAR", upsertDegreeType("REGULAR", "Regular", "Standard B.Tech degree"));
        degreeTypes.put("HONORS", upsertDegreeType("HONORS", "Honors", "B.Tech with Honors"));
        degreeTypes.put("HTE", upsertDegreeType("HTE", "Honors through Experiential Learning", "B.Tech with HTE"));
        degreeTypes.put("HTI", upsertDegreeType("HTI", "Honors through Innovation", "B.Tech with HTI"));
        degreeTypes.put("HTR", upsertDegreeType("HTR", "Honors through Research", "B.Tech with HTR"));

        // 5. Master Addon Types
        Map<String, AddonTypeMaster> addonTypes = new HashMap<>();
        addonTypes.put("NONE", upsertAddonType("NONE", "No Add-on"));
        addonTypes.put("SPECIALIZATION", upsertAddonType("SPECIALIZATION", "Specialization"));
        addonTypes.put("MINOR", upsertAddonType("MINOR", "Minor"));
        addonTypes.put("DOUBLE_MAJOR", upsertAddonType("DOUBLE_MAJOR", "Double Major"));

        // 6. Seed all 20 CSE Degree Paths
        seedCseDegreePaths(y23CseVer, cseDept, degreeTypes, addonTypes, y23Reg);

        // 7. Seed all 20 AIDS Degree Paths
        seedAidsDegreePaths(y23AidsVer, aidsDept, degreeTypes, addonTypes, y23Reg);

        // 8. Seed Full Per-Bucket Path Requirements (Rule Structure Only - No Dummy Courses)
        seedFullPerBucketRequirements();

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("cseVersion", "Y23-CSE");
        result.put("aidsVersion", "Y23-AIDS");
        result.put("totalPaths", 40);
        return result;
    }

    private void seedCseDegreePaths(CurriculumVersion ver, DepartmentMaster dept,
                                    Map<String, DegreeTypeMaster> dt, Map<String, AddonTypeMaster> at,
                                    RegulationMaster reg) {
        Map<String, Integer> cseTotals = Map.ofEntries(
                Map.entry("CSE-HTE-MINOR", 203),
                Map.entry("CSE-HTE-DOUBLE_MAJOR", 208),
                Map.entry("CSE-HTE-SPECIALIZATION", 193),
                Map.entry("CSE-HTE", 183),
                Map.entry("CSE-HTI-MINOR", 201),
                Map.entry("CSE-HTI-DOUBLE_MAJOR", 208),
                Map.entry("CSE-HTI-SPECIALIZATION", 193),
                Map.entry("CSE-HTI", 183),
                Map.entry("CSE-HTR-MINOR", 201),
                Map.entry("CSE-HTR-DOUBLE_MAJOR", 208),
                Map.entry("CSE-HTR-SPECIALIZATION", 193),
                Map.entry("CSE-HTR", 183),
                Map.entry("CSE-HONORS-MINOR", 201),
                Map.entry("CSE-HONORS-DOUBLE_MAJOR", 208),
                Map.entry("CSE-HONORS-SPECIALIZATION", 193),
                Map.entry("CSE-HONORS", 183),
                Map.entry("CSE-REGULAR-MINOR", 183),
                Map.entry("CSE-REGULAR-DOUBLE_MAJOR", 188),
                Map.entry("CSE-REGULAR-SPECIALIZATION", 168),
                Map.entry("CSE-REGULAR", 163)
        );

        for (Map.Entry<String, Integer> e : cseTotals.entrySet()) {
            String pathCode = e.getKey();
            int credits = e.getValue();
            String[] parts = pathCode.split("-");
            String typeCode = parts[1];
            String addonCode = parts.length > 2 ? parts[2] : "NONE";

            upsertDegreePath(ver, dept, dt.get(typeCode), at.get(addonCode), reg, pathCode, credits);
        }
    }

    private void seedAidsDegreePaths(CurriculumVersion ver, DepartmentMaster dept,
                                     Map<String, DegreeTypeMaster> dt, Map<String, AddonTypeMaster> at,
                                     RegulationMaster reg) {
        Map<String, Integer> aidsTotals = Map.ofEntries(
                Map.entry("AIDS-HTE-MINOR", 206),
                Map.entry("AIDS-HTE-DOUBLE_MAJOR", 211),
                Map.entry("AIDS-HTE-SPECIALIZATION", 196),
                Map.entry("AIDS-HTE", 186),
                Map.entry("AIDS-HTI-MINOR", 204),
                Map.entry("AIDS-HTI-DOUBLE_MAJOR", 211),
                Map.entry("AIDS-HTI-SPECIALIZATION", 196),
                Map.entry("AIDS-HTI", 186),
                Map.entry("AIDS-HTR-MINOR", 204),
                Map.entry("AIDS-HTR-DOUBLE_MAJOR", 211),
                Map.entry("AIDS-HTR-SPECIALIZATION", 196),
                Map.entry("AIDS-HTR", 186),
                Map.entry("AIDS-HONORS-MINOR", 204),
                Map.entry("AIDS-HONORS-DOUBLE_MAJOR", 211),
                Map.entry("AIDS-HONORS-SPECIALIZATION", 196),
                Map.entry("AIDS-HONORS", 186),
                Map.entry("AIDS-REGULAR-MINOR", 186),
                Map.entry("AIDS-REGULAR-DOUBLE_MAJOR", 191),
                Map.entry("AIDS-REGULAR-SPECIALIZATION", 171),
                Map.entry("AIDS-REGULAR", 166)
        );

        for (Map.Entry<String, Integer> e : aidsTotals.entrySet()) {
            String pathCode = e.getKey();
            int credits = e.getValue();
            String[] parts = pathCode.split("-");
            String typeCode = parts[1];
            String addonCode = parts.length > 2 ? parts[2] : "NONE";

            upsertDegreePath(ver, dept, dt.get(typeCode), at.get(addonCode), reg, pathCode, credits);
        }
    }

    private void seedFullPerBucketRequirements() {
        try (var inputStream = getClass().getClassLoader().getResourceAsStream("curriculum/y23_path_bucket_requirements.json")) {
            if (inputStream == null) {
                log.warn("y23_path_bucket_requirements.json not found on classpath, skipping JSON seeding");
                seedFallbackPathRequirements();
                return;
            }

            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            List<Map<String, Object>> reqsList = mapper.readValue(inputStream, new com.fasterxml.jackson.core.type.TypeReference<List<Map<String, Object>>>() {});
            log.info("Loading {} path bucket requirements from JSON...", reqsList.size());

            Map<String, DegreePath> pathMap = new HashMap<>();
            degreePathRepo.findAll().forEach(p -> pathMap.put(p.getPathCode(), p));

            Map<String, BucketMaster> bucketMap = new HashMap<>();
            bucketRepo.findAll().forEach(b -> bucketMap.put(b.getBucketCode(), b));

            int seeded = 0;
            for (Map<String, Object> r : reqsList) {
                String pathCode = (String) r.get("path_code");
                String bucketCode = (String) r.get("bucket_code");
                DegreePath path = pathMap.get(pathCode);

                if (path == null) {
                    continue;
                }

                BucketMaster bucket = bucketMap.computeIfAbsent(bucketCode, code -> {
                    return bucketRepo.findByBucketCode(code).orElseGet(() -> {
                        BucketMaster b = new BucketMaster();
                        b.setBucketCode(code);
                        b.setBucketName(code);
                        b.setBucketCategory((String) r.getOrDefault("category", "General"));
                        return bucketRepo.save(b);
                    });
                });

                int minCr = ((Number) r.getOrDefault("min_credits", 0)).intValue();
                int maxCr = ((Number) r.getOrDefault("max_credits", minCr)).intValue();
                int minCo = ((Number) r.getOrDefault("min_courses", 0)).intValue();
                int maxCo = ((Number) r.getOrDefault("max_courses", minCo)).intValue();
                String grouping = (String) r.get("grouping");
                int reqCr = (minCr == 0 && maxCr > 0) ? maxCr : minCr;

                PathBucketRequirement pbr = pathReqRepo.findByDegreePathIdAndBucketId(path.getId(), bucket.getId())
                        .orElse(new PathBucketRequirement());

                pbr.setDegreePath(path);
                pbr.setBucket(bucket);
                pbr.setRequiredCredits(reqCr);
                pbr.setMinCredits(minCr);
                pbr.setMaxCredits(maxCr);
                pbr.setMinCourses(minCo);
                pbr.setMaxCourses(maxCo);
                pbr.setGroupingCode(grouping);
                pbr.setIsMandatory(true);

                pathReqRepo.save(pbr);
                seeded++;
            }
            log.info("Successfully seeded/updated {} PathBucketRequirements.", seeded);
        } catch (Exception e) {
            log.error("Error seeding path bucket requirements from JSON: {}", e.getMessage(), e);
            seedFallbackPathRequirements();
        }
    }

    private void seedFallbackPathRequirements() {
        BucketMaster pcc = bucketRepo.findByBucketCode("PCC-CORE").orElse(null);
        if (pcc == null) return;
        List<DegreePath> allPaths = degreePathRepo.findAll();
        for (DegreePath path : allPaths) {
            if (pathReqRepo.findByDegreePathId(path.getId()).isEmpty()) {
                PathBucketRequirement pbr = new PathBucketRequirement();
                pbr.setDegreePath(path);
                pbr.setBucket(pcc);
                pbr.setRequiredCredits(path.getTotalCredits());
                pbr.setMinCredits(path.getTotalCredits());
                pbr.setIsMandatory(true);
                pathReqRepo.save(pbr);
            }
        }
    }

    private DegreeTypeMaster upsertDegreeType(String code, String name, String desc) {
        return degreeTypeRepo.findByTypeCode(code)
                .map(dt -> {
                    dt.setTypeName(name);
                    dt.setDescription(desc);
                    return degreeTypeRepo.save(dt);
                })
                .orElseGet(() -> {
                    DegreeTypeMaster dt = new DegreeTypeMaster();
                    dt.setTypeCode(code);
                    dt.setTypeName(name);
                    dt.setDescription(desc);
                    return degreeTypeRepo.save(dt);
                });
    }

    private AddonTypeMaster upsertAddonType(String code, String name) {
        return addonTypeRepo.findByAddonCode(code)
                .map(a -> {
                    a.setAddonName(name);
                    return addonTypeRepo.save(a);
                })
                .orElseGet(() -> {
                    AddonTypeMaster a = new AddonTypeMaster();
                    a.setAddonCode(code);
                    a.setAddonName(name);
                    return addonTypeRepo.save(a);
                });
    }

    private DegreePath upsertDegreePath(CurriculumVersion ver, DepartmentMaster dept,
                                        DegreeTypeMaster dt, AddonTypeMaster at,
                                        RegulationMaster reg, String pathCode, int totalCredits) {
        return degreePathRepo.findAll().stream()
                .filter(p -> pathCode.equals(p.getPathCode()) && p.getCurriculumVersion() != null && ver.getId().equals(p.getCurriculumVersion().getId()))
                .findFirst()
                .map(p -> {
                    p.setTotalCredits(totalCredits);
                    p.setCurriculumVersion(ver);
                    p.setDepartment(dept);
                    p.setDegreeType(dt);
                    p.setAddonType(at);
                    p.setRegulation(reg);
                    p.setIsActive(true);
                    return degreePathRepo.save(p);
                })
                .orElseGet(() -> {
                    DegreePath p = new DegreePath();
                    p.setPathCode(pathCode);
                    p.setCurriculumVersion(ver);
                    p.setDepartment(dept);
                    p.setDegreeType(dt);
                    p.setAddonType(at);
                    p.setRegulation(reg);
                    p.setTotalCredits(totalCredits);
                    p.setIsActive(true);
                    return degreePathRepo.save(p);
                });
    }
}
