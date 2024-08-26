namespace StillTerminal {
    public class StPrefsDialog {
        Adw.PreferencesDialog preferences_dialog;
    
        public StPrefsDialog () {
            this.preferences_dialog = new Adw.PreferencesDialog ();

            this.preferences_dialog.add (new StPrefsGeneralPage ());
        }

        public void present (Gtk.Widget parent) {
            this.preferences_dialog.present (parent);
        }
    }
}