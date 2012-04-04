<?php

   include("../../php_donantonio.inc");
   define(ISO639, "../../iso639");
   class person
   {
	   var $firstname;
	   var $surname;
	   var $address;
	   
	   function person($firstname, $surname, $address)
	   {
		   $this->firstname = $firstname;
		   $this->surname = $surname;
		   $this->address = $address;
	   }
   }

   class document
   {
	   var $title; //title of the document
	   var $subtitle; //subtitle of the documents
	   var $author; //array of document's authors
	   var $translator; //array
	   var $reviser; //array
	   var $converter; //array
	   var $abstract; 
	   var $lang;
	   var $license;
	   
	   function add_author($firstname, $surname, $address)
	   {
		   $this->author[] = new person($firstname, $surname, $address);
	   }

	   function add_translator($firstname, $surname, $address)
	   {
		   $this->translator[] = new person($firstname, $surname, $address);
	   }

	   function add_reviser($firstname, $surname, $address)
	   {
		   $this->reviser[] = new person($firstname, $surname, $address);
	   }

	   function add_converter($firstname, $surname, $address)
	   {
		   $this->converter[] = new person($firstname, $surname, $address);
	   }



   }

   function array_from_str($str)
   {
	   $array = explode("_", $str);
	   
	   $arr_ret = array();
	   
	   for ($i=0; $i<count($array); $i++)
	   {
	          $arr_ret[] = $array[$i];	 
	   }
	   
	   return $arr_ret;
   }
   
   
   
   function get_value($str_id, $which)
   {
	   global $$which;
	   
	   $array_str = array_from_str($str_id);
	   
	   $var = $$which;
	   
	   if (!$var)
	      return false;
	   
           for ($i=0;$i<count($array_str); $i++)
           {
		   $var = $var[$array_str[$i]];
	   }
	   
	   if ($var)
	      return $var;
   }
   
   function set_value($str_id, $value, $which, $append = false)
   {
	   global $$which;
	   	   
	   print("id: $str_id<br>");
	   print("\$which: $which<br>");
	   print("\$value: $value<br>");

	   $array_str = array_from_str($str_id);
	   
	   $var = $$which; 
	   
	   if (!$var)
	      return false;
	   
           for ($i=0;$i<count($array_str); $i++)
           {
		   if ($i == count($array_str) -1 )
		       $var = &$var[$array_str[$i]];
		   else
		       $var = $var[$array_str[$i]];
	   }
	   
	   if (!is_array($var) || $append)
	   {
	       if ($append)
		   {
		      if (count($var) == 0)
			     $var = array();

              $var[] = $value;

			  print("Count:" . count($var)."<br>");
		   }
		   else
	          $var = $value;
	   }
   }
   
   function print_value($str, $alone=false)
   {
	   if ($str_ret = get_value($str, "VARS"))
	   {
	   	if (!$alone)
	      	print("value = \"". utf8_decode($str_ret) . "\"");
		else
			print(utf8_decode($str_ret));
	   }
   }

   function print_languages($name, $original)
   {
	   
	   if (!$name)
	      return;
	   
	   $codes = file(ISO639);
	   
	   $selected = "";
	   
	   if ($original)
	   		$selected = get_value("document_lang_original", "VARS");
		else
			$selected = get_value("document_lang_translation", "VARS");
	   
	   print("<select name=\"$name\">\n");
	   
	   for ($i=0;$i<count($codes);$i++)
	   {
	   	   $sep = explode(":", $codes[$i]);
		   print("<option value=\"" .  $sep[0] . "\"");
		   if ($selected == $sep[0])
		      print(" selected"); 
		   print(">" . $sep[1] . "</option>\n");
	   }
	   
	   print("</select>\n");
   }
   
   function print_array($name, $str, $names = array())
   {
       $array_str = get_value($str, "VARS");
	   if (count($array_str)>0)
	   {
	      print("<table width=\"100%\">\n");
	      
	      if (count($names)>0)
	      {
		      print("<tr>\n"); 
		      for ($i=0;$i<count($array_str);$i++) //crea los td necesarios para los campos 
		      {
			      print("<td width=\"33%\">");
			      print("<div align=\"center\"><b>" . $names[$i] . "</b></div>");
			      print("</td>");
		      }
		      print("</tr>\n");
	      }
	      
		  $exit = false;
		  
	      for ($i=0;$i<count($array_str);$i++)
	      {
			   reset($array_str);
			   print("<tr>\n");
			   while (list ($key, $val) = each ($array_str)) 
			   {
				   if ($key == "firstname" && !$val[$i])
				   {
					 $exit = true;
					 break;
				   }
				   else
				   {
					print("<td width=\"33%\">");
							print("<input type=\"text\" name=\"$name\" value=\"" . utf8_decode($val[$i]) . "\"/><br/>");
					print("</td>");
	
				   }
				}
			   print("</tr>\n");
			   if ($exit)
				break;
	     }
	     print("</table>\n");
	   }
	   else
	      print("<input type=\"text\" name=\"$name\"/>");
	      
   }



   function isDocbook($source)
   {
	   $MAX = 5;
	   
	   if (!$source)
	   	return false;
	   
	   $array = file($source);
	   
	   if (!isset($array) || !$array)
	   {
		   return false;
	   }
	   else
	   {
		   for ($i=0;$i<$MAX;$i++)
		   {
			  $content .= $array[$i];
		   }

		   if (ereg("<!DOCTYPE.*DTD DocBook.*>", $content))
			   return true;

		   return false;
	   }
   }

   function find_tag($xmlnode, $tag)
   {
	   $nodes = $xmlnode->child_nodes();
	   
	   reset($nodes);
	   
	   while($node = array_shift($nodes))
	   {
		   if ($node->node_name() == $tag)
		   {

			  $ret = $node;

			   break;
		   }
	   }
	   
	   return $ret;
   }

   function get_info($source)
   {
	   $document = new document;
	   $file_content = file($source);
	   
	   if(!$file_content)
	      return false;

	   $file_content = implode(" ", $file_content); //convert the file to one string;
	   $doc = @domxml_open_mem($file_content); //create the xmldoc
	   
	   if (!$doc)
	   		return false;
	   
	   $book = $doc->document_element();
	   //$book_content = $book->child_nodes();
	   
	   $lang = $book->get_attribute("lang");
	   
	   if ($lang)
	   {
	      $document->lang = $lang;
	      
	   		print("lenguaje: $lang <br>");
	   }
	   $bookinfo = find_tag($book, "bookinfo");
	   
	   if ($bookinfo)
	   {
		   $title = $bookinfo->get_elements_by_tagname("title");
		   if (count($title) == 1)
		      $document->title = $title[0]->get_content();

		   $subtitle = $bookinfo->get_elements_by_tagname("subtitle");
		   if (count($subtitle) == 1)
		      $document->subtitle = $subtitle[0]->get_content();

		   $abstract = $bookinfo->get_elements_by_tagname("abstract");
		   if (count($abstract) == 1)
		   {
		   	  $abstract = $abstract[0]->get_content();
		   	  $abstract = eregi_replace("\n", "", $abstract);
			  $abstract = eregi_replace("<para>", "", $abstract);
			  $abstract = eregi_replace("</para>", "\n", $abstract);
		      $document->abstract = $abstract;
		   }
		   

		   $authors = find_tag($bookinfo, "authorgroup");

		   
		    if ($authors)
		    {
			   $authors = $authors->get_elements_by_tagname("author");
			   print("has bookinfo" . count($authors) . "<br>");
			}
			else
			{
			   $authors = $bookinfo->get_elements_by_tagname("author");
			}

			if ($authors)
			{   
			   for ($i=0;$i<count($authors);$i++)
			   {
				   $firstname = $authors[$i]->get_elements_by_tagname("firstname");
				   $surname = $authors[$i]->get_elements_by_tagname("surname");
				   $address =  $authors[$i]->get_elements_by_tagname("address");
				   
				   $firstname = $firstname[0];
				   $surname = $surname[0];
				   $address = $address[0];
				   
				   if ($firstname)
				   	$firstname = $firstname->get_content();
				   
				   if ($surname)
				   	$surname = $surname->get_content();
				   
				   if ($address)
				   	$address = $address->get_content();
				   
				   if(!$address)
				   {
				   }
				   
				   $document->add_author($firstname, $surname, $address);

				   print("Conteo: " . count($document->author) . "<br>");
			   }
			   
			   $others = $bookinfo->get_elements_by_tagname("othercredit");
			   
			   if (count($others)>0)
			   {
			   		for ($i=0;$i<count($others);$i++)
					{
					   $firstname = $others[$i]->get_elements_by_tagname("firstname");
					   $surname = $others[$i]->get_elements_by_tagname("surname");
					   $address =  $others[$i]->get_elements_by_tagname("address");
					   
					   $firstname = $firstname[0];
					   $surname = $surname[0];
					   $address = $address[0];
					   
					   if ($firstname)
						$firstname = $firstname->get_content();
					   
					   if ($surname)
						$surname = $surname->get_content();
					   
					   if ($address)
							$address = $address->get_content();

						$credit = $others[$i]->get_attribute("role");
						
						if ($credit == "translater")
						{
							$document->add_translator($firstname, $surname, $address);	
						}
						if ($credit == "reviser")
						{
							$document->add_reviser($firstname, $surname, $address);	
						}
						if ($credit == "converter")
						{
							$document->add_converter($firstname, $surname, $address);	
						}
						
					}
			   }
			   
			   $cr = $bookinfo->get_elements_by_tagname("legalnotice");
			   
			   if (count($cr) == 1)
			   {
					$cr = $cr[0];
					
				   print("Hallado copyright<br><br>");
					
					$license = $cr->get_content();		
					print("Licencia: $license<br><br>");
						
						if (eregi("GPL", $license))
							$document->license = "GNU GPL";
					
			   }
			   
		   }
		   
		   return $document;
	   }
	   else
	   {
		   //search articles??
	   }	   
   }

   function get_info_original($source)
   {
		global $VARS;

	   $document = new document;
	   $document = get_info($source);

		   if ($document->title)
		      set_value("document_title_original", $document->title, "VARS");
		      
		   print("Titulo: " . $document->title . "<br>");

		   if ($document->subtitle)
		      set_value("document_subtitle_original", $document->subtitle, "VARS");
           print("Subtitulo: " . $document->subtitle . "<br>");

		   if ($document->lang)
				set_value("document_lang_original", $document->lang, "VARS");
  
		   if (count($document->author)>0)
		   {
			   
			   for ($i=0;$i<count($document->author);$i++)
			   {
			       set_value("document_author_firstname", $document->author[$i]->firstname, "VARS", true);
			       set_value("document_author_surname", $document->author[$i]->surname, "VARS", true);
                               set_value("document_author_address", $document->author[$i]->address, "VARS", $append = true);
			   }
			   
		   }
		 if ($document->license)
			set_value("document_rights", $document->license, "VARS");
		   
		  return true;
   }
   
   function get_info_translation($source)
   {
		global $VARS;

	   $document = new document;
	   $document = get_info($source);

		   if ($document->title)
		      set_value("document_title_translation", $document->title, "VARS");
		      
		   print("Titulo: " . $document->title . "<br>");

		   if ($document->subtitle)
		      set_value("document_subtitle_translation", $document->subtitle, "VARS");
           print("Subtitulo: " . $document->subtitle . "<br>");

		   if ($document->lang)
				set_value("document_lang_translation", $document->lang, "VARS");
		
		   if ($document->abstract)
		   		set_value("document_abstract_translation", $document->abstract, "VARS");
  
		   if (count($document->translator)>0)
		   {
			   
			   for ($i=0;$i<count($document->translator);$i++)
			   {
			       set_value("document_translator_firstname", $document->translator[$i]->firstname, "VARS", $append = true);
			       set_value("document_translator_surname", $document->translator[$i]->surname, "VARS", $append = true);
                   set_value("document_translator_address", $document->translator[$i]->address, "VARS", $append = true);
			   }			   
		   }

		   if (count($document->reviser)>0)
		   {
			   
			   for ($i=0;$i<count($document->reviser);$i++)
			   {
			       set_value("document_reviser_firstname", $document->reviser[$i]->firstname, "VARS", $append = true);
			       set_value("document_reviser_surname", $document->reviser[$i]->surname, "VARS", $append = true);
                   set_value("document_reviser_address", $document->reviser[$i]->address, "VARS", $append = true);
			   }			   
		   }

		   if (count($document->converter)>0)
		   {
			   
			   for ($i=0;$i<count($document->converter);$i++)
			   {
			       set_value("document_converter_firstname", $document->converter[$i]->firstname, "VARS", $append = true);
			       set_value("document_converter_surname", $document->converter[$i]->surname, "VARS", $append = true);
                   set_value("document_converter_address", $document->converter[$i]->address, "VARS", $append = true);
			   }			   
		   }


		   return true;
   }   
?>
