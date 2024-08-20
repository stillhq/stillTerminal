namespace StillTerminal {
    public class StTerminal : Adw.Bin {
        public Vte.Terminal vte;
        public StColorScheme color_scheme;

        public StTerminal () {
            Object ();
            this.vte = new Vte.Terminal ();
            this.vte.vexpand = true;
            this.vte.hexpand = true;
            this.child = this.vte;
        }

        public void spawn_profile (StProfile profile) {
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

            GLib.File file = GLib.File.new_for_path(args[0]);
            if (file.query_exists ()) {
                return args;
            }
            string[] shell_cmd = {GLib.Environment.get_variable ("SHELL"), "-c"};
            foreach (string arg in args) {
                shell_cmd += arg;
            }
            return shell_cmd;
        }
    }
}

