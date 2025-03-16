package note.model;

import java.util.ArrayList;
import java.util.List;

public class CombinedNote extends Note {
    private List<NoteComponents> components;

    public CombinedNote() {
        super();
        this.components = new ArrayList<NoteComponents>();
    }
    public CombinedNote(String label) {
        super(label);
        this.components = new ArrayList<NoteComponents>();
    }

    //Getter and Setter
    public List<NoteComponents> getComponents() {
        return components;
    }

    public void addComponent(NoteComponents component) {
        this.components.add(component);
    }

    public void removeComponent(int index) {
        if (index >= 0 && index < this.components.size()) {
            this.components.remove(index);
        }else{
            throw new IndexOutOfBoundsException();
        }
    }

    public enum ComponentType {Text, Image, URL }

    public static class NoteComponents {
        private final ComponentType type;
        private final Object content;

        public NoteComponents(ComponentType type, Object content) {
            checkComponent(type, content);
            this.type = type;
            this.content = content;
        }

        //may need to be optimised after
        private void checkComponent(ComponentType type, Object content) {
            switch (type) {
                case Text:
                    if (!(content instanceof TextNote)) {
                        throw new IllegalArgumentException("Note component type: " + type + " is invalid");
                    }
                    break;
                case URL:
                    if (!(content instanceof URLNote)) {
                        throw new IllegalArgumentException("Note component type: " + type + " is invalid");
                    }
                    break;
                case Image:
                    if (!(content instanceof ImageNote)) {
                        throw new IllegalArgumentException("Note component type: " + type + " is invalid");
                    }
                    break;
                    default:
                        throw new IllegalArgumentException("Unknown component type: " + type);
            }
        }

        //Getter
        public ComponentType getType() {
            return type;
        }

        public Object getContent() {
            return content;
        }
    }
}
