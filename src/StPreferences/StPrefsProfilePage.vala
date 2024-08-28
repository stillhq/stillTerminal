namespace StillTerminal {
    public class StPrefsProfilePage : Adw.PreferencesPage {
        private StProfile[] profile_index = get_profiles();

        public StPrefsProfilePage () {
            this.set_title ("Profiles");
            this.set_icon_name ("utilities-terminal-symbolic");

            var profiles_group = new Adw.PreferencesGroup ();
            foreach (StProfile profile in profile_index) {
                var row = new Adw.ActionRow();
                row.set_title(profile.name);

                Gtk.Image icon;
                if (profile.icon_name != null) {
                    icon = new Gtk.Image.from_icon_name(profile.icon_name);
                } else {
                    icon = new Gtk.Image.from_icon_name("utilities-terminal-symbolic");
                }
                row.add_prefix(icon);

                if (profile.subtitle != null) {
                    row.set_subtitle (profile.subtitle);
                }
            }
        }
    }
}