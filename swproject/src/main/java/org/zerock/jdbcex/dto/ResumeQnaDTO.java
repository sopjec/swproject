package org.zerock.jdbcex.dto;

import lombok.Data;

@Data
public class ResumeQnaDTO {
    private int id;          // 기본키
    private int resumeId;    // resume 테이블의 ID 참조
    private String question; // 질문
    private String answer;   // 답변
}
