namespace StillTerminal {

    public class StTerminalPage : GLib.Object {
        //  Adw.TabPage tab_page;
        public StTerminal terminal;
        public Gtk.ScrolledWindow scrolled_window;

        public StTerminalPage (StSettings settings, StProfile profile) {
            terminal = new StTerminal(settings, profile);
            scrolled_window = new Gtk.ScrolledWindow();
            scrolled_window.set_overlay_scrolling (true);
            scrolled_window.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
            scrolled_window.set_child (terminal);
        }
    }
}