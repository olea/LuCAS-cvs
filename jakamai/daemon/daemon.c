/*

PROJECT JAKAMAI
Jakamai Daemon

daemon.c -- A daemon for periodically checking URL state, and update them
in Jakamai database.
$Id: daemon.c,v 1.2 2001/06/09 12:41:19 jjamor Exp $
Copyright (C) 2001  Juan Jose Amor Iglesias

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/

#define _GNU_SOURCE

#include <my_global.h>
#include <my_sys.h>
#include <mysql.h>

#include <ghttp.h>

#include <unistd.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <getopt.h>

int wwwstatus;
char host[32];
char user[32];
char password[32];
char database[32];
char agentString[32];

#define HALFHOUR 5

#define DVERSION "0.5"
#define DEFHOST "localhost"
#define DEFBASE "jakamai"

void daemon_sig_handler (int param)
{

  /* Terminate HTTP */
  /* empty */

  exit(0);

}

int send_head_request(char *url)
{   

  ghttp_request * request;
  int status;

  request = ghttp_request_new();

  ghttp_set_uri(request,url);

  ghttp_set_header(request, http_hdr_Connection, "close");

  ghttp_set_header(request, http_hdr_User_Agent, agentString);

  ghttp_set_type(request, ghttp_type_head);

  ghttp_set_sync(request, ghttp_sync);

  ghttp_prepare(request);

  ghttp_process(request);

  wwwstatus = ghttp_status_code(request);

  /* wwwstatus is the HTTP response code. By reading RFC 2616,
   * section "Status Code Definitions", all responses 2xx and 3xx
   * are considered Ok or Redirection (semi-OK) responses, so
   * we consider these codes as "mirror Ok" */
  if ( (wwwstatus >= 200) && (wwwstatus < 400))
    return 1;
  else
    return 0;

}

void checkloop(MYSQL *mysql)
{

  char querystring[256];

  int inservice;
  
  MYSQL_RES *result;
  
  MYSQL_ROW row;

  if (!mysql_real_connect(mysql,host,user,password,database,0,NULL,0)) {
    fprintf(stderr, "Failed to connect to database: Error: %s\n",
	    mysql_error(mysql));
    return;
  }
  
  if (mysql_query(mysql,"SELECT * FROM server")) {
    fprintf(stderr, "Error fetching server table");
    mysql_close(mysql);
    return;
  }
  
  result = mysql_store_result(mysql);
  
  while (row = mysql_fetch_row(result)) {
    
    inservice = send_head_request(row[1]);
    
    if (inservice && !strcmp(row[3], "0")) {
      sprintf(querystring,"UPDATE server SET inservice = %d WHERE name = \"%s\"",
	      1,row[0]);
      if (mysql_query(mysql,querystring)) fprintf(stderr,"SQL error: %s\n",
						  mysql_error(mysql));

    }
    
    if (!inservice && strcmp(row[3], "0")) {
      sprintf(querystring,"UPDATE server SET inservice = %d WHERE name = \"%s\"",
	      0,row[0]);
      if (mysql_query(mysql,querystring)) fprintf(stderr,"SQL error: %s\n",
						  mysql_error(mysql));
     }
    
  }
  
  mysql_free_result(result);
  
  mysql_close(mysql);

}

void usage(char *pname)
{
  fprintf(stderr,"Jakamai Daemon version %s\n",DVERSION);
  fprintf(stderr,
	  "Usage: %s [-d] [-h mysqlhost] [-b database] -u mysqluser -p password\n",
	  pname);
  fprintf(stderr, "Default host: %s\nDefault database: %s\n\n",
	  DEFHOST,DEFBASE);

  fprintf(stderr,
	  "This program is distributed under GNU GPL License version 2.\n");
  fprintf(stderr,
	  "That is, this program IS FREE\n\n");

}

int main(int argc, char **argv)
{

  MYSQL mysql;

  int pid;
  int is_daemon;
  int c;

  signal(SIGINT,daemon_sig_handler);
  signal(SIGTERM,daemon_sig_handler);

  /*
   * Init config data
   */
  strcpy(host,DEFHOST);
  user[0] = (char) 0;
  password[0] = (char) 0;
  strcpy(database,DEFBASE);
  sprintf(agentString,"LuCAS-checkurl/%s",DVERSION);

  /*
   * Check options
   */

  is_daemon = 0;

  while (1) {

    c = getopt(argc, argv, "dh:b:u:p:");


    if (c == -1)
      break;

    switch(c) {

    case 'd':
      is_daemon = 1;
      break;

    case 'h':
      strcpy(host,optarg);
      break;

    case 'b':
      strcpy(database,optarg);
      break;

    case 'u':
      strcpy(user,optarg);
      break;

    case 'p':
      strcpy(password,optarg);
      break;

    default:
      break;
    }

  }

  if ( (host[0] == (char) 0) || (database[0] == (char) 0) ||
       (user[0] == (char) 0) || (password[0] == (char) 0) ) {
    /* Required options empty: exit */
    usage(argv[0]);
    exit(1);
  }

  mysql_init(&mysql);
  mysql_options(&mysql,MYSQL_OPT_COMPRESS,0);
  mysql_options(&mysql,MYSQL_READ_DEFAULT_GROUP,"odbc");

  if (is_daemon) {
    if (pid = fork())
      {
	fprintf(stdout,"Daemon launched\n");
	exit(0);
      } else {
	while (1) {
	  checkloop(&mysql);
	  sleep(HALFHOUR);
	}
      }
  } else {
    while (1) {
      checkloop(&mysql);
      sleep(HALFHOUR);
    }
  }

  return(0);

}
