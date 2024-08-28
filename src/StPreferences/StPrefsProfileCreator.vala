namespace StillTerminal {
    public class StPrefsProfileCreator {
        Adw.PreferencesDialog preferences_dialog;

        StPrefsProfileCreator (MainWindow window) {
            this.preferences_dialog = new Adw.PreferencesDialog ();\
        }
    }

    public class StPrefsNamePage : Adw.PreferencesPage {
        Adw.EntryRow name_row;
        Adw.RevealerRow type_revealer_row;
        Adw.ActionRow system_row;
        Adw.ActionRow easy_dev_environment_row;
        Adw.ActionRow ssh_row;
        Adw.ActionRow custom_distrobox_row;
        Gtk.CheckButton? last_button;

        public StPrefsNamePage () {
            this.name_row = new Adw.EntryRow()
            this.name_row.set_title("Profile Name");
            this.add (this.name_row);

            this.type_revealer_row = new Adw.RevealerRow();
            this.type_revealer_row.set_title("Profile Type");
            this.add (this.type_revealer_row);
        }

        public add_check_button () {

        }
    }
}