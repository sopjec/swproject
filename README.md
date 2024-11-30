CREATE TABLE user (
    id VARCHAR(50) PRIMARY KEY,
    pwd VARCHAR(50),
    name VARCHAR(100),
    gender VARCHAR(10),
    profile_url VARCHAR(255),
    date_of_birth DATE
);

CREATE TABLE interview (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(50),
    path VARCHAR(255),
    feedback VARCHAR(500),
    interview_date DATE,
    FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE interview_qna (
    id INT AUTO_INCREMENT PRIMARY KEY,
    interview_id INT,
    user_id VARCHAR(50),
    question VARCHAR(500),
    answer VARCHAR(500),
    FOREIGN KEY (interview_id) REFERENCES interview(id),
    FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE interview_review (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(50),
    title VARCHAR(50),
    content VARCHAR(255),
    job VARCHAR(255),
    industry VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE resume (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(50),
    user_id VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE resume_qna (
    id INT AUTO_INCREMENT PRIMARY KEY,
    resume_id INT,
    question TEXT,
    answer TEXT,
    FOREIGN KEY (resume_id) REFERENCES resume(id)
);

CREATE TABLE review_reply (
    id INT AUTO_INCREMENT PRIMARY KEY,
    review_id INT,
    interview_id INT,
    user_id VARCHAR(50),
    content VARCHAR(255),
    FOREIGN KEY (review_id) REFERENCES interview_review(id),
    FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE scrap (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(50),
    scrap_key VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
);
