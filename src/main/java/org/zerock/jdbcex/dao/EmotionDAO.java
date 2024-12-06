package org.zerock.jdbcex.dao;

import org.zerock.jdbcex.util.ConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class EmotionDAO {

    public static void saveEmotion(int interviewId, String emotionType, double emotionValue, long timestamp) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        try {
            connection = ConnectionUtil.INSTANCE.getConnection();

            String sql = "INSERT INTO emotions (interview_id, emotion_type, emotion_value, timestamp) VALUES (?, ?, ?, ?)";
            preparedStatement = connection.prepareStatement(sql);

            preparedStatement.setInt(1, interviewId);
            preparedStatement.setString(2, emotionType);
            preparedStatement.setDouble(3, emotionValue);
            preparedStatement.setLong(4, timestamp);

            preparedStatement.executeUpdate();
        } finally {
            if (preparedStatement != null) {
                preparedStatement.close();
            }
            if (connection != null) {
                connection.close();
            }
        }
    }
}
