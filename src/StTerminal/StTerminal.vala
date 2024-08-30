namespace StillTerminal {
    public class StTerminal : Adw.Bin {
        public StProfile profile;
        public Vte.Terminal vte;
        public StSettings settings;
        public Pango.FontDescription default_font_desc;
        public Adw.StyleManager style_manager;

        public StTerminal (StSettings settings, StProfile profile) {
            Object ();
            this.settings = settings;
            this.profile = profile;

            this.style_manager = Adw.StyleManager.get_default ();

            this.vte = new Vte.Terminal ();
            this.vte.vexpand = true;
            this.vte.hexpand = true;
            this.child = this.vte;
            this.vte.set_enable_fallback_scrolling(false);

            // Used if custom font is disabled
            this.default_font_desc = this.vte.get_font ().copy ();
            this.spawn_profile ();
            this.settings.bind_to_vte (this, this.vte);
        }


        public void spawn_profile () {
            set_appearance ();

            // Spawn terminal
            this.vte.spawn_async (
                Vte.PtyFlags.DEFAULT,
                this.profile.working_directory,
                get_spawn_list (this.profile),
                null,
                GLib.SpawnFlags.SEARCH_PATH,
                null,
                -1,
                null,
                null
            );
        }

        public string[] get_spawn_list (StProfile profile) {
            string[] type_data = profile.type_data;
            switch (profile.type) {
                default:
                    if (profile.spawn_command == null) {
                        return new string[] {GLib.Environment.get_variable ("SHELL")};
                    }
                    string[] spawn_args = profile.spawn_command.split(" ");
                    if (spawn_args.length == 0) {
                        return new string[] {GLib.Environment.get_variable ("SHELL")};
                    }
        
                    GLib.File file = GLib.File.new_for_path (spawn_args[0]);
                    if (file.query_exists ()) {
                        return spawn_args;
                    }
                    string[] shell_cmd = {GLib.Environment.get_variable ("SHELL"), "-c"};
                    foreach (string arg in spawn_args) {
                        shell_cmd += arg;
                    }
                    return shell_cmd;

                case StProfileType.DISTROBOX:
                    string[] distrobox_cmd = {"/bin/distrobox", "enter", "-n", type_data[0]};
                    foreach (string arg in type_data[1:type_data.length]) {
                        distrobox_cmd += arg;
                    }
                    if (profile.spawn_command == null) {
                        return distrobox_cmd;
                    }

                    distrobox_cmd += "--";

                    string[] spawn_args = profile.spawn_command.split(" ");
                    foreach (string arg in spawn_args) {
                        distrobox_cmd += arg;
                    }
                    return distrobox_cmd;

                case StProfileType.SSH:
                    print ("Not implemented");
                    break;
            } 
            return new string[] {GLib.Environment.get_variable ("SHELL")};
        }

        public void set_appearance () {
            bool is_dark = this.style_manager.dark;
            string color_scheme_name = this.profile.color_scheme;
            
            if (color_scheme_name == "system" || !(this.settings.use_profile_color)) {
                color_scheme_name = this.settings.system_color;
            }
            var color_scheme = StColorScheme.new_from_id(color_scheme_name);

            if (color_scheme == null) {
                // Switch to default color scheme if the selected one is not found
                color_scheme = StColorScheme.new_from_id("Adwaita");
            }

            // Set color scheme
            Gdk.RGBA bold_color = Gdk.RGBA ();
            Gdk.RGBA cursor_color = Gdk.RGBA ();
            Gdk.RGBA background_color = Gdk.RGBA ();
            Gdk.RGBA foreground_color = Gdk.RGBA ();
            Gdk.RGBA[] palette;

            if (is_dark) {
                bold_color.parse ( color_scheme.dark_bold_color );
                cursor_color.parse ( color_scheme.dark_cursor_color );
                background_color.parse ( color_scheme.dark_background_color );
                foreground_color.parse ( color_scheme.dark_foreground_color );
                palette = color_scheme.get_dark_rgba_palette ();
            } else {
                bold_color.parse ( color_scheme.light_bold_color );
                cursor_color.parse ( color_scheme.light_cursor_color );
                background_color.parse ( color_scheme.light_background_color );
                foreground_color.parse ( color_scheme.light_foreground_color );
                palette = color_scheme.get_light_rgba_palette ();
            }

            // WTF IS THIS NOT WORKING!?
            // Maybe change widget
            background_color.alpha = (float) this.settings.opacity * 0.01f;

            this.vte.set_color_cursor ( bold_color );
            this.vte.set_color_cursor ( cursor_color );
            this.vte.set_colors (
                foreground_color, background_color, palette
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

