<?php

define(MAX_CHARS_PARA, 5000);

function get_xml_data($source)
{
	   $file_content = file($source);
	   
	   if(!$file_content)
	      return false;

	   $file_content = implode(" ", $file_content); //convert the file to one string;
	   $doc = @domxml_open_mem($file_content); //create the xmldoc
	   
	   if (!$doc)
	   		return false;
	   
	   $book = $doc->document_element();
	   
	   return $book;
}

function extract_chapters($file)
{
	$dump = get_xml_data($file);
	
	$chapters = $dump->get_elements_by_tagname("chapter");
	
	if (count($chapters)>0)
	{
		$to_return;
		
		for ($i=0;$i<count($chapters);$i++)
		{
			$title = $chapters[$i]->get_elements_by_tagname("title");
			if (count($title)>0)
			{
				$title = $title[0]->get_content();
				
				$to_return[] = $title;
			}
			
		}
		
		return $to_return;
		
	}
	else
		return false;
	
}

function extract_info_from_chapter($file, $no)
{
	if ($no<0)
		return false;
		
	$dump = get_xml_data($file);
	
	$chapters = $dump->get_elements_by_tagname("chapter");
	
	if (count($chapters)>=$no)
	{
		$chapter = $chapters[$no]->get_elements_by_tagname("para");
		
		$to_return = "";
		$temp = "";

		for ($i=0;$i<count($chapter);$i++)
			$temp = $temp . "<p>" .utf8_decode($chapter[$i]->get_content()) . "</p>";

		for ($i=0;$i<MAX_CHARS_PARA;$i++)
		{		
			$to_return = $to_return . $temp[$i];		
		}
		
		return ($to_return . "...");		
	}
	else
		return false;
	
}

?>
