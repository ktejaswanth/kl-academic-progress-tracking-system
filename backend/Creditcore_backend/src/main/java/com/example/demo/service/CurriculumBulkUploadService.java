package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.*;

@Service
public class CurriculumBulkUploadService {

    @Autowired
    private MasterDataService masterDataService;
    @Autowired
    private CourseCatalogRepository courseCatalogRepository;
    @Autowired
    private DegreePathRepository degreePathRepository;
    @Autowired
    private BucketMasterRepository bucketMasterRepository;
    @Autowired
    private CompletedCourseRepository completedCourseRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PathBucketRequirementRepository pathBucketRequirementRepository;
    @Autowired
    private CourseBucketMappingRepository courseBucketMappingRepository;

    // ==================== COURSE CATALOG UPLOAD ====================
    public Map<String, Object> uploadCourseCatalog(MultipartFile file) throws Exception {
        int added = 0, updated = 0, failed = 0;
        List<String> errors = new ArrayList<>();
        List<CourseCatalog> toSave = new ArrayList<>();

        // Load all existing courses into map
        Map<String, CourseCatalog> existingCourses = new HashMap<>();
        courseCatalogRepository.findAll().forEach(c -> existingCourses.put(c.getCourseCode(), c));

        try (InputStream is = file.getInputStream(); Workbook workbook = new XSSFWorkbook(is)) {
            Sheet sheet = workbook.getSheetAt(0);
            Iterator<Row> rowIterator = sheet.iterator();

            // Skip header
            if (rowIterator.hasNext()) rowIterator.next();

            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                try {
                    String code = getCellString(row.getCell(0));
                    String name = getCellString(row.getCell(1));
                    String l = getCellString(row.getCell(2));
                    String t = getCellString(row.getCell(3));
                    String p = getCellString(row.getCell(4));
                    String s = getCellString(row.getCell(5));
                    String creditsStr = getCellString(row.getCell(6));
                    String prereq = getCellString(row.getCell(7));

                    if (code == null || code.isEmpty() || name == null || name.isEmpty() || creditsStr == null || creditsStr.isEmpty()) {
                        continue;
                    }

                    int credits = (int) Double.parseDouble(creditsStr);
                    
                    CourseCatalog course = existingCourses.get(code);
                    if (course != null) {
                        updated++;
                    } else {
                        course = new CourseCatalog();
                        course.setCourseCode(code);
                        existingCourses.put(code, course); // add it to map to handle duplicate codes in excel
                        added++;
                    }
                    
                    course.setCourseName(name);
                    course.setCredits(credits);
                    
                    String metadata = String.format("{\"L\": %d, \"T\": %d, \"P\": %d, \"S\": %d, \"prerequisites\": \"%s\"}",
                        parseIntegerSafely(l),
                        parseIntegerSafely(t),
                        parseIntegerSafely(p),
                        parseIntegerSafely(s),
                        prereq != null ? prereq.replace("\"", "\\\"") : ""
                    );
                    course.setMetadata(metadata);

                    toSave.add(course);
                } catch (Exception e) {
                    failed++;
                    errors.add("Row " + (row.getRowNum() + 1) + ": " + e.getMessage());
                }
            }
            
            if (!toSave.isEmpty()) {
                courseCatalogRepository.saveAll(toSave);
            }
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("added", added);
        result.put("updated", updated);
        result.put("failed", failed);
        result.put("errors", errors);
        return result;
    }

    // ==================== PATH BUCKET REQUIREMENTS UPLOAD ====================
    public Map<String, Object> uploadPathRequirements(MultipartFile file) throws Exception {
        int processed = 0, failed = 0;
        List<String> errors = new ArrayList<>();
        List<PathBucketRequirement> toSave = new ArrayList<>();

        // Load existing paths and buckets maps
        Map<String, DegreePath> pathsMap = new HashMap<>();
        degreePathRepository.findAll().forEach(p -> pathsMap.put(p.getPathCode(), p));

        Map<String, BucketMaster> bucketsMap = new HashMap<>();
        bucketMasterRepository.findAll().forEach(b -> bucketsMap.put(b.getBucketCode(), b));

        // Load existing requirements set for duplicate checking
        Set<String> existingReqs = new HashSet<>();
        pathBucketRequirementRepository.findAll().forEach(r -> {
            existingReqs.add(r.getDegreePath().getId() + "_" + r.getBucket().getId());
        });

        try (InputStream is = file.getInputStream(); Workbook workbook = new XSSFWorkbook(is)) {
            Sheet sheet = workbook.getSheetAt(0);
            Iterator<Row> rowIterator = sheet.iterator();

            if (rowIterator.hasNext()) rowIterator.next();

            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                try {
                    String pathCode = getCellString(row.getCell(0));
                    String bucketCode = getCellString(row.getCell(1));
                    String requiredCreditsStr = getCellString(row.getCell(2));

                    if (pathCode == null || bucketCode == null || requiredCreditsStr == null) continue;

                    DegreePath path = pathsMap.get(pathCode);
                    if (path == null) {
                        throw new RuntimeException("Path not found: " + pathCode);
                    }

                    BucketMaster bucket = bucketsMap.get(bucketCode);
                    if (bucket == null) {
                        throw new RuntimeException("Bucket not found: " + bucketCode);
                    }

                    int requiredCredits = (int) Double.parseDouble(requiredCreditsStr);
                    String reqKey = path.getId() + "_" + bucket.getId();

                    if (existingReqs.contains(reqKey)) {
                        processed++;
                        continue;
                    }

                    PathBucketRequirement req = new PathBucketRequirement();
                    req.setDegreePath(path);
                    req.setBucket(bucket);
                    req.setRequiredCredits(requiredCredits);
                    req.setMinCourses(null);
                    req.setIsMandatory(true);

                    toSave.add(req);
                    existingReqs.add(reqKey); // avoid duplicates in excel sheet itself
                    processed++;
                } catch (Exception e) {
                    failed++;
                    errors.add("Row " + (row.getRowNum() + 1) + ": " + e.getMessage());
                }
            }

            if (!toSave.isEmpty()) {
                pathBucketRequirementRepository.saveAll(toSave);
            }
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("processed", processed);
        result.put("failed", failed);
        result.put("errors", errors);
        return result;
    }

    // ==================== COURSE BUCKET MAPPING UPLOAD ====================
    public Map<String, Object> uploadCourseBucketMappings(MultipartFile file) throws Exception {
        int processed = 0, failed = 0;
        List<String> errors = new ArrayList<>();
        List<CourseBucketMapping> toSave = new ArrayList<>();

        // Load existing courses, buckets, paths maps
        Map<String, CourseCatalog> coursesMap = new HashMap<>();
        courseCatalogRepository.findAll().forEach(c -> coursesMap.put(c.getCourseCode(), c));

        Map<String, BucketMaster> bucketsMap = new HashMap<>();
        bucketMasterRepository.findAll().forEach(b -> bucketsMap.put(b.getBucketCode(), b));

        Map<String, DegreePath> pathsMap = new HashMap<>();
        degreePathRepository.findAll().forEach(p -> pathsMap.put(p.getPathCode(), p));

        // Load existing mappings key set to avoid database duplicate entries
        Set<String> existingMappings = new HashSet<>();
        courseBucketMappingRepository.findAll().forEach(m -> {
            Long pathId = m.getDegreePath() != null ? m.getDegreePath().getId() : 0L;
            existingMappings.add(m.getCourse().getId() + "_" + m.getBucket().getId() + "_" + pathId);
        });

        try (InputStream is = file.getInputStream(); Workbook workbook = new XSSFWorkbook(is)) {
            Sheet sheet = workbook.getSheetAt(0);
            Iterator<Row> rowIterator = sheet.iterator();

            if (rowIterator.hasNext()) rowIterator.next();

            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                try {
                    String courseCode = getCellString(row.getCell(0));
                    String bucketCode = getCellString(row.getCell(1));
                    String pathCode = getCellString(row.getCell(2)); // Optional

                    if (courseCode == null || bucketCode == null) continue;

                    CourseCatalog course = coursesMap.get(courseCode);
                    if (course == null) {
                        throw new RuntimeException("Course not found: " + courseCode);
                    }

                    BucketMaster bucket = bucketsMap.get(bucketCode);
                    if (bucket == null) {
                        throw new RuntimeException("Bucket not found: " + bucketCode);
                    }

                    DegreePath path = null;
                    Long pathId = 0L;
                    if (pathCode != null && !pathCode.isEmpty()) {
                        path = pathsMap.get(pathCode);
                        if (path == null) {
                            throw new RuntimeException("Path not found: " + pathCode);
                        }
                        pathId = path.getId();
                    }

                    String mapKey = course.getId() + "_" + bucket.getId() + "_" + pathId;

                    if (existingMappings.contains(mapKey)) {
                        processed++;
                        continue;
                    }

                    CourseBucketMapping mapping = new CourseBucketMapping();
                    mapping.setCourse(course);
                    mapping.setBucket(bucket);
                    mapping.setDegreePath(path);
                    mapping.setIsMandatory(false);
                    mapping.setSemesterOffered(null);

                    toSave.add(mapping);
                    existingMappings.add(mapKey); // avoid duplicates in excel sheet itself
                    processed++;
                } catch (Exception e) {
                    failed++;
                    errors.add("Row " + (row.getRowNum() + 1) + ": " + e.getMessage());
                }
            }

            if (!toSave.isEmpty()) {
                courseBucketMappingRepository.saveAll(toSave);
            }
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("processed", processed);
        result.put("failed", failed);
        result.put("errors", errors);
        return result;
    }

    // ==================== UTILS ====================
    private String getCellString(Cell cell) {
        if (cell == null) return null;
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue().trim();
            case NUMERIC -> String.valueOf(cell.getNumericCellValue());
            case BOOLEAN -> String.valueOf(cell.getBooleanCellValue());
            default -> null;
        };
    }

    private int parseIntegerSafely(String val) {
        if (val == null || val.trim().isEmpty()) return 0;
        try {
            return (int) Double.parseDouble(val.trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    public byte[] generateTemplate(String type) throws Exception {
        try (Workbook workbook = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = workbook.createSheet("Template");
            Row header = sheet.createRow(0);

            switch (type.toUpperCase()) {
                case "COURSES":
                    header.createCell(0).setCellValue("Course Code");
                    header.createCell(1).setCellValue("Course Name");
                    header.createCell(2).setCellValue("L");
                    header.createCell(3).setCellValue("T");
                    header.createCell(4).setCellValue("P");
                    header.createCell(5).setCellValue("S");
                    header.createCell(6).setCellValue("Credits");
                    header.createCell(7).setCellValue("Prerequisites");
                    break;
                case "REQUIREMENTS":
                    header.createCell(0).setCellValue("Degree Path Code");
                    header.createCell(1).setCellValue("Bucket Code");
                    header.createCell(2).setCellValue("Required Credits");
                    break;
                case "MAPPINGS":
                    header.createCell(0).setCellValue("Course Code");
                    header.createCell(1).setCellValue("Bucket Code");
                    header.createCell(2).setCellValue("Degree Path Code (Optional)");
                    break;
            }

            workbook.write(out);
            return out.toByteArray();
        }
    }
}
