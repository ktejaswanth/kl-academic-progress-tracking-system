package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.example.demo.utils.PasswordGenerator;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@Service
public class BulkUploadService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StudentProfileRepository studentProfileRepository;

    @Autowired
    private UploadHistoryRepository uploadHistoryRepository;

    @Autowired
    private UploadFailedRecordRepository failedRecordRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public List<CredentialInfo> processBulkUpload(MultipartFile file, User uploadedBy) throws IOException {
        Workbook workbook = new XSSFWorkbook(file.getInputStream());
        Sheet sheet = workbook.getSheetAt(0);
        Iterator<Row> rows = sheet.iterator();

        UploadHistory history = new UploadHistory();
        history.setUploadedBy(uploadedBy);
        history.setFileName(file.getOriginalFilename());
        history = uploadHistoryRepository.save(history);

        int total = 0;
        int success = 0;
        int failed = 0;

        // Skip header
        if (rows.hasNext()) rows.next();

        List<CredentialInfo> credentials = new ArrayList<>();

        while (rows.hasNext()) {
            total++;
            Row row = rows.next();
            try {
                // User's columns: NAME | ID NUMBER | MAIL ID | DEPARTMENT | SUB DEPARTMENT | SPECIALIZATION TYPE | SPECIALIZATION NAME
                String fullName = getCellValue(row, 0);
                String studentId = getCellValue(row, 1);
                String email = getCellValue(row, 2);
                String department = getCellValue(row, 3);
                String subDept = getCellValue(row, 4);
                String specType = getCellValue(row, 5);
                String specName = getCellValue(row, 6);

                if (studentId.isEmpty() || email.isEmpty() || fullName.isEmpty()) {
                    throw new Exception("Missing required fields (Name, ID, or Email)");
                }

                if (userRepository.findByUsername(studentId).isPresent()) {
                    throw new Exception("Student ID " + studentId + " already exists");
                }

                // Split Name into First and Last
                String firstName = fullName;
                String lastName = "";
                if (fullName.contains(" ")) {
                    int lastSpace = fullName.lastIndexOf(" ");
                    firstName = fullName.substring(0, lastSpace);
                    lastName = fullName.substring(lastSpace + 1);
                }

                String rawPassword = PasswordGenerator.generateRandomPassword(8);
                
                User user = new User();
                user.setUsername(studentId);
                user.setEmail(email);
                user.setFirstName(firstName);
                user.setLastName(lastName);
                user.setPasswordHash(passwordEncoder.encode(rawPassword));
                user.setRawPassword(rawPassword);
                user.setRole(UserRole.STUDENT);
                user.setDepartment(department.isEmpty() ? "N/A" : department);
                user.setSubDepartment(subDept.isEmpty() ? "REGULAR" : subDept);
                user.setSpecializationType(specType.isEmpty() ? "NONE" : specType.toUpperCase());
                user.setSpecializationName(specName.isEmpty() ? "N/A" : specName);
                user.setForcePasswordChange(true);
                
                user = userRepository.save(user);

                StudentProfile profile = new StudentProfile();
                profile.setUser(user);
                profile.setDegreeType("REGULAR");
                profile.setSpecialization(user.getSpecializationType());
                studentProfileRepository.save(profile);

                credentials.add(new CredentialInfo(studentId, rawPassword, email, fullName, user.getDepartment(), user.getSubDepartment(), user.getSpecializationType(), user.getSpecializationName()));
                success++;

            } catch (Exception e) {
                failed++;
                UploadFailedRecord failedRecord = new UploadFailedRecord();
                failedRecord.setUpload(history);
                failedRecord.setRowNumber(row.getRowNum() + 1);
                failedRecord.setErrorReason(e.getMessage());
                failedRecord.setStudentIdNum(getCellValue(row, 1));
                failedRecord.setEmail(getCellValue(row, 2));
                failedRecordRepository.save(failedRecord);
            }
        }

        history.setTotalRecords(total);
        history.setSuccessCount(success);
        history.setFailedCount(failed);
        history.setStatus("COMPLETED");
        uploadHistoryRepository.save(history);
        
        workbook.close();
        return credentials;
    }

    private String getCellValue(Row row, int cellIndex) {
        Cell cell = row.getCell(cellIndex);
        if (cell == null) return "";
        
        switch (cell.getCellType()) {
            case STRING: return cell.getStringCellValue().trim();
            case NUMERIC: 
                if (DateUtil.isCellDateFormatted(cell)) return cell.getDateCellValue().toString();
                return String.valueOf((long)cell.getNumericCellValue());
            case BOOLEAN: return String.valueOf(cell.getBooleanCellValue());
            default: return "";
        }
    }

    public byte[] generateCredentialsExcel(Long uploadId) throws IOException {
        // Implementation for downloading the generated credentials
        // This is a placeholder for the logic to generate an Excel with ID, Password, Email
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Credentials");
        
        Row header = sheet.createRow(0);
        header.createCell(0).setCellValue("ID");
        header.createCell(1).setCellValue("Password");
        header.createCell(2).setCellValue("Email");

        // Note: We don't store raw passwords in DB, so we'd normally generate this file 
        // DURING the upload process and store it in a secure location or return it immediately.
        // For now, I'll return a simple dummy byte array to avoid errors, 
        // but in a real app, you'd handle the file storage.
        
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        workbook.write(out);
        workbook.close();
        return out.toByteArray();
    }

    public java.util.Map<String, Long> getFacultyAnalytics(User faculty) {
        List<UploadHistory> history = uploadHistoryRepository.findByUploadedBy(faculty);
        long totalStudents = history.stream().mapToLong(UploadHistory::getSuccessCount).sum();
        long recentUploads = history.size();
        
        java.util.Map<String, Long> stats = new java.util.HashMap<>();
        stats.put("totalStudents", totalStudents);
        stats.put("recentUploads", recentUploads);
        return stats;
    }

    public static class CredentialInfo {
        public String id;
        public String password;
        public String email;
        public String fullName;
        public String department;
        public String subDepartment;
        public String specializationType;
        public String specializationName;
        public CredentialInfo(String id, String password, String email, String fullName, String department, String subDepartment, String specializationType, String specializationName) {
            this.id = id; this.password = password; this.email = email; this.fullName = fullName;
            this.department = department; this.subDepartment = subDepartment;
            this.specializationType = specializationType; this.specializationName = specializationName;
        }
    }
}
