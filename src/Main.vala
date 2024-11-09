public class StillTerminal.App : Adw.Application {
    // Member variables

    // Constructor
    public App () {
        Object (application_id: "io.stillhq.stillTerminal",
            flags : GLib.ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var win = new MainWindow (this);
        win.present ();
    }

    protected override void open (GLib.File[] files, string hint) {
    }
}

int main (string[] args) {
    var my_app = new StillTerminal.App ();
    return my_app.run (args);
}
