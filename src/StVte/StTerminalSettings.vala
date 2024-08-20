namespace StillTerminal {
    public class StTerminalSettings : GLib.Object {
        // General Settings
        public int window_width { get; set; }
        public int window_height { get; set; }
        public bool keep_window_size { get; set; }
        public bool use_custom_font { get; set; }
        public string custom_font { get; set; }
        public double cell_height { get; set; }
        public double cell_width { get; set; }
        public bool bold_is_bright { get; set; }
        public bool easy_copy_paste { get; set; }
    
        // Appearance
        public string system_color { get; set; }
        public bool use_profile_color { get; set; }
        public bool use_tab_color { get; set; }
        public int padding { get; set; }
        public int opacity { get; set; }
    
        // Scroll
        public bool show_scrollbar { get; set; }
        public int scrollback_limit { get; set; }
    
        // Misc
        public bool notification_on_task { get; set; }
        public GLib.Settings settings = new GLib.Settings ("io.stillhq.terminal");
    
        public StTerminalSettings () {
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
    
        public void bind_to_window (Gtk.Window window) {
            settings.bind ("window-width", window, "default_width", SettingsBindFlags.DEFAULT);
            settings.bind ("window-height", window, "default_height", SettingsBindFlags.DEFAULT);
        }
    
        public void bind_to_vte (Adw.Bin bin, Vte.Terminal vte) {
            settings.bind ("cell-height", vte, "cell_height_scale", SettingsBindFlags.DEFAULT);
            settings.bind ("cell-width", vte, "cell_width_scale", SettingsBindFlags.DEFAULT);
            settings.bind ("bold-is-bright", vte, "bold_is_bright", SettingsBindFlags.DEFAULT);
            settings.bind ("scrollback-limit", vte, "scrollback_lines", SettingsBindFlags.DEFAULT);
    
            settings.bind ("padding", bin, "margin-start", SettingsBindFlags.DEFAULT);
            settings.bind ("padding", bin, "margin-end", SettingsBindFlags.DEFAULT);
            settings.bind ("padding", bin, "margin-top", SettingsBindFlags.DEFAULT);
            settings.bind ("padding", bin, "margin-bottom", SettingsBindFlags.DEFAULT);
        }
    }
}