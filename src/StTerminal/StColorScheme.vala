namespace StillTerminal {
    public class StColorScheme {
        public string id;
        public string name;

        // Light version colors
        public string light_foreground_color;
        public string light_background_color;
        public string light_bold_color;
        public string light_cursor_color;
        public string light_highlight_color;
        public string light_black;
        public string light_red;
        public string light_green;
        public string light_yellow;
        public string light_blue;
        public string light_magenta;
        public string light_cyan;
        public string light_white;
        public string light_bright_black;
        public string light_bright_red;
        public string light_bright_green;
        public string light_bright_yellow;
        public string light_bright_blue;
        public string light_bright_magenta;
        public string light_bright_cyan;
        public string light_bright_white;

        // Dark version colors
        public string dark_foreground_color;
        public string dark_background_color;
        public string dark_bold_color;
        public string dark_cursor_color;
        public string dark_highlight_color;
        public string dark_black;
        public string dark_red;
        public string dark_green;
        public string dark_yellow;
        public string dark_blue;
        public string dark_magenta;
        public string dark_cyan;
        public string dark_white;
        public string dark_bright_black;
        public string dark_bright_red;
        public string dark_bright_green;
        public string dark_bright_yellow;
        public string dark_bright_blue;
        public string dark_bright_magenta;
        public string dark_bright_cyan;
        public string dark_bright_white;

        public StColorScheme (string id) {
            this.id = id;
            this.light_foreground_color = "";
            this.light_background_color = "";
            this.light_bold_color = "";
            this.light_cursor_color = "";
            this.light_highlight_color = "";
            this.light_black = "";
            this.light_red = "";
            this.light_green = "";
            this.light_yellow = "";
            this.light_blue = "";
            this.light_magenta = "";
            this.light_cyan = "";
            this.light_white = "";
            this.light_bright_black = "";
            this.light_bright_red = "";
            this.light_bright_green = "";
            this.light_bright_yellow = "";
            this.light_bright_blue = "";
            this.light_bright_magenta = "";
            this.light_bright_cyan = "";
            this.light_bright_white = "";

            this.dark_foreground_color = "";
            this.dark_background_color = "";
            this.dark_bold_color = "";
            this.dark_cursor_color = "";
            this.dark_highlight_color = "";
            this.dark_black = "";
            this.dark_red = "";
            this.dark_green = "";
            this.dark_yellow = "";
            this.dark_blue = "";
            this.dark_magenta = "";
            this.dark_cyan = "";
            this.dark_white = "";
            this.dark_bright_black = "";
            this.dark_bright_red = "";
            this.dark_bright_green = "";
            this.dark_bright_yellow = "";
            this.dark_bright_blue = "";
            this.dark_bright_magenta = "";
            this.dark_bright_cyan = "";
            this.dark_bright_white = "";
        }

        public static StColorScheme new_from_colors (
            string id, string name,
            string light_foreground_color, string light_background_color, string light_bold_color,
            string light_cursor_color, string light_highlight_color,
            string light_black, string light_red, string light_green, string light_yellow,
            string light_blue, string light_magenta, string light_cyan, string light_white,
            string light_bright_black, string light_bright_red, string light_bright_green, string light_bright_yellow,
            string light_bright_blue, string light_bright_magenta, string light_bright_cyan, string light_bright_white,
            string dark_foreground_color, string dark_background_color, string dark_bold_color,
            string dark_cursor_color, string dark_highlight_color,
            string dark_black, string dark_red, string dark_green, string dark_yellow,
            string dark_blue, string dark_magenta, string dark_cyan, string dark_white,
            string dark_bright_black, string dark_bright_red, string dark_bright_green, string dark_bright_yellow,
            string dark_bright_blue, string dark_bright_magenta, string dark_bright_cyan, string dark_bright_white
        ) {
            var scheme = new StColorScheme (id);
            scheme.name = name;

            // Light colors
            scheme.light_foreground_color = light_foreground_color;
            scheme.light_background_color = light_background_color;
            scheme.light_bold_color = light_bold_color;
            scheme.light_cursor_color = light_cursor_color;
            scheme.light_highlight_color = light_highlight_color;
            scheme.light_black = light_black;
            scheme.light_red = light_red;
            scheme.light_green = light_green;
            scheme.light_yellow = light_yellow;
            scheme.light_blue = light_blue;
            scheme.light_magenta = light_magenta;
            scheme.light_cyan = light_cyan;
            scheme.light_white = light_white;
            scheme.light_bright_black = light_bright_black;
            scheme.light_bright_red = light_bright_red;
            scheme.light_bright_green = light_bright_green;
            scheme.light_bright_yellow = light_bright_yellow;
            scheme.light_bright_blue = light_bright_blue;
            scheme.light_bright_magenta = light_bright_magenta;
            scheme.light_bright_cyan = light_bright_cyan;
            scheme.light_bright_white = light_bright_white;

            // Dark colors
            scheme.dark_foreground_color = dark_foreground_color;
            scheme.dark_background_color = dark_background_color;
            scheme.dark_bold_color = dark_bold_color;
            scheme.dark_cursor_color = dark_cursor_color;
            scheme.dark_highlight_color = dark_highlight_color;
            scheme.dark_black = dark_black;
            scheme.dark_red = dark_red;
            scheme.dark_green = dark_green;
            scheme.dark_yellow = dark_yellow;
            scheme.dark_blue = dark_blue;
            scheme.dark_magenta = dark_magenta;
            scheme.dark_cyan = dark_cyan;
            scheme.dark_white = dark_white;
            scheme.dark_bright_black = dark_bright_black;
            scheme.dark_bright_red = dark_bright_red;
            scheme.dark_bright_green = dark_bright_green;
            scheme.dark_bright_yellow = dark_bright_yellow;
            scheme.dark_bright_blue = dark_bright_blue;
            scheme.dark_bright_magenta = dark_bright_magenta;
            scheme.dark_bright_cyan = dark_bright_cyan;
            scheme.dark_bright_white = dark_bright_white;

            return scheme;
        }

        public static StColorScheme new_from_array (
            string id, string name,
            string light_foreground_color,
            string light_background_color,
            string light_bold_color,
            string light_highlight_color,
            string[] light_palette,
            string dark_foreground_color,
            string dark_background_color, 
            string dark_bold_color,
            string dark_highlight_color,
            string[] dark_palette
        ) {
            var scheme = new StColorScheme (id);
            scheme.name = name;

            // Light colors
            scheme.light_foreground_color = light_foreground_color;
            scheme.light_background_color = light_background_color;
            scheme.light_bold_color = light_bold_color;
            scheme.light_cursor_color = light_palette[0];
            scheme.light_highlight_color = light_highlight_color;
            scheme.light_black = light_palette[1];
            scheme.light_red = light_palette[2];
            scheme.light_green = light_palette[3];
            scheme.light_yellow = light_palette[4];
            scheme.light_blue = light_palette[5];
            scheme.light_magenta = light_palette[6];
            scheme.light_cyan = light_palette[7];
            scheme.light_white = light_palette[8];
            scheme.light_bright_black = light_palette[9];
            scheme.light_bright_red = light_palette[10];
            scheme.light_bright_green = light_palette[11];
            scheme.light_bright_yellow = light_palette[12];
            scheme.light_bright_blue = light_palette[13];
            scheme.light_bright_magenta = light_palette[14];
            scheme.light_bright_cyan = light_palette[15];
            scheme.light_bright_white = light_palette[16];

            // Dark colors
            scheme.dark_foreground_color = dark_foreground_color;
            scheme.dark_background_color = dark_background_color;
            scheme.dark_bold_color = dark_bold_color;
            scheme.dark_cursor_color = dark_palette[0];
            scheme.dark_highlight_color = dark_highlight_color;
            scheme.dark_black = dark_palette[1];
            scheme.dark_red = dark_palette[2];
            scheme.dark_green = dark_palette[3];
            scheme.dark_yellow = dark_palette[4];
            scheme.dark_blue = dark_palette[5];
            scheme.dark_magenta = dark_palette[6];
            scheme.dark_cyan = dark_palette[7];
            scheme.dark_white = dark_palette[8];
            scheme.dark_bright_black = dark_palette[9];
            scheme.dark_bright_red = dark_palette[10];
            scheme.dark_bright_green = dark_palette[11];
            scheme.dark_bright_yellow = dark_palette[12];
            scheme.dark_bright_blue = dark_palette[13];
            scheme.dark_bright_magenta = dark_palette[14];
            scheme.dark_bright_cyan = dark_palette[15];
            scheme.dark_bright_white = dark_palette[16];

            return scheme;
        }

        public string[] get_light_palette () {
            return new string[] {
                this.light_black,
                this.light_red,
                this.light_green,
                this.light_yellow,
                this.light_blue,
                this.light_magenta,
                this.light_cyan,
                this.light_white,
                this.light_bright_black,
                this.light_bright_red,
                this.light_bright_green,
                this.light_bright_yellow,
                this.light_bright_blue,
                this.light_bright_magenta,
                this.light_bright_cyan,
                this.light_bright_white
            };
        }

        public string[] get_dark_palette () {
            return new string[] {
                this.dark_black,
                this.dark_red,
                this.dark_green,
                this.dark_yellow,
                this.dark_blue,
                this.dark_magenta,
                this.dark_cyan,
                this.dark_white,
                this.dark_bright_black,
                this.dark_bright_red,
                this.dark_bright_green,
                this.dark_bright_yellow,
                this.dark_bright_blue,
                this.dark_bright_magenta,
                this.dark_bright_cyan,
                this.dark_bright_white
            };
        }

        public Gdk.RGBA[] get_dark_rgba_palette () {
            Gdk.RGBA[] palette = new Gdk.RGBA[16];
            palette[0].parse (this.dark_black);
            palette[1].parse (this.dark_red);
            palette[2].parse (this.dark_green);
            palette[3].parse (this.dark_yellow);
            palette[4].parse (this.dark_blue);
            palette[5].parse (this.dark_magenta);
            palette[6].parse (this.dark_cyan);
            palette[7].parse (this.dark_white);
            palette[8].parse (this.dark_bright_black);
            palette[9].parse (this.dark_bright_red);
            palette[10].parse (this.dark_bright_green);
            palette[11].parse (this.dark_bright_yellow);
            palette[12].parse (this.dark_bright_blue);
            palette[13].parse (this.dark_bright_magenta);
            palette[14].parse (this.dark_bright_cyan);
            palette[15].parse (this.dark_bright_white);
            return palette;
        }

        public static StColorScheme? new_from_json(string filename) {
            // Each json will have a light and dark hash with the colors
            
            try {
                Json.Parser parser = new Json.Parser();
                parser.load_from_file (filename);
                
                Json.Object obj = parser.get_root ().get_object();

                string id = obj.get_string_member ("id");
                string name = obj.get_string_member ("name");

                // Extract light and dark color schemes
                Json.Object light = obj.get_object_member("light");
                Json.Object dark = obj.get_object_member("dark");
                
                // Create the color scheme using new_from_colors
                return new_from_colors (
                    id, name,
                    light.get_string_member("foreground_color"),
                    light.get_string_member("background_color"),
                    light.get_string_member("bold_color"),
                    light.get_string_member("cursor_color"),
                    light.get_string_member("highlight_color"),
                    light.get_string_member("black"),
                    light.get_string_member("red"),
                    light.get_string_member("green"),
                    light.get_string_member("yellow"),
                    light.get_string_member("blue"),
                    light.get_string_member("magenta"),
                    light.get_string_member("cyan"),
                    light.get_string_member("white"),
                    light.get_string_member("bright_black"),
                    light.get_string_member("bright_red"),
                    light.get_string_member("bright_green"),
                    light.get_string_member("bright_yellow"),
                    light.get_string_member("bright_blue"),
                    light.get_string_member("bright_magenta"),
                    light.get_string_member("bright_cyan"),
                    light.get_string_member("bright_white"),
                    dark.get_string_member("foreground_color"),
                    dark.get_string_member("background_color"),
                    dark.get_string_member("bold_color"),
                    dark.get_string_member("cursor_color"),
                    dark.get_string_member("highlight_color"),
                    dark.get_string_member("black"),
                    dark.get_string_member("red"),
                    dark.get_string_member("green"),
                    dark.get_string_member("yellow"),
                    dark.get_string_member("blue"),
                    dark.get_string_member("magenta"),
                    dark.get_string_member("cyan"),
                    dark.get_string_member("white"),
                    dark.get_string_member("bright_black"),
                    dark.get_string_member("bright_red"),
                    dark.get_string_member("bright_green"),
                    dark.get_string_member("bright_yellow"),
                    dark.get_string_member("bright_blue"),
                    dark.get_string_member("bright_magenta"),
                    dark.get_string_member("bright_cyan"),
                    dark.get_string_member("bright_white")
                );
            } catch (GLib.Error e) {
                return null;
            }
        }

        public static StColorScheme? new_from_id(string id) {
            var available_schemes = get_available_schemes();
            if (available_schemes.has_key(id)) {
                return new_from_json(available_schemes[id]);
            }
            return null;
        }
    }
    
    public string[] get_scheme_dirs() {
        string[] user_dirs = {};
        foreach (string dir in GLib.Environment.get_system_data_dirs ()) {
            if (GLib.FileUtils.test(dir, GLib.FileTest.IS_DIR)) {
                user_dirs += (dir + "/stillTerminal/themes");
            }
            user_dirs += (dir + "/stillTerminal/themes");
        }
        return user_dirs;
    }

    public Gee.HashMap<string, string> get_available_schemes () {
        Gee.HashMap<string, string> available_schemes = new Gee.HashMap<string, string>();

        // THIS IS FOR TESTING PURPOSES
        // TODO: Remove this
        available_schemes["default"] = "/home/cameronknauff/Documents/stillTerminal/data/schemes/default.json";
        
        string[] dirs = get_scheme_dirs();
        try {
            foreach (string dir_path in dirs) {
                GLib.Dir dir = GLib.Dir.open(dir_path);
                string? filename = dir.read_name();
                while (filename != null) {
                    if (filename.has_suffix(".json")) {
                        // try loading json to check if it's valid
                        try {
                            Json.Parser parser = new Json.Parser();
                            parser.load_from_file (filename);
                            string id = parser.get_root().get_object().get_string_member("id");
                            if (StColorScheme.new_from_json (dir_path + "/" + filename) != null) {
                                available_schemes[id] = dir_path + "/" + filename;
                            }
                        } catch (GLib.Error e) {}
                    }
                }
            }
        } catch (GLib.FileError e) {}
        return available_schemes;
    }
}