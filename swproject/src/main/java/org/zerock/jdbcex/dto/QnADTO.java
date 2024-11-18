package org.zerock.jdbcex.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class QnADTO {
    private int id;
    private String userId;
    private String title;
    private String content;
    private String filePath;
    private LocalDate qnaDate;
    private String category;

    // 파일 업로드 없이 생성할 경우 사용할 생성자
    public QnADTO(String userId, String title, String content, LocalDate qnaDate, String category) {
        this.userId = userId;
        this.title = title;
        this.content = content;
        this.qnaDate = qnaDate;
        this.category = category;
    }

    // 파일 업로드 포함 생성자
    public QnADTO(String userId, String title, String content, String filePath, LocalDate qnaDate, String category) {
        this.userId = userId;
        this.title = title;
        this.content = content;
        this.filePath = filePath;
        this.qnaDate = qnaDate;
        this.category = category;
    }
}
