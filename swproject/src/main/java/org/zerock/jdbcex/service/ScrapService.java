package org.zerock.jdbcex.service;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.zerock.jdbcex.dao.ScrapDAO;
import org.zerock.jdbcex.dto.ScrapDTO;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ScrapService {
    private final ScrapDAO scrapDAO = new ScrapDAO();
    private static final String API_URL = "https://apis.data.go.kr/1051000/recruitment/detail";
    private static final String SERVICE_KEY = "m4%2BOenhwqExP36CL%2F5Pb7tiHlIxAqX75ReTHzMfWzxb%2BpEYUtedtI%2BughHYGWfH%2FXXFk3sIWKu3HIhtbYDQozw%3D%3D";

    public void addScrap(String userId, String scrapKey) throws Exception {
        ScrapDTO scrap = new ScrapDTO();
        scrap.setUserId(userId);
        scrap.setScrapKey(scrapKey);

        scrapDAO.insertScrap(scrap);
    }


    public List<Map<String, String>> fetchScrapJobs(String userId) throws Exception {
        // DAO에서 스크랩된 키 가져오기
        List<String> scrapKeys = scrapDAO.getScrapKeys(userId);
        List<Map<String, String>> jobList = new ArrayList<>();
        ObjectMapper objectMapper = new ObjectMapper();

        for (String scrapKey : scrapKeys) {
            String urlString = API_URL + "?serviceKey=" + SERVICE_KEY + "&resultType=json&sn=" + scrapKey;
            HttpURLConnection conn = null;

            try {
                // API 호출
                URL url = new URL(urlString);
                conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.setConnectTimeout(10000); // 타임아웃 설정
                conn.setReadTimeout(10000);

                if (conn.getResponseCode() != HttpURLConnection.HTTP_OK) {
                    System.err.println("Failed API Call for Scrap Key: " + scrapKey);
                    continue; // API 호출 실패 시 다음 스크랩 키로 진행
                }

                // API 응답 처리
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                    JsonNode rootNode = objectMapper.readTree(br);
                    JsonNode resultNode = rootNode.path("result");

                    // 응답 데이터 파싱 및 저장
                    if (!resultNode.isMissingNode()) {
                        Map<String, String> jobData = new HashMap<>();
                        jobData.put("title", resultNode.path("instNm").asText("기관명 없음"));
                        jobData.put("duty", resultNode.path("ncsCdNmLst").asText("정보 없음"));
                        jobData.put("employmentType", resultNode.path("hireTypeNmLst").asText("정보 없음"));
                        jobData.put("region", resultNode.path("workRgnNmLst").asText("정보 없음"));
                        jobData.put("deadline", resultNode.path("pbancEndYmd").asText("정보 없음"));
                        jobData.put("url", resultNode.path("srcUrl").asText("#"));
                        jobList.add(jobData);
                    }
                }
            } catch (Exception e) {
                System.err.println("Error fetching data for Scrap Key: " + scrapKey);
                e.printStackTrace();
            } finally {
                if (conn != null) conn.disconnect(); // 연결 종료
            }
        }

        return jobList;
    }

    public void deleteScrap(String userId, String scrapKey) {
        scrapDAO.deleteScrap(userId, scrapKey);
    }
}
