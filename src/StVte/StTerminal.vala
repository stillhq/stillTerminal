namespace StillTerminal {
    public class StTerminal : Adw.Bin {
        public Vte.Terminal vte;
        public StColorScheme color_scheme;

        public StTerminal () {
            Object ();
            this.vte = new Vte.Terminal ();
            this.child = this.vte;
        }
    }
}
