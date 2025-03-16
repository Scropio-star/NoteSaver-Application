package note.model;

import java.time.LocalDateTime;
import java.util.UUID;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonFormat;

@JsonTypeInfo(
        use = JsonTypeInfo.Id.NAME,
        include = JsonTypeInfo.As.PROPERTY,
        property = "noteType"
)
@JsonSubTypes({
        @JsonSubTypes.Type(value = TextNote.class, name = "Text"),
        @JsonSubTypes.Type(value = URLNote.class, name = "URL"),
        @JsonSubTypes.Type(value = ImageNote.class, name = "Image"),
        @JsonSubTypes.Type(value = CombinedNote.class, name = "Combination")
})
@JsonIgnoreProperties(ignoreUnknown = true)
public abstract class Note {
    private String id;
    private String label;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime creationTime;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime lastModificationTime;

    public Note() {
        this.id = UUID.randomUUID().toString();
        this.creationTime = LocalDateTime.now();
        this.lastModificationTime = LocalDateTime.now();
    }

    public Note(String label) {
        this();
        this.label = label;
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public String getLabel() {
        return label;
    }

    public LocalDateTime getCreationTime() {
        return creationTime;
    }

    public LocalDateTime getLastModificationTime() {
        return lastModificationTime;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    protected void updateLastModificationTime() {
        this.lastModificationTime = LocalDateTime.now();
    }
}