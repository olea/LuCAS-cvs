
class Principal
{
        public static void Main()
        {
                Gtk.Application.Init();
                
                Navegador nav = new Navegador();

                Gtk.Application.Run();
        }
}
