package org.zerock.jdbcex.service;
import org.zerock.jdbcex.dao.ScrapDAO;
import org.zerock.jdbcex.dto.ScrapDTO;

import java.sql.Connection;

public class ScrapService {

    private final ScrapDAO scrapDAO = new ScrapDAO();

    public void addScrap(String userId, String scrapKey) throws Exception {
        ScrapDTO scrap = new ScrapDTO();
        scrap.setUserId(userId);
        scrap.setScrapKey(scrapKey);

        scrapDAO.insertScrap(scrap);
    }
}
