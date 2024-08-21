 class StillTerminal.MainWindow : Adw.ApplicationWindow {
    // GLib.ListStore clocks_list_store;
    public Adw.TabBar tab_bar;
    public Adw.TabView tab_view;

    public MainWindow (Adw.Application app) {
        Object (application: app);

        StillTerminal.StSettings settings = new StillTerminal.StSettings ();
        this.default_height = 400;
        this.default_width = 600;

        var header = new Adw.HeaderBar ();

        this.tab_view = new Adw.TabView ();

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
        box.append (new StHeaderBar (this.tab_view));
        box.append (tab_view);                                              
        
        this.add_tab(settings, get_system_profile ());
        this.add_tab(settings, get_system_profile ());

        this.content = box;
    }

    public void add_tab (StSettings settings, StProfile profile) {
        var page = new StTerminalPage (settings, profile);
        Adw.TabPage tab_page = this.tab_view.add_page (page.scrolled_window, null);
    }
}