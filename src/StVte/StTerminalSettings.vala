class StTerminalSettings {
    // General Settings
    int window_width;
    int window_height;
    bool keep_window_size;
    bool use_custom_font;
    string custom_font;
    double cell_height;
    double cell_width;
    bool bold_is_bright;
    bool easy_copy_paste;

    // Appearance
    string system_color;
    bool use_profile_color;
    bool use_tab_color;
    int padding;
    int opacity;

    // Scroll
    bool show_scrollbar;
    int scrollback_limit;

    // Misc
    bool notification_on_task;


    public StTerminalSettings () {
        GLib.Settings settings = new GLib.Settings ("io.stillhq.terminal");
        this.window_width = settings.get_int ("window_width");
        this.window_height = settings.get_int ("window_height");
        this.keep_window_size = settings.get_boolean ("keep_window_size");
        this.use_custom_font = settings.get_boolean ("use_custom_font");
        this.custom_font = settings.get_string ("custom_font");
        this.cell_height = settings.get_double ("cell_height");
        this.cell_width = settings.get_double ("cell_width");
        this.bold_is_bright = settings.get_boolean ("bold_is_bright");
        this.easy_copy_paste = settings.get_boolean ("easy_copy_paste");
        this.system_color = settings.get_string ("system_color");
        this.use_profile_color = settings.get_boolean ("use_profile_color");
        this.use_tab_color = settings.get_boolean ("use_tab_color");
        this.padding = settings.get_int ("padding");
        this.opacity = settings.get_int ("opacity");
        this.show_scrollbar = settings.get_boolean ("show_scrollbar");
        this.scrollback_limit = settings.get_int ("scrollback_limit");
        this.notification_on_task = settings.get_boolean ("notification_on_task");
    }
}