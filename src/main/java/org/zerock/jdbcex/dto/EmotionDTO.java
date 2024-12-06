package org.zerock.jdbcex.dto;

public class EmotionDTO {
    private String type;
    private double value;

    public EmotionDTO(String type, double value) {
        this.type = type;
        this.value = value;
    }

    public String getType() {
        return type;
    }

    public double getValue() {
        return value;
    }
}
