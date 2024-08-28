namespace StillTerminal {
    public class StPrefsProfilePage : Adw.PreferencesPage {
        private StProfile[] profile_index;

        public StPrefsProfilePage () {
            this.profile_index = get_profiles ();
            this.set_title ("Profiles");
            this.set_icon_name ("utilities-terminal-symbolic");

            var profiles_group = new Adw.PreferencesGroup ();
            var profile_button = new Gtk.Button ();
            profile_button.set_label ("New Profile");
            profile_button.clicked.connect (() => {
                var dialog = new StPrefsProfileCreator ();
                dialog.present(this);
            });
            profiles_group.set_header_suffix (profile_button);

            foreach (StProfile profile in profile_index) {
                print(profile.id);
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
                profiles_group.add (row);
            }
            this.add (profiles_group);
        }
    }
}