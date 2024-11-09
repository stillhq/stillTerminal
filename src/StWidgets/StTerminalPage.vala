namespace StillTerminal {

    public class DynamicStyleManager : GLib.Object {
        private Gtk.CssProvider provider;

        public DynamicStyleManager () {
            provider = new Gtk.CssProvider ();
            Gtk.StyleContext.add_provider_for_display (
                Gdk.Display.get_default (), provider, 
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }

        public void update_style(string css) {
            try {
                provider.load_from_string(css);
            } catch (Error e) {
                warning("Failed to load CSS: %s", e.message);
            }
        }
    }

    public class StTerminalPage : GLib.Object {
        public Adw.StyleManager style_manager;
        public StTerminal terminal;
        public Gtk.ScrolledWindow scrolled_window;
        public DynamicStyleManager dynamic_style_manager = new DynamicStyleManager ();

        public StTerminalPage (StSettings settings, StProfile profile) {
            terminal = new StTerminal (settings, profile);
            scrolled_window = new Gtk.ScrolledWindow();
            scrolled_window.add_css_class("terminal-scrolled-window");
            scrolled_window.set_overlay_scrolling (true);
            this.set_scrollbar_visibility(settings.show_scrollbar);
            scrolled_window.set_child (terminal);

            this.style_manager = Adw.StyleManager.get_default ();

            settings.settings.changed.connect((key) => {
                if (key == "show-scrollbar") {
                    this.set_scrollbar_visibility(settings.show_scrollbar);
                }
            });
        }

        public void modify_zoom (double zoom) {
            var new_scale = this.terminal.font_scale + zoom;
            if (new_scale < 0.20) {
                new_scale = 0.20;
            } else if (new_scale > 5.0) {
                new_scale = 5.0;
            }
            this.terminal.font_scale = new_scale;
        }

        public void update_background_color () {
            bool is_dark = this.style_manager.dark;
            string color_scheme_name = this.terminal.profile.color_scheme;
            
            if (color_scheme_name == "system" || !(this.terminal.settings.use_profile_color)) {
                color_scheme_name = this.terminal.settings.system_color;
            }
            var color_scheme = StColorScheme.new_from_id(color_scheme_name);

            if (color_scheme == null) {
                this.dynamic_style_manager.update_style("""
                :root {
                    --alpha-value: %.2f;
                }
                .my-element {
                    color: rgba(currentColor, var(--alpha-value));
                }""".printf (this.terminal.settings.opacity));
                return;
            }

            // Set color scheme
            Gdk.RGBA background_color = Gdk.RGBA ();

            if (is_dark) {
                background_color.parse ( color_scheme.dark_background_color );
            } else {
                background_color.parse ( color_scheme.light_background_color );
            }

            background_color.alpha = (float) this.terminal.settings.opacity * 0.01f;
        }

        public void set_scrollbar_visibility (bool visible) {
            var policy = Gtk.PolicyType.AUTOMATIC;
            if (!visible) {
                policy = Gtk.PolicyType.NEVER;
            }
            scrolled_window.set_policy (policy, policy);
        }
    }
}