namespace StillTerminal {
    public class StHeaderBar : Adw.Bin {
        Gtk.HeaderBar header_bar;
        Adw.TabBar tab_bar;
        Gtk.Button new_tab_button;
        Gtk.Button settings_button;

        public StHeaderBar (MainWindow main_window) {
            this.add_css_class ("custom-headerbar");
            this.header_bar.add_css_class ("flat");
            this.tab_bar.add_css_class ("flat");

            this.header_bar = new Gtk.HeaderBar ();
            this.tab_bar = new Adw.TabBar ();

            this.tab_bar.set_hexpand (true);
            this.tab_bar.set_halign (Gtk.Align.FILL);
            this.tab_bar.set_view(main_window.tab_view);
            this.header_bar.pack_start (this.tab_bar);
            this.child = this.header_bar;

            this.new_tab_button = new Gtk.Button.from_icon_name ("list-add-symbolic");
            this.new_tab_button.clicked.connect (() => {
                main_window.add_tab (get_system_profile ());
            });
            this.new_tab_button.valign = Gtk.Align.CENTER;
            this.new_tab_button.halign = Gtk.Align.CENTER;
            this.new_tab_button.add_css_class ("circular");
            this.header_bar.pack_end (this.new_tab_button);

            this.settings_button = new Gtk.Button.from_icon_name ("settings-symbolic");
            this.settings_button.clicked.connect (() => {
                var dialog = new StPrefsDialog ();
                dialog.present(this);
            });
            this.settings_button.valign = Gtk.Align.CENTER;
            this.settings_button.halign = Gtk.Align.CENTER;
            this.settings_button.add_css_class ("circular");
            this.header_bar.pack_end (this.settings_button);

        }
    }
}