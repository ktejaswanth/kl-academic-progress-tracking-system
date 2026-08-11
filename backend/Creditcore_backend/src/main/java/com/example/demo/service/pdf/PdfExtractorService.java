package com.example.demo.service.pdf;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
public class PdfExtractorService {

    /**
     * Extracts text from a PDF file uploaded as a MultipartFile.
     * Inserts page markers (=== PAGE N ===) between pages for AI context.
     */
    public String extractText(MultipartFile pdfFile) throws IOException {
        byte[] bytes = pdfFile.getBytes();
        if (bytes == null || bytes.length == 0) {
            throw new IOException("Uploaded file is empty (0 bytes).");
        }

        // Validate %PDF magic number signature
        if (bytes.length < 4 || 
            bytes[0] != 0x25 || // '%'
            bytes[1] != 0x50 || // 'P'
            bytes[2] != 0x44 || // 'D'
            bytes[3] != 0x46) { // 'F'
            
            String prefix = new String(bytes, 0, Math.min(bytes.length, 50)).replaceAll("[^\\x20-\\x7E]", "?");
            throw new IOException("Uploaded file is not a valid PDF document. Header signature is missing. File starts with: " + prefix);
        }

        try (PDDocument document = Loader.loadPDF(bytes)) {
            int totalPages = document.getNumberOfPages();
            StringBuilder fullText = new StringBuilder();

            PDFTextStripper stripper = new PDFTextStripper();
            stripper.setSortByPosition(true);

            for (int page = 1; page <= totalPages; page++) {
                stripper.setStartPage(page);
                stripper.setEndPage(page);

                String pageText = stripper.getText(document);
                String cleanedText = cleanPageText(pageText);

                if (shouldKeepPage(page, cleanedText)) {
                    fullText.append("=== PAGE ").append(page).append(" ===\n");
                    fullText.append(cleanedText);
                    fullText.append("\n");
                }
            }

            return fullText.toString();
        }
    }

    /**
     * Filters pages to keep only key introduction and main program structure table pages,
     * while discarding massive minor catalogs and redundant credit path combination tables.
     */
    private boolean shouldKeepPage(int pageNum, String pageText) {
        if (pageNum <= 15) {
            return true;
        }

        String lowerText = pageText.toLowerCase();
        
        // Keep pages containing course structure tables
        boolean hasTableHead = lowerText.contains("s#");
        boolean hasColumns = lowerText.contains("sub-cat") || 
                             lowerText.contains("sub-category") || 
                             lowerText.contains("coursecode") || 
                             lowerText.contains("course code") || 
                             lowerText.contains("l-t-p-s") || 
                             lowerText.contains("l t p s");

        // Discard pages containing minor catalog course listings
        boolean isMinor = lowerText.contains("minor:") || 
                          lowerText.contains("minor ") || 
                          lowerText.contains("min-core");

        return hasTableHead && hasColumns && !isMinor;
    }

    /**
     * Cleans extracted page text by removing common header/footer repetitions
     * and normalizing whitespace.
     */
    private String cleanPageText(String rawText) {
        if (rawText == null || rawText.isBlank()) {
            return "";
        }

        // Normalize line endings
        String cleaned = rawText.replace("\r\n", "\n").replace("\r", "\n");

        // Remove common footer pattern (page numbers like "70", "71" at end of lines)
        cleaned = cleaned.replaceAll("(?m)^\\s*\\d{1,3}\\s*$", "");

        // Collapse multiple blank lines into one
        cleaned = cleaned.replaceAll("\n{3,}", "\n\n");

        return cleaned.trim();
    }
}
