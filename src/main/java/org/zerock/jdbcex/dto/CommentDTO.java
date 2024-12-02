package org.zerock.jdbcex.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class CommentDTO {
    private int id;                // 댓글 ID
    private int reviewId;          // 연관된 리뷰 ID
    private Integer parentCommentId; // 부모 댓글 ID (null이면 일반 댓글)
    private String author;         // 댓글 작성자
    private String content;        // 댓글 내용
    private LocalDateTime createdDate; // 생성 날짜
    private LocalDateTime updatedDate; // 업데이트 날짜 (옵션)

    // 기본 생성자
    public CommentDTO() {}

    // 전체 필드를 받는 생성자
    public CommentDTO(int id, int reviewId, Integer parentCommentId, String author, String content, LocalDateTime createdDate, LocalDateTime updatedDate) {
        this.id = id;
        this.reviewId = reviewId;
        this.parentCommentId = parentCommentId;
        this.author = author;
        this.content = content;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }
}
