namespace StillTerminal {
    public class StHeaderBar : Adw.Bin {
        public Adw.WindowTitle window_title;
        MainWindow main_window;
        StProfile[] profiles;
        Adw.TabBar tab_bar;
        Gtk.MenuButton new_tab_button;
        Gtk.Button settings_button;
        Gtk.Box box;

        public StHeaderBar (MainWindow main_window) {
            this.main_window = main_window;
            var window_handle = new Gtk.WindowHandle();
            this.add_css_class ("custom-headerbar");
            this.child = window_handle;

            this.box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            window_handle.child = this.box;

            var start_controls = new Gtk.WindowControls(Gtk.PackType.START);
            start_controls.add_css_class("custom-headerbar");
            start_controls.set_margin_start(5);
            this.box.append(start_controls);

            //  var tab_button = new Gtk.Button.from_icon_name ("view-grid-symbolic");
            //  tab_button.set_valign(Gtk.Align.CENTER);
            //  tab_button.clicked.connect (() => {
            //      this.main_window.tab_view.set_visible (!this.main_window.tab_view.get_visible ());
            //  });
            //  add_button_to_box (tab_button);

            var tab_overlay = new Gtk.Overlay();
            tab_overlay.hexpand = true;
            tab_overlay.halign = Gtk.Align.FILL;
            this.box.append (tab_overlay);

            this.window_title = new Adw.WindowTitle("stillTerminal", "");
            this.window_title.set_halign (Gtk.Align.CENTER);
            this.window_title.set_margin_top(20);
            this.window_title.set_margin_bottom(19);
            tab_overlay.set_child(this.window_title);

            this.tab_bar = new Adw.TabBar ();
            this.tab_bar.set_hexpand (true);
            this.tab_bar.set_halign (Gtk.Align.FILL);
            this.tab_bar.set_view(this.main_window.tab_view);
            this.tab_bar.set_margin_end(5);
            tab_overlay.add_overlay(this.tab_bar);

            this.new_tab_button = new Gtk.MenuButton ();
            this.new_tab_button.set_icon_name ("list-add-symbolic");
            this.new_tab_button.valign = Gtk.Align.CENTER;
            this.new_tab_button.halign = Gtk.Align.CENTER;
            this.new_tab_button.add_css_class ("circular");
            this.new_tab_button.add_css_class ("flat");
            this.new_tab_button.set_margin_end(5);
            this.new_tab_button.vexpand = true;
            this.new_tab_button.valign = Gtk.Align.CENTER;
            this.box.append (this.new_tab_button);

            this.settings_button = new Gtk.Button.from_icon_name ("settings-symbolic");
            this.settings_button.clicked.connect (() => {
                var dialog = new StPrefsDialog (this.main_window);
                dialog.present (this);
            });
            add_button_to_box (this.settings_button);
            
            var end_controls = new Gtk.WindowControls (Gtk.PackType.END);
            end_controls.set_margin_end (5);
            end_controls.add_css_class ("custom-headerbar");
            this.box.append (end_controls);

            update_new_tab_menu();
        }

        public void add_button_to_box(Gtk.Button button) {
            button.add_css_class ("circular");
            button.add_css_class ("flat");
            button.set_margin_end(5);
            button.vexpand = true;
            button.valign = Gtk.Align.CENTER;
            this.box.append (button);
        }

        public void update_new_tab_menu () {
            var menu = new GLib.Menu();
            this.profiles = get_profiles ();
            foreach (var profile in this.profiles) {var action = new GLib.SimpleAction (profile.id, null);
                action.activate.connect (() => {
                    this.main_window.add_tab (profile);
                });
                var app = this.main_window.get_application ();
                if (app.has_action(profile.id)) {
                    app.remove_action (profile.id);
                }
                app.add_action (action);
                menu.append(profile.name, "app." + profile.id);
            }
            var popover = new Gtk.PopoverMenu.from_model (menu);
            this.new_tab_button.set_popover (popover);
        }
    }
}