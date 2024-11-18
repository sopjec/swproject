<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 24. 11. 15.
  Time: 오전 1:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 세션 무효화
    session.invalidate();
    // 메인 페이지로 이동
    response.sendRedirect("index.jsp");
%>
