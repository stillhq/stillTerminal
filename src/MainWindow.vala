namespace StillTerminal {
    public class MainWindow : Adw.ApplicationWindow {
        public Adw.TabBar tab_bar;
        public Adw.TabView tab_view;
        public StillTerminal.StSettings settings;
        public StHeaderBar header;
        public ShortcutController shortcuts = new ShortcutController ();

        public MainWindow (Adw.Application app) {
            Object (application: app);

            this.settings = new StillTerminal.StSettings ();
            this.default_height = this.settings.window_height;
            this.default_width = this.settings.window_width;
            this.add_css_class ("transparent-window");
    
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
    
            this.content = box;
    
            // ACTIONS
            var new_tab_action = new SimpleAction ("new-tab", null);
            new_tab_action.activate.connect (() => {
                this.add_tab (get_default_profile ());
            });
            this.add_action (new_tab_action);
    
            var close_tab_action = new SimpleAction ("close-tab", null);
            close_tab_action.activate.connect (() => {
                if (this.tab_view.get_n_pages () > 1) {
                    this.tab_view.close_page (this.tab_view.get_selected_page ());
                } else {
                    this.close ();
                }
            });
            this.add_action (close_tab_action);
            
            var next_tab_action = new SimpleAction ("next-tab", null);
            next_tab_action.activate.connect (() => {
                var current_page = this.tab_view.get_selected_page ();
                var next_page = this.tab_view.get_nth_page (
                    (this.tab_view.get_page_position (current_page) + 1) % this.tab_view.get_n_pages ()
                );
                this.tab_view.set_selected_page (next_page);
            });
            this.add_action (next_tab_action);
    
            var previous_tab_action = new SimpleAction ("previous-tab", null);
            previous_tab_action.activate.connect (() => {
                var current_page = this.tab_view.get_selected_page ();
                var previous_page = this.tab_view.get_nth_page (
                    (this.tab_view.get_page_position (current_page) - 1 + this.tab_view.get_n_pages ()) % this.tab_view.get_n_pages ()
                );
                this.tab_view.set_selected_page (previous_page);
            });
            this.add_action (previous_tab_action);
    
            var copy_action = new SimpleAction ("copy", null);
            copy_action.activate.connect (() => {
                this.get_current_terminal_page ().terminal.copy_clipboard ();
            });
            this.add_action (copy_action);
    
            var paste_action = new SimpleAction ("paste", null);
            paste_action.activate.connect (() => {
                this.get_current_terminal_page ().terminal.paste_clipboard ();
            });
            this.add_action (paste_action);
    
            var fullscreen_action = new SimpleAction ("fullscreen", null);
            fullscreen_action.activate.connect (() => {
                this.fullscreen ();
            });
            this.add_action (fullscreen_action);
    
            var new_window_action = new SimpleAction ("new-window", null);
            new_window_action.activate.connect (() => {
                var win = new MainWindow (this.get_application () as Adw.Application);
                win.present ();
            });
            this.add_action (new_window_action);
            
            var quit_action = new SimpleAction ("preferences", null);
            quit_action.activate.connect (() => {
                var dialog = new StPrefsDialog (this);
                dialog.present (this);
            });
            this.add_action (quit_action);
    
            var zoom_in_action = new SimpleAction ("zoom-in", null);
            zoom_in_action.activate.connect (() => {
                this.get_current_terminal_page ().modify_zoom (0.1);
            });
            this.add_action (zoom_in_action);
    
            var zoom_out_action = new SimpleAction ("zoom-out", null);
            zoom_out_action.activate.connect (() => {
                this.get_current_terminal_page ().modify_zoom (-0.1);
            });
            this.add_action (zoom_out_action);
            
            // SHORTCUTS
            this.add_controller (shortcuts.controller);
            this.settings.bind_to_shortcut_controller (shortcuts);
            this.shortcuts.refresh_shortcuts ();
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
                terminal.get_window_title ()
            );
        }
    
        public StTerminalPage get_current_terminal_page () {
            return this.tab_view.get_selected_page ().get_child () as StTerminalPage;
        }
    
        public override void size_allocate (int width, int height, int baseline) {
            if (this.settings.keep_window_size) {
                this.settings.window_width = width;
                this.settings.window_height = height;
            }
            base.size_allocate (width, height, baseline);
        }
    }
}