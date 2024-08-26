namespace StillTerminal {
    public class StTerminal : Adw.Bin {
        public Vte.Terminal vte;
        public StColorScheme color_scheme;
        public StSettings settings;
        public Pango.FontDescription default_font_desc;

        public StTerminal (StSettings settings) {
            Object ();
            this.settings = settings;

            this.vte = new Vte.Terminal ();
            this.vte.vexpand = true;
            this.vte.hexpand = true;
            this.child = this.vte;
            this.vte.set_enable_fallback_scrolling(false);

            // Used if custom font is disabled
            this.default_font_desc = this.vte.get_font ().copy ();

            this.spawn_profile (get_system_profile ());
            this.settings.bind_to_vte (this, this.vte);
        }

        public void spawn_profile (StProfile profile) {
            set_appearance (profile.color_scheme);
            // Spawn terminal
            this.vte.spawn_async (
                Vte.PtyFlags.DEFAULT,
                profile.working_directory,
                get_spawn_list (profile),
                null,
                GLib.SpawnFlags.SEARCH_PATH,
                null,
                -1,
                null,
                null
            );
        }

        public string[] get_spawn_list (StProfile profile) {
            if (profile.spawn_command == null) {
                return new string[] {GLib.Environment.get_variable ("SHELL")};
            }
            string[] args = profile.spawn_command.split(" ");
            if (args.length == 0) {
                return new string[] {GLib.Environment.get_variable ("SHELL")};
            }
            if (profile.distrobox_id != null) {
                string[] distrobox_cmd = {"/bin/distrobox", "enter", "-n", profile.distrobox_id, "--"};
                foreach (string arg in args) {
                    distrobox_cmd += arg;
                }
                return args;
            }

            GLib.File file = GLib.File.new_for_path (args[0]);
            if (file.query_exists ()) {
                return args;
            }
            string[] shell_cmd = {GLib.Environment.get_variable ("SHELL"), "-c"};
            foreach (string arg in args) {
                shell_cmd += arg;
            }
            return shell_cmd;
        }

        public void set_appearance (string color_scheme_name) {
            if (color_scheme_name == "system") {
                color_scheme_name = this.settings.system_color;
            }
            this.color_scheme = StColorScheme.new_from_id(color_scheme_name);

            // Set color scheme
            Gdk.RGBA bold_color = Gdk.RGBA ();
            bold_color.parse ( color_scheme.dark_bold_color );
            this.vte.set_color_cursor ( bold_color );

            Gdk.RGBA cursor_color = Gdk.RGBA ();
            cursor_color.parse ( color_scheme.dark_cursor_color );
            this.vte.set_color_cursor ( cursor_color );

            Gdk.RGBA background_color = Gdk.RGBA ();
            background_color.parse ( color_scheme.dark_background_color );
            Gdk.RGBA foreground_color = Gdk.RGBA ();
            foreground_color.parse ( color_scheme.dark_foreground_color );
            this.vte.set_colors (
                foreground_color, background_color, color_scheme.get_dark_rgba_palette ()
            );

            // Set font
            if (this.settings.use_custom_font) {
                var font_desc = Pango.FontDescription.from_string (this.settings.custom_font);
                this.vte.set_font (font_desc);
            } else {
                this.vte.set_font (this.default_font_desc);
            }
        }
    }
}

