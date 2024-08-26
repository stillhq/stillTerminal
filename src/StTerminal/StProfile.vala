namespace StillTerminal {
    public class StProfile {
        public string id;
        public string name;
        public string color_scheme;
        public string working_directory;
        public string? spawn_command;
        public string? distrobox_id;

        public StProfile (
            string id, string name, string color_scheme, string working_directory,
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
                obj.get_string_member("color-scheme"),
                obj.get_string_member("working_directory"),
                obj.get_string_member("spawn_command"),
                obj.get_string_member("distrobox_id")
            );
        }

        public Gee.HashMap<string, string> as_hash() {
            Gee.HashMap<string, string> hash = new Gee.HashMap<string, string> ();
            hash["id"] = this.id;
            hash["name"] = this.name;
            hash["working_directory"] = this.working_directory;
            hash["spawn_command"] = this.spawn_command;
            hash["distrobox_id"] = this.distrobox_id;
            return hash;
        }

        public void save_to_json(string filename) {
            var hash = this.as_hash();
            var builder = new Json.Builder();
            builder.begin_object();

            var hash_iter = hash.map_iterator();
            hash_iter.foreach((key, value) => {
                builder.set_member_name(key);
                builder.add_string_value(value);
                return true;
            });

            builder.end_object();

            var generator = new Json.Generator();
            generator.set_root(builder.get_root());

            try {
                generator.to_file(filename);
            } catch (GLib.Error e) {
                print("Error saving profile to file: %s\n".printf(e.message));
            }
        }
    }

    public StProfile get_system_profile() {
        return new StProfile(
            "system",
            "System",
            "system",
            GLib.Environment.get_home_dir()
        );
    }
}