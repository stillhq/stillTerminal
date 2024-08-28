namespace StillTerminal {
    public class StPrefsGeneralPage : Adw.PreferencesPage {
        public StPrefsWindowGroup window_group;
        public StPrefsCellSpacingGroup cell_spacing_group;
        public StPrefsAppearanceGroup appearance_group;
        
        public StPrefsGeneralPage () {
            this.window_group = new StPrefsWindowGroup ();
            this.cell_spacing_group = new StPrefsCellSpacingGroup ();
            this.appearance_group = new StPrefsAppearanceGroup ();

            this.set_title ("General");
            this.set_icon_name ("utilities-terminal-symbolic");

            this.add (this.window_group);
            this.add (this.cell_spacing_group);
            this.add (this.appearance_group);
        }
    }

    public class StPrefsWindowGroup : Adw.PreferencesGroup {
        public Adw.SpinRow window_width;
        public Adw.SpinRow window_height;
        public Adw.SwitchRow save_window_size;

        public StPrefsWindowGroup () {
            this.set_title("Window Size");
            double max_width;
            double max_height;
            this.get_max_size (out max_width, out max_height);

            this.window_width = new Adw.SpinRow.with_range (400, max_width, 5);
            this.window_width.set_title ("Default Window Width");
            this.window_width.set_subtitle("Default: 600");
            this.window_width.set_digits(0);

            this.window_height = new Adw.SpinRow.with_range (300, max_height, 5);
            this.window_height.set_title ("Default Window Height");
            this.window_height.set_subtitle("Default: 400");
            this.window_height.set_digits(0);

            this.save_window_size = new Adw.SwitchRow ();
            this.save_window_size.set_title ("Save Window Size");

            this.add (this.window_width);
            this.add (this.window_height);
            this.add (this.save_window_size);
        }

        public void get_max_size (out double width, out double height) {
            var display = Gdk.Display.get_default ();
            var monitors = display.get_monitors ();
            var n_monitors = monitors.get_n_items();
            var monitor_index = 0;
            width = 0;
            height = 0;

            while (monitor_index < n_monitors) {
                var monitor = monitors.get_item (monitor_index) as Gdk.Monitor;
                if (monitor != null) {
                    var rect = monitor.get_geometry ();
                    var monitor_width = rect.width;
                    var monitor_height = rect.height;
                    width = Math.fmax (monitor_width, width);
                    height = Math.fmax (monitor_height, height);
                }
                monitor_index++;
            }
        }
    }

    public class StPrefsCellSpacingGroup : Adw.PreferencesGroup {
        public Adw.SpinRow cell_width;
        public Adw.SpinRow cell_height;

        public StPrefsCellSpacingGroup () {
            this.set_title("Cell Spacing");

            this.cell_width = new Adw.SpinRow.with_range (1, 2, 0.05);
            this.cell_width.set_title ("Terminal Cell Width");

            this.cell_height = new Adw.SpinRow.with_range (1, 2, 0.05);
            this.cell_height.set_title ("Terminal Cell Height");

            this.add (this.cell_width);
            this.add (this.cell_height);
        }
    }

    public class StPrefsAppearanceGroup : Adw.PreferencesGroup {
        public bool change_settings = false;
        public Adw.ComboRow system_color;
        private string[] available_scheme_strings = {};
        public Adw.SwitchRow use_profile_color;
        public Adw.SwitchRow use_tab_color;
        public Adw.SpinRow padding;
        public Adw.SpinRow opacity_setting; // different name to avoid conflict with opacity property
        public Adw.SwitchRow use_custom_font;
        public Adw.ActionRow custom_font;
        public Adw.SwitchRow bold_is_bright;
        public Gtk.FontDialogButton font_button;
        public Gtk.FontDialog font_dialog;

        public StPrefsAppearanceGroup () {
            this.set_title ("Appearance");

            this.system_color = new Adw.ComboRow ();
            this.system_color.set_title ("System Color Scheme");
            var available_schemes = get_available_schemes ();
            foreach (var scheme in available_schemes.keys) {
                this.available_scheme_strings += scheme;
            }

            this.system_color.set_model(
                new Gtk.StringList(available_scheme_strings)
            );

            this.use_profile_color = new Adw.SwitchRow ();
            this.use_profile_color.set_title ("Use Profile Specific Color Scheme");

            this.use_tab_color = new Adw.SwitchRow ();
            this.use_tab_color.set_title ("Use Tab Color Scheme");

            this.padding = new Adw.SpinRow.with_range (0, 10, 1);
            this.padding.set_title ("Padding");

            this.opacity_setting = new Adw.SpinRow.with_range (0, 100, 1);
            this.opacity_setting.set_title ("Opacity");

            this.use_custom_font = new Adw.SwitchRow ();
            this.use_custom_font.set_title ("Use Custom Font");
            this.font_button = new Gtk.FontDialogButton ();
            this.font_dialog = new Gtk.FontDialog ();


            this.custom_font = new Adw.ActionRow ();
            this.custom_font.set_title ("Custom Font");

            this.bold_is_bright = new Adw.SwitchRow ();
            this.bold_is_bright.set_title ("Bold is Bright");

            this.add (this.system_color);
            this.add (this.use_profile_color);
            this.add (this.use_tab_color);
            this.add (this.padding);
            this.add (this.opacity_setting);
            this.add (this.use_custom_font);
            this.add (this.custom_font);
            this.add (this.bold_is_bright);
        }

        public void scheme_dropdown_changed (Settings settings) {
            print("dropdown changed");
            string selected_scheme = available_scheme_strings[this.system_color.get_selected ()];
            if (settings.get_string("system-color") == selected_scheme) {
                return;
            }

            settings.set_string("system-color", selected_scheme);
        }

        public void scheme_setting_changed (GLib.Settings settings, string key) {
            if (key != "system-color") {
                return;
            }

            var scheme = settings.get_string (key);
            if (scheme == this.available_scheme_strings[this.system_color.get_selected()]) {
                return;
            }
            for (int i = 0; i < this.available_scheme_strings.length; i++) {
                if (this.available_scheme_strings[i] == scheme) {
                    this.system_color.set_selected (i);
                    return;
                }
            }
        }
    }
}