package org.zerock.jdbcex.util;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class HttpClientHelper {

    public static String get(String apiUrl) throws Exception {
        StringBuilder result = new StringBuilder();
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("GET");
        conn.setConnectTimeout(5000); // 연결 타임아웃 5초
        conn.setReadTimeout(5000); // 읽기 타임아웃 5초

        int responseCode = conn.getResponseCode();

        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            String line;
            while ((line = reader.readLine()) != null) {
                result.append(line);
            }
            reader.close();
        } else {
            throw new Exception("HTTP GET 요청 실패. 응답 코드: " + responseCode);
        }

        conn.disconnect();
        return result.toString();
    }
}
