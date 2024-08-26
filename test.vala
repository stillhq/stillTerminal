using Pango;

void main () {
    // Array of font names to test, including valid and bogus fonts
    string[] font_names = {
        "Arial 12",
        "Nonexistent Font 14",
        "Times New Roman Bold 16",
        "CompletelyBogus!@#$%^&*() 10",
        "Sans 11",
        ""  // Empty string
    };

    foreach (string font_name in font_names) {
        print("Testing font: '%s'\n", font_name);

        // Create font description
        var font_desc = FontDescription.from_string(font_name);

        // Print information about the resulting font description
        print("  Family: %s\n", font_desc.get_family());
        print("  Style: %s\n", font_desc.get_style().to_string());
        print("  Weight: %s\n", font_desc.get_weight().to_string());
        print("  Size: %d\n", font_desc.get_size() / Pango.SCALE);

        if (!(is_font_available(font_desc))) {
            print("  Font is loadable\n");
        } else {
            print("  Font is not loadable\n");
        }

        print("\n");
    }
}

public bool is_font_available(Pango.FontDescription font_description) {
    // Create a Pango context
    var font_map = new Pango.FontMap();
    var pango_context = font_map.create_context();

    // Create a font from the description
    var font = pango_context.load_font(font_description);

    // Check if the font is actually available
    if (font == null) {
        return false;
    }

    return true;
}