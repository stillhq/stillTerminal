namespace StillTerminal {
    // Different from StProfileType to allow premade distrobox and custom distrobox 
    public enum CreationType {
        SYSTEM, PREMADE_DISTROBOX, SSH, CUSTOM_DISTROBOX;
    }

    public class StPrefsProfileCreator {
        Adw.PreferencesDialog new_profile_dialog;

        public StPrefsProfileCreator () {
            this.new_profile_dialog = new Adw.PreferencesDialog ();
        }

        public void present (Gtk.Widget parent) {
            this.new_profile_dialog.present (parent);
        }
    }

    public class StPrefsNamePage : Adw.PreferencesPage {
        Adw.PreferencesGroup pref_group;
        Adw.EntryRow name_row;
        Adw.ExpanderRow type_revealer_row;
        Adw.ActionRow system_row;
        Adw.ActionRow easy_dev_environment_row;
        Adw.ActionRow ssh_row;
        Adw.ActionRow custom_distrobox_row;
        string selected_option;
        Gtk.CheckButton? last_button;
    
        public StPrefsNamePage () {
            this.pref_group = new Adw.PreferencesGroup ();
            this.add(this.pref_group);
            
            this.name_row = new Adw.EntryRow();
            this.name_row.set_title("Profile Name");
            this.pref_group.add (this.name_row);
            
            this.type_revealer_row = new Adw.ExpanderRow();
            this.type_revealer_row.set_title("Profile Type");
            this.pref_group.add (this.type_revealer_row);

            Gtk.CheckButton? last_button = null;
            this.system_row = add_check_button(
                out last_button,
                "System Profile", "Use the system profile",
                "utilities-terminal-symbolic",
                CreationType.SYSTEM, last_button
            );
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
            Gtk.Image icon = new Gtk.Image.from_icon_name(icon_name);
            row.add_prefix(icon);
            button = new Gtk.CheckButton();
            button.valign = Gtk.Align.CENTER;
            button.halign = Gtk.Align.END;
            if (last_button != null) {
                button.set_group(last_button);
            }
            row.add_suffix(button);
            this.pref_group.add (row);
            return row;
        }
    }
}