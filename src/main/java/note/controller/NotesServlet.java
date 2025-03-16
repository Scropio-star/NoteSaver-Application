package note.controller;

import com.fasterxml.jackson.databind.JsonNode;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import note.model.Note;
import note.model.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class NotesServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String pathInfo = req.getPathInfo();
            System.out.println("GET request received with pathInfo: " + pathInfo);

             
            if (pathInfo != null && !pathInfo.equals("/")) {
                String id = extractPathInfo(pathInfo);
                Note note = noteService.getNoteById(id);

                if (note == null) {
                    sendJsonError(resp, HttpServletResponse.SC_NOT_FOUND, "Note not found");
                    return;
                }

                 
                sendJsonResponse(resp, getSingleNoteJson(note));
            } else {
                 
                List<Note> notes = noteService.getAllNotes();
                System.out.println("Returning " + notes.size() + " notes");

                 
                sendJsonResponse(resp, getNotesJson(notes));
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error: " + e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
         
        String id = extractPathInfo(req.getPathInfo());
        Note note = noteService.getNoteById(id);

        if (note == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Note not found");
            return;
        }

         
        JsonNode jsonNode = objectMapper.readTree(req.getInputStream());

         
        if (jsonNode.has("label")) {
            note.setLabel(jsonNode.get("label").asText());
        }

         
        if (note instanceof TextNote) {
             
        } else if (note instanceof URLNote) {
             
        } else if (note instanceof ImageNote) {
             
        }

         
        noteService.updateNote(note);

         
        resp.setStatus(HttpServletResponse.SC_OK);
    }

     
    private void sendJsonResponse(HttpServletResponse resp, String jsonContent) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(jsonContent);
    }

     
    private void sendJsonError(HttpServletResponse resp, int statusCode, String errorMessage) throws IOException {
        resp.setStatus(statusCode);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write("{\"error\":\"" + escapeJson(errorMessage) + "\"}");
    }

     
    private String getNotesJson(List<Note> notes) {
        StringBuilder json = new StringBuilder();
        json.append("[");

        for (int i = 0; i < notes.size(); i++) {
            json.append(getSingleNoteJson(notes.get(i)));
            if (i < notes.size() - 1) {
                json.append(",");
            }
        }

        json.append("]");
        return json.toString();
    }

     
    private String getSingleNoteJson(Note note) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"id\":\"").append(escapeJson(note.getId())).append("\",");
        json.append("\"label\":\"").append(escapeJson(note.getLabel())).append("\",");

         
        json.append("\"creationTime\":\"").append(note.getCreationTime().toString()).append("\",");
        json.append("\"lastModificationTime\":\"").append(note.getLastModificationTime().toString()).append("\"");

         
        if (note instanceof TextNote) {
            TextNote textNote = (TextNote) note;
            json.append(",\"noteType\":\"Text\"");
            json.append(",\"content\":\"").append(escapeJson(textNote.getContent())).append("\"");
        } else if (note instanceof URLNote) {
            URLNote urlNote = (URLNote) note;
            json.append(",\"noteType\":\"URL\"");
            json.append(",\"url\":\"").append(escapeJson(urlNote.getURL())).append("\"");
            json.append(",\"description\":\"").append(escapeJson(urlNote.getDescription())).append("\"");
        } else if (note instanceof ImageNote) {
            ImageNote imageNote = (ImageNote) note;
            json.append(",\"noteType\":\"Image\"");
            json.append(",\"imagePath\":\"").append(escapeJson(imageNote.getImagePath())).append("\"");
            json.append(",\"imageFormat\":\"").append(escapeJson(imageNote.getImageFormat())).append("\"");
            json.append(",\"caption\":\"").append(escapeJson(imageNote.getCaption())).append("\"");
        }  
        else if (note instanceof CombinedNote) {
            CombinedNote combinedNote = (CombinedNote) note;
            json.append(",\"noteType\":\"Combined\"");

             
            json.append(",\"components\":[");
            List<CombinedNote.NoteComponents> components = combinedNote.getComponents();

            for (int i = 0; i < components.size(); i++) {
                CombinedNote.NoteComponents component = components.get(i);
                json.append("{");
                json.append("\"type\":\"").append(component.getType().toString()).append("\"");

                 
                if (component.getType() == CombinedNote.ComponentType.Text) {
                    TextNote textNote = (TextNote) component.getContent();
                    json.append(",\"content\":\"").append(escapeJson(textNote.getContent())).append("\"");
                } else if (component.getType() == CombinedNote.ComponentType.URL) {
                    URLNote urlNote = (URLNote) component.getContent();
                    json.append(",\"url\":\"").append(escapeJson(urlNote.getURL())).append("\"");
                    json.append(",\"description\":\"").append(escapeJson(urlNote.getDescription())).append("\"");
                } else if (component.getType() == CombinedNote.ComponentType.Image) {
                    ImageNote imageNote = (ImageNote) component.getContent();
                    json.append(",\"imagePath\":\"").append(escapeJson(imageNote.getImagePath())).append("\"");
                    json.append(",\"imageFormat\":\"").append(escapeJson(imageNote.getImageFormat())).append("\"");
                    json.append(",\"caption\":\"").append(escapeJson(imageNote.getCaption())).append("\"");
                }

                json.append("}");
                if (i < components.size() - 1) {
                    json.append(",");
                }
            }

            json.append("]");
        }

        json.append("}");
        return json.toString();
    }

     
    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            JsonNode jsonNode = objectMapper.readTree(req.getInputStream());

             
            System.out.println("Received POST request with body: " + jsonNode.toString());

            if (!jsonNode.has("type") || !jsonNode.has("label")) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required fields");
                return;
            }

            String type = jsonNode.get("type").asText();
            String label = jsonNode.get("label").asText().trim();

            switch (type.toUpperCase()) {
                case "TEXT":
                    if (!jsonNode.has("content")) {
                        resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing 'content' field for text note");
                        return;
                    }
                    String content = jsonNode.get("content").asText().trim();
                    noteService.saveTextNote(label, content);
                    break;

                case "URL":
                    if (!jsonNode.has("url")) {
                        resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing 'url' field for URL note");
                        return;
                    }
                    String url = jsonNode.get("url").asText().trim();
                    String description = jsonNode.has("description") ? jsonNode.get("description").asText().trim() : "";
                    noteService.saveURLNote(label, url, description);
                    break;

                case "IMAGE":
                    if (!jsonNode.has("imageData") || !jsonNode.has("imageFormat")) {
                        resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing image data or format for Image note");
                        return;
                    }
                    String imagePath = jsonNode.has("imageData") ? jsonNode.get("imageData").asText() : "";
                    String imageFormat = jsonNode.get("imageFormat").asText().trim();
                    String caption = jsonNode.has("caption") ? jsonNode.get("caption").asText().trim() : "";
                    noteService.saveImageNote(label, imagePath, imageFormat, caption);
                    break;
                case "COMBINED":
                    if (!jsonNode.has("components")) {
                        resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing 'components' field for combined note");
                        return;
                    }

                    List<CombinedNote.NoteComponents> components = new ArrayList<>();

                     
                    JsonNode componentsNode = jsonNode.get("components");
                    for (JsonNode componentNode : componentsNode) {
                        String componentType = componentNode.get("type").asText().toUpperCase();

                        switch (componentType) {
                            case "TEXT":
                                String textContent = componentNode.get("content").asText();
                                TextNote textComponent = new TextNote("", textContent);
                                components.add(new CombinedNote.NoteComponents(
                                        CombinedNote.ComponentType.Text, textComponent));
                                break;

                            case "URL":
                                String urlValue = componentNode.get("url").asText();
                                String urlDescription = componentNode.has("description") ?
                                        componentNode.get("description").asText() : "";
                                URLNote urlComponent = new URLNote("", urlValue, urlDescription);
                                components.add(new CombinedNote.NoteComponents(
                                        CombinedNote.ComponentType.URL, urlComponent));
                                break;

                            case "IMAGE":
                                String ImagePath = componentNode.get("imageData").asText();
                                String ImageFormat = componentNode.get("imageFormat").asText();
                                String imageCaption = componentNode.has("caption") ?
                                        componentNode.get("caption").asText() : "";
                                ImageNote imageComponent = new ImageNote("", ImagePath, ImageFormat, imageCaption);
                                components.add(new CombinedNote.NoteComponents(
                                        CombinedNote.ComponentType.Image, imageComponent));
                                break;

                            default:
                                resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                                        "Unsupported component type: " + componentType);
                                return;
                        }
                    }

                    noteService.saveCombinedNote(label, components);
                    break;

                default:
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unsupported note type: " + type);
                    return;
            }

             
            resp.setContentType("application/json");
            resp.setStatus(HttpServletResponse.SC_CREATED);
             
            resp.getWriter().write("{\"status\":\"success\",\"message\":\"Note created successfully\"}");

        } catch (Exception e) {
             
            e.printStackTrace();

             
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.setContentType("text/plain");
            resp.getWriter().write("Server error: " + e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String pathInfo = req.getPathInfo();
            System.out.println("DELETE request received with pathInfo: " + pathInfo);

            if (pathInfo == null || pathInfo.equals("/")) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing note ID");
                return;
            }

            String id = extractPathInfo(pathInfo);
            Note note = noteService.getNoteById(id);

            if (note == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Note not found");
                return;
            }

            noteService.deleteNoteById(id);

             
            resp.setContentType("application/json");
            resp.setStatus(HttpServletResponse.SC_OK);  
             
            resp.getWriter().write("{\"status\":\"success\",\"message\":\"Note deleted successfully\"}");

        } catch (Exception e) {
             
            e.printStackTrace();

             
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.setContentType("text/plain");
            resp.getWriter().write("Server error: " + e.getMessage());
        }
    }

    private String extractPathInfo(String pathInfo) {
        if (pathInfo == null || pathInfo.equals("/")) {
            return null;
        }
        String[] parts = pathInfo.split("/");
        for (String part : parts) {
            if (!part.isEmpty()) {
                return part;
            }
        }
        return null;
    }
}