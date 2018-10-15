#!/usr/bin/perl

use lib "/home/velbus/velserver/lib" ;

use strict;
use POSIX qw/strftime/;
use URI::QueryParam qw( );

our %global ; # Variable shared by all functions where we store all data
$global{BaseDir} = "/home/velbus/velserver" ;

use Velbus ;
use Velbus::Velbus_www ;

&init ;

use HTTP::Daemon;
use threads;
use JSON ;

use CGI ;

$global{cgi}{CGI} = CGI->new;

# Ignore SIGPIPE otherwise when you overload this script it will terminate with error code 141
$SIG{PIPE} = "IGNORE";

my $d = HTTP::Daemon->new(
      LocalPort => $global{Config}{velserver}{WEBSERVERPORT},
      Reuse => 1,
   ) ;

if ( $d ) {
   &log("webserver","Web Server started, server address: ", $d->sockhost(), ", server port: ", $d->sockport()) ;
   print "Web Server started, server address: ", $d->sockhost(), ", server port: ", $d->sockport(),"\n" ;

   while (my $c = $d->accept) {
      #&process($c) ;
      threads->create(\&process, $c)->detach ;
       $c->close ;  # close client socket in server
   }
} else {
   &log("webserver","Web server not started on port $global{Config}{velserver}{WEBSERVERPORT}: $@") ;
   print "Web server not started on port $global{Config}{velserver}{WEBSERVERPORT}: $@\n" ;
}

sub process {
   my $c = shift ;
   $c->daemon->close ; # close server socket in client
   while (my $r = $c->get_request) {
      &init ;
      &log("webserver",sprintf("[%s] %s %s", $c->peerhost, $r->method, $r->uri->as_string)) ;

      my $response = new HTTP::Response("200") ;
      $response->protocol("HTTP/1.0") ;
      $response->request($r) ;

      # Get the CGI parameters
      my $u = URI->new($r->uri->as_string) ;
      foreach ($u->query_param) {
         $global{cgi}{params}{$_} = $u->query_param($_) ;
      }

      # Depending on the path, we have a webservice call or we need to serve a web page
      my $path = $r->url->path ;
      if ( $path eq "/service" ) {
         my %json = &www_service ;
         if ( %json ) {
            $response->header('type' => 'application/json') ;
            my $encoder = JSON::XS->new();
            $encoder->allow_nonref();
            my $json = $encoder->encode(\%json);
            $response->content($json) ;
         }
      } else {
         &read_all_configs ; # Re-read the config files to pick up possible changes
         my $content = &www_index ;
         $response->content($content)  ;
      }

      $c->send_response($response) ;
      $c->send_crlf ;
   }
   $c->close ;
}
