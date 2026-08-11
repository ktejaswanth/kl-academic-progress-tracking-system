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
import java.util.Optional;

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

        int nameCol = 0;
        int idCol = 1;
        int emailCol = 2;
        int deptCol = 3;
        int subDeptCol = 4;
        int specTypeCol = 5;
        int specNameCol = 6;

        // Parse header row dynamically if present
        if (rows.hasNext()) {
            Row headerRow = rows.next();
            for (int c = 0; c < headerRow.getLastCellNum(); c++) {
                String header = getCellValue(headerRow, c).toUpperCase().trim();
                if (header.contains("NAME") && !header.contains("SPEC")) {
                    nameCol = c;
                } else if (header.contains("ID") && !header.contains("MAIL") && !header.contains("EMAIL")) {
                    idCol = c;
                } else if (header.contains("MAIL") || header.contains("EMAIL")) {
                    emailCol = c;
                } else if (header.contains("SUB DEPT") || header.contains("SUB DEPARTMENT") || header.contains("SUB_DEPT") || header.contains("SUBDEPT")) {
                    subDeptCol = c;
                } else if (header.contains("DEPARTM") || header.contains("DEPT") || header.contains("DEPARTMENT")) {
                    deptCol = c;
                } else if (header.contains("SPEC") && header.contains("TYPE")) {
                    specTypeCol = c;
                } else if (header.contains("SPEC") && (header.contains("NAME") || header.contains("TITLE"))) {
                    specNameCol = c;
                }
            }
        }

        List<CredentialInfo> credentials = new ArrayList<>();

        while (rows.hasNext()) {
            Row row = rows.next();
            
            String fullName = getCellValue(row, nameCol);
            String studentId = getCellValue(row, idCol);
            String email = getCellValue(row, emailCol);

            // Skip empty rows
            if (fullName.isEmpty() && studentId.isEmpty() && email.isEmpty()) {
                continue;
            }

            total++;
            try {
                String department = getCellValue(row, deptCol);
                String subDept = getCellValue(row, subDeptCol);
                String specType = getCellValue(row, specTypeCol);
                String specName = getCellValue(row, specNameCol);

                if (studentId.isEmpty() || email.isEmpty() || fullName.isEmpty()) {
                    throw new Exception("Missing required fields (Name, ID, or Email)");
                }

                // Split Name into First and Last
                String firstName = fullName;
                String lastName = "";
                if (fullName.contains(" ")) {
                    int lastSpace = fullName.lastIndexOf(" ");
                    firstName = fullName.substring(0, lastSpace);
                    lastName = fullName.substring(lastSpace + 1);
                }

                Optional<User> existingOpt = userRepository.findByUsername(studentId);
                User user;
                String rawPassword;

                if (existingOpt.isPresent()) {
                    user = existingOpt.get();
                    rawPassword = user.getRawPassword();
                    if (rawPassword == null || rawPassword.isEmpty()) {
                        rawPassword = PasswordGenerator.generateRandomPassword(8);
                        user.setPasswordHash(passwordEncoder.encode(rawPassword));
                        user.setRawPassword(rawPassword);
                    }
                } else {
                    rawPassword = PasswordGenerator.generateRandomPassword(8);
                    user = new User();
                    user.setUsername(studentId);
                    user.setPasswordHash(passwordEncoder.encode(rawPassword));
                    user.setRawPassword(rawPassword);
                    user.setRole(UserRole.STUDENT);
                    user.setForcePasswordChange(true);
                }

                user.setEmail(email);
                user.setFirstName(firstName);
                user.setLastName(lastName);
                user.setDepartment(department.isEmpty() ? "N/A" : department);
                user.setSubDepartment(subDept.isEmpty() ? "REGULAR" : subDept);
                user.setSpecializationType(specType.isEmpty() ? "NONE" : specType.toUpperCase());
                user.setSpecializationName(specName.isEmpty() ? "N/A" : specName);

                final User savedUser = userRepository.save(user);

                Optional<StudentProfile> profileOpt = studentProfileRepository.findByUser(savedUser);
                StudentProfile profile = profileOpt.orElseGet(() -> {
                    StudentProfile sp = new StudentProfile();
                    sp.setUser(savedUser);
                    return sp;
                });
                profile.setDegreeType("B.Tech");
                profile.setSpecialization(savedUser.getDepartment() != null && !savedUser.getDepartment().equals("N/A") ? savedUser.getDepartment() : "CSE");
                studentProfileRepository.save(profile);

                credentials.add(new CredentialInfo(studentId, rawPassword, email, fullName, savedUser.getDepartment(), savedUser.getSubDepartment(), savedUser.getSpecializationType(), savedUser.getSpecializationName()));
                success++;

            } catch (Exception e) {
                failed++;
                UploadFailedRecord failedRecord = new UploadFailedRecord();
                failedRecord.setUpload(history);
                failedRecord.setRowNumber(row.getRowNum() + 1);
                failedRecord.setErrorReason(e.getMessage());
                failedRecord.setStudentIdNum(getCellValue(row, idCol));
                failedRecord.setEmail(getCellValue(row, emailCol));
                failedRecordRepository.save(failedRecord);
            }
        }

        history.setTotalRecords(total);
        history.setSuccessCount(success);
        history.setFailedCount(failed);
        history.setStatus("COMPLETED");
        uploadHistoryRepository.save(history);
        
        workbook.close();

        if (total > 0 && success == 0) {
            throw new RuntimeException("All " + total + " row(s) in the Excel file failed to process. Please ensure required columns (Name, ID, Email) are present and formatted correctly.");
        }

        return credentials;
    }

    private String getCellValue(Row row, int cellIndex) {
        Cell cell = row.getCell(cellIndex);
        if (cell == null) return "";
        
        switch (cell.getCellType()) {
            case STRING: return cell.getStringCellValue().trim();
            case NUMERIC: 
                if (DateUtil.isCellDateFormatted(cell)) return cell.getDateCellValue().toString();
                return new java.text.DecimalFormat("#").format(cell.getNumericCellValue());
            case BOOLEAN: return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                try {
                    return cell.getStringCellValue().trim();
                } catch (Exception e) {
                    return new java.text.DecimalFormat("#").format(cell.getNumericCellValue());
                }
            default: return "";
        }
    }

    public byte[] generateCredentialsExcel(Long uploadId) throws IOException {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Credentials");
        
        Row header = sheet.createRow(0);
        header.createCell(0).setCellValue("ID");
        header.createCell(1).setCellValue("Password");
        header.createCell(2).setCellValue("Email");

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
