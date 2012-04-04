#!/usr/bin/perl -w

#    Generador de configuración para cursos en porciones
#    Copyright (C) 2002 Proyecto Cursos | TLDP-ES
#                       http://es.tldp.org/htmls/cursos.html
#
#
#    Autores:
#             Lucas Di Pentima <ldipenti@ciudad.com.ar>
#              German Maglione <germancho@ciudad.com.ar>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

use Gtk;
use Gtk::GladeXML;

# Uso de parámetros
use Getopt::Long;

my $dirparam = "./contenido/";
my $closed;
my $closed_mask;
my $opened;
my $opened_mask;
my $leaf;
my $leaf_mask;

my @cat_closed_xpm = (
'16 16 6 1',
' 	c None',
'.	c #000000',
'+	c #0000FF',
'@	c #008080',
'#	c #C0C0C0',
'$	c #808080',
'       ..       ',
'     ..++.      ',
'   ..+++++.     ',
' ..++++++++.    ',
'.@#+++++++++.   ',
'.+@#+++++++++.  ',
'.++@#+++++++++. ',
'.+++@#++++++++..',
'.++++@#+++++..@$',
' .++++@#++..@#@$',
'  .++++@..@###..',
'   .+++.@####.. ',
'    .++.###..   ',
'     .+.@..     ',
'      ...       ',
'                ');

my @cat_open_xpm = (
'16 16 6 1',
' 	c None',
'.	c #0000FF',
'+	c #000000',
'@	c #C0C0C0',
'#	c #000080',
'$	c #FFFFFF',
'  .             ',
' +@.            ',
'#+@@.    ...    ',
'#+@@.  ..$$..   ',
'#+@@@..$$$$.@+  ',
'#+@@@+@$$$$.@+  ',
'#+@@@+@$$$$.@+  ',
'#+@@@+@$$$$.@+  ',
'#+@@@+@$$$$.@+  ',
'#+@@@+@$$$$.@+  ',
'#+@@@+@$$$$.@+  ',
'+##@@+@$.+++@+  ',
' +##@+++.@@@@+  ',
'  +#++++++++++  ',
'  ++++          ',
'                ');

my @porcion_xpm = (
'18 18 5 1',
' 	c None',
'.	c #000000',
'+	c #FFFFFF',
'@	c #848484',
'#	c #C6C6C6',
'                  ',
'   .+.+.+.+.      ',
'  .+@+@+@+@+.     ',
' @+.+.+.+.+.+.    ',
' @++++++++++#.    ',
' @++++++++++#.    ',
' @++...+..++#.    ',
' @++++++++++#.    ',
' @++......++#.    ',
' @++++++++++#.    ',
' @++......++#.    ',
' @++++++++++#.    ',
' @++......++#.    ',
' @++++++++++#.    ',
' @++++++++++#.    ',
' @###########.    ',
'  ...........     ',
'                  ');

# Opciones de ejecución
&GetOptions("d|dir=s" => \$dirparam,
    	    "h|help" => \$help);

if($help) { &help };
&main();

sub help {
    print << "EOH";

Uso:
    cursos.pl [-d directorio]

    -d directorio         Directorio donde buscar porciones (opcional)

EOH

    exit;
}

sub main {
    eval {
	require Gtk::Gdk::ImlibImage;
	require Gnome;
	init Gnome('glade.pl');
    };
    init Gtk if $@;
    
    $g = new Gtk::GladeXML(shift || "cursos.glade");
    
    $g->signal_autoconnect_from_package('main');
    $w = $g->get_widget('GeneraCursos');
    $p_list = $g->get_widget('porciones');
    $c_list  = $g->get_widget('curso');

    my $raiz;
    my $raiz_curso;
    &inicializar($dirparam);
    
    main Gtk;
}

sub inicializar {
    my($dir) =  @_;
    
    $dir =~ s/(.*)\/$/$1/;
    my $dir_text = $dir;
    $dir_text =~ s/.*\///;
    
    # Set up Pixmaps
    ($closed, $closed_mask) = initialize_pixmap( @cat_closed_xpm );
    ($opened, $opened_mask) = initialize_pixmap( @cat_open_xpm );
    ($leaf, $leaf_mask) = initialize_pixmap( @porcion_xpm );
    $raiz_curso = &insert_node($c_list,undef,["Curso"], 0);
    $raiz = &insert_node($p_list,undef,[$dir_text], 0);

    $p_list->node_set_selectable($raiz, 0);
    $c_list->node_set_selectable($raiz_curso, 0);

    $p_list->expand($raiz);
    $c_list->expand($raiz_curso);
    
    # Detalles estéticos...
    my $sep = 18;
    my $line_style = 'dotted'; # solid, dotted, none
    $p_list->set_line_style($line_style);
    $p_list->set_row_height($sep);
    $c_list->set_line_style($line_style);
    $c_list->set_row_height($sep);
    
    # Si se cierra la ventana, salir por las buenas.
    $w->signal_connect('destroy', sub { Gtk->exit( 0 ); } );

    # Generamos la lista de porciones
    &carga_porciones($raiz, $dir);
}

sub carga_porciones {
    my $raiz = shift;
    my $dir = shift;

    $p_list->freeze;
    &carga_porciones_r($raiz, $dir);
    $p_list->sort_recursive($raiz);
    $p_list->thaw;
}

sub carga_porciones_r {
    my $raiz = shift;
    my $dir = shift;
    
    opendir(DIR, $dir);
    my @archivos = readdir DIR;
    closedir DIR;
    
    $dir =~ s/(.*)\/$/$1/;
    
    foreach $archivo (@archivos) {
	if (! ($archivo eq "." or $archivo eq ".." )) {
	    if (-d "$dir/$archivo") {
		$raiz_nueva = &insert_node($p_list,$raiz,[$archivo], 0);
		carga_porciones_r($raiz_nueva, "$dir/$archivo");
	    } elsif (-f "$dir/$archivo" && ($archivo =~ /.*\.xml\.porcion$/)) {
		$archivo =~ s/(.*)\.xml\.porcion/$1/;
		my $porcion = &insert_node($p_list,$raiz, [$archivo], 1);
		my $p_id = &arma_porcion_id($porcion);
		$p_list->node_set_row_data($porcion,\$p_id);
	    }
	}
    }
}

## callbacks..
sub gtk_main_quit {
    main_quit Gtk;
}

sub gtk_widget_hide {
    shift->hide();
}
sub gtk_widget_show {
    my ($w) = shift;
    $w->show;
}

sub on_btnCargar_clicked {
    if (not defined $fs_window) {
	$fs_window = new Gtk::FileSelection("Seleccione archivo a cargar");
	$fs_window->position(-mouse);
	$fs_window->signal_connect("destroy", \&destroy_window, \$fs_window);
	$fs_window->signal_connect("delete_event", \&destroy_window, \$fs_window);
	$fs_window->ok_button->signal_connect("clicked", \&file_in_selection_ok, $fs_window);
	$fs_window->cancel_button->signal_connect("clicked", sub { destroy $fs_window });
	
    }
    if (!visible $fs_window) {
	show $fs_window;
    } else {
	destroy $fs_window;
    }
}

sub on_btnAgregar_clicked {
    my @nodos = $p_list->selection;
    $c_list->freeze;
    # Procesamos la lista de seleccionados
    foreach $nodo (@nodos) {
	# Si es una porción...
	if($nodo->row->is_leaf) {
	    # Lo agregamos al primer nodo por defecto...
	    my $porcion_id = &arma_porcion_id($nodo);
	    my $c_nodo =&insert_node($c_list, $c_list->node_nth(0), [$porcion_id], 0);
	    $c_list->node_set_row_data($c_nodo,\$porcion_id);
	    &porcion_set_selectable($nodo,0);
	}
	# Si es una categoría...agregamos todo tu contenido
	else {
	    # Por ahora no hacemos nada, pero deberían
	    # agregarse todas las porciones dentro de la categoría
	    #

	    $p_list->select_recursive($nodo);
	    $p_list->unselect($nodo);
	    foreach $sub_nodo ($p_list->selection()){
		if($sub_nodo->row->is_leaf) {
		    # Lo agregamos al primer nodo por defecto...
		    my $porcion_id = &arma_porcion_id($sub_nodo);
		    my $c_nodo = &insert_node($c_list, $c_list->node_nth(0), [$porcion_id], 0);
		    $c_list->node_set_row_data($c_nodo,\$porcion_id);
		    # deshabilitamos para que no se seleccione
		    &porcion_set_selectable($sub_nodo,0);
		}else{
		    $p_list->unselect($sub_nodo);
		}
	    }
	}
    }
    $c_list->thaw;
}

# sub on_porciones_tree_collapse {
#     my $raiz = shift;
    
#     my @lista_rows = $p_list->row_list;

#     foreach $row (@lista_rows) {
# 	my $item = $row->children;
# 	# Falta implementar....
# 	# FIXME
#     }
# }


sub insert_node {
   my ( $tree, $parent, $text, $is_leaf ) = @_;

   my @args;
   my $true = 1;
   my $false = 0;

   if ( $is_leaf ) {
          @args = ( $leaf, $leaf_mask,
   		    undef, undef,
		    $true, $false );
   } else {
	  @args = ( $closed, $closed_mask,
		    $opened, $opened_mask,
		    $false, $false );
   }
   return ( $tree->insert_node( $parent, undef, $text, 5, @args ) );
}

sub initialize_pixmap {
   my @xpm = @_;

   my $pixmap;
   my $mask;
   my $style = $w->get_style()->bg( 'normal' );

   ($pixmap, $mask) = Gtk::Gdk::Pixmap->create_from_xpm_d( $w->window,
       							   $style, @xpm );
   return ( $pixmap, $mask );
}

# Función recursiva que va subiendo por la estructura
# de árbol y devuelve el path completo de la porción
sub arma_porcion_id {
    my($nodo) = @_;

    my $nodo_padre = $nodo->row->parent;
    my @nodo_info = $p_list->get_node_info($nodo);
    
    if($nodo_padre) {
	return &arma_porcion_id($nodo_padre)."/".$nodo_info[0];
    } else {
	return $nodo_info[0];
    }
}

sub file_in_selection_ok {
    my($widget, $fs) = @_;
    my $file_name = $fs->get_filename();
    $fs->destroy;

    if (-f $file_name) {
	$p_list->freeze;
	$c_list->freeze;

	$c_list->select_recursive($raiz_curso);
	&on_btnQuitar_clicked();
	
	&parse_cfg_file($file_name);
	&deshabilitar_porciones(\$raiz_curso);
	$c_list->collapse($raiz_curso);
	$c_list->expand($raiz_curso);
	$p_list->thaw;
	$c_list->thaw;
    } 
}

sub parse_cfg_file {
    my ($cfg_file) = @_;

    open(FILE, "$cfg_file");

    # Algunas variables...
    my $profundidad = 0;
    my $nro_linea = 0;
    my $nueva_prof;


    while($linea = <FILE>) {
	my $porcion;
	chomp($linea);
	$nro_linea++;
	
	# Eliminamos comentarios
	$linea =~ s/\#.*//;
	# Transformamos TABs en espacios
	$linea =~ s/\t/ /g;
	# Reemplazamos múltiples espacios por uno solo
	$linea =~ s/  (.*)/ $1/;

	# Si lo que encontramos es una linea válida...
	if($linea =~ /.+ .+/) {
	    ($nueva_prof,$porcion) = split(" ", $linea);
	    
	    if($nueva_prof > $profundidad) {
		# Bajamos en profundidad
		if($nueva_prof - $profundidad > 1) {
		    die "Error en archivo $cfg_file; línea $nro_linea\n";
		}
	    }

	    my $nodo_porcion = &insert_node($c_list,$raiz_curso,[$porcion], 0);
	    $c_list->node_set_row_data($nodo_porcion, \$porcion);
	    $profundidad = $nueva_prof;

	    while($nueva_prof - 1) {
		$nueva_prof--;
		$c_list->select($nodo_porcion);
		&on_btnDerecha_clicked();
		$c_list->unselect($nodo_porcion);
	    }
	}
    }
    close(FILE);
}

sub destroy_window {
        my($widget, $windowref, $w2) = @_;
        $$windowref = undef;
        $w2 = undef if defined $w2;
        0;
}
my $ret;
sub on_btnQuitar_clicked {
    my @nodos = $c_list->selection;
    my $nodo;
    # Procesamos la lista de seleccionados
    foreach $nodo (@nodos) {
	$c_list->select_recursive($nodo);
    }

    my @t_nodos = $c_list->selection;
    $c_list->freeze;
    foreach my $c_nodo (@t_nodos){
	# Esto es muy pedorro....
	# La funcones post_recursive y pre_recursive, pierden el último
	# elemento que se le pasa como argumento
	# FIXME !!!
	
	#$c_list->remove($c_nodo);
	my $c_id = $c_list->node_get_row_data($c_nodo);
	$p_list->post_recursive($raiz,\&compara_nodos,$c_nodo,$c_id,undef);
	if($ret){
	    &porcion_set_selectable($ret,1);
	    &borra_nodo($$c_id);
	    $ret = undef;
	}
    }
    $c_list->thaw;
}

sub compara_nodos{
    my($p_tree, $p_nodo,$c_nodo, $c_id) = @_;

    if($p_nodo->row->is_leaf){
	my $p_id = $p_list->node_get_row_data($p_nodo);
 	if($$c_id eq $$p_id){
	    $ret = $p_nodo;
 	}
    }
}

sub borra_nodo{
    my ($id)= @_;

    $c_list->freeze;
    $c_list->select_recursive($raiz_curso);
    my @nodos = $c_list->selection();
    foreach my $nodo (@nodos) {
	my $c_id = $c_list->node_get_row_data($nodo);
	if($id eq $$c_id){
	    my $children = $nodo->row->children;
	    while($children){
		on_btnIzquierda_clicked($children);
		$children = $nodo->row->children;
	    }
	    $c_list->remove($nodo);
	}
    }	
    $c_list->unselect_recursive($raiz_curso);
    $c_list->thaw;
}	

sub on_curso_tree_move {
#    print "Moviendo ramas...\n";
}

sub on_btnArriba_clicked{
    my @nodos = $c_list->selection;
    $c_list->freeze;
    foreach my $nodo (@nodos) {
	my $parent = $nodo->row->parent;
	my $child = &prev_brother($nodo);
	if($child){
	    $c_list->move($nodo, $parent, $child);
	}
    }
    $c_list->thaw;
}
sub on_btnAbajo_clicked{
    my @nodos = $c_list->selection;
    $c_list->freeze;
    foreach my $nodo (@nodos) {
	my $parent = $nodo->row->parent;
	my $child = $nodo->row->sibling;
	if($child){
	    $c_list->move($nodo, $parent, $child->row->sibling);
	}
    }
    $c_list->thaw;
}

sub on_btnDerecha_clicked{
    my @nodos = $c_list->selection;
    $c_list->freeze;
    foreach my $nodo (@nodos) {
	my $parent = &prev_brother($nodo); 

	if($parent){
	    $c_list->move($nodo, $parent, undef);
	    $c_list->expand($parent);
	}
    }
    $c_list->thaw;
}
sub on_btnIzquierda_clicked {
   my @nodos = $c_list->selection;
    $c_list->freeze;
    foreach my $nodo (@nodos) {
	my $parent = $nodo->row->parent; 
	if($parent->row->parent){
	    my $sibling = $parent->row->sibling;
	    $c_list->move($nodo, $parent->row->parent, $sibling);
	}
    }
    $c_list->thaw;
}

sub prev_brother {
    my ($nodo) = @_;
    
    my $parent = $nodo->row->parent;
    my $prev_bro = $parent->row->children;
    if($nodo != $prev_bro){
	while($nodo != $prev_bro->row->sibling){
	    $prev_bro = $prev_bro->row->sibling;
	}
	return $prev_bro;
    }
    return undef;

}

sub on_btnGuardar_clicked{

    if (not defined $fs_window) {
	$fs_window = new Gtk::FileSelection("Seleccione archivo de destino");
	$fs_window->position(-mouse);
	$fs_window->signal_connect("destroy", \&destroy_window, \$fs_window);
	$fs_window->signal_connect("delete_event", \&destroy_window, \$fs_window);
	$fs_window->ok_button->signal_connect("clicked", \&file_out_selection_ok, $fs_window);
	$fs_window->cancel_button->signal_connect("clicked", sub { destroy $fs_window });
	
    }
    if (!visible $fs_window) {
	show $fs_window;
    } else {
	destroy $fs_window;
    }
}

sub file_out_selection_ok{
    my($widget, $fs) = @_;
    my $cfg_file = $fs->get_filename();
    $fs->destroy;
    open(CFG_FILE,">$cfg_file");
    &browse_tree_print_cfg(0,$raiz_curso);
    close(CFG_FILE);
}

sub browse_tree_print_cfg{
    my ($depth, $node) = @_;
    
    my $node_data;

    if($node != $raiz_curso){
	$node_data = $c_list->node_get_row_data($node);
	print CFG_FILE "$depth      $$node_data\n";
    }

    my $children = $node->row->children;
    while($children){
	&browse_tree_print_cfg(($depth + 1),$children);
	$children = $children->row->sibling;
    }
    
}

sub deshabilitar_porciones{
    my ($node)= @_;
    my $c_id;
    
 
    if($$node != $raiz_curso){
	$c_id = $c_list->node_get_row_data($$node);
	&match_porcion_id($c_id,\$raiz);
	&porcion_set_selectable($ret,0);
    }

    my $children = $$node->row->children;
    while($children){
	&deshabilitar_porciones(\$children);
	$children = $children->row->sibling;
    }
}

sub match_porcion_id {
    my ($c_id,$node) = @_;

    my $p_id;
 
    if($$node->row->is_leaf ){
	$p_id = $p_list->node_get_row_data($$node);
	if($$c_id eq $$p_id){
	    $ret = $$node;
	}
    }

    my $children = $$node->row->children;
    while($children){
	&match_porcion_id($c_id,\$children);
	$children = $children->row->sibling;
    }
}


sub porcion_set_selectable{
    my ($porcion,$select) = @_;
    my $color;

    if($select){
	$color=Gtk::Gdk::Color->parse_color('black');
    }else{
	$color=Gtk::Gdk::Color->parse_color('red');
    }
	
    $p_list->node_set_selectable($porcion, $select);
    $p_list->node_set_foreground($porcion, $color);
}

