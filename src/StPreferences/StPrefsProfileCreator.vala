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
                this.dialog.new_profile_dialog.close ();
            });
            header.pack_start(cancel_button);

            var next_button = new Gtk.Button.with_label("Next");
            next_button.add_css_class("suggested-action");
            next_button.clicked.connect( () => {
                next_page();
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
                this.push_profile_editor (StProfile.new_blank_profile ());
                    break;
                case CreationType.PREMADE_DISTROBOX:
                    break;
                case CreationType.SSH:
                    break;
                case CreationType.CUSTOM_DISTROBOX:
                    break;
            }
        }

        public void push_profile_editor (StProfile profile) {
            var editor_page = new StProfileEditorPage(this.dialog, profile);
            var create_button = new Gtk.Button.with_label("Create");
            create_button.add_css_class("suggested-action");
            editor_page.header.pack_end (create_button);
            this.dialog.new_profile_dialog.push_subpage(editor_page);
        }
    }
}