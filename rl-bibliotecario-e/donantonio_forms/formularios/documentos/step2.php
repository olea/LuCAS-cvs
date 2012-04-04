<?php

    include("php/library.php");
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"
    "http://www.w3.org/TR/REC-html40/loose.dtd">


<html>
  <head>
    <script language="javascript">
       function addAuthor()
       {
	       alert("Agregar Autor");
       }
    </script>
    <title>Registro de Documentos - Paso 2</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
  </head>
  
  <body>
  
  <?php
     if ($HTTP_POST_VARS["data"] == "yes")
     {
            $ret_url_original = isDocbook($HTTP_POST_VARS["url_original"]);
	    $ret_url_translation = isDocbook($HTTP_POST_VARS["url_translation"]);
	    $ret_doc_original = isDocbook($doc_original);
	    $ret_doc_translation = isDocbook($doc_translation);
	    $info = "";

		     print("The function has returned the value: $ret_url_original<br/>");
		     print("The function has returned the value: $ret_url_translation<br/>");
		     print("The function has returned the value: $ret_doc_original<br/>");
		     print("The function has returned the value: $ret_doc_translation<br/>");
	    
		if ($ret_url_original)
	    {
	    	$info = get_info_original($HTTP_POST_VARS["url_original"]);
	    }
		
		if ($ret_url_translation)
		{
			$info = get_info_translation($HTTP_POST_VARS["url_translation"]);
		}
	}
  ?>
  <h1>Paso 2 - Confirmaci&oacute;n de informaci&oacute;n</h1>
  <form method="get" action="step2.php">
      <table width="100%">
      <tr>
	  	<td width="100%">
	      <h2>Documento Original</h2>
	    </td>
	  </tr>

       <tr>
	      <td width="100%">
	          <table width="60%" align="center">
		      <tr>
		          <td width="25%">
			        <div align="right">T&iacute;tulo original</div>
			      </td>
		          <td width="75%">
			        <input type="text" <?php print_value("document_title_original"); ?> />
			      </td>
		      </tr>

		      <tr>
		          <td width="25%">
			        <div align="right">Subt&iacute;tulo original</div>
			      </td>
		          <td width="75%">
			        <input type="text" <?php print_value("document_subtitle_original"); ?> />
			      </td>
		      </tr>

      		      <tr>
		          <td width="25%">
			        <div align="right">Lenguaje:</div>
			      </td>
		          <td width="75%">
			        <?php print_languages("lang", true); ?>
			      </td>
		      </tr>

		      <tr>
		          <td width="25%">
			        &nbsp;
			      </td>
		          <td width="75%">
			        <div align="center"><b>Autor[es] original[es]</b></div>
			      </td>
		      </tr>

		      <tr>
		          <td width="25%">
			        <div align="right">Autor:</div>
			      </td>
		          <td width="75%">
			        <?php print_array("author", "document_author", array("nombre", "apellido", "email")); ?>
				<input type="button" name="addAuthor" value="Añadir otro autor" onClick="javascript:addAuthor()">
			      </td>
		      </tr>
			  
		      <tr>
		          <td width="25%">
			        <div align="right">Licencia</div>
			      </td>
		          <td width="75%">
			        <input type="text" <?php print_value("document_rights"); ?> />
			      </td>
		      </tr>
			  
			</table>
			
          <tr>
	      <td width="100%">
	      <h2>Documento Traducido</h2>
	      </td>
	  </tr>

          <tr>
	      <td width="100%">
	          <table width="60%" align="center">
		      <tr>
		          <td width="25%">
			        <div align="right">T&iacute;tulo traducido</div>
			      </td>
		          <td width="75%">
			        <input type="text" <?php print_value("document_title_translation"); ?> />
			      </td>
		      </tr>

		      <tr>
		          <td width="25%">
			        <div align="right">Subt&iacute;tulo traducido</div>
			      </td>
		          <td width="75%">
			        <input type="text" <?php print_value("document_subtitle_translation"); ?> />
			      </td>
		      </tr>

      		      <tr>
		          <td width="25%">
			        <div align="right">Lenguaje:</div>
			      </td>
		          <td width="75%">
			        <?php print_languages("lang", false); ?>
			      </td>
		      </tr>


		      <tr>
		          <td width="25%">
			        <div align="right">Abstract</div>
			      </td>
		          <td width="75%">
			        <textarea name="document_abstract_translation"><?php print_value("document_abstract_translation", true); ?></textarea>
			      </td>
		      </tr>

		      <tr>
		          <td width="25%">
			        <div align="right">Traductor[es]:</div>
			      </td>
		          <td width="75%">
			        <?php print_array("document_translator", "document_translator", array("Nombre", "Apellido", "Email")); ?>
				<input type="button" name="addAuthor" value="Añadir otro autor" onClick="javascript:addAuthor()">
			      </td>
		      </tr>

		      <tr>
		          <td width="25%">
			        <div align="right">Revisores[es]:</div>
			      </td>
		          <td width="75%">
			        <?php print_array("document_reviser", "document_reviser", array("Nombre", "Apellido", "Email")); ?>
				<input type="button" name="addAuthor" value="Añadir otro revisor" onClick="javascript:addReviser()">
			      </td>
		      </tr>

		      <tr>
		          <td width="25%">
			        <div align="right">Convertidores ??:</div>
			      </td>
		          <td width="75%">
			        <?php print_array("document_converter", "document_converter", array("Nombre", "Apellido", "Email")); ?>
				<input type="button" name="addAuthor" value="Añadir otro revisor" onClick="javascript:addConverter()">
			      </td>
		      </tr>


		  </table>
	      </td>
	  </tr>
      </table>
  </form>
  
  </body>
</html>
