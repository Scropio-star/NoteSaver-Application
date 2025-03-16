package note.service;

import note.model.*;
import note.repository.NoteRepository;

import java.util.List;

public class NoteService {
    private final NoteRepository repository;

    public NoteService(NoteRepository repository) {
        this.repository = repository;
    }

    public void saveTextNote(String label, String content) {
        TextNote note = new TextNote(label, content);
        repository.saveNote(note);
    }

    public void saveURLNote(String label, String url, String description) {
        URLNote note = new URLNote(label, url, description);
        repository.saveNote(note);
    }

    public void saveImageNote(String label, String ImagePath, String ImageFormat, String Caption) {
        ImageNote note = new ImageNote(label, ImagePath, ImageFormat, Caption);
        repository.saveNote(note);
    }

    public void saveCombinedNote(String label, List<CombinedNote.NoteComponents> components) {
        CombinedNote note = new CombinedNote(label);
        for (CombinedNote.NoteComponents component : components) {
            note.addComponent(component);
        }
        repository.saveNote(note);
    }

    public Note getNoteById(String id) {
        return repository.getNoteById(id);
        }

    public List<Note> getAllNotes() {
        return repository.getAllNotes();
    }

    public void deleteNoteById(String id) {
        repository.deleteNote(id);
    }

    public void updateNote(Note note) {
        repository.saveNote(note);
    }

    }


