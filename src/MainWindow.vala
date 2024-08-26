 public class StillTerminal.MainWindow : Adw.ApplicationWindow {
    // GLib.ListStore clocks_list_store;
    public Adw.TabBar tab_bar;
    public Adw.TabView tab_view;
    public StillTerminal.StSettings settings;

    public MainWindow (Adw.Application app) {
        Object (application: app);

        this.settings = new StillTerminal.StSettings ();
        this.default_height = 400;
        this.default_width = 600;

        
        // Load the CSS file
        var css_provider = new Gtk.CssProvider ();
        // TODO: Change this to be a gresource
        css_provider.load_from_path ("/home/cameronknauff/Documents/stillTerminal/data/style.css");
        Gtk.StyleContext.add_provider_for_display (
            Gdk.Display.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );

        var header = new Adw.HeaderBar ();

        this.tab_view = new Adw.TabView ();

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
        box.append (new StHeaderBar (this));
        box.append (tab_view);

        this.add_tab (get_system_profile ());
        this.add_tab (get_system_profile ());

        this.content = box;
    }

    public void add_tab (StProfile profile) {
        var page = new StTerminalPage (this.settings, profile);
        Adw.TabPage tab_page = this.tab_view.add_page (page.scrolled_window, null);
    }
 }