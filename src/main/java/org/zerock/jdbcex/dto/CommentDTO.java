package org.zerock.jdbcex.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class CommentDTO {
    private int id;               // 댓글 ID
    private int reviewId;         // 연관된 리뷰 ID
    private String author;        // 댓글 작성자
    private String content;       // 댓글 내용
    private LocalDateTime createdDate; // 생성 날짜
    private LocalDateTime updatedDate; // 업데이트 날짜 (옵션)

    // 기본 생성자
    public CommentDTO() {}

    // 전체 필드를 받는 생성자 (선택사항, 필요하면 사용)
    public CommentDTO(int id, int reviewId, String author, String content, LocalDateTime createdDate, LocalDateTime updatedDate) {
        this.id = id;
        this.reviewId = reviewId;
        this.author = author;
        this.content = content;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }

    // 생성 날짜와 작성자를 기본값으로 설정하는 헬퍼 메서드 (익명 댓글 처리 등)
    public static CommentDTO createAnonymousComment(int reviewId, String content, int anonymousIndex) {
        CommentDTO comment = new CommentDTO();
        comment.setReviewId(reviewId);
        comment.setAuthor("익명 " + anonymousIndex);
        comment.setContent(content);
        comment.setCreatedDate(LocalDateTime.now());
        return comment;
    }
}
