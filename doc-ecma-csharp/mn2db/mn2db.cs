/* mn2db.cs
 * A simple program to transform a MonoDoc document to DocBook format
 * via XSL Transformation
 *
 * maintainer: Ricardo Varela - phobeo at ieee dot org
 */

using System;
using System.IO;
using System.Xml;
using System.Xml.Xsl;

namespace Mn2Db {

	public class Mn2DbMain {
		public static void Main(string [] args) {
            
			if(args.Length!=1 
                || args[0].Equals("/?")
                || args[0].Equals("--help") ){
				PrintUsage();
			}
			else {
				string source = args[0];
                if(Directory.Exists(source)) {
                    Console.WriteLine("Transforming files in {0}. Please wait.",source);
                    try {
                        Mn2DbTransform.TransformDirectory(source); 
                    } catch (Mn2DbTransformException e) {
                            Console.Error.WriteLine("ERROR: {0}", e.ToString());
                        }
                    Console.WriteLine("Conversion succeeded!");
                    Console.WriteLine("Please check the DocBook files output in docbook/ directory");
                }
                else {
                    Console.Error.WriteLine("ERROR: The argument given was not a directory");
                    PrintUsage();
                }
				
			}
			Console.WriteLine("Press any key to finish");
			Console.Read();
		}
		
		public static void PrintUsage() {
			Console.WriteLine("ERROR: Wrong arguments given!");
            Console.WriteLine("  mn2db receives a directory with valid monodoc .xml files and transforms");
            Console.WriteLine("  these files into DocBook format, writing them in the docbook/ directory");
			Console.WriteLine("Usage: mn2db.exe <source_directory>");
		}
	}
    
    public class Mn2DbTransform {
        
        public static bool TransformDirectory(string source) {
            string stylesheet = "mn2db.xsl";
			string destination = "docbook" + Path.DirectorySeparatorChar;
			// create destination directory if needed
			string destdir = Directory.GetCurrentDirectory() + Path.DirectorySeparatorChar + destination;
            
            try {
                if(!Directory.Exists(destdir)) {
                    Directory.CreateDirectory(destdir);
                }
                // transform the documents in the directory
                string[] filelist = Directory.GetFiles(source,"*.xml");
                XslTransform transform = new XslTransform();
                transform.Load(stylesheet);
                foreach(string sourcefile in filelist) {
                    string destfile = destdir + Path.GetFileName(sourcefile);
					Console.WriteLine("Transforming {0}",sourcefile);
                    transform.Transform(sourcefile, destfile);
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
