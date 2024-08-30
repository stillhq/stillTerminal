namespace StillTerminal {
    public class StPrefsDialog {
        public Adw.PreferencesDialog preferences_dialog;
    
        public StPrefsDialog (MainWindow window) {
            this.preferences_dialog = new Adw.PreferencesDialog ();

            var general_page = new StPrefsGeneralPage ();
            var profile_page = new StPrefsProfilePage (this);
            window.settings.bind_to_general(general_page);
            this.preferences_dialog.add (general_page);
            this.preferences_dialog.add (profile_page);
        }

        public void present (Gtk.Widget parent) {
            this.preferences_dialog.present (parent);
        }
    }
}