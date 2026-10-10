package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional
public class MasterDataService {

    @Autowired
    private BucketMasterRepository bucketMasterRepository;
    @Autowired
    private DepartmentMasterRepository departmentMasterRepository;
    @Autowired
    private RegulationMasterRepository regulationMasterRepository;
    @Autowired
    private DegreeTypeMasterRepository degreeTypeMasterRepository;
    @Autowired
    private AddonTypeMasterRepository addonTypeMasterRepository;
    @Autowired
    private DegreePathRepository degreePathRepository;
    @Autowired
    private PathBucketRequirementRepository pathBucketRequirementRepository;
    @Autowired
    private CourseBucketMappingRepository courseBucketMappingRepository;
    @Autowired
    private CourseCatalogRepository courseCatalogRepository;

    // ==================== BUCKETS ====================
    public List<BucketMaster> listBuckets() {
        return bucketMasterRepository.findAll();
    }

    public BucketMaster createBucket(BucketMaster bucket) {
        return bucketMasterRepository.save(bucket);
    }

    public BucketMaster updateBucket(Long id, BucketMaster updates) {
        BucketMaster bucket = bucketMasterRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Bucket not found"));
        bucket.setBucketCode(updates.getBucketCode());
        bucket.setBucketName(updates.getBucketName());
        bucket.setBucketCategory(updates.getBucketCategory());
        bucket.setDescription(updates.getDescription());
        return bucketMasterRepository.save(bucket);
    }

    public void deleteBucket(Long id) {
        bucketMasterRepository.deleteById(id);
    }

    public Optional<BucketMaster> getBucketByCode(String code) {
        return bucketMasterRepository.findByBucketCode(code);
    }

    // ==================== DEPARTMENTS ====================
    public List<DepartmentMaster> listDepartments() {
        return departmentMasterRepository.findAll();
    }

    public DepartmentMaster createDepartment(DepartmentMaster dept) {
        return departmentMasterRepository.save(dept);
    }

    public DepartmentMaster updateDepartment(Long id, DepartmentMaster updates) {
        DepartmentMaster dept = departmentMasterRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Department not found"));
        dept.setDeptCode(updates.getDeptCode());
        dept.setDeptName(updates.getDeptName());
        return departmentMasterRepository.save(dept);
    }

    public void deleteDepartment(Long id) {
        departmentMasterRepository.deleteById(id);
    }

    // ==================== REGULATIONS ====================
    public List<RegulationMaster> listRegulations() {
        return regulationMasterRepository.findAll();
    }

    public RegulationMaster createRegulation(RegulationMaster reg) {
        return regulationMasterRepository.save(reg);
    }

    public RegulationMaster updateRegulation(Long id, RegulationMaster updates) {
        RegulationMaster reg = regulationMasterRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Regulation not found"));
        reg.setRegCode(updates.getRegCode());
        reg.setRegName(updates.getRegName());
        reg.setEffectiveYear(updates.getEffectiveYear());
        return regulationMasterRepository.save(reg);
    }

    public void deleteRegulation(Long id) {
        regulationMasterRepository.deleteById(id);
    }

    // ==================== DEGREE TYPES ====================
    public List<DegreeTypeMaster> listDegreeTypes() {
        return degreeTypeMasterRepository.findAll();
    }

    public DegreeTypeMaster createDegreeType(DegreeTypeMaster type) {
        return degreeTypeMasterRepository.save(type);
    }

    public DegreeTypeMaster updateDegreeType(Long id, DegreeTypeMaster updates) {
        DegreeTypeMaster type = degreeTypeMasterRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Degree type not found"));
        type.setTypeCode(updates.getTypeCode());
        type.setTypeName(updates.getTypeName());
        type.setDescription(updates.getDescription());
        return degreeTypeMasterRepository.save(type);
    }

    public void deleteDegreeType(Long id) {
        degreeTypeMasterRepository.deleteById(id);
    }

    // ==================== ADDON TYPES ====================
    public List<AddonTypeMaster> listAddonTypes() {
        return addonTypeMasterRepository.findAll();
    }

    public AddonTypeMaster createAddonType(AddonTypeMaster addon) {
        return addonTypeMasterRepository.save(addon);
    }

    public AddonTypeMaster updateAddonType(Long id, AddonTypeMaster updates) {
        AddonTypeMaster addon = addonTypeMasterRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Addon type not found"));
        addon.setAddonCode(updates.getAddonCode());
        addon.setAddonName(updates.getAddonName());
        return addonTypeMasterRepository.save(addon);
    }

    public void deleteAddonType(Long id) {
        addonTypeMasterRepository.deleteById(id);
    }

    // ==================== DEGREE PATHS ====================
    public List<DegreePath> listDegreePaths() {
        return degreePathRepository.findAll();
    }

    public List<DegreePath> listActiveDegreePaths() {
        return degreePathRepository.findByIsActiveTrue();
    }

    public DegreePath createDegreePath(DegreePath path) {
        return degreePathRepository.save(path);
    }

    public DegreePath createDegreePathFromCodes(String deptCode, String typeCode, String addonCode, String addonName, int totalCredits) {
        DepartmentMaster dept = departmentMasterRepository.findByDeptCode(deptCode)
                .orElseThrow(() -> new RuntimeException("Department not found: " + deptCode));
        DegreeTypeMaster type = degreeTypeMasterRepository.findByTypeCode(typeCode)
                .orElseThrow(() -> new RuntimeException("Degree type not found: " + typeCode));
        AddonTypeMaster addon = addonTypeMasterRepository.findByAddonCode(addonCode)
                .orElseThrow(() -> new RuntimeException("Addon type not found: " + addonCode));
        RegulationMaster reg = regulationMasterRepository.findByRegCode("Y23")
                .orElseThrow(() -> new RuntimeException("Regulation Y23 not found"));

        String pathCode = deptCode + "-" + typeCode;
        if (!"NONE".equals(addonCode)) {
            pathCode += "-" + addonCode;
            if (addonName != null && !addonName.isEmpty()) {
                pathCode += "-" + addonName.toUpperCase().replace(" ", "_");
            }
        }

        DegreePath path = new DegreePath();
        path.setPathCode(pathCode);
        path.setDepartment(dept);
        path.setDegreeType(type);
        path.setAddonType(addon);
        path.setRegulation(reg);
        path.setAddonName(addonName);
        path.setTotalCredits(totalCredits);
        path.setIsActive(true);

        return degreePathRepository.save(path);
    }

    public DegreePath updateDegreePath(Long id, DegreePath updates) {
        DegreePath path = degreePathRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Degree path not found"));
        if (updates.getPathCode() != null) path.setPathCode(updates.getPathCode());
        if (updates.getAddonName() != null) path.setAddonName(updates.getAddonName());
        if (updates.getTotalCredits() != null) path.setTotalCredits(updates.getTotalCredits());
        if (updates.getIsActive() != null) path.setIsActive(updates.getIsActive());
        if (updates.getDepartment() != null) path.setDepartment(updates.getDepartment());
        if (updates.getDegreeType() != null) path.setDegreeType(updates.getDegreeType());
        if (updates.getAddonType() != null) path.setAddonType(updates.getAddonType());
        if (updates.getRegulation() != null) path.setRegulation(updates.getRegulation());
        return degreePathRepository.save(path);
    }

    public void deleteDegreePath(Long id) {
        degreePathRepository.deleteById(id);
    }

    public Optional<DegreePath> getDegreePath(Long id) {
        return degreePathRepository.findById(id);
    }

    // ==================== PATH BUCKET REQUIREMENTS ====================
    public List<PathBucketRequirement> listPathRequirements(Long pathId) {
        return pathBucketRequirementRepository.findByDegreePathId(pathId);
    }

    public PathBucketRequirement createPathRequirement(Long pathId, Long bucketId, int requiredCredits, Integer minCourses, boolean isMandatory) {
        DegreePath path = degreePathRepository.findById(pathId)
                .orElseThrow(() -> new RuntimeException("Degree path not found"));
        BucketMaster bucket = bucketMasterRepository.findById(bucketId)
                .orElseThrow(() -> new RuntimeException("Bucket not found"));

        PathBucketRequirement req = new PathBucketRequirement();
        req.setDegreePath(path);
        req.setBucket(bucket);
        req.setRequiredCredits(requiredCredits);
        req.setMinCourses(minCourses);
        req.setIsMandatory(isMandatory);
        return pathBucketRequirementRepository.save(req);
    }

    public PathBucketRequirement createPathRequirementByCode(Long pathId, String bucketCode, int requiredCredits, Integer minCourses, boolean isMandatory) {
        BucketMaster bucket = bucketMasterRepository.findByBucketCode(bucketCode)
                .orElseThrow(() -> new RuntimeException("Bucket not found: " + bucketCode));
        return createPathRequirement(pathId, bucket.getId(), requiredCredits, minCourses, isMandatory);
    }

    public PathBucketRequirement updatePathRequirement(Long id, PathBucketRequirement updates) {
        PathBucketRequirement req = pathBucketRequirementRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Requirement not found"));
        if (updates.getRequiredCredits() != null) req.setRequiredCredits(updates.getRequiredCredits());
        if (updates.getMinCourses() != null) req.setMinCourses(updates.getMinCourses());
        if (updates.getIsMandatory() != null) req.setIsMandatory(updates.getIsMandatory());
        return pathBucketRequirementRepository.save(req);
    }

    public void deletePathRequirement(Long id) {
        pathBucketRequirementRepository.deleteById(id);
    }

    // ==================== COURSE BUCKET MAPPING ====================
    public List<CourseBucketMapping> listCourseBucketMappings() {
        return courseBucketMappingRepository.findAll();
    }

    public CourseBucketMapping createCourseBucketMapping(Long courseId, Long bucketId, Long degreePathId, boolean isMandatory, String semesterOffered) {
        CourseCatalog course = courseCatalogRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Course not found"));
        BucketMaster bucket = bucketMasterRepository.findById(bucketId)
                .orElseThrow(() -> new RuntimeException("Bucket not found"));

        CourseBucketMapping mapping = new CourseBucketMapping();
        mapping.setCourse(course);
        mapping.setBucket(bucket);
        if (degreePathId != null) {
            DegreePath path = degreePathRepository.findById(degreePathId)
                    .orElseThrow(() -> new RuntimeException("Degree path not found"));
            mapping.setDegreePath(path);
        }
        mapping.setIsMandatory(isMandatory);
        mapping.setSemesterOffered(semesterOffered);
        return courseBucketMappingRepository.save(mapping);
    }

    public void deleteCourseBucketMapping(Long id) {
        courseBucketMappingRepository.deleteById(id);
    }

    // ==================== SUMMARY / STATS ====================
    public Map<String, Object> getMasterDataSummary() {
        Map<String, Object> summary = new LinkedHashMap<>();
        summary.put("buckets", bucketMasterRepository.count());
        summary.put("departments", departmentMasterRepository.count());
        summary.put("regulations", regulationMasterRepository.count());
        summary.put("degreeTypes", degreeTypeMasterRepository.count());
        summary.put("addonTypes", addonTypeMasterRepository.count());
        summary.put("degreePaths", degreePathRepository.count());
        summary.put("pathRequirements", pathBucketRequirementRepository.count());
        summary.put("courseMappings", courseBucketMappingRepository.count());
        summary.put("courses", courseCatalogRepository.count());
        return summary;
    }
}
