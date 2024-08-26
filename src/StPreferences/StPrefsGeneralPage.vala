namespace StillTerminal {
    public class StPrefsGeneralPage : Adw.PreferencesPage {
        public StPrefsWindowGroup window_group;
        public StPrefsCellSpacingGroup cell_spacing_group;
        
        public StPrefsGeneralPage () {
            this.window_group = new StPrefsWindowGroup ();
            this.cell_spacing_group = new StPrefsCellSpacingGroup ();

            this.set_title ("General");
            this.set_icon_name ("utilities-terminal-symbolic");

            this.add (this.window_group);
            this.add (this.cell_spacing_group);
        }
    }

    public class StPrefsWindowGroup : Adw.PreferencesGroup {
        public Adw.SpinRow window_width;
        public Adw.SpinRow window_height;
        public Adw.SwitchRow save_window_size;

        public StPrefsWindowGroup () {
            this.set_title("Window Size");
            double max_width;
            double max_height;
            this.get_max_size (out max_width, out max_height);

            this.window_width = new Adw.SpinRow.with_range (400, max_width, 5);
            this.window_width.set_title ("Default Window Width");
            this.window_width.set_subtitle("Default: 600");
            this.window_width.set_digits(0);

            this.window_height = new Adw.SpinRow.with_range (300, max_height, 5);
            this.window_height.set_title ("Default Window Height");
            this.window_height.set_subtitle("Default: 400");
            this.window_height.set_digits(0);

            this.save_window_size = new Adw.SwitchRow ();
            this.save_window_size.set_title ("Save Window Size");

            this.add (this.window_width);
            this.add (this.window_height);
            this.add (this.save_window_size);
        }

        public void get_max_size (out double width, out double height) {
            var display = Gdk.Display.get_default ();
            var monitors = display.get_monitors ();
            var n_monitors = monitors.get_n_items();
            var monitor_index = 0;
            width = 0;
            height = 0;

            while (monitor_index < n_monitors) {
                var monitor = monitors.get_item (monitor_index) as Gdk.Monitor;
                if (monitor != null) {
                    var rect = monitor.get_geometry ();
                    var monitor_width = rect.width;
                    var monitor_height = rect.height;
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

            this.add (this.cell_width);
            this.add (this.cell_height);
        }
    }
}