package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.service.MasterDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/dyod/master")
@CrossOrigin(origins = "http://localhost:5173")
public class MasterDataController {

    @Autowired
    private MasterDataService masterDataService;

    // --- BUCKETS ---
    @GetMapping("/buckets")
    public ResponseEntity<List<BucketMaster>> getAllBuckets() {
        return ResponseEntity.ok(masterDataService.listBuckets());
    }

    @PostMapping("/buckets")
    public ResponseEntity<BucketMaster> createBucket(@RequestBody BucketMaster bucket) {
        return ResponseEntity.ok(masterDataService.createBucket(bucket));
    }

    // --- DEGREE PATHS ---
    @GetMapping("/paths")
    public ResponseEntity<List<DegreePath>> getAllDegreePaths() {
        return ResponseEntity.ok(masterDataService.listDegreePaths());
    }

    @PostMapping("/paths/generate")
    public ResponseEntity<DegreePath> generatePath(@RequestParam String deptCode, 
                                                  @RequestParam String typeCode, 
                                                  @RequestParam String addonCode, 
                                                  @RequestParam(required = false) String addonName,
                                                  @RequestParam int totalCredits) {
        return ResponseEntity.ok(masterDataService.createDegreePathFromCodes(deptCode, typeCode, addonCode, addonName, totalCredits));
    }

    // --- PATH REQUIREMENTS ---
    @GetMapping("/paths/{pathId}/requirements")
    public ResponseEntity<List<PathBucketRequirement>> getPathRequirements(@PathVariable Long pathId) {
        return ResponseEntity.ok(masterDataService.listPathRequirements(pathId));
    }

    @PostMapping("/paths/{pathId}/requirements")
    public ResponseEntity<PathBucketRequirement> addRequirement(@PathVariable Long pathId, @RequestBody PathBucketRequirement req) {
        return ResponseEntity.ok(masterDataService.createPathRequirement(pathId, req.getBucket().getId(), req.getRequiredCredits(), req.getMinCourses(), req.getIsMandatory()));
    }

    // --- COURSE MAPPINGS ---
    @GetMapping("/mappings")
    public ResponseEntity<List<CourseBucketMapping>> getAllMappings() {
        return ResponseEntity.ok(masterDataService.listCourseBucketMappings());
    }

    @PostMapping("/mappings")
    public ResponseEntity<CourseBucketMapping> addMapping(@RequestParam Long courseId, @RequestParam Long bucketId, @RequestParam(required = false) Long pathId, @RequestParam(defaultValue = "false") boolean isMandatory) {
        return ResponseEntity.ok(masterDataService.createCourseBucketMapping(courseId, bucketId, pathId, isMandatory, null));
    }

    // --- DELETES ---
    @DeleteMapping("/buckets/{id}")
    public ResponseEntity<?> deleteBucket(@PathVariable Long id) {
        masterDataService.deleteBucket(id);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/paths/{id}")
    public ResponseEntity<?> deletePath(@PathVariable Long id) {
        masterDataService.deleteDegreePath(id);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/paths/requirements/{reqId}")
    public ResponseEntity<?> deleteRequirement(@PathVariable Long reqId) {
        masterDataService.deletePathRequirement(reqId);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/mappings/{id}")
    public ResponseEntity<?> deleteMapping(@PathVariable Long id) {
        masterDataService.deleteCourseBucketMapping(id);
        return ResponseEntity.ok().build();
    }

    // --- STATS ---
    @GetMapping("/stats")
    public ResponseEntity<?> getStats() {
        return ResponseEntity.ok(masterDataService.getMasterDataSummary());
    }
}
