#!/bin/bash

# Script usado para 'refinar' la salida de
# ld2db.sh a docbook/xml.

# Script used to help ld2db.sh to correct some mistakes.

# <ricardo.cervera@hispalinux.es> | GPL licensed.

# Actualizacion 29/03/03:
# parse.sh puede pasar de db3x a db4x: ./parse.sh -t fich_db3x fichdest_db4x.
# No obstante, se debe revisar despues el documento resultante.
# En la funcion parse2 pueden añadirse el resto de etiquetas de db3x.

# Update 29/03/03:
# parse.sh may be used to convert from db3x to db4x, as described in "uso"
# function. Anyway, the resulting document should be corrected.
# parse2 function may be completed by adding the rest of db3x marks.

function parse ()
{
	F="$1"
	cat "$F" | sed -e 's/<xref \(.*[^ >]\)>/<xref \1\/>/g' \
	| sed -e 's/&percnt;/%/g' \
	| sed -e 's/&lowbar;/_/g' \
	| sed -e 's/&verbar;/|/g' \
	| sed -e 's/URL/url/g' \
	| sed -e 's/&nbsp;/ /g' \
	| sed -e 's/&num;/#/g' \
	| sed -e 's/FOOTNOTE/footnote/g' \
	| sed -e 's/QUOTE/quote/g' \
	| sed -e 's/&dollar;/\$/g' > temp
	cat temp > $F
	rm temp
	echo "Hecho. Done."
	echo "."

}

function parse_t ()
{
	F_ORIG="$1"
	F_DEST="$2"

	cat "$F_ORIG" | sed -e 's/Article/article/g' \
	| sed -e 's/AUTHOR/author/g' \
	| sed -e 's/Abbrev/abbrev/g' \
	| sed -e 's/Abstract/abstract/g' \
	| sed -e 's/Accel/accel/g' \
	| sed -e 's/Ackno/ackno/g' \
	| sed -e 's/Acronym/acronym/g' \
	| sed -e 's/Action/action/g' \
	| sed -e 's/Address/address/g' \
	| sed -e 's/Affiliation/affiliation/g' \
	| sed -e 's/Alt/alt/g' \
	| sed -e 's/Anchor/anchor/g' \
	| sed -e 's/Answer/answer/g' \
	| sed -e 's/Appendix/appendix/g' \
	| sed -e 's/Application/application/g' \
	| sed -e 's/Area/Area/g' \
	| sed -e 's/AreaSet/areaset/g' \
	| sed -e 's/AreaSpec/areaspec/g' \
	| sed -e 's/Arg/arg/g' \
	| sed -e 's/Article/article/g' \
	| sed -e 's/ArtHeader/articleinfo/g' \
	| sed -e 's/ArgPageNums/artpagenums/g' \
	| sed -e 's/Attribution/attribution/g' \
	| sed -e 's/AudioData/audiodata/g' \
	| sed -e 's/AudioObject/audioobject/g' \
	| sed -e 's/Author/author/g' \
	| sed -e 's/AuthorBlurb/authorblurb/g' \
	| sed -e 's/AuthorInitials/authorinitials/g' \
	| sed -e 's/BeginPage/beginpage/g' \
	| sed -e 's/BiblioDiv/bibliodiv/g' \
	| sed -e 's/BiblioEntry/biblioentry/g' \
	| sed -e 's/Bibliography/bibliography/g' \
	| sed -e 's/BiblioMisc/bibliomisc/g' \
	| sed -e 's/BiblioMixed/bibliomixed/g' \
	| sed -e 's/BiblioMSet/bibliomset/g' \
	| sed -e 's/BiblioSet/biblioset/g' \
	| sed -e 's/BlockQuote/blockquote/g' \
	| sed -e 's/Book/book/g' \
	| sed -e 's/BookInfo/bookinfo/g' \
	| sed -e 's/BridgeHead/bridgehead/g' \
	| sed -e 's/Callout/callout/g' \
	| sed -e 's/CalloutList/calloutlist/g' \
	| sed -e 's/Caption/caption/g' \
	| sed -e 's/Caution/caution/g' \
	| sed -e 's/Chapter/chapter/g' \
	| sed -e 's/Citation/citation/g' \
	| sed -e 's/CiteRefEntry/citerefentry/g' \
	| sed -e 's/CiteTitle/citetitle/g' \
	| sed -e 's/City/city/g' \
	| sed -e 's/ClassName/classname/g' \
	| sed -e 's/CmdSynopsis/cmdsinopsys/g' \
	| sed -e 's/CO>/co>/g' \
	| sed -e 's/Collab/collab/g' \
	| sed -e 's/CollabName/collabname/g' \
	| sed -e 's/Colophon/colophon/g' \
	| sed -e 's/Command/command/g' \
	| sed -e 's/Comment/comment/g' \
	| sed -e 's/ComputerOutput/computeroutput/g' \
	| sed -e 's/ConfDates/confdates/g' \
	| sed -e 's/ConfGroup/confgroup/g' \
	| sed -e 's/ConfNum/confnum/g' \
	| sed -e 's/ConfSponsor/confsponsor/g' \
	| sed -e 's/ConfTitle/conftitle/g' \
	| sed -e 's/Constant/constant/g' \
	| sed -e 's/ContractNum/contractnum/g' \
	| sed -e 's/ContractSponsor/contractSponsor/g' \
	| sed -e 's/Contrib/contrib/g' \
	| sed -e 's/Copyright/copyright/g' \
	| sed -e 's/CorpAuthor/corpauthor/g' \
	| sed -e 's/CorpName/corpname/g' \
	| sed -e 's/Country/country/g' \
	| sed -e 's/Database/database/g' \
	| sed -e 's/Date/date/g' \
	| sed -e 's/Dedication/dedication/g' \
	| sed -e 's/Edition/edition/g' \
	| sed -e 's/Editor/editor/g' \
	| sed -e 's/Email/email/g' \
	| sed -e 's/Emphasis/emphasis/g' \
	| sed -e 's/EnVar/envar/g' \
	| sed -e 's/Epigraph/epigraph/g' \
	| sed -e 's/Ecuation/ecuation/g' \
	| sed -e 's/ErrorCode/errorcode/g' \
	| sed -e 's/ErrorType/errortype/g' \
	| sed -e 's/Example/example/g' \
	| sed -e 's/Fax/fax/g' \
	| sed -e 's/Figure/figure/g' \
	| sed -e 's/Filename/filename/g' \
	| sed -e 's/FirstName/firstname/g' \
	| sed -e 's/FirstTerm/firstterm/g' \
	| sed -e 's/Footnote/footnote/g' \
	| sed -e 's/FOOTNOTE/footnote/g' \
	| sed -e 's/FootnoteRef/footnoteref/g' \
	| sed -e 's/ForeignPhrase/foreignphrase/g' \
	| sed -e 's/FormalPara/formalpara/g' \
	| sed -e 's/FuncDef/funcdef/g' \
	| sed -e 's/FuncParams/funcparams/g' \
	| sed -e 's/FuncPrototype/funcprototype/g' \
	| sed -e 's/Function/function/g' \
	| sed -e 's/Glossary/glossary/g' \
	| sed -e 's/GlossDef/glossdef/g' \
	| sed -e 's/GlossDiv/glossdiv/g' \
	| sed -e 's/GlossEntry/glossentry/g' \
	| sed -e 's/GlossList/glosslist/g' \
	| sed -e 's/GlossSee/glosssee/g' \
	| sed -e 's/GlossSeeAlso/glossseealso/g' \
	| sed -e 's/GlossTerm/glossterm/g' \
	| sed -e 's/Graphic/graphic/g' \
	| sed -e 's/GraphicCO/graphicco/g' \
	| sed -e 's/Group/group/g' \
	| sed -e 's/GUIButton/guibutton/g' \
	| sed -e 's/GUIIcon/guiicon/g' \
	| sed -e 's/GUILabel/guilabel/g' \
	| sed -e 's/GUIMenu/guimenu/g' \
	| sed -e 's/GUIMenuItem/guimenuitem/g' \
	| sed -e 's/GUISubmenu/guisubmenu/g' \
	| sed -e 's/Hardware/hardware/g' \
	| sed -e 's/Highlights/highlights/g' \
	| sed -e 's/Holder/holder/g' \
	| sed -e 's/Honorific/honorific/g' \
	| sed -e 's/ImageData/imagedata/g' \
	| sed -e 's/ImageObject/imageobject/g' \
	| sed -e 's/ImageObjectCO/imageobjectco/g' \
	| sed -e 's/Important/important/g' \
	| sed -e 's/Index/index/g' \
	| sed -e 's/IndexDiv/indexdiv/g' \
	| sed -e 's/IndexEntry/indexentry/g' \
	| sed -e 's/IndexTerm/indexterm/g' \
	| sed -e 's/InformalEquation/informalequation/g' \
	| sed -e 's/InformalExample/informalexample/g' \
	| sed -e 's/InformalFigure/informalfigure/g' \
	| sed -e 's/InformalTable/informaltable/g' \
	| sed -e 's/InlineEquation/inlineequation/g' \
	| sed -e 's/InlineGraphic/inlinegraphic/g' \
	| sed -e 's/InlineMediaObject/inlinemediaobject/g' \
	| sed -e 's/Interface/interface/g' \
	| sed -e 's/InterfaceDefinition/interfacename/g' \
	| sed -e 's/InvPartNumber/invpartnumber/g' \
	| sed -e 's/ISBN/isbn/g' \
	| sed -e 's/IssueNum/issuenum/g' \
	| sed -e 's/ItemizedList/itemizedlist/g' \
	| sed -e 's/ITermSet/itermset/g' \
	| sed -e 's/JobTitle/jobtitle/g' \
	| sed -e 's/KeyCap/keycap/g' \
	| sed -e 's/KeyCode/keycode/g' \
	| sed -e 's/KeyCombo/keycombo/g' \
	| sed -e 's/KeySym/keysym/g' \
	| sed -e 's/Keyword/keyword/g' \
	| sed -e 's/KeywordSet/keywordset/g' \
	| sed -e 's/Label/label/g' \
	| sed -e 's/LegalNotice/legalnotice/g' \
	| sed -e 's/Lineage/lineage/g' \
	| sed -e 's/LineAnnotation/lineannotation/g' \
	| sed -e 's/Link/link/g' \
	| sed -e 's/ListItem/listitem/g' \
	| sed -e 's/Literal/literal/g' \
	| sed -e 's/LiteralLayout/literallayout/g' \
	| sed -e 's/LoT/lot/g' \
	| sed -e 's/LoTentry/lotentry/g' \
	| sed -e 's/ManVolNum/manvolnum/g' \
	| sed -e 's/Markup/markup/g' \
	| sed -e 's/MediaLabel/medialabel/g' \
	| sed -e 's/MediaObject/mediaobject/g' \
	| sed -e 's/Member/member/g' \
	| sed -e 's/MenuChoice/menuchoice/g' \
	| sed -e 's/ModeSpec/modespec/g' \
	| sed -e 's/MouseButton/mousebutton/g' \
	| sed -e 's/Msg/msg/g' \
	| sed -e 's/MsgAud/msgaud/g' \
	| sed -e 's/MsgEntry/msgentry/g' \
	| sed -e 's/MsgExplan/msgexplan/g' \
	| sed -e 's/MsgInfo/msginfo/g' \
	| sed -e 's/MsgLevel/msglevel/g' \
	| sed -e 's/MsgMain/msgmain/g' \
	| sed -e 's/MsgOrig/msgorig/g' \
	| sed -e 's/MsgRel/msgrel/g' \
	| sed -e 's/MsgSet/msgset/g' \
	| sed -e 's/MsgSub/msgsub/g' \
	| sed -e 's/MsgText/msgtext/g' \
	| sed -e 's/Note/note/g' \
	| sed -e 's/ObjectInfo/objectinfo/g' \
	| sed -e 's/OLink/olink/g' \
	| sed -e 's/Option/option/g' \
	| sed -e 's/Optional/optional/g' \
	| sed -e 's/OrderedList/orderedlist/g' \
	| sed -e 's/OrgDiv/orgdiv/g' \
	| sed -e 's/OrgName/orgname/g' \
	| sed -e 's/OtherAddr/otheraddr/g' \
	| sed -e 's/OtherCredit/othercredit/g' \
	| sed -e 's/OtherName/othername/g' \
	| sed -e 's/PageNums/pagenums/g' \
	| sed -e 's/Para/para/g' \
	| sed -e 's/ParamDef/paramdef/g' \
	| sed -e 's/Parameter/parameter/g' \
	| sed -e 's/Part/part/g' \
	| sed -e 's/PartIntro/partintro/g' \
	| sed -e 's/Phone/phone/g' \
	| sed -e 's/Phrase/phrase/g' \
	| sed -e 's/POB/pob/g' \
	| sed -e 's/Postcode/postcode/g' \
	| sed -e 's/Preface/preface/g' \
	| sed -e 's/PrimaryIE/primaryie/g' \
	| sed -e 's/Primary/primary/g' \
	| sed -e 's/PrintHistory/printhistory/g' \
	| sed -e 's/Procedure/procedure/g' \
	| sed -e 's/ProductName/productname/g' \
	| sed -e 's/ProductNumber/productnumber/g' \
	| sed -e 's/ProgramListing/programlisting/g' \
	| sed -e 's/ProgramListingCO/programlistingco/g' \
	| sed -e 's/Prompt/prompt/g' \
	| sed -e 's/Property/property/g' \
	| sed -e 's/PubDate/pubdate/g' \
	| sed -e 's/Pubdate/pubdate/g' \
	| sed -e 's/Publisher/publisher/g' \
	| sed -e 's/PublisherName/publishername/g' \
	| sed -e 's/PubsNumber/pubsnumber/g' \
	| sed -e 's/QandADiv/qandadiv/g' \
	| sed -e 's/QandAEntry/qandaentry/g' \
	| sed -e 's/QandASet/qandaset/g' \
	| sed -e 's/Question/question/g' \
	| sed -e 's/Quote/quote/g' \
	| sed -e 's/RefClass/refclass/g' \
	| sed -e 's/RefDescriptor/refdescriptor/g' \
	| sed -e 's/RefEntry/refentry/g' \
	| sed -e 's/RefEntryTitle/refentrytitle/g' \
	| sed -e 's/Reference/reference/g' \
	| sed -e 's/RefMeta/refmeta/g' \
	| sed -e 's/RefMiscInfo/refmiscinfo/g' \
	| sed -e 's/RefName/refname/g' \
	| sed -e 's/RefNameDiv/refnamediv/g' \
	| sed -e 's/RefPurpose/refpurpose/g' \
	| sed -e 's/RefSect1Info/refsect1info/g' \
	| sed -e 's/RefSect1/refsect1/g' \
	| sed -e 's/RefSect2Info/refsect2info/g' \
	| sed -e 's/RefSect2/refsect2/g' \
	| sed -e 's/RefSect3Info/refsect3info/g' \
	| sed -e 's/RefSect3/refsect3/g' \
	| sed -e 's/RefSynopsisDivInfo/refsynopsisdivinfo/g' \
	| sed -e 's/RefSynopsisDiv/refsinopsisdiv/g' \
	| sed -e 's/ReleaseInfo/releaseinfo/g' \
	| sed -e 's/Replaceable/replaceable/g' \
	| sed -e 's/ReturnValue/returnvalue/g' \
	| sed -e 's/RevHistory/revhistory/g' \
	| sed -e 's/Revision/revision/g' \
	| sed -e 's/RevNumber/revnumber/g' \
	| sed -e 's/RevRemark/revremark/g' \
	| sed -e 's/SBR/sbr/g' \
	| sed -e 's/ScreenCO/screenco/g' \
	| sed -e 's/ScreenInfo/screeninfo/g' \
	| sed -e 's/ScreenShot/screenshot/g' \
	| sed -e 's/Screen/screen/g' \
	| sed -e 's/SecondaryIE/secondaryie/g' \
	| sed -e 's/Secondary/secondary/g' \
	| sed -e 's/Sect\([1-5]\)Info/sect\1info/g' \
	| sed -e 's/Sect\([1-5]\)/sect\1/g' \
	| sed -e 's/SectionInfo/sectioninfo/g' \
	| sed -e 's/Section/section/g' \
	| sed -e 's/See/see/g' \
	| sed -e 's/SeeAlsoIE/seealsoie/g' \
	| sed -e 's/SeeAlso/seealso/g' \
	| sed -e 's/SeeIE/seeie/g' \
	| sed -e 's/Seg/seg/g' \
	| sed -e 's/SegListItem/seglistitem/g' \
	| sed -e 's/SegmentedList/segmentedlist/g' \
	| sed -e 's/SegTitle/segtitle/g' \
	| sed -e 's/SeriesVolNums/seriesvolnums/g' \
	| sed -e 's/SetIndex/setindex/g' \
	| sed -e 's/SetInfo/setinfo/g' \
	| sed -e 's/Set>/set>/g' \
	| sed -e 's/SGMLTag/sgmltag/g' \
	| sed -e 's/ShortAffil/shortaffil/g' \
	| sed -e 's/Shortcut/shortcut/g' \
	| sed -e 's/Sidebar/sidebar/g' \
	| sed -e 's/SimPara/simpara/g' \
	| sed -e 's/SimpleList/simplelist/g' \
	| sed -e 's/SimpleSect/simplesect/g' \
	| sed -e 's/State>/state>/g' \
	| sed -e 's/Step>/step>/g' \
	| sed -e 's/Street/street/g' \
	| sed -e 's/StructField/structfield/g' \
	| sed -e 's/StructName/structname/g' \
	| sed -e 's/SubjectSet/subjectset/g' \
	| sed -e 's/SubjectTerm/subjectterm/g' \
	| sed -e 's/Subject/subject/g' \
	| sed -e 's/Subscript/subscript/g' \
	| sed -e 's/SubSteps/substeps/g' \
	| sed -e 's/Subtitle/subtitle/g' \
	| sed -e 's/Superscript/superscript/g' \
	| sed -e 's/Surname/surname/g' \
	| sed -e 's/Symbol/symbol/g' \
	| sed -e 's/SynopFragmentRef/synopfragmentref/g' \
	| sed -e 's/SynopFragment/synopfragment/g' \
	| sed -e 's/Synopsis/synopsis/g' \
	| sed -e 's/SystemItem/systemitem/g' \
	| sed -e 's/Table/table/g' \
	| sed -e 's/Term/term/g' \
	| sed -e 's/TertiaryIE/tertiaryie/g' \
	| sed -e 's/Tertiary/tertiary/g' \
	| sed -e 's/TextObject/textobject/g' \
	| sed -e 's/Tip/tip/g' \
	| sed -e 's/Title/title/g' \
	| sed -e 's/TitleAbbrev/titleabbrev/g' \
	| sed -e 's/ToCback/tocback/g' \
	| sed -e 's/ToCchap/tocchap/g' \
	| sed -e 's/ToCentry/tocentry/g' \
	| sed -e 's/ToCfront/tocfront/g' \
	| sed -e 's/ToCpart/tocpart/g' \
	| sed -e 's/ToClevel([1-5])/toclevel\1/g' \
	| sed -e 's/ToC/toc/g' \
	| sed -e 's/Token/token/g' \
	| sed -e 's/Trademark/trademark/g' \
	| sed -e 's/Type/type/g' \
	| sed -e 's/ULink URL/ulink url/g' \
	| sed -e 's/Ulink URL/ulink url/g' \
	| sed -e 's/ULink/ulink/g' \
	| sed -e 's/Ulink/ulink/g' \
	| sed -e 's/UserInput/userinput/g' \
	| sed -e 's/VarArgs/varargs/g' \
	| sed -e 's/VariableList/variablelist/g' \
	| sed -e 's/VarListEntry/varlistentry/g' \
	| sed -e 's/VarName/varname/g' \
	| sed -e 's/VideoData/videodata/g' \
	| sed -e 's/VideoObject/videoobject/g' \
	| sed -e 's/Void/void/g' \
	| sed -e 's/VolumeNum/volumenum/g' \
	| sed -e 's/Warning/warning/g' \
	| sed -e 's/WordAsWord/wordasword/g' \
	| sed -e 's/XRef/xref/g' \
	| sed -e 's/linkEnd/linkend/g' \
	| sed -e 's/Year/year/g' > "$F_DEST"

## Only the basic ones | Solo las basicas: ##
#	| sed -e 's/Book/book/g' \
#	| sed -e 's/Title/title/g' \
#	| sed -e 's/AUTHOR/author/g' \
#	| sed -e 's/FirstName/firstname/g' \
#	| sed -e 's/Literal/literal/g' \
#	| sed -e 's/Surname/surname/g' \
#	| sed -e 's/Sect1/sect1/g' \
#	| sed -e 's/Sect2/sect2/g' \
#	| sed -e 's/Sect3/sect3/g' \
#	| sed -e 's/ArtHeader/articleinfo/g' \
#	| sed -e 's/Para/para/g' \
#	| sed -e 's/Emphasis/emphasis/g' \
#	| sed -e 's/URL/url/g' \
#	| sed -e 's/ULink/ulink/g' \
#	| sed -e 's/XRef/xref/g' \
#	| sed -e 's/LinkEnd/linkend/g' \
#	| sed -e 's/Screen/screen/g' \
#	| sed -e 's/ItemizedList/itemizedlist/g' \
#	| sed -e 's/ListItem/listitem/g' \
#	| sed -e 's/ProgramListing/programlisting/g' \
#	| sed -e 's/VariableList/variablelist/g' \
#	| sed -e 's/Term/term/g' \
#	| sed -e 's/PubDate/pubdate/g' \
#	| sed -e 's/Abstract/abstract/g' \
#	| sed -e 's/VarListEntry/varlistentry/g' > "$F_DEST"
	
	parse $F_DEST	
}


function uso () {
	echo "parse.sh - Complemento de ld2db.sh o bien conversor"
	echo "de DocBook 3x a DocBook 4x."
	echo "--"
	echo "parse.sh - Adding to ld2db.sh or DocBook 3x to DocBook 4x"
	echo "converter"
	echo "--"
	echo "Como complemento de ld2db.sh:"
	echo "When using with ld2db.sh:"
	echo " "
	echo "./parse.sh file_to_correct (will be over-written)"
	echo " "
	echo "Para convertir de db3x a db4x:"
	echo "When converting from db3x to db4x:"
	echo " "
	echo "parse.sh -t file_db3x file_db4x"
	echo " "
	echo "."
}

##

if test $1 = "-t" ; then
	if test -e $2; then
		if [ $3 != "" ]; then
			parse_t $2 $3
			echo "Hecho. Done."
			echo "."

			exit
		else
			echo "Error. Debe especificar un archivo de destino"
			echo "Error. You must specify a destination file"
			uso

			exit
		fi
	else
		echo "Error. El archivo de origen no existe."
		echo "Error. Origin file does not exist."
		uso
		
		exit
	fi

else
	if test ! $1; then
		uso
		
		exit
	else
		if test -e $1; then
			parse $1
		else
			uso
			
			exit
		fi

		exit
	fi
fi

#if test -e "$1"; then
#	parse $1
#fi
