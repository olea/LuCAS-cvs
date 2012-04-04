<?php
  /* Information about templates */
  
  $TEMPLATES["document"] = "templates/template_documents.rdf";
  $TEMPLATES["project"] = "templates/template_notdefined.rdf";
  $TEMPLATES["formats"]["pdf"] = "templates/template_notdefined.rdf";
  $TEMPLATES["formats"]["ps"] = "templates/template_notdefined.rdf";
  $TEMPLATES["formats"]["html"] = "templates/template_notdefined.rdf";
  
//  $RDF_PARSING["separator"] = "|";

  $RDF_PARSING["xml"]["encoding"] = "xml_encoding";

  $RDF_PARSING["document"]["lang"]["original"] = "xml_original_lang";
  $RDF_PARSING["document"]["lang"]["translation"] = "xml_translation_lang";
  
  $RDF_PARSING["document"]["author"]["firstname"] = "author_firstname";
  $RDF_PARSING["document"]["translator"]["firstname"] = "translator_firstname";
  $RDF_PARSING["document"]["reviser"]["firstname"] = "reviser_firstname";
  
  $RDF_PARSING["document"]["author"]["surname"] = "author_surname";
  $RDF_PARSING["document"]["translator"]["surname"] = "translator_surname";
  $RDF_PARSING["document"]["reviser"]["surname"] = "reviser_surname";
  
  $RDF_PARSING["document"]["author"]["address"] = "author_address";
  $RDF_PARSING["document"]["translator"]["address"] = "translator_address";
  $RDF_PARSING["document"]["reviser"]["address"] = "reviser_address";
  
  $RDF_PARSING["document"]["title"]["original"] = "title_original";
  $RDF_PARSING["document"]["title"]["translation"] = "title";
  $RDF_PARSING["document"]["subtitle"]["original"] = "subtitle_original";
  $RDF_PARSING["document"]["subtitle"]["translation"] = "subtitle";
  $RDF_PARSING["document"]["version"]["translation"] = "version";
  $RDF_PARSING["document"]["version"]["original"] = "original_version";
  $RDF_PARSING["document"]["abstract"]["original"] = "abstract";
  $RDF_PARSING["document"]["abstract"]["translation"] = "abstract_traslation";  
  $RDF_PARSING["document"]["subject"] = "subject";    
  $RDF_PARSING["document"]["dochome"] = "doc_home";
  $RDF_PARSING["document"]["rights"] = "rights";
  
  /*TODO: include the repository information*/

  $RDF_PARSING["formats"]["dbxml"]["name"] = "dbxml";
  $RDF_PARSING["formats"]["dbxml"]["info"] = "DocBook/xml";
  
  $VARS["xml"]["encoding"] = "xml_encoding";

  $VARS["document"]["lang"]["original"] = "";
  $VARS["document"]["lang"]["translation"] = "";
  
  $VARS["document"]["author"]["firstname"] = "";
  $VARS["document"]["translator"]["firstname"] = "";
  $VARS["document"]["reviser"]["firstname"]  = "";
  $VARS["document"]["converter"]["firstname"]  = "";
  
  $VARS["document"]["author"]["surname"] = "";
  $VARS["document"]["translator"]["surname"] = "";
  $VARS["document"]["reviser"]["surname"] = "";
  $VARS["document"]["converter"]["surname"] = "";
  
  $VARS["document"]["author"]["address"] = "";
  $VARS["document"]["translator"]["address"] = "";
  $VARS["document"]["reviser"]["address"] = "";
  $VARS["document"]["converter"]["address"] = "";
    
  $VARS["document"]["title"]["original"] = "";
  $VARS["document"]["title"]["translation"] = "";
  $VARS["document"]["subtitle"]["original"] = "";
  $VARS["document"]["subtitle"]["translation"] = "";
  $VARS["document"]["version"]["translation"] = "";
  $VARS["document"]["version"]["original"] = "";
  $VARS["document"]["abstract"]["original"] = "";
  $VARS["document"]["abstract"]["translation"] = "";    
  $VARS["document"]["subject"] = "";   
  $VARS["document"]["dochome"] = "";
  $VARS["document"]["rights"] = "";
  
  
?>
