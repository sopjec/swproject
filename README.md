CREATE TABLE user (
                      id VARCHAR(50) PRIMARY KEY,
                      pwd VARCHAR(50) NOT NULL,
                      name VARCHAR(100) NOT NULL,
                      gender VARCHAR(10),
                      profile_url VARCHAR(255),
                      date_of_birth DATE
);


CREATE TABLE interview (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           user_id VARCHAR(50) NOT NULL,
                           interview_date DATE NOT NULL,
                           title VARCHAR(255) NOT NULL,
                           FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE interview_qna (
                               id INT AUTO_INCREMENT PRIMARY KEY,
                               interview_id INT NOT NULL,
                               user_id VARCHAR(50) NOT NULL,
                               question VARCHAR(500) NOT NULL,
                               answer VARCHAR(500) NOT NULL,
                               FOREIGN KEY (interview_id) REFERENCES interview(id) ON DELETE CASCADE ON UPDATE CASCADE,
                               FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE review (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        user_id VARCHAR(50) NOT NULL,
                        content TEXT NOT NULL,
                        job VARCHAR(255),
                        commane VARCHAR(255),
                        experience VARCHAR(50),
                        region VARCHAR(50),
                        count_likes INT DEFAULT 0,
                        FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE likes (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       user_id VARCHAR(50) NOT NULL,
                       review_id INT NOT NULL,
                       FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE,
                       FOREIGN KEY (review_id) REFERENCES review(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE resume (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        title VARCHAR(50) NOT NULL,
                        user_id VARCHAR(50) NOT NULL,
                        FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE resume_qna (
                            id INT AUTO_INCREMENT PRIMARY KEY,
                            resume_id INT NOT NULL,
                            question TEXT NOT NULL,
                            answer TEXT NOT NULL,
                            FOREIGN KEY (resume_id) REFERENCES resume(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE scrap (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       user_id VARCHAR(50) NOT NULL,
                       scrap_key VARCHAR(255) NOT NULL,
                       FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE comments (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          review_id INT NOT NULL,
                          author VARCHAR(255) NOT NULL,
                          content TEXT NOT NULL,
                          created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                          updated_date DATETIME,
                          parent_comment_id INT,
                          FOREIGN KEY (review_id) REFERENCES review(id) ON DELETE CASCADE ON UPDATE CASCADE,
                          FOREIGN KEY (author) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE,
                          FOREIGN KEY (parent_comment_id) REFERENCES comments(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE emotions (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          interview_id INT NOT NULL,
                          emotion_type VARCHAR(50) NOT NULL,
                          emotion_value DOUBLE NOT NULL,
                          FOREIGN KEY (interview_id) REFERENCES interview(id) ON DELETE CASCADE
);


DELIMITER $$

CREATE TRIGGER after_likes_insert
    AFTER INSERT ON likes
    FOR EACH ROW
BEGIN
    UPDATE review
    SET count_likes = count_likes + 1
    WHERE id = NEW.review_id;
END$$

DELIMITER ;
DELIMITER $$
CREATE TRIGGER after_likes_delete
    AFTER DELETE ON likes
    FOR EACH ROW
BEGIN
    UPDATE review
    SET count_likes = count_likes - 1
    WHERE id = OLD.review_id;
END$$

DELIMITER ;

ALTER TABLE review ADD COLUMN created_date DATETIME DEFAULT CURRENT_TIMESTAMP;
