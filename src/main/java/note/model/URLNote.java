package note.model;

public class URLNote extends Note {
    private String url;
    private String description;

    public URLNote() {
        super();
    }

    public URLNote(String label, String url, String description) {
        super(label);
        this.url = url;
        this.description = description;
    }

    // Getters and Setters
    public String getURL() {
        return url;
    }

    public String getDescription() {
        return description;
    }

    public void setURL(String url) {
        this.url = url;
    }
    public void setDescription(String description) {
        this.description = description;
    }
}

