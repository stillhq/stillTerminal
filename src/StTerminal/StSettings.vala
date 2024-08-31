namespace StillTerminal {
    public class StSettings : GLib.Object {
        // General Settings
        public int window_width { get; set; }
        public int window_height { get; set; }
        public bool keep_window_size { get; set; }
        public double cell_height { get; set; }
        public double cell_width { get; set; }
    
        // Appearance
        public string system_color { get; set; }
        public bool use_profile_color { get; set; }
        public bool use_tab_color { get; set; }
        public int padding { get; set; }
        public int opacity { get; set; }
        public bool use_custom_font { get; set; }
        public string custom_font { get; set; }
        public bool bold_is_bright { get; set; }
    
        // Scroll
        public bool show_scrollbar { get; set; }
        public int scrollback_limit { get; set; }
    
        // Misc
        public bool easy_copy_paste { get; set; }
        public bool notification_on_task { get; set; }
        public GLib.Settings settings;
    
        public StSettings () {
            settings = new GLib.Settings ("io.stillhq.terminal");
            settings.bind ("window-width", this, "window_width", SettingsBindFlags.DEFAULT);
            settings.bind ("window-height", this, "window_height", SettingsBindFlags.DEFAULT);
            settings.bind ("keep-window-size", this, "keep_window_size", SettingsBindFlags.DEFAULT);
            settings.bind ("use-custom-font", this, "use_custom_font", SettingsBindFlags.DEFAULT);
            settings.bind ("custom-font", this, "custom_font", SettingsBindFlags.DEFAULT);
            settings.bind ("cell-height", this, "cell_height", SettingsBindFlags.DEFAULT);
            settings.bind ("cell-width", this, "cell_width", SettingsBindFlags.DEFAULT);
            settings.bind ("bold-is-bright", this, "bold_is_bright", SettingsBindFlags.DEFAULT);
            settings.bind ("easy-copy-paste", this, "easy_copy_paste", SettingsBindFlags.DEFAULT);
            settings.bind ("system-color", this, "system_color", SettingsBindFlags.DEFAULT);
            settings.bind ("use-profile-color", this, "use_profile_color", SettingsBindFlags.DEFAULT);
            settings.bind ("use-tab-color", this, "use_tab_color", SettingsBindFlags.DEFAULT);
            settings.bind ("padding", this, "padding", SettingsBindFlags.DEFAULT);
            settings.bind ("opacity", this, "opacity", SettingsBindFlags.DEFAULT);
            settings.bind ("show-scrollbar", this, "show_scrollbar", SettingsBindFlags.DEFAULT);
            settings.bind ("scrollback-limit", this, "scrollback_limit", SettingsBindFlags.DEFAULT);
            settings.bind ("notification-on-task", this, "notification_on_task", SettingsBindFlags.DEFAULT);
        }
  
        public void bind_to_vte (StTerminal bin, Vte.Terminal vte) {
            settings.bind ("cell-height", vte, "cell_height_scale", SettingsBindFlags.DEFAULT);
            settings.bind ("cell-width", vte, "cell_width_scale", SettingsBindFlags.DEFAULT);
            settings.bind ("bold-is-bright", vte, "bold_is_bright", SettingsBindFlags.DEFAULT);
            settings.bind ("scrollback-limit", vte, "scrollback_lines", SettingsBindFlags.DEFAULT);
    
            settings.bind ("padding", bin, "margin-start", SettingsBindFlags.DEFAULT);
            settings.bind ("padding", bin, "margin-end", SettingsBindFlags.DEFAULT);
            settings.bind ("padding", bin, "margin-top", SettingsBindFlags.DEFAULT);
            settings.bind ("padding", bin, "margin-bottom", SettingsBindFlags.DEFAULT);

            bin.style_manager.notify["dark"].connect(
                (_style_manager, _pspec) => {
                    bin.set_appearance ();
                }
            );

            if (bin.profile.color_scheme == "system") {
                this.notify["system-color"].connect(
                    (_settings, _pspec) => {
                        bin.set_appearance ();
                    }
                );
            }

            this.notify["use-profile-color"].connect(
                (_settings, _pspec) => {
                    bin.set_appearance ();
                }
            );
            this.notify["opacity"].connect(
                (_settings, _pspec) => {
                    bin.set_appearance ();
                }
            );
        }

        public void bind_to_general (StPrefsGeneralPage general) {
            settings.bind ("window-width", general.window_group.window_width, "value", SettingsBindFlags.DEFAULT);
            settings.bind ("window-height", general.window_group.window_height, "value", SettingsBindFlags.DEFAULT);
            settings.bind ("keep-window-size", general.window_group.save_window_size, "active", SettingsBindFlags.DEFAULT);
            settings.bind ("keep-window-size", general.window_group.window_width, "sensitive", SettingsBindFlags.INVERT_BOOLEAN);
            settings.bind ("keep-window-size", general.window_group.window_height, "sensitive", SettingsBindFlags.INVERT_BOOLEAN);
            settings.bind ("cell-height", general.cell_spacing_group.cell_height, "value", SettingsBindFlags.DEFAULT);
            settings.bind ("cell-width", general.cell_spacing_group.cell_width, "value", SettingsBindFlags.DEFAULT);
            settings.bind ("use-profile-color", general.appearance_group.use_profile_color, "active", SettingsBindFlags.DEFAULT);
            settings.bind ("use-tab-color", general.appearance_group.use_tab_color, "active", SettingsBindFlags.DEFAULT);
            settings.bind ("padding", general.appearance_group.padding, "value", SettingsBindFlags.DEFAULT);
            settings.bind ("opacity", general.appearance_group.opacity_setting, "value", SettingsBindFlags.DEFAULT);
            settings.bind ("use-custom-font", general.appearance_group.use_custom_font, "active", SettingsBindFlags.DEFAULT);
            settings.bind ("use-custom-font", general.appearance_group.custom_font, "sensitive", SettingsBindFlags.DEFAULT);
            settings.bind ("bold-is-bright", general.appearance_group.bold_is_bright, "active", SettingsBindFlags.DEFAULT);

            // Connecting dropdown to system color
            general.appearance_group.scheme_setting_changed(this.settings, "system-color");

            general.appearance_group.system_color.notify["selected"].connect(
                (_combo, _spec) => {
                    general.appearance_group.scheme_dropdown_changed(this.settings);
                }
            );
            settings.changed.connect((key) => {
                if (key == "system-color") {
                    general.appearance_group.scheme_setting_changed(this.settings, key);
                }
            });

            // Connecting the font button
            general.appearance_group.font_button.set_font_desc(
                Pango.FontDescription.from_string(this.custom_font)
            );
            general.appearance_group.font_button.notify["font-desc"].connect(
                (_button) => {
                    general.appearance_group.font_button_changed(this.settings);
                }
            );
            settings.changed.connect((key) => {
                if (key == "custom-font") {
                    general.appearance_group.font_setting_changed(this.settings, key);
                }
            });
        }
    }
}