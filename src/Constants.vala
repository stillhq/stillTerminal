namespace StillTerminal {
    public string[] get_scheme_dirs() {
        string[] user_dirs = {};
        foreach (string dir in GLib.Environment.get_system_data_dirs ()) {
            user_dirs += (dir + "/stillTerminal/themes");
        }
        return user_dirs;
    }

    public string[] get_profile_dirs() {
        string[] user_dirs = {};
        foreach (string dir in GLib.Environment.get_system_data_dirs ()) {
            user_dirs += (dir + "/stillTerminal/profiles");
        }
        return user_dirs;
    }