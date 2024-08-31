namespace StillTerminal {
    public class StPrefsProfilePage : Adw.PreferencesPage {
        public StPrefsDialog dialog;
        private Adw.PreferencesGroup profiles_group;
        Adw.ActionRow[] rows = {};

        public StPrefsProfilePage (StPrefsDialog dialog) {
            this.dialog = dialog;
            this.set_title ("Profiles");
            this.set_icon_name ("utilities-terminal-symbolic");

            this.profiles_group = new Adw.PreferencesGroup ();
            var profile_button = new Gtk.Button ();
            profile_button.set_label ("New Profile");
            profile_button.clicked.connect (() => {
                var profile_creator = new StProfileCreatorTypePage (this.dialog);
                this.dialog.preferences_dialog.push_subpage (profile_creator);
            });
            this.profiles_group.set_header_suffix (profile_button);
            this.add (profiles_group);
            regenerate_profile_list ();
        }

        private void save_profile_with_backup (StProfile profile) {
            File original_file = File.new_for_path(profile.profile_file);
            File backup_file = File.new_for_path(profile.profile_file + ".bak");
            
            try {
                // Create a backup
                if (original_file.query_exists()) {
                    original_file.copy(backup_file, FileCopyFlags.OVERWRITE);
                }
                
                // Save the new profile data
                profile.save_to_json(profile.profile_file);
                
                // If everything went well, delete the backup
                if (backup_file.query_exists()) {
                    backup_file.delete();
                }
                
                print("Profile saved successfully.\n");
            } catch (Error e) {
                print("Error saving profile: %s\n", e.message);
                
                try {
                    // If there was an error, attempt to restore from backup
                    if (backup_file.query_exists()) {
                        original_file.delete(); // Delete the potentially corrupted file
                        backup_file.move(original_file, FileCopyFlags.OVERWRITE);
                        print("Profile restored from backup.\n");
                    }
                } catch (Error restore_error) {
                    print("Error restoring from backup: %s\n", restore_error.message);
                }
            }
        }
        
        public void open_profile_editor(StProfile profile) {
            var profile_editor = new StProfileEditorPage (this.dialog, profile);
            
            var save_button = new Gtk.Button.with_label ("Save");
            save_button.clicked.connect(() => {
                this.save_profile_with_backup(profile_editor.get_edited_profile ());
                this.dialog.window.header.update_new_tab_menu ();
                regenerate_profile_list ();
                this.dialog.preferences_dialog.pop_subpage ();
            });
            profile_editor.set_button (save_button);
            
            if (profile.id != "default") {
                var remove_button = new Gtk.Button.with_label ("Remove Profile");
                remove_button.add_css_class ("destructive-action");
                remove_button.clicked.connect (() => {
                    var file = File.new_for_path(profile.profile_file);
                    try { file.delete(); }
                    catch (Error e) { print ("Error deleting profile: $(e.message)\n"); }
                    this.dialog.window.header.update_new_tab_menu ();
                    regenerate_profile_list ();
                    this.dialog.preferences_dialog.pop_subpage ();
                });
                profile_editor.header.pack_end (remove_button);
            }

            this.dialog.preferences_dialog.push_subpage (profile_editor);
        }

        
        public void regenerate_profile_list () {
            foreach (var row in this.rows) {
                this.profiles_group.remove (row);
            }

            var profile_index = get_profiles ();
            
            foreach (StProfile profile in profile_index) {
                var row = new Adw.ActionRow ();
                row.set_title (profile.name);

                Gtk.Image icon;
                if (profile.icon_name != null && profile.icon_name in StillTerminal.AVAILABLE_ICONS) {
                    icon = new Gtk.Image.from_resource (@"/io/stillhq/terminal/icons/$(profile.icon_name).svg");
                } else {
                    icon = new Gtk.Image.from_icon_name ("utilities-terminal-symbolic");
                }
                icon.set_pixel_size (32);
                row.add_prefix (icon);

                if (profile.type_subtitle != null) {
                    row.set_subtitle (profile.type_subtitle);
                }

                var button = new Gtk.Button.from_icon_name ("go-next");
                button.add_css_class ("flat");
                button.valign = Gtk.Align.CENTER;
                button.clicked.connect (() => {
                    this.open_profile_editor (profile);
                });
                row.add_suffix (button);
                row.set_activatable_widget (button);
                this.profiles_group.add (row);
                this.rows += row;
            }
        }
    }
}