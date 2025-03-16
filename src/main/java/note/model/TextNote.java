package note.model;

public class TextNote extends Note {
    private String content;

    public TextNote() {
        super();
    }

    public TextNote(String label, String content) {
        super(label);
        this.content = content;
    }

    // Getters and Setters
    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
