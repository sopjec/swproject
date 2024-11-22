package org.zerock.jdbcex.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ScrapDTO {
    private int id;           // 자동 증가 ID
    private String userId;    // User 테이블의 외래키
    private String scrapKey;  // 스크랩 고유키
}

