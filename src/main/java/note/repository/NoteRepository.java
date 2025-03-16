package note.repository;

import note.model.*;
import java.io.*;
import java.nio.file.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.*;

public class NoteRepository {
    private Map<String, Note> notes = new ConcurrentHashMap<>();
    private final String DATA_FILE = "notes.csv";
    private final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public NoteRepository() {
        loadNotes();
    }

    public void saveNote(Note note) {
        System.out.println("Saving note: " + note.getId() + ", label: " + note.getLabel());
        notes.put(note.getId(), note);
        scheduleSave();
    }

    private void scheduleSave() {
        System.out.println("Scheduling save operation");
        scheduler.schedule(this::saveToFile, 2, TimeUnit.SECONDS);
    }

    private void saveToFile() {
        File file = new File(DATA_FILE);
        System.out.println("Saving to file: " + file.getAbsolutePath());

        try (PrintWriter writer = new PrintWriter(new FileWriter(file))) {
              
            writer.println("noteType,id,label,creationTime,lastModificationTime,content,url,description,ImagePath,ImageFormat,Caption,componentsCount");

              
            for (Note note : notes.values()) {
                StringBuilder line = new StringBuilder();

                  
                if (note instanceof TextNote) {
                    line.append("Text,");
                } else if (note instanceof URLNote) {
                    line.append("URL,");
                } else if (note instanceof ImageNote) {
                    line.append("Image,");
                } else if (note instanceof CombinedNote) {
                    line.append("Combined,");
                } else {
                    continue;   
                }

                line.append(escapeCSV(note.getId())).append(",");
                line.append(escapeCSV(note.getLabel())).append(",");
                line.append(escapeCSV(note.getCreationTime().format(DATE_FORMAT))).append(",");
                line.append(escapeCSV(note.getLastModificationTime().format(DATE_FORMAT))).append(",");

                  
                if (note instanceof TextNote) {
                    TextNote textNote = (TextNote) note;
                    line.append(escapeCSV(textNote.getContent())).append(",,,,,");
                } else if (note instanceof URLNote) {
                    URLNote urlNote = (URLNote) note;
                    line.append(",").append(escapeCSV(urlNote.getURL())).append(",")
                            .append(escapeCSV(urlNote.getDescription())).append(",,,");
                } else if (note instanceof ImageNote) {
                    ImageNote imageNote = (ImageNote) note;
                    line.append(",,," + escapeCSV(imageNote.getImagePath())).append(",")
                            .append(escapeCSV(imageNote.getImageFormat())).append(",")
                            .append(escapeCSV(imageNote.getCaption()));
                } else if (note instanceof CombinedNote) {
                    CombinedNote combinedNote = (CombinedNote) note;
                      
                    line.append(",,,,,").append(combinedNote.getComponents().size());

                      
                    writer.println(line.toString());

                      
                    int componentIndex = 0;
                    for (CombinedNote.NoteComponents component : combinedNote.getComponents()) {
                        StringBuilder componentLine = new StringBuilder();
                        componentLine.append("Component,");
                        componentLine.append(escapeCSV(note.getId() + "_" + componentIndex)).append(",");
                        componentLine.append(escapeCSV(note.getId())).append(",");   
                        componentLine.append(componentIndex).append(",");   

                          
                        componentLine.append(component.getType().toString()).append(",");

                          
                        if (component.getType() == CombinedNote.ComponentType.Text) {
                            TextNote textComponent = (TextNote) component.getContent();
                            componentLine.append(escapeCSV(textComponent.getContent())).append(",,,,,");
                        } else if (component.getType() == CombinedNote.ComponentType.URL) {
                            URLNote urlComponent = (URLNote) component.getContent();
                            componentLine.append(",").append(escapeCSV(urlComponent.getURL())).append(",")
                                    .append(escapeCSV(urlComponent.getDescription())).append(",,,");
                        } else if (component.getType() == CombinedNote.ComponentType.Image) {
                            ImageNote imageComponent = (ImageNote) component.getContent();
                            componentLine.append(",,," + escapeCSV(imageComponent.getImagePath())).append(",")
                                    .append(escapeCSV(imageComponent.getImageFormat())).append(",")
                                    .append(escapeCSV(imageComponent.getCaption()));
                        }

                        writer.println(componentLine.toString());
                        componentIndex++;
                    }
                    
                    continue;
                }

                writer.println(line.toString());
            }

            System.out.println("Successfully saved " + notes.size() + " notes");
        } catch (Exception e) {
            System.err.println("Error saving notes: " + e.getMessage());
            e.printStackTrace();
        }
    }
    private String escapeCSV(String value) {
        if (value == null) return "";
          
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }

    private void loadNotes() {
        File file = new File(DATA_FILE);
        if (!file.exists()) {
            System.out.println("Notes file does not exist: " + file.getAbsolutePath());
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            boolean isHeader = true;
            Map<String, CombinedNote> combinedNotesMap = new HashMap<>();   

            while ((line = reader.readLine()) != null) {
                if (isHeader) {
                    isHeader = false;
                    continue;   
                }

                try {
                    List<String> fields = parseCSVFields(line);
                    if (fields.isEmpty()) continue;

                    String type = fields.get(0);

                    if ("Component".equals(type)) {
                          
                        String componentId = fields.get(1);
                        String parentId = fields.get(2);
                        int componentIndex = Integer.parseInt(fields.get(3));
                        String componentType = fields.get(4);

                        CombinedNote parentNote = combinedNotesMap.get(parentId);
                        if (parentNote == null) continue;   

                          
                        CombinedNote.NoteComponents component = null;
                        switch (componentType) {
                            case "Text":
                                String content = fields.size() > 5 ? fields.get(5) : "";
                                TextNote textComponent = new TextNote("", content);
                                component = new CombinedNote.NoteComponents(
                                        CombinedNote.ComponentType.Text, textComponent);
                                break;

                            case "URL":
                                String url = fields.size() > 6 ? fields.get(6) : "";
                                String description = fields.size() > 7 ? fields.get(7) : "";
                                URLNote urlComponent = new URLNote("", url, description);
                                component = new CombinedNote.NoteComponents(
                                        CombinedNote.ComponentType.URL, urlComponent);
                                break;

                            case "Image":
                                String imagePath = fields.size() > 8 ? fields.get(8) : "";
                                String imageFormat = fields.size() > 9 ? fields.get(9) : "";
                                String caption = fields.size() > 10 ? fields.get(10) : "";
                                ImageNote imageComponent = new ImageNote("", imagePath, imageFormat, caption);
                                component = new CombinedNote.NoteComponents(
                                        CombinedNote.ComponentType.Image, imageComponent);
                                break;
                        }

                        if (component != null) {
                            parentNote.addComponent(component);
                        }

                    } else {
                          
                        Note note = parseCSVLine(line);
                        if (note != null) {
                            notes.put(note.getId(), note);

                              
                            if (note instanceof CombinedNote) {
                                combinedNotesMap.put(note.getId(), (CombinedNote) note);
                            }
                        }
                    }
                } catch (Exception e) {
                    System.err.println("Error parsing line: " + line);
                    e.printStackTrace();
                }
            }

            System.out.println("Loaded " + notes.size() + " notes");
        } catch (IOException e) {
            System.err.println("Error loading notes: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private Note parseCSVLine(String line) {
        List<String> fields = parseCSVFields(line);
        if (fields.size() < 5) return null;

        String type = fields.get(0);
        String id = fields.get(1);
        String label = fields.get(2);
        LocalDateTime creationTime = LocalDateTime.parse(fields.get(3), DATE_FORMAT);
        LocalDateTime lastModTime = LocalDateTime.parse(fields.get(4), DATE_FORMAT);

        Note note;

        switch (type) {
            case "Text":
                String content = fields.size() > 5 ? fields.get(5) : "";
                note = new TextNote(label, content);
                break;
            case "URL":
                String url = fields.size() > 6 ? fields.get(6) : "";
                String description = fields.size() > 7 ? fields.get(7) : "";
                note = new URLNote(label, url, description);
                break;
            case "Image":
                String imagePath = fields.size() > 8 ? fields.get(8) : "";
                String imageFormat = fields.size() > 9 ? fields.get(9) : "";
                String caption = fields.size() > 10 ? fields.get(10) : "";
                note = new ImageNote(label, imagePath, imageFormat, caption);
                break;
            case "Combined":
                note = new CombinedNote(label);
                break;
            default:
                return null;
        }

          
        note.setId(id);

        return note;
    }

    private List<String> parseCSVFields(String line) {
        List<String> fields = new ArrayList<>();
        StringBuilder field = new StringBuilder();
        boolean inQuotes = false;

        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);

            if (c == '\"') {
                if (inQuotes && i + 1 < line.length() && line.charAt(i + 1) == '\"') {
                      
                    field.append('\"');
                    i++;   
                } else {
                      
                    inQuotes = !inQuotes;
                }
            } else if (c == ',' && !inQuotes) {
                  
                fields.add(field.toString());
                field.setLength(0);
            } else {
                field.append(c);
            }
        }

          
        fields.add(field.toString());

        return fields;
    }

    public Note getNoteById(String id) {
        return notes.get(id);
    }

    public List<Note> getAllNotes() {
        return new ArrayList<>(notes.values());
    }

    public void deleteNote(String id) {
        notes.remove(id);
        scheduleSave();
    }

    public void shutdown() {
        try {
            saveToFile();   
            scheduler.shutdown();
            System.out.println("Note repository shut down");
        } catch (Exception e) {
            System.err.println("Error during shutdown: " + e.getMessage());
            e.printStackTrace();
        }
    }
}