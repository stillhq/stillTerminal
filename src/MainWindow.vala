 class StillTerminal.MainWindow : Adw.ApplicationWindow {
    // GLib.ListStore clocks_list_store;
    public Adw.TabBar tab_bar;
    public Adw.TabView tab_view;

    public MainWindow (Adw.Application app) {
        Object (application: app);

        StillTerminal.StTerminalSettings settings = new StillTerminal.StTerminalSettings ();
        this.default_height = 400;
        this.default_width = 600;

        var header = new Adw.HeaderBar ();

        this.tab_bar = new Adw.TabBar ();
        this.tab_view = new Adw.TabView ();
        this.tab_bar.hexpand = true;
        this.tab_bar.halign = Gtk.Align.FILL;
        this.tab_bar.set_view(this.tab_view);
        
        var header_content = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        header_content.hexpand = true;
        header_content.append(new Gtk.WindowControls (Gtk.PackType.START));
        header_content.append(this.tab_bar);
        header_content.append(new Gtk.WindowControls (Gtk.PackType.END));
        header.set_show_end_title_buttons (false);
        header.set_show_start_title_buttons (false);
        header.set_title_widget (header_content);

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
        box.append (header);
        box.append (tab_view);                                              
        
        this.add_tab(settings, get_system_profile ());
        this.add_tab(settings, get_system_profile ());

        this.content = box;
    }

    public void add_tab (StTerminalSettings settings, StProfile profile) {
        var page = new StTerminalPage (settings, profile);
        Adw.TabPage tab_page = this.tab_view.add_page (page.scrolled_window, null);
    }
}