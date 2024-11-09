namespace StillTerminal {
    public class ShortcutController : GLib.Object {
        public string new_tab { get; set; default = "<Control><Shift>t"; }
        public string close_tab { get; set; default = "<Control><Shift>w"; }
        public string next_tab { get; set; default = "<Control>Tab"; }
        public string previous_tab { get; set; default = "<Control><Shift>Tab"; }
        public string copy { get; set; default = "<Control><Shift>c"; }
        public string paste { get; set; default = "<Control><Shift>v"; }
        public string fullscreen { get; set; default = "F11"; }
        public string new_window { get; set; default = "<Control>n"; }
        public string preferences { get; set; default = "<Control>comma"; }
        public string zoom_in { get; set; default = "<Control><Shift>plus"; }
        public string zoom_out { get; set; default = "<Control>minus"; }

        public Gtk.Shortcut new_tab_shortcut;
        public Gtk.Shortcut close_tab_shortcut;
        public Gtk.Shortcut next_tab_shortcut;
        public Gtk.Shortcut previous_tab_shortcut;
        public Gtk.Shortcut copy_shortcut;
        public Gtk.Shortcut paste_shortcut;
        public Gtk.Shortcut fullscreen_shortcut;
        public Gtk.Shortcut new_window_shortcut;
        public Gtk.Shortcut preferences_shortcut;
        public Gtk.Shortcut zoom_in_shortcut;
        public Gtk.Shortcut zoom_out_shortcut;

        public Gtk.ShortcutController controller = new Gtk.ShortcutController();

        public void refresh_shortcuts () {

            string[] actions = {
                new_tab, close_tab, next_tab, previous_tab, copy, paste,
                fullscreen, new_window, preferences, zoom_in, zoom_out
            };
            Gtk.Shortcut[] shortcuts = {
                new_tab_shortcut, close_tab_shortcut, next_tab_shortcut, previous_tab_shortcut,
                copy_shortcut, paste_shortcut, fullscreen_shortcut, new_window_shortcut,
                preferences_shortcut, zoom_in_shortcut, zoom_out_shortcut
            };

            for (int i = 0; i < actions.length; i++) {
                string action = actions[i];
                Gtk.Shortcut shortcut = shortcuts[i];
                Gtk.ShortcutTrigger? trigger = Gtk.ShortcutTrigger.parse_string(action);
                if (trigger != null) {
                    shortcut.set_trigger(trigger);
                }
            }
        }

        public ShortcutController() {
            new_tab_shortcut = new Gtk.Shortcut(null, Gtk.ShortcutAction.parse_string("new_tab"));
            close_tab_shortcut = new Gtk.Shortcut(null, Gtk.ShortcutAction.parse_string("close_tab"));
            next_tab_shortcut = new Gtk.Shortcut(null, Gtk.ShortcutAction.parse_string("next_tab"));
            previous_tab_shortcut = new Gtk.Shortcut(null, Gtk.ShortcutAction.parse_string("previous_tab"));
            copy_shortcut = new Gtk.Shortcut(null, Gtk.ShortcutAction.parse_string("copy"));
            paste_shortcut = new Gtk.Shortcut(null, Gtk.ShortcutAction.parse_string("paste"));
            fullscreen_shortcut = new Gtk.Shortcut(null, Gtk.ShortcutAction.parse_string("fullscreen"));
            new_window_shortcut = new Gtk.Shortcut(null, Gtk.ShortcutAction.parse_string("new_window"));
            preferences_shortcut = new Gtk.Shortcut(null, Gtk.ShortcutAction.parse_string("preferences"));
            zoom_in_shortcut = new Gtk.Shortcut(null, Gtk.ShortcutAction.parse_string("zoom_in"));
            zoom_out_shortcut = new Gtk.Shortcut(null, Gtk.ShortcutAction.parse_string("zoom_out"));

            Gtk.Shortcut[] shortcuts = {
                new_tab_shortcut, close_tab_shortcut, next_tab_shortcut, previous_tab_shortcut,
                copy_shortcut, paste_shortcut, fullscreen_shortcut, new_window_shortcut,
                preferences_shortcut, zoom_in_shortcut, zoom_out_shortcut
            };

            refresh_shortcuts ();
            foreach (Gtk.Shortcut shortcut in shortcuts) {
                this.controller.add_shortcut (shortcut);
            }
        }
    }
}