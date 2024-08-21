namespace StillTerminal {
    public class StHeaderBar : Adw.Bin {
        Adw.HeaderBar header_bar;
        Adw.TabBar tab_bar;

        public StHeaderBar (Adw.TabView tab_view) {
            this.add_css_class ("custom-headerbar");

            this.header_bar = new Adw.HeaderBar ();
            this.tab_bar = new Adw.TabBar ();
            this.set_child (this.header_bar);

            this.tab_bar.hexpand = true;
            this.tab_bar.halign = Gtk.Align.FILL;
            this.tab_bar.set_view(tab_view);

            var header_content = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            header_content.hexpand = true;
            header_content.append(new Gtk.WindowControls (Gtk.PackType.START));
            header_content.append(this.tab_bar);
            header_content.append(new Gtk.WindowControls (Gtk.PackType.END));

            this.header_bar.set_show_end_title_buttons (false);
            this.header_bar.set_show_start_title_buttons (false);
            this.header_bar.set_title_widget (header_content);
        }
    }
}