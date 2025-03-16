package note.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import note.repository.NoteRepository;
import note.service.NoteService;

public abstract class BaseServlet extends HttpServlet {
    protected NoteService noteService;
    protected ObjectMapper objectMapper;

    private static final ObjectMapper SHARED_OBJECT_MAPPER = new ObjectMapper();

    @Override
    public void init() throws ServletException {
        try {
            super.init();
            this.objectMapper = SHARED_OBJECT_MAPPER;
            this.noteService  = getNoteService();

        }catch (Exception e) {
            throw new ServletException("Error initializing servlet", e);
        }
    }

    protected NoteService getNoteService() {
        NoteRepository noteRepository = getNoteRepository();
        return new NoteService(noteRepository);
    }

    protected NoteRepository getNoteRepository() {
        return new NoteRepository();
    }

}
