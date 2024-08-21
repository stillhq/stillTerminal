public class StillTerminal.App : Adw.Application {
    // Member variables

    // Constructor
    public App () {
        Object (application_id: "io.stillhq.stillTerminal",
                flags : GLib.ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var win = this.get_active_window ();
        if (win == null) {
            win = new MainWindow (this);
        }
        win.present ();
    }

    protected override void open (GLib.File[] files, string hint) {
    }
}

int main (string[] args) {
 // Load the CSS file
    var css_provider = new Gtk.CssProvider ();
    // TODO: Change this to be a gresource
    css_provider.load_from_path ("/home/cameronknauff/Documents/stillTerminal/data/style.css");
    Gtk.StyleContext.add_provider_for_display (
        Gdk.Display.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
    );

    var my_app = new StillTerminal.App ();
    return my_app.run (args);
}
