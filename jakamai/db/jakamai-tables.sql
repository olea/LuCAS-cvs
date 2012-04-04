# MySQL dump 8.13
#
# Host: localhost    Database: jakamai
#--------------------------------------------------------
# Server version	3.23.36-log
#
##
# Código fuente Jakamai
# Copyright (C) 2001 Hispalinux / Juan J. Amor
# Programa bajo la proteccion de GPL 2.0
##
# $Id: jakamai-tables.sql,v 1.2 2001/06/09 12:38:41 jjamor Exp $
##
#

#
# Table structure for table 'server'
#

CREATE TABLE server (
  name varchar(30) NOT NULL default '',
  mainurl varchar(80) NOT NULL default '',
  maintainer varchar(40) default NULL,
  inservice tinyint(1) NOT NULL default '0',
  loadpercent int(2) NOT NULL DEFAULT '0',
  PRIMARY KEY  (name)
) TYPE=MyISAM;

#
# Dumping data for table 'server'
#


