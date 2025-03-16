package note.model;

import java.util.Set;

public class ImageNote extends Note {
    private String ImagePath;
    private String ImageFormat;
    private String Caption;
    private static final Set<String> ALLOWED_FORMATS = Set.of("png", "jpg", "jpeg", "gif");

    public ImageNote() {
        super();
    }

    public ImageNote(String label, String ImagePath, String ImageFormat, String Caption) {
        super(label);
        this.ImagePath = ImagePath;
        this.ImageFormat = ImageFormat;
        this.Caption = Caption;
    }

    // Getters and Setters
    public String getImagePath() {
        return ImagePath;
    }

    public String getImageFormat() {
        return ImageFormat;
    }

    public String getCaption() {
        return Caption;
    }


    public void setImagePath(String imagePath) {
        if (isValidPath(imagePath)){
            this.ImagePath = imagePath;
        }else {
            throw new IllegalArgumentException("Invalid image path");
        }
    }

    public void setImageFormat(String ImageFormat) {
        if (ALLOWED_FORMATS.contains(ImageFormat)){
            this.ImageFormat = ImageFormat ;
        }else {
            throw new IllegalArgumentException("Unsupported image format");
        }
    }

    public void setCaption(String caption) {
        if (caption != null && caption.length() <= 200 ){
            this.Caption = caption;
        }else {
            throw new IllegalArgumentException("Your caption is too long or invalid");
        }
    }
    private boolean isValidPath(String path) {
        return path != null && !path.trim().isEmpty();
    }
}

