/* mn2html.cs
 * A simple program to transform a MonoDoc document to html 
 * via XSL Transformation
 *
 * maintainer: Ricardo Varela - phobeo at ieee dot org
 * 
 * modificado por Fabian Seoane fabian@fseoane.net 18 de julio 2004
 */

using System;
using System.IO;
using System.Xml;
using System.Xml.Xsl;

namespace Mn2Db {

	public class Mn2DbMain {
		public static void Main(string [] args) {
                
		bool frames = false; 
		string source = ""; //directorio del codigo a transformar
		int i;

		for( i = 0; i<args.Length; i++ )
		{
			switch( args[i] ){
				case "--help": 
					PrintUsage();
					break;
				case "/?": 
					PrintUsage();
					break;
				case "-f": 
					frames = true;
					break;
				case "-d": 
					source = args[i+1];
					i++;
					break;
				default:
					PrintUsage();
					return;
			}
		}
		
		
		if(Directory.Exists(source)) {
			Console.WriteLine("Transforming files in {0}. Please wait.",source);
			try {
				Mn2DbTransform.TransformDirectory(source, frames); 
			} catch (Mn2DbTransformException e) {
				Console.Error.WriteLine("ERROR: {0}", e.ToString());
			}
			Console.WriteLine("Conversion succeeded!");
			Console.WriteLine("Please check the HTML files output in html/ directory");
                }
                else {
                	Console.Error.WriteLine("ERROR: The argument given was not a directory");
                	PrintUsage();
                }
			Console.WriteLine("Press any key to finish");
			Console.Read();
		}
		
		
	public static void PrintUsage() {
		Console.WriteLine("ERROR: Wrong arguments given!");
		Console.WriteLine("  mn2html recibe el direcorio con validos archivos monodoc .xml");
		Console.WriteLine("  y los transforma en formato html, escribiéndolos en el directorio html"); 
		Console.WriteLine("Uso: mn2html.exe <source_directory> o, si trabajas en la traduccion");
		Console.WriteLine("del estandar ECMA es suficiente hacer ./mn2html" + 
				" ( tal vez tengas que cambiarle los permisos a este archivo )");
		}
	}
    
	public class Mn2DbTransform {
		public static bool TransformDirectory(string source, bool frames) {
			string stylesheet, destination, destdir;
		    
			if( !frames )
			{
				stylesheet = "ecmaspec-html-es.xsl";
				destination = "html" + Path.DirectorySeparatorChar;
			}		    		
			else
			{
				stylesheet = "ecmaspec-html-frames-es.xsl";
				destination = "html-frames" + Path.DirectorySeparatorChar;
			}
		    
			destdir = Directory.GetCurrentDirectory() + Path.DirectorySeparatorChar + destination;
            
			try {
				if(!Directory.Exists(destdir)) {
					Directory.CreateDirectory(destdir);
				}
				// transform the documents in the directory
				string[] filelist = Directory.GetFiles(source,"*.xml");
				XslTransform transform = new XslTransform();
				transform.Load(stylesheet);
				
				foreach(string sourcefile in filelist) {
					string destfile = destdir + (Path.GetFileName(sourcefile)).Replace("xml", "html");
					Console.WriteLine("Transforming {0}",sourcefile);
					transform.Transform(sourcefile, destfile, null);
				}
			} catch(Exception e) {
				throw new Mn2DbTransformException(e.ToString());
			}
			return true;
		}
	}
    
	
	public class Mn2DbTransformException : System.Exception {
		public Mn2DbTransformException(string s) : base(s) {}
	}
}
