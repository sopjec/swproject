package org.zerock.jdbcex.dto;

import lombok.Data;

@Data
public class InterviewQnADTO {
    private int id;
    private int interviewId;
    private String user_id;
    private String question;
    private String answer;
}
