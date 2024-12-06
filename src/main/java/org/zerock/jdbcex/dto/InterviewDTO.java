package org.zerock.jdbcex.dto;

import lombok.Builder;
import lombok.Data;

import java.sql.Date;

@Data
@Builder
public class InterviewDTO {
    private int id;
    private String title;
    private String userId;
    private String path;
    private String feedback;
    private int resume_id;
    private Date interviewDate;
}
