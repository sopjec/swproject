package org.zerock.jdbcex.dto;

import lombok.Data;

@Data
public class QnAReplyDTO {
    private int id;
    private int qnaId;
    private String content;
}
