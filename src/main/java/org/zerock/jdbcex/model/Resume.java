package org.zerock.jdbcex.model;

public class Resume {
    private int introId;
    private String userId;
    private String question;
    private String answer;

    // Getters and setters
    public int getIntroId() {
        return introId;
    }

    public void setIntroId(int introId) {
        this.introId = introId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }
}