#!/bin/sh
#
# Copyright (C) 2004 Sergio González González <sergio.gonzalez@hispalinux.es>
# 
# Depends on:
#               - ldapsearch
#               - maildirmake ( from courier )
#
# Based on http://jeroen.protheus.com/postfix-courier-ldap-howto.html
# (c) J.Vriesman
#
# and
#
# Based on http://bulma.net/body.phtml?nIdNoticia=2013
# (c) Jesús Roncero Franco
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#
# This script manage the home directories of LDAP users (make the new users home
# directory and delete the non-existent users home directory)


# Password to bind to ldap server
systempass="1"  
# Bind dn
binddn="cn=admin,dc=gsr,dc=pt" 
# Acount leave
accountleave="ou=people,dc=gsr,dc=pt" 
# ldap host
ldaphost="gsr.pt"
# skel directory
skel="/etc/skel/"
# Home leave (without final slash: '/')
homeleave="/home/samba/users"


usernames=`ldapsearch -h $ldaphost -x -w $systempass -D "$binddn" \
                      -b "$accountleave" uid | grep "^[^#]" | grep "^[^dn]" \
                      | grep uid | awk '{ print $2 }'`

# create personal home directories

for username in $usernames
do
  homedirectory=`ldapsearch -h $ldaphost -x -w $systempass -D "$binddn" \
                            -b "$accountleave" "(uid=$username)" homeDirectory \
                            | grep "^[^#]" | grep homeDirectory \
                            | awk '{ print $2 }'`

  group=`ldapsearch -h $ldaphost -x -w $systempass -D "$binddn" \
                    -b "$accountleave" "(uid=$username)" gidNumber \
                    | grep "^[^#]" | grep gidNumber \
                    | awk '{ print $2 }'`

  if [ ! -d $homedirectory ] && [ ! -z $homedirectory ]
  then

    cp -a $skel $homedirectory
    chown -R $username.$group $homedirectory
  fi

done

# delete personal home directories

for username in `ls $homeleave`
do
  name=`ldapsearch -h $ldaphost -x -w $systempass -D "$binddn" \
                   -b "$accountleave" "(homeDirectory=$homeleave/$username)" uid \
                   | grep "^[^#]" | grep "uid:" | awk '{ print $2 }'`

  if [ -z $name ]
  then
    rm -rf $homeleave/$username
  fi
done
