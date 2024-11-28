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


    public List<Map<String, String>> fetchScrapJobs(String userId, int page, int pageSize) throws Exception {
        List<String> scrapKeys = scrapDAO.getScrapKeys(userId);

        // 페이지네이션 처리
        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, scrapKeys.size());
        List<String> paginatedKeys = scrapKeys.subList(startIndex, endIndex);

        List<Map<String, String>> jobList = new ArrayList<>();
        ObjectMapper objectMapper = new ObjectMapper();

        for (String scrapKey : paginatedKeys) {
            String urlString = API_URL + "?serviceKey=" + SERVICE_KEY + "&resultType=json&sn=" + scrapKey;

            try {
                HttpURLConnection conn = (HttpURLConnection) new URL(urlString).openConnection();
                conn.setRequestMethod("GET");
                conn.setConnectTimeout(10000);
                conn.setReadTimeout(10000);

                if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                        JsonNode rootNode = objectMapper.readTree(br);
                        JsonNode resultNode = rootNode.path("result");

                        if (!resultNode.isMissingNode()) {
                            Map<String, String> jobData = new HashMap<>();
                            jobData.put("scrapKey", scrapKey);
                            jobData.put("title", resultNode.path("instNm").asText("기관명 없음"));
                            jobData.put("duty", resultNode.path("ncsCdNmLst").asText("정보 없음"));
                            jobData.put("employmentType", resultNode.path("hireTypeNmLst").asText("정보 없음"));
                            jobData.put("region", resultNode.path("workRgnNmLst").asText("정보 없음"));
                            jobData.put("deadline", resultNode.path("pbancEndYmd").asText("정보 없음"));
                            jobData.put("url", resultNode.path("srcUrl").asText("#"));
                            jobList.add(jobData);
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return jobList;
    }

    public int getScrapCount(String userId) throws Exception {
        return scrapDAO.getScrapCount(userId);
    }

    public List<String> getScrapedKeys(String userId) throws Exception {
        return scrapDAO.getScrapKeys(userId);
    }

    public void deleteScrap(String userId, String scrapKey) {
        scrapDAO.deleteScrap(userId, scrapKey);
    }
}
