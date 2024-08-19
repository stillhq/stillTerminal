public class StillTerm.MainWindow : Gtk.ApplicationWindow {
    // GLib.ListStore clocks_list_store;
    public MainWindow (Gtk.Application app) {
        Object (application: app);

        this.default_height = 400;
        this.default_width = 600;

        var header = new Gtk.HeaderBar ();
        this.set_titlebar (header);

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
        box.append (new StTerminal ());

        this.child = box;
    }
}