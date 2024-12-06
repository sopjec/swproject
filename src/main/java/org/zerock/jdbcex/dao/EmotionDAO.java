package org.zerock.jdbcex.dao;

import org.zerock.jdbcex.util.ConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class EmotionDAO {

    public static void saveEmotion(int interviewId, String emotionType, double emotionValue) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        try {
            connection = ConnectionUtil.INSTANCE.getConnection();
            if (connection == null) {
                System.err.println("Database connection is null");
                throw new SQLException("Cannot establish database connection");
            }

            String sql = "INSERT INTO emotions (interview_id, emotion_type, emotion_value) VALUES (?, ?, ?)";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, interviewId);
            preparedStatement.setString(2, emotionType);
            preparedStatement.setDouble(3, emotionValue);

            int rowsAffected = preparedStatement.executeUpdate();
            System.out.println("Emotion saved - Interview ID: " + interviewId
                    + ", Type: " + emotionType
                    + ", Value: " + emotionValue
                    + ", Rows affected: " + rowsAffected);
        } catch (SQLException e) {
            System.err.println("Detailed error saving emotion: " + e.getMessage());
            e.printStackTrace();
            throw e;
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
