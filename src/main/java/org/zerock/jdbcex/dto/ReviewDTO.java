//ReviewDTO
package org.zerock.jdbcex.dto;

import lombok.Data;

@Data
public class ReviewDTO {
    private int id; //순번
    private String userId; //아이디
    private String title; //제목
    private String content; //내용
    private String job; //직무
    private String industry; //업종
}
