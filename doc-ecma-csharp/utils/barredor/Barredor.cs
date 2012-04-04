//Autor: Rodolfo Campero
using System;
using System.IO;
using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;

namespace BarredorTraduccion
{
	class Barredor
	{
		//FIXME: reemplazar por el path real en la maquina del usuario
		const string BASE_PATH = "../../../doc-ecma-csharp";
		
		public static void Main(string[] args)
		{
			string basePath = BASE_PATH;
			basePath = (args.Length > 0 ? args[0] : BASE_PATH);
			string outputFile = (args.Length > 1 ? args[1] : "output.xml");
			string source = Path.Combine(basePath, "ecma334");
			XmlDocument output = new XmlDocument();
			output.LoadXml(
				"<?xml-stylesheet type='text/xsl' href='estilo.xslt'?><traducciones/>");
			XmlElement outputRoot = output.DocumentElement;
			XmlElement targetNode, originalName;
			string where;
			// obtiene los terminos originales
			DirectoryInfo dirInfo = new DirectoryInfo(source);
			XmlDocument input = new XmlDocument();
			foreach(FileInfo fileInfo in dirInfo.GetFiles("*.xml"))
			{
				input.Load(fileInfo.FullName);
				foreach(XmlElement nonTerminal in input.SelectNodes("//non_terminal"))
				{
					where = nonTerminal.GetAttribute("where");
					targetNode = (XmlElement)outputRoot.SelectSingleNode(
						"non_terminal[@where='" + where + "']");
					if(targetNode == null)
					{
						targetNode = output.CreateElement("non_terminal");
						outputRoot.AppendChild(targetNode);
						targetNode.SetAttribute("where", where);
					}
					if(targetNode.SelectSingleNode(
						"original[.='" + nonTerminal.InnerText + "']") == null)
					{
						originalName = output.CreateElement("original");
						originalName.InnerText = nonTerminal.InnerText;
						targetNode.AppendChild(originalName);
					}
				}
			}
			// obtiene las traducciones
			string target = Path.Combine(basePath, "traducido");
			dirInfo = new DirectoryInfo(target);
			XmlElement fichero, texto, traduccion;
			foreach(FileInfo fileInfo in dirInfo.GetFiles("*.xml"))
			{
				input.Load(fileInfo.FullName);
				foreach(XmlElement nonTerminal in input.SelectNodes("//non_terminal"))
				{
					where = nonTerminal.GetAttribute("where");
					targetNode = (XmlElement)outputRoot.SelectSingleNode(
						"non_terminal[@where='" + where + "']");
					if(targetNode == null)
					{
						targetNode = output.CreateElement("non_terminal");
						outputRoot.AppendChild(targetNode);
						targetNode.SetAttribute("where", where);
					}
					traduccion = (XmlElement)targetNode.SelectSingleNode(
						"traduccion[texto='" + nonTerminal.InnerText + "']"); 
					if(traduccion == null)
					{
						traduccion = output.CreateElement("traduccion");
						targetNode.AppendChild(traduccion);
						texto = output.CreateElement("texto");
						traduccion.AppendChild(texto);
						texto.InnerText = nonTerminal.InnerText;
					}
					fichero = (XmlElement)traduccion.SelectSingleNode(
						"fichero[.='" + fileInfo.Name + "']");
					if(fichero == null)
					{
						fichero = output.CreateElement("fichero");
						fichero.InnerText = fileInfo.Name;
						traduccion.AppendChild(fichero);
					}
				}
			}
			XmlTextWriter writer = new XmlTextWriter(outputFile, System.Text.Encoding.UTF8);
			writer.Formatting = Formatting.Indented;
			output.Save(writer);

		}
	
        }
}
