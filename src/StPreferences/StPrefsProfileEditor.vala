namespace StillTerminal {
    public class StProfileEditorPage : Adw.NavigationPage {
        StProfile profile;
        StPrefsDialog dialog;
        string[] available_schemes;
        public Adw.HeaderBar header;
        Adw.PreferencesGroup pref_group;
        Adw.EntryRow name_row;
        Adw.ComboRow color_scheme_row;
        Adw.EntryRow working_directory_row;
        Gtk.FileDialog file_dialog;
        Adw.EntryRow spawn_command_row;
        Adw.EntryRow icon_name_row;
        Gtk.Button? button;

        public StProfileEditorPage (StPrefsDialog dialog, StProfile profile) {
            this.available_schemes = get_available_schemes ().keys.to_array ();
            this.dialog = dialog;
            this.title = "Profile Settings";

            this.header = new Adw.HeaderBar ();
            this.header.set_show_start_title_buttons (false);
            this.header.set_show_end_title_buttons (false);

            var preferences_page = new Adw.PreferencesPage ();
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            box.append (this.header);
            box.append (preferences_page);

            this.pref_group = new Adw.PreferencesGroup ();
            preferences_page.add (this.pref_group);
            this.set_child (box);

            this.name_row = new Adw.EntryRow ();
            this.name_row.set_title ("Profile Name");
            this.name_row.set_input_purpose (Gtk.InputPurpose.NAME);
            this.name_row.changed.connect (this.check_entries);
            this.name_row.bind_property("changed", profile, "name", GLib.BindingFlags.DEFAULT);
            
            this.pref_group.add (this.name_row);

            this.color_scheme_row = new Adw.ComboRow ();
            this.color_scheme_row.set_title ("Color Scheme");
            this.color_scheme_row.set_subtitle ("Color scheme used for this profile");
            this.color_scheme_row.set_model (new Gtk.StringList(this.available_schemes));
            this.color_scheme_row.notify["selected"].connect (this.color_scheme_changed);
            this.pref_group.add (this.color_scheme_row);

            this.working_directory_row = new Adw.EntryRow ();
            this.working_directory_row.set_text(GLib.Environment.get_home_dir());
            this.working_directory_row.set_title ("Starting Directory");
            this.working_directory_row.changed.connect (this.check_entries);
            Gtk.Button working_directory_button = new Gtk.Button.from_icon_name("folder-open-symbolic");
            working_directory_button.add_css_class("flat");
            this.working_directory_row.add_suffix(working_directory_button);
            this.file_dialog = new Gtk.FileDialog();
            this.pref_group.add (this.working_directory_row);

            this.spawn_command_row = new Adw.EntryRow ();
            this.spawn_command_row.set_title ("Profile Starting Command");
            this.spawn_command_row.changed.connect (() => {
                profile.spawn_command = this.spawn_command_row.get_text();
            });
            this.pref_group.add (this.spawn_command_row);

            // This is temporary for testing purposes. This will be replaced with a combo box
            this.icon_name_row = new Adw.EntryRow ();
            this.icon_name_row.set_title ("Icon Name");
            this.icon_name_row.changed.connect (() => {
                profile.icon_name = this.icon_name_row.get_text();
            });
            this.pref_group.add (this.icon_name_row);

            check_entries(null);
        }

        public void color_scheme_changed (GLib.Object? _source_object, GLib.ParamSpec? _pspec) {
            profile.color_scheme = this.available_schemes[this.color_scheme_row.get_selected()];
        }

        public void set_button (Gtk.Button button) {
            this.button = button;
            button.add_css_class("suggested-action");
            this.header.pack_end (button);
        }

        public void set_button_sensitive (bool sensitive) {
            if (this.button != null) {
                this.button.set_sensitive(sensitive);
            }
        }

        public void check_entries (Gtk.Editable? _editable) {
            this.set_button_sensitive (true);
            
            if (this.name_row.get_text().length == 0 || !(are_all_chars_in_alphabet(this.name_row.get_text())) ) {
                this.name_row.add_css_class ("error");
                this.set_button_sensitive(false);
            } else {
                this.name_row.remove_css_class("error");
                this.profile.name = this.name_row.get_text();
            }

            if (GLib.FileUtils.test(this.working_directory_row.get_text(), GLib.FileTest.IS_DIR)) {
                this.working_directory_row.add_css_class ("error");
                this.set_button_sensitive(false);
            } else {
                this.working_directory_row.remove_css_class("error");
                this.profile.working_directory = this.working_directory_row.get_text();
            }
        }

        public void directory_picker_clicked (Gtk.Button button) {
            Gtk.Window window = this.dialog.preferences_dialog.get_root() as Gtk.Window;
            this.file_dialog.select_folder.begin (window, null, select_folder_callback);
            this.remove_css_class("error");
        }

        public void select_folder_callback(GLib.Object? _source_object, GLib.AsyncResult res) {
            try {
                string? folder = this.file_dialog.select_folder.end(res).get_path();
                if (folder != null) {
                    this.working_directory_row.set_text(folder);
                    this.remove_css_class("error");
                }
            } catch (GLib.Error e) {
                print("Error selecting folder: " + e.message);
            }
        }
    }

    public bool are_all_chars_in_alphabet(string input) {
        string alphabet = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
        for (int i = 0; i < input.length; i++) {
            unichar c = input[i];
            string char_string = c.to_string();
            
            if (alphabet.index_of (char_string) == -1) {
                return false;
            }
        }

        return true;
    }
}