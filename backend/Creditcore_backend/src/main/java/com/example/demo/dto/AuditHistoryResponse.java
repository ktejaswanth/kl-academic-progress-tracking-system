package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuditHistoryResponse {
    private Long id;
    private Long studentId;
    private String universityId;
    private String studentName;
    private String actionType;
    private Long performedBy;
    private String actorUsername;
    private String actorRole;
    private Long courseId;
    private String courseCode;
    private String description;
    private Map<String, Object> oldValues;
    private Map<String, Object> newValues;
    private String payload;
    private String result;
    private LocalDateTime createdAt;
}
