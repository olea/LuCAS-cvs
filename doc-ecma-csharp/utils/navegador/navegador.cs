
using System;
using System.IO;


class Navegador : Gtk.Window
{
        Gtk.HBox hbox;
        Gtk.HTML html_enlaces;
        Gtk.HTML html_en;
        Gtk.HTML html_es;

        Gtk.HTMLStream s1; 
        Gtk.HTMLStream s2;
        Gtk.HTMLStream s3;
        
        public Navegador() : base("navegador")
        {
                SetDefaultSize( 300, 300);
                DeleteEvent += new Gtk.DeleteEventHandler( Quit );
                
                hbox = new Gtk.HBox( false, 3 );
                Add( hbox );

                Gtk.ScrolledWindow sw1 = new Gtk.ScrolledWindow();
                Gtk.ScrolledWindow sw2 = new Gtk.ScrolledWindow();
                Gtk.ScrolledWindow sw3 = new Gtk.ScrolledWindow();

                html_enlaces = new Gtk.HTML();
                sw1.Add( html_enlaces );

                html_en = new Gtk.HTML();
                sw2.Add( html_en );
                
                html_es = new Gtk.HTML();
                sw3.Add( html_es );
                

                hbox.PackStart( sw1, true, true, 1 );
                hbox.PackStart( sw2, true, true, 1 );
                hbox.PackStart( sw3, true, true, 1 );


                s1 = html_enlaces.Begin("text/html");
                s2 = html_en.Begin("text/html");
                s3 = html_es.Begin("text/html");

 
                using (StreamReader sr1 = new StreamReader( "es/index.html") ) 
                {
                        s1.Write( sr1.ReadToEnd() );
                }
                html_enlaces.End (s1, Gtk.HTMLStreamStatus.Ok);

                html_enlaces.LinkClicked += new Gtk.LinkClickedHandler (OnLinkClicked);
                html_en.LinkClicked += new Gtk.LinkClickedHandler (OnLinkClicked);
                html_es.LinkClicked += new Gtk.LinkClickedHandler (OnLinkClicked);



                LoadURL( "1.html" );

                

                ShowAll();
        }

        void Quit( object o, Gtk.DeleteEventArgs args )
        {
                Gtk.Application.Quit();
        }

        void LoadURL( string url )
        {
               using ( StreamReader sr = new StreamReader( "en/" + url ) )
               {
                       s2 = html_en.Begin();
                       s2.Write( sr.ReadToEnd() );
                       html_en.End (s2, Gtk.HTMLStreamStatus.Ok);

               }

               using( StreamReader sr = new StreamReader( "es/" + url ) )
               {
                       s3 = html_es.Begin();
                       s3.Write( sr.ReadToEnd() );
                       html_es.End (s3, Gtk.HTMLStreamStatus.Ok);

               }
        }

        void OnLinkClicked( object obj, Gtk.LinkClickedArgs args)
        {
                LoadURL( args.Url );
        }
        
}



class Principal
{
        public static void Main()
        {
                Gtk.Application.Init();
                
                Navegador nav = new Navegador();

                Gtk.Application.Run();
        }
}
