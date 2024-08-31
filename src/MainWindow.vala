 public class StillTerminal.MainWindow : Adw.ApplicationWindow {
    public Adw.TabBar tab_bar;
    public Adw.TabView tab_view;
    public StillTerminal.StSettings settings;
    public StHeaderBar header;

    public MainWindow (Adw.Application app) {
        Object (application: app);

        this.settings = new StillTerminal.StSettings ();
        this.default_height = this.settings.window_height;
        this.default_width = this.settings.window_width;
        this.add_css_class("transparent-window");

        // Load the CSS file
        var css_provider = new Gtk.CssProvider ();
        // TODO: Change this to be a gresource
        css_provider.load_from_resource ("/io/stillhq/terminal/style.css");
        Gtk.StyleContext.add_provider_for_display (
            Gdk.Display.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );

        this.tab_view = new Adw.TabView ();
        this.header = new StHeaderBar (this);

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.append (this.header);
        box.append (this.tab_view);

        this.add_tab (get_default_profile ());
        this.add_tab (get_fallback_profile ());
        // this.connect ("allocate-size", this.window_resized);

        this.content = box;
    }

    public Adw.TabPage add_tab (StProfile profile) {
        var page = new StTerminalPage (this.settings, profile);
        Adw.TabPage tab_page = this.tab_view.append (page.scrolled_window);
        tab_page.title = profile.name;
        page.terminal.set_tab_page (tab_page);
        this.tab_view.set_selected_page (tab_page);

        tab_page.notify["title"].connect (() => {
            if (this.tab_view.get_n_pages () <= 1 && this.tab_view.get_selected_page () == tab_page) {
                set_window_title (tab_page, page.terminal);
            }
        });

        tab_page.notify["selected"].connect (() => {
            set_window_title (tab_page, page.terminal);
        });

        return tab_page;
    }

    public void set_window_title (Adw.TabPage tab_page, StTerminal terminal) {
        this.header.window_title.set_title (
            terminal.profile.name + ": " +
            terminal.vte.get_window_title ()
        );
    }

    public override void size_allocate (int width, int height, int baseline) {
        if (this.settings.keep_window_size) {
            this.settings.window_width = width;
            this.settings.window_height = height;
        }
        base.size_allocate (width, height, baseline);
    }
}
