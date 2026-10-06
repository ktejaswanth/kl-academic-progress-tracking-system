package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.example.demo.utils.PasswordGenerator;
import org.apache.poi.openxml4j.util.ZipSecureFile;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.util.IOUtils;
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

    static {
        IOUtils.setByteArrayMaxOverride(Integer.MAX_VALUE);
        ZipSecureFile.setMinInflateRatio(0.0);
    }


    @Autowired
    private StudentProfileRepository studentProfileRepository;

    @Autowired
    private com.example.demo.repository.StudentRepository studentRepository;

    @Autowired
    private UploadHistoryRepository uploadHistoryRepository;

    @Autowired
    private UploadFailedRecordRepository failedRecordRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public List<CredentialInfo> processBulkUpload(MultipartFile file, Long uploadedBy) throws IOException {
        IOUtils.setByteArrayMaxOverride(Integer.MAX_VALUE);
        ZipSecureFile.setMinInflateRatio(0.0);
        Workbook workbook;
        try {
            workbook = WorkbookFactory.create(file.getInputStream());
        } catch (Exception ex) {
            workbook = new XSSFWorkbook(file.getInputStream());
        }
        Sheet sheet = workbook.getSheetAt(0);
        Iterator<Row> rows = sheet.iterator();

        UploadHistory history = new UploadHistory();
        history.setUploadedBy(uploadedBy);
        history.setFileName(file.getOriginalFilename());
        history = uploadHistoryRepository.save(history);

        int total = 0;
        int success = 0;
        int failed = 0;

        int nameCol = -1;
        int firstNameCol = -1;
        int lastNameCol = -1;
        int idCol = -1;
        int emailCol = -1;
        int acadYearCol = -1;
        int deptCol = -1;
        int subDeptCol = -1; // Add-on
        int specTypeCol = -1;
        int specNameCol = -1;
        int passwordCol = -1;

        // Parse header row dynamically if present
        if (rows.hasNext()) {
            Row headerRow = rows.next();
            for (int c = 0; c < headerRow.getLastCellNum(); c++) {
                String header = getCellValue(headerRow, c).toUpperCase().trim();
                if (header.contains("FIRST") && header.contains("NAME")) {
                    firstNameCol = c;
                } else if (header.contains("LAST") && header.contains("NAME")) {
                    lastNameCol = c;
                } else if (header.contains("NAME") && !header.contains("SPEC")) {
                    nameCol = c;
                } else if (header.contains("ACADEMIC") || header.contains("BATCH") || (header.contains("YEAR") && !header.contains("BIRTH"))) {
                    acadYearCol = c;
                } else if (header.contains("ID") && !header.contains("MAIL") && !header.contains("EMAIL")) {
                    idCol = c;
                } else if (header.contains("MAIL") || header.contains("EMAIL")) {
                    emailCol = c;
                } else if (header.contains("ADD-ON") || header.contains("ADD ON") || header.contains("ADDON")
                        || header.contains("SUB DEPT") || header.contains("SUB DEPARTMENT") 
                        || header.contains("SUB_DEPT") || header.contains("SUBDEPT")) {
                    subDeptCol = c;
                } else if (header.contains("DEPARTM") || header.contains("DEPT") || header.contains("BRANCH")) {
                    deptCol = c;
                } else if (header.contains("SPEC") && header.contains("TYPE")) {
                    specTypeCol = c;
                } else if (header.contains("SPEC") && (header.contains("NAME") || header.contains("TITLE"))) {
                    specNameCol = c;
                } else if (header.contains("PASS") || header.contains("PWD") || header.contains("SECRET")) {
                    passwordCol = c;
                }
            }
        }

        // Positional fallback for legacy 7-column sheets
        if (idCol == -1 && nameCol == -1 && firstNameCol == -1) {
            nameCol = 0;
            idCol = 1;
            emailCol = 2;
            deptCol = 3;
            subDeptCol = 4;
            specTypeCol = 5;
            specNameCol = 6;
        }

        List<CredentialInfo> credentials = new ArrayList<>();

        while (rows.hasNext()) {
            Row row = rows.next();
            
            String studentId = (idCol != -1) ? getCellValue(row, idCol) : "";
            String email = (emailCol != -1) ? getCellValue(row, emailCol) : "";

            String firstName = "";
            String lastName = "";
            if (firstNameCol != -1 && !getCellValue(row, firstNameCol).isEmpty()) {
                firstName = getCellValue(row, firstNameCol);
                lastName = (lastNameCol != -1) ? getCellValue(row, lastNameCol) : "";
            } else if (nameCol != -1) {
                String fullName = getCellValue(row, nameCol);
                if (fullName.contains(" ")) {
                    int lastSpace = fullName.lastIndexOf(" ");
                    firstName = fullName.substring(0, lastSpace).trim();
                    lastName = fullName.substring(lastSpace + 1).trim();
                } else {
                    firstName = fullName.trim();
                    lastName = "";
                }
            }

            // Skip empty rows
            if (firstName.isEmpty() && lastName.isEmpty() && studentId.isEmpty() && email.isEmpty()) {
                continue;
            }

            total++;
            try {
                if (studentId.isEmpty() || email.isEmpty() || firstName.isEmpty()) {
                    throw new Exception("Missing required fields (ID, Name, or Email)");
                }

                String academicYear = "Y23";
                if (acadYearCol != -1 && !getCellValue(row, acadYearCol).isEmpty()) {
                    academicYear = getCellValue(row, acadYearCol).trim().toUpperCase();
                    if (academicYear.equals("2023-2024") || academicYear.equals("2023") || academicYear.equals("23")) academicYear = "Y23";
                    else if (academicYear.equals("2024-2025") || academicYear.equals("2024") || academicYear.equals("24")) academicYear = "Y24";
                    else if (academicYear.equals("2025-2026") || academicYear.equals("2025") || academicYear.equals("25")) academicYear = "Y25";
                    else if (academicYear.equals("2026-2027") || academicYear.equals("2026") || academicYear.equals("26")) academicYear = "Y26";
                }

                String department = (deptCol != -1 && !getCellValue(row, deptCol).isEmpty()) ? getCellValue(row, deptCol) : "CSE";
                String subDept = (subDeptCol != -1 && !getCellValue(row, subDeptCol).isEmpty()) ? getCellValue(row, subDeptCol) : "REGULAR";
                String specType = (specTypeCol != -1 && !getCellValue(row, specTypeCol).isEmpty()) ? getCellValue(row, specTypeCol).toUpperCase() : "NONE";
                String specName = (specNameCol != -1 && !getCellValue(row, specNameCol).isEmpty()) ? getCellValue(row, specNameCol) : "N/A";

                Optional<com.example.demo.model.Student> existingStudentOpt = studentRepository.findByStudentId(studentId);
                com.example.demo.model.Student student = existingStudentOpt.orElseGet(com.example.demo.model.Student::new);

                String rawPassword = (passwordCol != -1 && !getCellValue(row, passwordCol).isEmpty()) 
                        ? getCellValue(row, passwordCol) 
                        : student.getRawPassword();

                if (rawPassword == null || rawPassword.isEmpty()) {
                    rawPassword = PasswordGenerator.generateRandomPassword(8);
                }

                student.setStudentId(studentId);
                student.setAcademicYear(academicYear);
                student.setFirstName(firstName);
                student.setLastName(lastName);
                student.setEmail(email);
                student.setDepartment(department.isEmpty() ? "CSE" : department);
                student.setSubDepartment(subDept.isEmpty() ? "REGULAR" : subDept);
                student.setSpecializationType(specType.isEmpty() ? "NONE" : specType.toUpperCase());
                student.setSpecializationName(specName.isEmpty() ? "N/A" : specName);
                student.setPassword(passwordEncoder.encode(rawPassword));
                student.setRawPassword(rawPassword);
                student.setIsActive(true);
                student.setFirstLoginCompleted(false);

                studentRepository.save(student);

                String fullName = (firstName + " " + lastName).trim();
                credentials.add(new CredentialInfo(studentId, rawPassword, email, fullName, student.getDepartment(), student.getSubDepartment(), student.getSpecializationType(), student.getSpecializationName(), student.getAcademicYear()));
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

    public java.util.Map<String, Long> getFacultyAnalytics(Long facultyId) {
        List<UploadHistory> history = (facultyId != null)
                ? uploadHistoryRepository.findByUploadedBy(facultyId)
                : uploadHistoryRepository.findAll();
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
        public String academicYear;

        public CredentialInfo(String id, String password, String email, String fullName, String department, String subDepartment, String specializationType, String specializationName) {
            this(id, password, email, fullName, department, subDepartment, specializationType, specializationName, "Y23");
        }

        public CredentialInfo(String id, String password, String email, String fullName, String department, String subDepartment, String specializationType, String specializationName, String academicYear) {
            this.id = id; this.password = password; this.email = email; this.fullName = fullName;
            this.department = department; this.subDepartment = subDepartment;
            this.specializationType = specializationType; this.specializationName = specializationName;
            this.academicYear = academicYear;
        }
    }
}
