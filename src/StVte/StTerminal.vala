public class StTerminal : Adw.Bin {
    public Vte.Terminal vte;

    public StTerminal () {
        this.vte = new Vte.Terminal ();
    }
}

