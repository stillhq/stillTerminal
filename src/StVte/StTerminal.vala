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
            var env = new string[1];
            //  this.vte.spawn_async (
            //      Vte.PtyFlags.DEFAULT,
            //      profile.working_directory,
            //      new string[] { profile.spawn_command.split(" ") },
            //      env,
            //      Vte.SpawnFlags.DEFAULT,
            //      null,
            //      null,
            //      null
            //  );
        }

        public string[] get_spawn_list (StProfile profile) {
            string[] args = profile.spawn_command.split(" ");
            if (profile.distrobox_id != null) {
                return ["distrobox", "enter", "-n", profile.distrobox_id, "--"] + args;
            }
            try {
                GLib.File file = GLib.File.new_for_path(args[0]);
                bool file_exists = file.query_exists();
                if (file_exists) {
                    return args;
                } else {
                    return ["distrobox", "enter", "-n", "default", "--"] + args;
                }
            }
        }
    }
}

