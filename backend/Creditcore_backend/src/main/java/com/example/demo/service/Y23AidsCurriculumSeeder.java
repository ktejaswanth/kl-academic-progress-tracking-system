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
    @Autowired private CurriculumBucketRepository curriculumBucketRepo;
    @Autowired private CourseCatalogRepository courseCatalogRepo;
    @Autowired private CurriculumCourseRepository curriculumCourseRepo;
    @Autowired private CurriculumCourseMappingRepository curriculumMappingRepo;
    @Autowired private DegreePathRepository degreePathRepo;
    @Autowired private PathBucketRequirementRepository pathReqRepo;
    @Autowired private SpecializationRepository specializationRepo;
    @Autowired private SpecializationCourseRepository specializationCourseRepo;

    public Map<String, Object> seedY23AidsCurriculum() {
        log.info("Starting Y23 AIDS curriculum seeding/verification...");

        // 1. Department
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

        // 3. Curriculum Version
        CurriculumVersion y23AidsVer = curriculumVersionRepo.findByCurriculumCode("Y23-AIDS")
                .orElseGet(() -> {
                    CurriculumVersion cv = new CurriculumVersion();
                    cv.setCurriculumCode("Y23-AIDS");
                    cv.setVersionName("Y23 B.Tech. AIDS Curriculum");
                    cv.setProgramName("B.Tech. - Artificial Intelligence and Data Science");
                    cv.setDepartment(aidsDept);
                    cv.setRegulationMaster(y23Reg);
                    cv.setRegulation("Y23");
                    cv.setStatus("PUBLISHED");
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

        // 6. Degree Paths for Y23 AIDS
        Map<String, DegreePath> paths = new HashMap<>();
        paths.put("AIDS-REGULAR", upsertDegreePath(y23AidsVer, aidsDept, degreeTypes.get("REGULAR"), addonTypes.get("NONE"), y23Reg, "AIDS-REGULAR", null, 163));
        paths.put("AIDS-HONORS", upsertDegreePath(y23AidsVer, aidsDept, degreeTypes.get("HONORS"), addonTypes.get("NONE"), y23Reg, "AIDS-HONORS", null, 183));
        paths.put("AIDS-HTE", upsertDegreePath(y23AidsVer, aidsDept, degreeTypes.get("HTE"), addonTypes.get("NONE"), y23Reg, "AIDS-HTE", null, 183));
        paths.put("AIDS-HTI", upsertDegreePath(y23AidsVer, aidsDept, degreeTypes.get("HTI"), addonTypes.get("NONE"), y23Reg, "AIDS-HTI", null, 183));
        paths.put("AIDS-HTR", upsertDegreePath(y23AidsVer, aidsDept, degreeTypes.get("HTR"), addonTypes.get("NONE"), y23Reg, "AIDS-HTR", null, 183));
        paths.put("AIDS-REGULAR-SPECIALIZATION", upsertDegreePath(y23AidsVer, aidsDept, degreeTypes.get("REGULAR"), addonTypes.get("SPECIALIZATION"), y23Reg, "AIDS-REGULAR-SPECIALIZATION", "Data Science", 163));
        paths.put("AIDS-REGULAR-MINOR", upsertDegreePath(y23AidsVer, aidsDept, degreeTypes.get("REGULAR"), addonTypes.get("MINOR"), y23Reg, "AIDS-REGULAR-MINOR", "CSE Minor", 181));
        paths.put("AIDS-REGULAR-DOUBLE_MAJOR", upsertDegreePath(y23AidsVer, aidsDept, degreeTypes.get("REGULAR"), addonTypes.get("DOUBLE_MAJOR"), y23Reg, "AIDS-REGULAR-DOUBLE_MAJOR", "CSE Double Major", 203));

        // 7. Buckets & Path Requirements
        Map<String, BucketMaster> buckets = seedBucketsAndRequirements(paths);

        // 8. Core AIDS Courses
        int coursesCreated = seedAidsCourses(y23AidsVer, buckets);

        // 9. Specializations
        int specCoursesCreated = seedAidsSpecializations(y23AidsVer, aidsDept);

        Map<String, Object> report = new LinkedHashMap<>();
        report.put("curriculumCode", y23AidsVer.getCurriculumCode());
        report.put("department", aidsDept.getDeptCode());
        report.put("regulation", y23Reg.getRegCode());
        report.put("status", "PUBLISHED");
        report.put("pathsCreated", paths.size());
        report.put("bucketsMapped", buckets.size());
        report.put("coursesImported", coursesCreated);
        report.put("specializationCoursesImported", specCoursesCreated);
        report.put("success", true);

        log.info("Y23 AIDS curriculum seeding complete: {}", report);
        return report;
    }

    private DegreeTypeMaster upsertDegreeType(String code, String name, String desc) {
        return degreeTypeRepo.findAll().stream()
                .filter(d -> d.getTypeCode().equalsIgnoreCase(code))
                .findFirst()
                .orElseGet(() -> {
                    DegreeTypeMaster dt = new DegreeTypeMaster();
                    dt.setTypeCode(code);
                    dt.setTypeName(name);
                    dt.setDescription(desc);
                    return degreeTypeRepo.save(dt);
                });
    }

    private AddonTypeMaster upsertAddonType(String code, String name) {
        return addonTypeRepo.findAll().stream()
                .filter(a -> a.getAddonCode().equalsIgnoreCase(code))
                .findFirst()
                .orElseGet(() -> {
                    AddonTypeMaster a = new AddonTypeMaster();
                    a.setAddonCode(code);
                    a.setAddonName(name);
                    return addonTypeRepo.save(a);
                });
    }

    private DegreePath upsertDegreePath(CurriculumVersion ver, DepartmentMaster dept, DegreeTypeMaster dt, AddonTypeMaster at, RegulationMaster reg, String pathCode, String addonName, int totalCredits) {
        return degreePathRepo.findAll().stream()
                .filter(p -> p.getPathCode().equalsIgnoreCase(pathCode))
                .findFirst()
                .orElseGet(() -> {
                    DegreePath p = new DegreePath();
                    p.setPathCode(pathCode);
                    p.setCurriculumVersion(ver);
                    p.setDepartment(dept);
                    p.setDegreeType(dt);
                    p.setAddonType(at);
                    p.setRegulation(reg);
                    p.setAddonName(addonName);
                    p.setTotalCredits(totalCredits);
                    p.setIsActive(true);
                    return degreePathRepo.save(p);
                });
    }

    private Map<String, BucketMaster> seedBucketsAndRequirements(Map<String, DegreePath> paths) {
        Map<String, BucketMaster> map = new HashMap<>();

        Map<String, Integer> regularReqs = new LinkedHashMap<>();
        regularReqs.put("HAS-CORE", 12);
        regularReqs.put("BSC-CORE", 24);
        regularReqs.put("ESC-CORE", 16);
        regularReqs.put("PCC-CORE", 56);
        regularReqs.put("SDC-CORE", 12);
        regularReqs.put("PE-CORE", 15);
        regularReqs.put("PRI-CORE", 12);
        regularReqs.put("OE-CORE", 9);
        regularReqs.put("VAC-CORE", 4);
        regularReqs.put("AUC-CORE", 0);
        regularReqs.put("SIL-CORE", 3);

        for (Map.Entry<String, Integer> entry : regularReqs.entrySet()) {
            BucketMaster b = bucketRepo.findByBucketCode(entry.getKey()).orElseGet(() -> {
                BucketMaster newB = new BucketMaster();
                newB.setBucketCode(entry.getKey());
                newB.setBucketName(entry.getKey());
                newB.setBucketCategory("Core");
                return bucketRepo.save(newB);
            });
            map.put(entry.getKey(), b);

            for (DegreePath p : paths.values()) {
                upsertPathReq(p, b, entry.getValue());
            }
        }

        // Add 20 extra credits for HTE, HTI, HTR, HONORS
        BucketMaster honorsBucket = bucketRepo.findByBucketCode("HONORS-EXTRA").orElseGet(() -> {
            BucketMaster newB = new BucketMaster();
            newB.setBucketCode("HONORS-EXTRA");
            newB.setBucketName("Honors / HTE / HTI / HTR Extra Courses");
            newB.setBucketCategory("Honors");
            return bucketRepo.save(newB);
        });
        map.put("HONORS-EXTRA", honorsBucket);

        for (String key : List.of("AIDS-HONORS", "AIDS-HTE", "AIDS-HTI", "AIDS-HTR")) {
            DegreePath p = paths.get(key);
            if (p != null) {
                upsertPathReq(p, honorsBucket, 20);
            }
        }

        return map;
    }

    private void upsertPathReq(DegreePath p, BucketMaster b, int credits) {
        boolean exists = pathReqRepo.findAll().stream()
                .anyMatch(r -> r.getDegreePath().getId().equals(p.getId()) && r.getBucket().getId().equals(b.getId()));
        if (!exists) {
            PathBucketRequirement pbr = new PathBucketRequirement();
            pbr.setDegreePath(p);
            pbr.setBucket(b);
            pbr.setRequiredCredits(credits);
            pbr.setMinCredits(credits);
            pbr.setIsMandatory(true);
            pbr.setSelectionRule("CREDIT_MINIMUM");
            pathReqRepo.save(pbr);
        }
    }

    private int seedAidsCourses(CurriculumVersion ver, Map<String, BucketMaster> buckets) {
        List<Object[]> courseData = List.of(
            new Object[]{"23AD2101", "Introduction to Data Science & AI", 4.0, "PCC-CORE", true, "3-0-2-0"},
            new Object[]{"23AD2102", "Data Structures & Algorithms in Python", 4.0, "PCC-CORE", true, "3-0-2-0"},
            new Object[]{"23AD2103", "Database Management Systems", 4.0, "PCC-CORE", true, "3-0-2-0"},
            new Object[]{"23AD2104", "Machine Learning Fundamentals", 4.0, "PCC-CORE", true, "3-0-2-0"},
            new Object[]{"23AD2205", "Deep Learning & Neural Networks", 4.0, "PCC-CORE", true, "3-0-2-0"},
            new Object[]{"23AD2206", "Big Data Analytics & Spark", 4.0, "PCC-CORE", true, "3-0-2-0"},
            new Object[]{"23AD2207", "Natural Language Processing", 4.0, "PCC-CORE", true, "3-0-2-0"},
            new Object[]{"23AD2208", "Computer Vision & Image Processing", 4.0, "PCC-CORE", true, "3-0-2-0"},
            new Object[]{"23AD3109", "Reinforcement Learning & AI Agents", 3.0, "PE-CORE", false, "3-0-0-0"},
            new Object[]{"23AD3110", "AI Ethics, Governance & Safety", 3.0, "PE-CORE", false, "3-0-0-0"},
            new Object[]{"23AD3111", "Generative AI & LLM Applications", 3.0, "PE-CORE", false, "3-0-0-0"},
            new Object[]{"23MT1101", "Linear Algebra & Probability for Data Science", 4.0, "BSC-CORE", true, "3-1-0-0"},
            new Object[]{"23MT1102", "Discrete Mathematics & Optimization", 4.0, "BSC-CORE", true, "3-1-0-0"},
            new Object[]{"23CS1101", "Programming for Problem Solving", 4.0, "ESC-CORE", true, "3-0-2-0"},
            new Object[]{"23UC1101", "Technical Communication & Soft Skills", 3.0, "HAS-CORE", true, "2-1-0-0"}
        );

        int count = 0;
        for (Object[] c : courseData) {
            String code = (String) c[0];
            String name = (String) c[1];
            double credits = (Double) c[2];
            String bucketCode = (String) c[3];
            boolean isMandatory = (Boolean) c[4];
            String ltps = (String) c[5];

            CourseCatalog course = courseCatalogRepo.findByCourseCode(code).orElseGet(() -> {
                CourseCatalog newC = new CourseCatalog();
                newC.setCourseCode(code);
                newC.setCourseName(name);
                newC.setCredits((int) credits);
                newC.setCategory("AIDS");
                return courseCatalogRepo.save(newC);
            });

            boolean ccExists = curriculumCourseRepo.findByCurriculumVersionId(ver.getId()).stream()
                    .anyMatch(cc -> cc.getCourse().getCourseCode().equalsIgnoreCase(code));

            if (!ccExists) {
                CurriculumCourse cc = new CurriculumCourse();
                cc.setCurriculumVersion(ver);
                cc.setCourse(course);
                cc.setCourseName(name);
                cc.setCredits(credits);
                cc.setBucketName(bucketCode);
                cc.setLtps(ltps);
                cc.setIsMandatory(isMandatory);
                curriculumCourseRepo.save(cc);
                count++;
            }
        }
        return count;
    }

    private int seedAidsSpecializations(CurriculumVersion ver, DepartmentMaster dept) {
        Specialization dsSpec = specializationRepo.findAll().stream()
                .filter(s -> s.getCode().equalsIgnoreCase("DATA-SCIENCE"))
                .findFirst()
                .orElseGet(() -> {
                    Specialization s = new Specialization();
                    s.setCode("DATA-SCIENCE");
                    s.setName("Data Science & Business Analytics");
                    s.setDescription("Specialization track in Data Science");
                    s.setCurriculumVersion(ver);
                    s.setDepartment(dept);
                    s.setIsActive(true);
                    return specializationRepo.save(s);
                });

        List<Object[]> specCourses = List.of(
            new Object[]{"23AD3109", "PE-1"},
            new Object[]{"23AD3110", "PE-2"},
            new Object[]{"23AD3111", "PE-3"}
        );

        int count = 0;
        for (Object[] scData : specCourses) {
            String code = (String) scData[0];
            String role = (String) scData[1];

            Optional<CourseCatalog> cOpt = courseCatalogRepo.findByCourseCode(code);
            if (cOpt.isPresent()) {
                CourseCatalog c = cOpt.get();
                boolean exists = specializationCourseRepo.findBySpecializationId(dsSpec.getId()).stream()
                        .anyMatch(sc -> sc.getCourse().getCourseCode().equalsIgnoreCase(code));
                if (!exists) {
                    SpecializationCourse sc = new SpecializationCourse();
                    sc.setSpecialization(dsSpec);
                    sc.setCurriculumVersion(ver);
                    sc.setCourse(c);
                    sc.setRole(role);
                    sc.setSequenceNo(count + 1);
                    sc.setRequired(true);
                    specializationCourseRepo.save(sc);
                    count++;
                }
            }
        }
        return count;
    }
}
