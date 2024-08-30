namespace StillTerminal {
    public enum StProfileType {
        SYSTEM, DISTROBOX, SSH;

        public string to_string() {
            switch (this) {
                case SYSTEM:
                    return "system";
                case DISTROBOX:
                    return "distrobox";
                case SSH:
                    return "ssh";
            }
            return "";
        }

        public static StProfileType? from_string(string type) {
            switch (type.ascii_down()) {
                case "system":
                    return SYSTEM;
                case "distrobox":
                    return DISTROBOX;
                case "ssh":
                    return SSH;
            }
            return null;
        }
    }

    public class StProfile : GLib.Object {
        public string id;
        public string name;
        public string color_scheme;
        public string working_directory;
        public string? spawn_command;
        public string? profile_file;
        public string? icon_name;
        public StProfileType type;
        public string[]? type_data;
        public string? subtitle;
    
        public StProfile (
            string id, string name, string color_scheme, string working_directory,
            string? spawn_command = null, string? profile_file = null,
            string? icon_name = null, StProfileType type = StProfileType.SYSTEM,
            string[]? type_data = null, string? subtitle = null
        ) {
            this.id = id;
            this.name = name;
            this.color_scheme = color_scheme;
            this.working_directory = working_directory;
            this.spawn_command = spawn_command;
            this.profile_file = profile_file;
            this.icon_name = icon_name;
            this.type = type;
            this.type_data = type_data;
            this.subtitle = subtitle;
        }

        public static StProfile? new_blank_profile() {
            return new StProfile(
                "",
                "",
                "system",
                GLib.Environment.get_home_dir(),
                null,
                null,
                null,
                StProfileType.SYSTEM,
                null,
                null
            );
        }
    
        public static StProfile? new_from_json(string filename) {
            Json.Parser parser = new Json.Parser();
            try {
                parser.load_from_file (filename);
            } catch (GLib.Error e) {
                print("Error loading profile from file: %s\n".printf(e.message));
                return null;
            }
    
            Json.Object obj = parser.get_root().get_object();
            
            StProfileType profile_type = StProfileType.SYSTEM;
            if (obj.has_member("type")) {
                profile_type = StProfileType.from_string(obj.get_string_member("type"));
            }
    
            string[]? type_data = null;
            if (obj.has_member("type_data")) {
                var type_data_array = obj.get_array_member("type_data");
                type_data = new string[type_data_array.get_length()];
                for (int i = 0; i < type_data_array.get_length(); i++) {
                    type_data[i] = type_data_array.get_string_element(i);
                }
            }
    
            return new StProfile(
                obj.get_string_member("id"),
                obj.get_string_member("name"),
                obj.has_member("color-scheme") ? obj.get_string_member("color-scheme") : "system",
                obj.has_member("working_directory") ? obj.get_string_member("working_directory") : "",
                obj.has_member("spawn_command") ? obj.get_string_member("spawn_command") : "",
                filename,
                obj.has_member("icon-name") ? obj.get_string_member("icon-name") : "",
                profile_type,
                type_data,
                obj.has_member("subtitle") ? obj.get_string_member("subtitle") : ""
            );
        }
    
        public Gee.HashMap<string, string> as_hash() {
            var hash = new Gee.HashMap<string, string>();
            hash["id"] = this.id;
            hash["name"] = this.name;
            hash["color_scheme"] = this.color_scheme;
            hash["working_directory"] = this.working_directory;
            if (this.spawn_command != null) hash["spawn_command"] = this.spawn_command;
            if (this.profile_file != null) hash["profile_file"] = this.profile_file;
            if (this.icon_name != null) hash["icon_name"] = this.icon_name;
            hash["type"] = this.type.to_string();
            if (this.type_data != null) hash["type_data"] = string.joinv(",", this.type_data);
            if (this.subtitle != null) hash["subtitle"] = this.subtitle;
            return hash;
        }
    
        public void save_to_json(string filename) {
            var hash = this.as_hash();
            var builder = new Json.Builder();
            builder.begin_object();
    
            foreach (var entry in hash.entries) {
                builder.set_member_name(entry.key);
                if (entry.key == "type_data" && this.type_data != null) {
                    builder.begin_array();
                    foreach (string data in this.type_data) {
                        builder.add_string_value(data);
                    }
                    builder.end_array();
                } else {
                    builder.add_string_value(entry.value);
                }
            }
    
            builder.end_object();
    
            var generator = new Json.Generator();
            generator.set_root(builder.get_root());
    
            try {
                generator.to_file(filename);
            } catch (GLib.Error e) {
                print("Error saving profile to file: %s\n", e.message);
            }
        }
    }

    public StProfile get_fallback_profile() {
        return new StProfile(
            "system_fallback",
            "System",
            "system",
            GLib.Environment.get_home_dir(),
            null,
            null,
            null,
            StProfileType.SYSTEM,
            null,
            "stillOS (Fallback Profile)"
        );
    }

    public StProfile get_default_profile() {
        StProfile[] profiles = get_profiles ();
        if (profiles.length == 0) {
            return get_fallback_profile();
        }
        foreach (var profile in profiles) {
            if (profile.id == "default") {
                return profile;
            }
        }
        return profiles[0];
    }

    public string get_local_profile_dir() {
        File file = File.new_build_filename(
            GLib.Environment.get_home_dir(),
            "/.local/share/stillTerminal/profiles"
        );

        // Create the directory if it doesn't exist
        if (!(file.query_exists())) {
            try {
                file.make_directory_with_parents();

                // Create a default profile
                var profile = get_fallback_profile();
                profile.id = "default";
                profile.name = "Default";
                profile.subtitle = "stillOS";
                profile.save_to_json(file.get_child("default.json").get_path());
            } catch (GLib.Error e) {
                print("Error creating profile directory: %s\n".printf(e.message));
            }
        }

        return file.get_path ();
    }

    public StProfile[] get_profiles() {
        var profile_dir = get_local_profile_dir();
        StProfile[] profiles = {};

        var dir = File.new_for_path(profile_dir);
        try {
            var enumerator = dir.enumerate_children(
                "standard::name,standard::type",
                FileQueryInfoFlags.NONE,
                null
            );

            FileInfo? info;
            while ((info = enumerator.next_file()) != null) {
                if (info.get_file_type() != FileType.REGULAR) {
                    continue;
                }
    
                var profile = StProfile.new_from_json(
                    GLib.Path.build_filename (profile_dir, info.get_name())
                );
                if (profile != null) {
                    profiles += profile;
                }
            }
        } catch (GLib.Error e) {
            print("Error enumerating profile directory: %s\n".printf (e.message));
            return {get_fallback_profile ()};
        }

        print(profiles.length.to_string());
        return profiles;
    }
}