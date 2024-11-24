package org.zerock.jdbcex.util;

import org.springframework.web.client.RestTemplate;

public class HttpClientHelper {
    public static String get(String apiUrl) {
        RestTemplate restTemplate = new RestTemplate();
        return restTemplate.getForObject(apiUrl, String.class);
    }
}
