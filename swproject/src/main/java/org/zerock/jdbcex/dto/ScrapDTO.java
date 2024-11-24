package org.zerock.jdbcex.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ScrapDTO {
    private int id; // auto-increment primary key
    private String userId; // varchar(50), foreign key to user table
    private String scrapKey; // varchar(255), stores the scrap key
}
