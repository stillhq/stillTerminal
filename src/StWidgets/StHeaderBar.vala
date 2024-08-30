namespace StillTerminal {
    public class StHeaderBar : Adw.Bin {
        Adw.WindowTitle window_title;
        Adw.TabBar tab_bar;
        Gtk.Button new_tab_button;
        Gtk.Button settings_button;
        Gtk.Box box;

        public StHeaderBar (MainWindow main_window) {
            var window_handle = new Gtk.WindowHandle();
            this.add_css_class ("custom-headerbar");
            this.child = window_handle;

            this.box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            window_handle.child = this.box;

            var start_controls = new Gtk.WindowControls(Gtk.PackType.START);
            start_controls.add_css_class("custom-headerbar");
            start_controls.set_margin_start(5);
            this.box.append(start_controls);

            var tab_button = new Gtk.Button.from_icon_name ("view-grid-symbolic");
            tab_button.set_valign(Gtk.Align.CENTER);
            tab_button.clicked.connect (() => {
                main_window.tab_view.set_visible (!main_window.tab_view.get_visible ());
            });
            add_button_to_box (tab_button);

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
            this.tab_bar.set_view(main_window.tab_view);
            this.tab_bar.set_margin_end(5);
            tab_overlay.add_overlay(this.tab_bar);

            this.new_tab_button = new Gtk.Button.from_icon_name ("list-add-symbolic");
            this.new_tab_button.clicked.connect (() => {
                main_window.add_tab (get_fallback_profile ());
            });
            this.new_tab_button.valign = Gtk.Align.CENTER;
            this.new_tab_button.halign = Gtk.Align.CENTER;
            add_button_to_box (this.new_tab_button);

            this.settings_button = new Gtk.Button.from_icon_name ("settings-symbolic");
            this.settings_button.clicked.connect (() => {
                var dialog = new StPrefsDialog (main_window);
                dialog.present(this);
            });
            add_button_to_box (this.settings_button);
            
            var end_controls = new Gtk.WindowControls(Gtk.PackType.END);
            end_controls.set_margin_end(5);
            end_controls.add_css_class("custom-headerbar");
            this.box.append(end_controls);
        }

        public void add_button_to_box(Gtk.Button button) {
            button.add_css_class ("circular");
            button.add_css_class ("flat");
            button.set_margin_end(5);
            button.vexpand = true;
            button.valign = Gtk.Align.CENTER;
            this.box.append(button);
        }
    }
}