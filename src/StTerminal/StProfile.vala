namespace StillTerminal {
    public class StProfile {
        public string id;
        public string name;
        public StColorScheme? color_scheme;
        public string working_directory;
        public string? spawn_command;
        public string? distrobox_id;

        public StProfile (
            string id, string name, StColorScheme? color_scheme, string working_directory,
            string? distrobox_id = null, string? spawn_command = null
        ) {
            this.id = id;
            this.name = name;
            this.color_scheme = color_scheme;
            this.working_directory = working_directory;
            this.spawn_command = spawn_command;
            this.distrobox_id = distrobox_id;
        }

        public StProfile? new_from_json(string filename) {
            Json.Parser parser = new Json.Parser();
            try {
                parser.load_from_file (filename);
            } catch (GLib.Error e) {
                return null;
            }

            Json.Object obj = parser.get_root().get_object();
            return new StProfile(
                obj.get_string_member("id"),
                obj.get_string_member("name"),
                StColorScheme.new_from_id("default"),
                obj.get_string_member("working_directory"),
                obj.get_string_member("spawn_command"),
                obj.get_string_member("distrobox_id")
            );
        }
    }

    public StProfile get_system_profile() {
        return new StProfile(
            "system",
            "System",
            StColorScheme.new_from_id("default"),
            GLib.Environment.get_home_dir()
        );
    }
}