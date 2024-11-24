package org.zerock.jdbcex.service;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.zerock.jdbcex.dao.ScrapDAO;
import org.zerock.jdbcex.dto.ScrapDTO;
import org.zerock.jdbcex.util.HttpClientHelper;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ScrapService {

    private final ScrapDAO scrapDAO = new ScrapDAO();

    public void addScrap(String userId, String scrapKey) throws Exception {
        ScrapDTO scrap = new ScrapDTO();
        scrap.setUserId(userId);
        scrap.setScrapKey(scrapKey);

        scrapDAO.insertScrap(scrap);
    }
    public List<String> getScrapKeys(String userId) {
        return scrapDAO.getScrapKeys(userId);
    }

    public void deleteScrap(String userId, String scrapKey) {
        scrapDAO.deleteScrap(userId, scrapKey);
    }

    public List<Map<String, String>> fetchScrapDetails(String userId) {
        List<Map<String, String>> scrapDetails = new ArrayList<>();
        String serviceKey = "m4%2BOenhwqExP36CL%2F5Pb7tiHlIxAqX75ReTHzMfWzxb%2BpEYUtedtI%2BughHYGWfH%2FXXFk3sIWKu3HIhtbYDQozw%3D%3D";
        String baseUrl = "http://apis.data.go.kr/1051000/recruitment/details?serviceKey=" + serviceKey;

        // 로그인 된 유저의 scrap_key 리스트 가져오기
        List<String> scrapKeys = scrapDAO.getScrapKeys(userId);

        // scrap_key별로 API 호출
        for (String scrapKey : scrapKeys) {
            try {
                String apiUrl = baseUrl + "&scrapKey=" + scrapKey;
                String jsonResponse = HttpClientHelper.get(apiUrl);
                Map<String, String> scrapData = new ObjectMapper().readValue(jsonResponse, Map.class);
                scrapDetails.add(scrapData);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return scrapDetails;
    }
}

