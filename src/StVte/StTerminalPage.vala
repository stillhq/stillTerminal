namespace StillTerminal {
    public class StTerminalPage : GLib.Object {
        Adw.TabPage tab_page = new Adw.TabPage ();
        StTerminal terminal = new StTerminal ();
        scrolled_window = new Gtk.ScrolledWindow ();
        scrolled_window.add (terminal.vte);
        tab_page.child = scrolled_window;
    }
}