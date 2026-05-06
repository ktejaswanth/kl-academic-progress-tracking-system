package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "upload_failed_records")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UploadFailedRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "upload_id", referencedColumnName = "id")
    private UploadHistory upload;

    @Column(name = "row_number")
    private Integer rowNumber;

    @Column(name = "student_id_num")
    private String studentIdNum;

    private String email;

    @Column(name = "error_reason")
    private String errorReason;
}
