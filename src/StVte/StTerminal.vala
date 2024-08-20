namespace StillTerminal {
    public class StTerminal : Adw.Bin {
        public Vte.Terminal vte;
        public StColorScheme color_scheme;

        public StTerminal (StTerminalSettings settings) {
            Object ();
            this.vte = new Vte.Terminal ();
            this.vte.vexpand = true;
            this.vte.hexpand = true;
            this.child = this.vte;
            this.vte.set_enable_fallback_scrolling(false);
            this.spawn_profile (get_system_profile ());
            settings.bind_to_vte (this, this.vte);
        }

        public void spawn_profile (StProfile profile) {
            set_colorscheme (profile.color_scheme);
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

        public void set_colorscheme (StColorScheme color_scheme) {
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
        }
    }
}

