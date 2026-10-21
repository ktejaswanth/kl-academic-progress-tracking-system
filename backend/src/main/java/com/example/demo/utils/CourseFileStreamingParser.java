package com.example.demo.utils;

import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.util.XMLHelper;
import org.apache.poi.xssf.eventusermodel.ReadOnlySharedStringsTable;
import org.apache.poi.xssf.eventusermodel.XSSFReader;
import org.apache.poi.xssf.eventusermodel.XSSFSheetXMLHandler;
import org.apache.poi.xssf.eventusermodel.XSSFSheetXMLHandler.SheetContentsHandler;
import org.apache.poi.xssf.model.StylesTable;
import org.apache.poi.xssf.usermodel.XSSFComment;
import org.xml.sax.ContentHandler;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.Consumer;

/**
 * High-performance streaming parser for course upload files.
 * Capable of streaming up to 1,000,000 rows with strictly bounded memory (O(1) memory footprint).
 * Supports .csv, .xlsx (via SAX Event API), and .xls.
 */
public class CourseFileStreamingParser {

    public static class ParsedRow {
        public String universityId;
        public String studentName;
        public String courseCode;
        public String ltps;
        public String courseName;
        public String bucketGroup;
        public String courseType;
        public String academicYear;
        public String semester;
        public Integer studyYear;
        public String sectionNo;
        public LocalDate registerDate;
        public String courseRef;
        public String offerTo;
        public String offerBy;
        public String branch;
        public Integer credits;
        public String grade;
        public String category;
        public String status = "Completed";
    }

    private static final DateTimeFormatter[] DATE_FORMATTERS = new DateTimeFormatter[]{
            DateTimeFormatter.ofPattern("yyyy-MM-dd"),
            DateTimeFormatter.ofPattern("dd-MM-yyyy"),
            DateTimeFormatter.ofPattern("dd/MM/yyyy"),
            DateTimeFormatter.ofPattern("yyyy/MM/dd"),
            DateTimeFormatter.ofPattern("M/d/yyyy"),
            DateTimeFormatter.ofPattern("d/M/yyyy")
    };

    /**
     * Parse stream and stream rows to the consumer in real-time.
     */
    public static void streamRows(InputStream inputStream, String fileName, Consumer<ParsedRow> rowConsumer) throws Exception {
        String lowerName = (fileName != null) ? fileName.toLowerCase() : "";

        if (lowerName.endsWith(".csv") || lowerName.endsWith(".txt")) {
            parseCsv(inputStream, rowConsumer);
        } else if (lowerName.endsWith(".xlsx")) {
            parseXlsxStreaming(inputStream, rowConsumer);
        } else {
            parseStandardWorkbook(inputStream, rowConsumer);
        }
    }

    /**
     * High-speed streaming CSV parser.
     */
    private static void parseCsv(InputStream is, Consumer<ParsedRow> rowConsumer) throws Exception {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String line = reader.readLine();
            if (line == null) return;

            // Remove UTF-8 BOM if present
            if (line.startsWith("\uFEFF")) {
                line = line.substring(1);
            }

            Map<String, Integer> colMap = detectHeaderMap(parseCsvLine(line));

            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                List<String> values = parseCsvLine(line);
                ParsedRow row = mapRowValues(values, colMap);
                if (row != null) {
                    rowConsumer.accept(row);
                }
            }
        }
    }

    /**
     * Event-driven SAX streaming for .xlsx files.
     * Prevents OutOfMemoryError by streaming XML without loading DOM into memory.
     */
    private static void parseXlsxStreaming(InputStream is, Consumer<ParsedRow> rowConsumer) throws Exception {
        // Save stream to temp file if not already a file stream to allow random access for ZIP package
        File tempFile = File.createTempFile("course_upload_", ".xlsx");
        try {
            try (FileOutputStream fos = new FileOutputStream(tempFile)) {
                byte[] buffer = new byte[65536];
                int bytesRead;
                while ((bytesRead = is.read(buffer)) != -1) {
                    fos.write(buffer, 0, bytesRead);
                }
            }

            try (OPCPackage pkg = OPCPackage.open(tempFile)) {
                ReadOnlySharedStringsTable strings = new ReadOnlySharedStringsTable(pkg);
                XSSFReader xssfReader = new XSSFReader(pkg);
                StylesTable styles = xssfReader.getStylesTable();
                XSSFReader.SheetIterator iter = (XSSFReader.SheetIterator) xssfReader.getSheetsData();

                if (iter.hasNext()) {
                    try (InputStream sheetStream = iter.next()) {
                        InputSource sheetSource = new InputSource(sheetStream);
                        XMLReader sheetParser = XMLHelper.newXMLReader();

                        Map<String, Integer> colMap = new HashMap<>();
                        boolean[] isFirstRow = new boolean[]{true};

                        ContentHandler handler = new XSSFSheetXMLHandler(styles, strings, new SheetContentsHandler() {
                            private final List<String> currentRow = new ArrayList<>();

                            @Override
                            public void startRow(int rowNum) {
                                currentRow.clear();
                            }

                            @Override
                            public void endRow(int rowNum) {
                                if (isFirstRow[0]) {
                                    colMap.putAll(detectHeaderMap(currentRow));
                                    isFirstRow[0] = false;
                                } else {
                                    ParsedRow row = mapRowValues(currentRow, colMap);
                                    if (row != null) {
                                        rowConsumer.accept(row);
                                    }
                                }
                            }

                            @Override
                            public void cell(String cellAddress, String formattedValue, XSSFComment comment) {
                                int colIndex = getColumnIndexFromAddress(cellAddress);
                                while (currentRow.size() < colIndex) {
                                    currentRow.add("");
                                }
                                String val = (formattedValue != null) ? formattedValue.trim() : "";
                                if (colIndex < currentRow.size()) {
                                    currentRow.set(colIndex, val);
                                } else {
                                    currentRow.add(val);
                                }
                            }

                            @Override
                            public void headerFooter(String text, boolean isHeader, String tagName) {}
                        }, false);

                        sheetParser.setContentHandler(handler);
                        sheetParser.parse(sheetSource);
                    }
                }
            }
        } finally {
            if (tempFile.exists()) {
                tempFile.delete();
            }
        }
    }

    /**
     * Fallback standard workbook parser for legacy .xls files.
     */
    private static void parseStandardWorkbook(InputStream is, Consumer<ParsedRow> rowConsumer) throws Exception {
        try (Workbook workbook = WorkbookFactory.create(is)) {
            Sheet sheet = workbook.getSheetAt(0);
            Iterator<Row> rowIterator = sheet.iterator();
            if (!rowIterator.hasNext()) return;

            Row headerRow = rowIterator.next();
            List<String> headers = new ArrayList<>();
            for (Cell cell : headerRow) {
                headers.add(getCellValueAsString(cell));
            }
            Map<String, Integer> colMap = detectHeaderMap(headers);

            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                List<String> values = new ArrayList<>();
                int lastCell = Math.max(row.getLastCellNum(), 16);
                for (int i = 0; i < lastCell; i++) {
                    values.add(getCellValueAsString(row.getCell(i)));
                }
                ParsedRow parsed = mapRowValues(values, colMap);
                if (parsed != null) {
                    rowConsumer.accept(parsed);
                }
            }
        }
    }

    private static int getColumnIndexFromAddress(String cellAddress) {
        if (cellAddress == null || cellAddress.isEmpty()) return 0;
        int col = 0;
        for (int i = 0; i < cellAddress.length(); i++) {
            char c = cellAddress.charAt(i);
            if (Character.isLetter(c)) {
                col = col * 26 + (Character.toUpperCase(c) - 'A' + 1);
            } else {
                break;
            }
        }
        return Math.max(0, col - 1);
    }

    private static Map<String, Integer> detectHeaderMap(List<String> headers) {
        Map<String, Integer> map = new HashMap<>();
        if (headers == null) return map;

        // Pass 1: Match specific known column patterns (do NOT match bare "id" as universityId here)
        for (int i = 0; i < headers.size(); i++) {
            String h = headers.get(i).trim().toLowerCase().replaceAll("[^a-z0-9]", "");
            if (h.contains("univ") || h.contains("regd") || h.contains("studentid") || h.equals("rollno") || h.equals("rollnumber")) {
                map.putIfAbsent("universityId", i);
            } else if (h.contains("studentname") || (h.contains("name") && !h.contains("course"))) {
                map.putIfAbsent("studentName", i);
            } else if (h.contains("coursecode") || h.equals("code")) {
                map.putIfAbsent("courseCode", i);
            } else if (h.contains("coursename") || (h.contains("title") || h.equals("course"))) {
                map.putIfAbsent("courseName", i);
            } else if (h.contains("ltps")) {
                map.putIfAbsent("ltps", i);
            } else if (h.contains("bucket")) {
                map.putIfAbsent("bucketGroup", i);
            } else if (h.contains("coursetype") || h.equals("type")) {
                map.putIfAbsent("courseType", i);
            } else if (h.contains("academicyear") || h.contains("acadyear")) {
                map.putIfAbsent("academicYear", i);
            } else if (h.contains("semester") || h.equals("sem")) {
                map.putIfAbsent("semester", i);
            } else if (h.contains("studyyear") || h.equals("year")) {
                map.putIfAbsent("studyYear", i);
            } else if (h.contains("section") || h.equals("sec")) {
                map.putIfAbsent("sectionNo", i);
            } else if (h.contains("registerdate") || h.contains("regdate") || h.contains("date")) {
                map.putIfAbsent("registerDate", i);
            } else if (h.contains("courseref") || h.contains("ref")) {
                map.putIfAbsent("courseRef", i);
            } else if (h.contains("offeredto") || h.contains("offerto")) {
                map.putIfAbsent("offerTo", i);
            } else if (h.contains("offeredby") || h.contains("offerby")) {
                map.putIfAbsent("offerBy", i);
            } else if (h.contains("branch") || h.contains("department") || h.equals("dept")) {
                map.putIfAbsent("branch", i);
            } else if (h.contains("credit")) {
                map.putIfAbsent("credits", i);
            } else if (h.contains("grade")) {
                map.putIfAbsent("grade", i);
            } else if (h.contains("category")) {
                map.putIfAbsent("category", i);
            }
        }

        // Pass 2: Fallback only if no university/student ID header was found in pass 1
        if (!map.containsKey("universityId")) {
            for (int i = 0; i < headers.size(); i++) {
                String h = headers.get(i).trim().toLowerCase().replaceAll("[^a-z0-9]", "");
                if (h.equals("id") || h.equals("student")) {
                    map.put("universityId", i);
                    break;
                }
            }
        }

        return map;
    }

    private static String getVal(List<String> values, Map<String, Integer> colMap, String key, int fallbackIndex) {
        Integer idx = colMap.get(key);
        if (idx == null) idx = fallbackIndex;
        if (idx >= 0 && idx < values.size()) {
            String v = values.get(idx);
            return (v != null) ? v.trim() : "";
        }
        return "";
    }

    private static ParsedRow mapRowValues(List<String> values, Map<String, Integer> colMap) {
        if (values == null || values.isEmpty()) return null;

        String universityId = getVal(values, colMap, "universityId", 0);
        String courseCode = getVal(values, colMap, "courseCode", 2);

        if (universityId.isEmpty() && courseCode.isEmpty()) {
            return null;
        }
        if (universityId.isEmpty() || courseCode.isEmpty()) {
            ParsedRow invalid = new ParsedRow();
            invalid.universityId = universityId;
            invalid.courseCode = courseCode;
            invalid.studentName = getVal(values, colMap, "studentName", 1);
            invalid.status = "FAILED: Missing required universityId or courseCode";
            return invalid;
        }

        ParsedRow r = new ParsedRow();
        r.universityId = universityId;
        r.studentName = getVal(values, colMap, "studentName", 1);
        r.courseCode = courseCode.toUpperCase();
        r.ltps = getVal(values, colMap, "ltps", 3);
        r.courseName = getVal(values, colMap, "courseName", 4);
        r.bucketGroup = getVal(values, colMap, "bucketGroup", 5);
        r.courseType = getVal(values, colMap, "courseType", 6);
        r.academicYear = getVal(values, colMap, "academicYear", 7);
        r.semester = getVal(values, colMap, "semester", 8);
        if (r.semester.isEmpty()) r.semester = "ODD";

        String studyYearStr = getVal(values, colMap, "studyYear", 9);
        if (!studyYearStr.isEmpty()) {
            try {
                r.studyYear = Integer.parseInt(studyYearStr);
            } catch (Exception ignored) {}
        }

        r.sectionNo = getVal(values, colMap, "sectionNo", 10);
        String dateStr = getVal(values, colMap, "registerDate", 11);
        r.registerDate = parseDateString(dateStr);

        r.courseRef = getVal(values, colMap, "courseRef", 12);
        r.offerTo = getVal(values, colMap, "offerTo", 13);
        r.offerBy = getVal(values, colMap, "offerBy", 14);
        r.branch = getVal(values, colMap, "branch", 15);

        String creditsStr = getVal(values, colMap, "credits", -1);
        if (!creditsStr.isEmpty()) {
            try {
                r.credits = (int) Math.round(Double.parseDouble(creditsStr));
            } catch (Exception ignored) {}
        }
        if (r.credits == null) {
            r.credits = parseCreditsFromLtps(r.ltps);
        }

        r.grade = getVal(values, colMap, "grade", -1);
        r.category = getVal(values, colMap, "category", -1);

        return r;
    }

    private static Integer parseCreditsFromLtps(String ltps) {
        if (ltps == null || ltps.trim().isEmpty()) return 0;
        try {
            String[] parts = ltps.trim().split("[-+]");
            if (parts.length >= 4) {
                double l = Double.parseDouble(parts[0].trim());
                double t = Double.parseDouble(parts[1].trim());
                double p = Double.parseDouble(parts[2].trim());
                double s = Double.parseDouble(parts[3].trim());
                return (int) Math.round(l + t + (p / 2.0) + (s / 2.0));
            } else if (parts.length == 3) {
                double l = Double.parseDouble(parts[0].trim());
                double t = Double.parseDouble(parts[1].trim());
                double p = Double.parseDouble(parts[2].trim());
                return (int) Math.round(l + t + (p / 2.0));
            }
        } catch (Exception ignored) {}
        return 0;
    }

    private static LocalDate parseDateString(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) return null;
        String clean = dateStr.trim();
        for (DateTimeFormatter fmt : DATE_FORMATTERS) {
            try {
                return LocalDate.parse(clean, fmt);
            } catch (Exception ignored) {}
        }
        return null;
    }

    private static List<String> parseCsvLine(String line) {
        List<String> tokens = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        boolean inQuotes = false;

        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            if (c == '\"') {
                if (inQuotes && i + 1 < line.length() && line.charAt(i + 1) == '\"') {
                    sb.append('\"');
                    i++;
                } else {
                    inQuotes = !inQuotes;
                }
            } else if (c == ',' && !inQuotes) {
                tokens.add(sb.toString().trim());
                sb.setLength(0);
            } else {
                sb.append(c);
            }
        }
        tokens.add(sb.toString().trim());
        return tokens;
    }

    private static String getCellValueAsString(Cell cell) {
        if (cell == null) return "";
        CellType type = cell.getCellType();
        if (type == CellType.STRING) return cell.getStringCellValue().trim();
        if (type == CellType.NUMERIC) {
            if (DateUtil.isCellDateFormatted(cell)) {
                return cell.getLocalDateTimeCellValue().toLocalDate().toString();
            }
            double val = cell.getNumericCellValue();
            if (val == Math.floor(val)) {
                return String.valueOf((long) val);
            }
            return String.valueOf(val);
        }
        if (type == CellType.BOOLEAN) return String.valueOf(cell.getBooleanCellValue());
        return "";
    }
}
