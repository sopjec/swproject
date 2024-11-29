package org.zerock.jdbcex.service;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.zerock.jdbcex.dao.ScrapDAO;
import org.zerock.jdbcex.dto.ScrapDTO;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
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

    public List<Map<String, String>> fetchScrapJobs(
            String userId, int page, int pageSize, String keyword, String region, String employmentType, String jobType) throws Exception {
        List<String> scrapKeys = scrapDAO.getScrapKeys(userId);

        // 페이지네이션 처리
        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, scrapKeys.size());
        List<String> paginatedKeys = scrapKeys.subList(startIndex, endIndex);

        List<Map<String, String>> jobList = new ArrayList<>();
        ObjectMapper objectMapper = new ObjectMapper();

        for (String scrapKey : paginatedKeys) {
            // URL 생성
            StringBuilder urlStringBuilder = new StringBuilder(API_URL)
                    .append("?serviceKey=").append(SERVICE_KEY)
                    .append("&resultType=json")
                    .append("&sn=").append(scrapKey);

            System.out.println("Generated URL: " + urlStringBuilder);

            try {
                // API 호출
                HttpURLConnection conn = (HttpURLConnection) new URL(urlStringBuilder.toString()).openConnection();
                conn.setRequestMethod("GET");
                conn.setConnectTimeout(10000);
                conn.setReadTimeout(10000);

                if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                        JsonNode rootNode = objectMapper.readTree(br);
                        JsonNode resultNode = rootNode.path("result");

                        if (!resultNode.isMissingNode()) {
                            // JSON 데이터를 Java Map으로 매핑
                            Map<String, String> jobData = new HashMap<>();
                            jobData.put("scrapKey", scrapKey);
                            jobData.put("title", resultNode.path("instNm").asText("기관명 없음"));
                            jobData.put("duty", resultNode.path("ncsCdNmLst").asText("정보 없음"));
                            jobData.put("employmentType", resultNode.path("hireTypeNmLst").asText("정보 없음"));
                            jobData.put("region", resultNode.path("workRgnNmLst").asText("정보 없음"));
                            jobData.put("deadline", resultNode.path("pbancEndYmd").asText("정보 없음"));
                            jobData.put("url", resultNode.path("srcUrl").asText("#"));

                            // 필터링 로직
                            boolean matchesKeyword = keyword == null || keyword.isEmpty() || jobData.get("title").contains(keyword);
                            boolean matchesRegion = region == null || region.isEmpty() || jobData.get("region").contains(region);
                            boolean matchesEmploymentType = employmentType == null || employmentType.isEmpty() || jobData.get("employmentType").contains(employmentType);
                            boolean matchesJobType = jobType == null || jobType.isEmpty() || jobData.get("duty").contains(jobType);

                            if (matchesKeyword && matchesRegion && matchesEmploymentType && matchesJobType) {
                                jobList.add(jobData); // 필터 조건에 맞는 데이터만 추가
                            }
                        }
                    }
                } else {
                    System.err.println("API 호출 실패. HTTP Response Code: " + conn.getResponseCode());
                }
            } catch (Exception e) {
                System.err.println("Error fetching data for URL: " + urlStringBuilder.toString());
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
