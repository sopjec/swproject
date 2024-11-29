@WebServlet("/resume")
public class ResumeServlet extends HttpServlet {
    private ResumeDAO resumeDAO = new ResumeDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            System.out.println("No user logged in, redirecting to login page.");
            response.sendRedirect("login.jsp");
            return;
        }

        String userId = loggedInUser.getId();
        String title = request.getParameter("title");
        String[] questions = request.getParameterValues("question");
        String[] answers = request.getParameterValues("answer");

        if (userId == null || userId.trim().isEmpty() || title == null || title.trim().isEmpty() || questions == null || answers == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid input. Please make sure all fields are filled.");
            return;
        }

        try {
            // Create a new ResumeDTO and set the title and user ID
            ResumeDTO resumeDTO = new ResumeDTO();
            resumeDTO.setTitle(title);
            resumeDTO.setUserId(userId);

            // Save the resume to the database
            resumeDAO.createResume(resumeDTO);
            int introId = resumeDTO.getId(); // Generated ID from the database

            // Save each question and answer as a separate resume entry
            for (int i = 0; i < questions.length; i++) {
                String question = questions[i];
                String answer = answers[i];

                if (question == null || question.trim().isEmpty() || answer == null || answer.trim().isEmpty()) {
                    continue;
                }

                ResumeDTO detailResume = new ResumeDTO();
                detailResume.setIntroId(introId);
                detailResume.setUserId(userId);
                detailResume.setQuestion(question);
                detailResume.setAnswer(answer);

                // Save each question-answer pair
                resumeDAO.createResume(detailResume);
            }

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Resume successfully saved.");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("An error occurred while saving the resume.");
        }
    }
}
