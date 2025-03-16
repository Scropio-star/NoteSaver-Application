package note.controller;

import com.fasterxml.jackson.databind.JsonNode;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class UrlServlet extends BaseServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        JsonNode jsonNode = objectMapper.readTree(req.getInputStream());

        if (!jsonNode.has("label")) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing 'label' field");
            return;
        }

        String label = jsonNode.get("label").asText().trim();
        String url = jsonNode.get("url").asText().trim();
        String description = jsonNode.get("description").asText().trim();

        noteService.saveURLNote(label, url, description );

        resp.setStatus(HttpServletResponse.SC_CREATED);
    }

}
