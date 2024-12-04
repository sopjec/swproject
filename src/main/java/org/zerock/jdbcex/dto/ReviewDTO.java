//ReviewDTO
package org.zerock.jdbcex.dto;

import lombok.Data;


import java.time.LocalDateTime;

@Data
public class ReviewDTO {
    private int id;             // 기본 키
    private String comname;     // 기업명
    private String job;         // 직무직업
    private String experience;  // 경력
    private String region;      // 지역
    private String content;     // 면접 내용
    private String userId;      // 사용자 ID
    private LocalDateTime createdDate; // 등록 날짜
    private int likes;          //좋아요 수
    private int reviewId; // 리뷰 ID
}