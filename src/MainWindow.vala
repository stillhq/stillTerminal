public class StillTerminal.MainWindow : Adw.ApplicationWindow {
    // GLib.ListStore clocks_list_store;
    public MainWindow (Adw.Application app) {
        Object (application: app);

        StillTerminal.StTerminalSettings settings = new StillTerminal.StTerminalSettings ();
        this.default_height = 400;
        this.default_width = 600;

        // var header = new Gtk.HeaderBar ();
        // this.set_titlebar (header);

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
        box.append (new StTerminal (settings));

        this.content = box;
    }
}