package org.zerock.jdbcex.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class UserDTO {
    private String id;
    private String pwd;
    private String name;
    private String gender;
    private String profileUrl;
    private String dateOfBirth;
}
