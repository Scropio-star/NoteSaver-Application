package note.controller;

import com.fasterxml.jackson.databind.JsonNode;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class ImageNoteServlet extends BaseServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        JsonNode jsonNode = objectMapper.readTree(req.getInputStream());

        if (!jsonNode.has("label")) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing 'label' field");
            return;
        }

        String label = jsonNode.get("label").asText().trim();
        String ImagePath = jsonNode.get("ImagePath").asText().trim();
        String ImageFormat = jsonNode.get("ImageFormat").asText().trim();
        String Caption = jsonNode.get("Caption").asText().trim();

        noteService.saveImageNote(label, ImagePath, ImageFormat, Caption);

        resp.setStatus(HttpServletResponse.SC_CREATED);
    }

}
