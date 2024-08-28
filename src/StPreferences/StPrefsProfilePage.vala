namespace StillTerminal {
    public class StPrefsProfilePage : Adw.PreferencesPage {
        public StPrefsProfilePage () {
            this.set_title ("Profiles");
            this.set_icon_name ("utilities-terminal-symbolic");

            var profiles_group = new StPrefsProfilesGroup ();
            foreach (var profile in MainWindow.profiles) {
                row = new Adw.ActionRow();
                row.set_title(profile.name);
            }

        }
    }
}