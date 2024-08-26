namespace StillTerminal {
    public class StPrefsGeneralPage : Adw.PreferencesPage {
        public StPrefsWindowGroup window_group;
        public StPrefsCellSpacingGroup cell_spacing_group;
        
        public StPrefsGeneralPage () {
            this.window_group = new StPrefsWindowGroup ();

            this.set_title ("General");
            this.set_icon_name ("utilities-terminal-symbolic");
        }
    }

    public class StPrefsWindowGroup : Adw.PreferencesGroup {
        public Adw.SpinRow window_width;
        public Adw.SpinRow window_height;
        public Adw.SwitchRow save_window_size;

        public StPrefsWindowGroup () {
            this.set_title("Cell Spacing");

            this.window_width = new Adw.SpinRow.with_range (100, 2, 0.05);
            this.window_width.set_title ("Terminal Cell Width");

            this.window_height = new Adw.SpinRow.with_range (100, 2, 0.05);
            this.window_height.set_title ("Terminal Cell Height");
        }

        public void get_max_size (out int width, out int height) {
            var display = Gdk.Display.get_default ();
            var monitors = display.get_monitors ();
            var n_monitors = monitors.get_n_items();
            var monitor_index = 0;
            width = 0;
            height = 0;

            while (monitor_index < n_monitors) {
                var monitor = monitors.get_item (monitor_index);
                if (monitor != null) {
                    var geometry = monitor.get_geometry ();
                    var monitor_width = geometry.get_width ();
                    var monitor_height = geometry.get_height ();
                    width = Math.fmax (monitor_width, width);
                    height = Math.fmax (monitor_height, height);
                }
                monitor_index++;
            }
        }
    }

    public class StPrefsCellSpacingGroup : Adw.PreferencesGroup {
        public Adw.SpinRow cell_width;
        public Adw.SpinRow cell_height;

        public StPrefsCellSpacingGroup () {
            this.set_title("Cell Spacing");

            this.cell_width = new Adw.SpinRow.with_range (1, 2, 0.05);
            this.cell_width.set_title ("Terminal Cell Width");

            this.cell_height = new Adw.SpinRow.with_range (1, 2, 0.05);
            this.cell_height.set_title ("Terminal Cell Height");
        }
    }
}