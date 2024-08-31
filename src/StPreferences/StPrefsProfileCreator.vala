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

    public class StProfileCreatorTypePage : Adw.NavigationPage {
        StPrefsDialog dialog;
        Adw.PreferencesGroup pref_group;
        Adw.ActionRow system_row;
        Adw.ActionRow easy_dev_environment_row;
        Adw.ActionRow ssh_row;
        Adw.ActionRow custom_distrobox_row;
        CreationType selected_option;

        public StProfileCreatorTypePage (StPrefsDialog dialog) {
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
            this.pref_group.set_title("Select Profile Type");
            preferences_page.add(this.pref_group);
            this.set_child(box);

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
                this.dialog.preferences_dialog.pop_subpage ();
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
            this.pref_group.add (row);
            button.toggled.connect ((button) => {
                if (button.active) {
                    this.selected_option = type;
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
            create_button.set_sensitive (false);
            create_button.clicked.connect(() => {
                this.create_profile_button (editor_page);
            });
            editor_page.set_button(create_button);
            this.dialog.preferences_dialog.push_subpage(editor_page);
        }

        public void create_profile_button (StProfileEditorPage editor_page) {
            this.dialog.preferences_dialog.pop_subpage ();
            var profile = editor_page.get_edited_profile();
            profile.save_to_json (get_local_profile_dir() + "/" + profile.id + ".json");
            this.dialog.window.add_tab(profile);
            this.dialog.preferences_dialog.close();
        }
    }
}