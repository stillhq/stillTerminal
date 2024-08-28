namespace StillTerminal {
    public class StPrefsProfilePage : Adw.PreferencesPage {
        private St.Profile[] profile_index = get_profiles();

        public StPrefsProfilePage () {
            this.set_title ("Profiles");
            this.set_icon_name ("utilities-terminal-symbolic");

            var profiles_group = new Adw.PreferencesGroup ();
            foreach (var profile in profile_index) {
                var row = new Adw.ActionRow();
                row.set_title(profile.name);

                if (profile.icon_name != null) {
                    row.set_icon_name(profile.icon_name);
                } else {
                    row.set_icon_name("utilities-terminal-symbolic");
                }

                if (profile.subtitle != null) {
                    row.set_subtitle(profile.subtitle);
                }
            }
        }

        public on_row_clicked (Adw.ActionRow row) {
            row.get_index
        }
    }
}