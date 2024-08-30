namespace StillTerminal {
    // Different from StProfileType to allow premade distrobox and custom distrobox 
    public enum CreationType {
        SYSTEM, PREMADE_DISTROBOX, SSH, CUSTOM_DISTROBOX;
    }
    
    // These are only used for creating profiles, not for the profiles themselves
    public class StDistroBoxProfile {
        public string image_name;
        public bool use_sdbm; // Still DistroBox Manager
    }
    
    // These are only used for creating profiles, not for the profiles themselves
    public class StSshProfile {
        public string url;
        public string username;
        public string password;
        public string key_file;
        public string port;
    }

    public class StPrefsProfileCreator {
        public Adw.PreferencesDialog new_profile_dialog;
        StProfileCreatorNamePage name_page;

        public StPrefsProfileCreator () {
            this.new_profile_dialog = new Adw.PreferencesDialog ();
            this.name_page = new StProfileCreatorNamePage (this);
            this.new_profile_dialog.push_subpage (this.name_page);
        }

        public void present (Gtk.Widget parent) {
            this.new_profile_dialog.present (parent);
        }
    }

    public class StProfileCreatorNamePage : Adw.NavigationPage {
        StPrefsProfileCreator dialog;
        Adw.PreferencesGroup pref_group;
        Adw.EntryRow name_row;
        Adw.ExpanderRow type_revealer_row;
        Adw.ActionRow system_row;
        Adw.ActionRow easy_dev_environment_row;
        Adw.ActionRow ssh_row;
        Adw.ActionRow custom_distrobox_row;
        CreationType selected_option;

        public StProfileCreatorNamePage (StPrefsProfileCreator dialog) {
            this.dialog = dialog;
            this.can_pop = false;
            this.title = "New Profile";

            var header = new Adw.HeaderBar ();
            header.set_show_start_title_buttons (false);
            header.set_show_end_title_buttons (false);
            
            var preferences_page = new Adw.PreferencesPage ();
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            box.append (header);
            box.append (preferences_page);

            this.pref_group = new Adw.PreferencesGroup ();
            preferences_page.add(this.pref_group);
            this.set_child(box);
            
            this.name_row = new Adw.EntryRow();
            this.name_row.set_title("Profile Name");
            this.pref_group.add (this.name_row);
            
            this.type_revealer_row = new Adw.ExpanderRow();
            this.type_revealer_row.set_title("Profile Type");
            this.type_revealer_row.set_subtitle("System Profile");
            this.pref_group.add (this.type_revealer_row);

            Gtk.CheckButton? last_button = null;
            this.system_row = add_check_button(
                out last_button,
                "System Profile", "Use the system profile",
                "utilities-terminal-symbolic",
                CreationType.SYSTEM, last_button
            );
            last_button.set_active (true);
            this.easy_dev_environment_row = add_check_button(
                out last_button,
                "Easy Development Environment", "Setup a quick development environment using DistroBox",
                "utilities-terminal-symbolic",
                CreationType.PREMADE_DISTROBOX, last_button
            );
            this.ssh_row = add_check_button(
                out last_button,
                "SSH Profile", "Use an SSH profile",
                "utilities-terminal-symbolic",
                CreationType.SSH, last_button
            );
            this.custom_distrobox_row = add_check_button(
                out last_button,
                "Custom Distrobox Profile", "Create a custom distrobox profile",
                "utilities-terminal-symbolic",
                CreationType.CUSTOM_DISTROBOX, last_button
            );

            var cancel_button = new Gtk.Button.with_label("Cancel");
            cancel_button.clicked.connect(() => {
                this.dialog.new_profile_dialog.close();
            });
            header.pack_start(cancel_button);

            var next_button = new Gtk.Button.with_label("Next");
            next_button.add_css_class("suggested-action");
            next_button.clicked.connect( () => {
                print("Next button clicked");
            });
            header.pack_end(next_button);
            
        }
    
        public Adw.ActionRow add_check_button (
            out Gtk.CheckButton button,
            string title, string subtitle,
            string icon_name, CreationType type,
            Gtk.CheckButton? last_button
        ) {
            Adw.ActionRow row = new Adw.ActionRow();
            row.set_title(title);
            row.set_subtitle(subtitle);
            Gtk.Image icon = new Gtk.Image.from_icon_name (icon_name);
            row.add_prefix(icon);
            button = new Gtk.CheckButton ();
            button.valign = Gtk.Align.CENTER;
            button.halign = Gtk.Align.END;
            if (last_button != null) {
                button.set_group(last_button);
            }
            row.add_suffix(button);
            this.type_revealer_row.add_row (row);
            button.toggled.connect((button) => {
                if (button.active) {
                    this.type_revealer_row.set_subtitle(row.get_title());
                    this.selected_option = type;
                    print("clicked");
                }
            });
            row.set_activatable_widget (button);
            return row;
        }

        public void next_page () {
            switch (this.selected_option) {
                case CreationType.SYSTEM:
                    this.dialog.new_profile_dialog.push_subpage(new StProfileCreatorProfilePage(this.dialog));
                case CreationType.PREMADE_DISTROBOX:
                    break;
                case CreationType.SSH:
                    break;
                case CreationType.CUSTOM_DISTROBOX:
                    break;
            }
        }
    }

    public class StProfileCreatorProfilePage : Adw.NavigationPage {
        StPrefsProfileCreator dialog;
        string[] available_schemes;
        Adw.PreferencesGroup pref_group;
        Adw.EntryRow name_row;
        Adw.ComboRow color_scheme_row;
        Adw.EntryRow working_directory_row;
        Gtk.FileDialog file_dialog;
        Adw.EntryRow spawn_command_row;
        Adw.EntryRow icon_name_row;

        public StProfileCreatorProfilePage (StPrefsProfileCreator dialog) {
            this.available_schemes = get_available_schemes ().keys.to_array ();
            this.dialog = dialog;
            this.title = "Profile Settings";

            var header = new Adw.HeaderBar ();
            header.set_show_start_title_buttons (false);
            header.set_show_end_title_buttons (false);
            
            var preferences_page = new Adw.PreferencesPage ();
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            box.append (header);
            box.append (preferences_page);

            this.pref_group = new Adw.PreferencesGroup ();
            preferences_page.add (this.pref_group);
            this.set_child (box);

            this.name_row = new Adw.EntryRow ();
            this.name_row.set_title ("Profile Name");
            this.name_row.set_input_purpose (Gtk.InputPurpose.NAME);
            this.pref_group.add (this.name_row);

            this.color_scheme_row = new Adw.ComboRow ();
            this.color_scheme_row.set_title ("Color Scheme");
            this.color_scheme_row.set_subtitle ("Color scheme used for this profile");
            this.color_scheme_row.set_model (new Gtk.StringList(this.available_schemes));
            this.pref_group.add (this.color_scheme_row);

            this.working_directory_row = new Adw.EntryRow ();
            this.working_directory_row.set_title ("Starting Directory");
            this.working_directory_row.connect ("changed", this.check_working_directory);
            Gtk.Button working_directory_button = new Gtk.Button.from_icon_name("folder-open-symbolic");
            working_directory_button.add_css_class("flat");
            this.working_directory_row.add_suffix(working_directory_row);
            this.file_dialog = new Gtk.FileDialog();
            this.pref_group.add (this.working_directory_row);

            this.spawn_command_row = new Adw.EntryRow ();
            this.spawn_command_row.set_title ("Profile Starting Command");
            this.pref_group.add (this.spawn_command_row);

            // This is temporary for testing purposes. This will be replaced with a combo box
            this.icon_name_row = new Adw.EntryRow ();
            this.icon_name_row.set_title ("Icon Name");
            this.pref_group.add (this.icon_name_row);
        }

        public void check_working_directory (Adw.EntryRow working_directory_row) {
            if (GLib.FileUtils.test(working_directory_row.get_text(), GLib.FileTest.IS_DIR)) {
                this.add_css_class ("error");
            } else {
                this.remove_css_class("error");
            }
        }

        public void directory_picker_clicked (Gtk.Button button) {
            Gtk.Window window = this.dialog.new_profile_dialog.get_root() as Gtk.Window;
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
}