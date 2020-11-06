#!/usr/bin/perl

use lib "/home/velbus/velserver/lib" ;

use strict;
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
use CGI::Session ;

$global{cgi}{CGI} = new CGI ;

# Ignore SIGPIPE otherwise when you overload this script it will terminate with error code 141
$SIG{PIPE} = "IGNORE";

my $d = HTTP::Daemon->new(
      LocalPort => $global{Config}{velserver}{WEBSERVERPORT},
      Reuse => 1,
   ) ;

if ( $d ) {
   &log("webserver",&timestamp . " Web Server started, server address: " . $d->sockhost(). ", server port: " . $d->sockport()) ;
   print "Web Server started, server address: ", $d->sockhost(), ", server port: ", $d->sockport(),"\n" ;

   my $sock = &open_socket ;

   while (my $c = $d->accept) {
      # Connected socket? Good!
      if ( defined $sock and $sock->connected ) {

      # No socket or socket exist but it's not connected? Open a new one.
      } else {
         $sock = &open_socket ;
         if ( defined $sock and $sock->connected ) {
            &log("webserver",&timestamp . " OK: Connection opened to $global{Config}{velbus}{HOST} port $global{Config}{velbus}{PORT}") ;
         } else {
            &log("webserver",&timestamp . " ERROR: No connection to $global{Config}{velbus}{HOST} port $global{Config}{velbus}{PORT}") ;
         }
      }
      threads->create(\&process, $c, $sock)->detach ;
      #&process($c) ;
   }
} else {
   &log("webserver",&timestamp . " Web server not started on port $global{Config}{velserver}{WEBSERVERPORT}: $@") ;
   print "Web server not started on port $global{Config}{velserver}{WEBSERVERPORT}: $@\n" ;
}

sub process {
   my $c = shift ;
   my $sock = shift ;

   while (my $r = $c->get_request) {
      &init ;
      &log("webserver",&timestamp . sprintf("[%s] %s %s", $c->peerhost, $r->method, $r->uri->as_string)) ;

      my $response = new HTTP::Response("200") ;
      $response->protocol("HTTP/1.0") ;
      $response->request($r) ;

      # For Memo, we do a POST and so we get the Value in the content of the request.
      if ( defined $r->{_content} ) { # and $r->{_content} ne "" ) {
         $global{cgi}{params}{Value} = $r->{_content} ;
      }

      # Get the CGI parameters
      my $u = URI->new($r->uri->as_string) ;
      foreach ($u->query_param) {
         $global{cgi}{params}{$_} = $u->query_param($_) ;
      }

      # Depending on the path, we have a webservice call or we need to serve a web page
      my $path = $r->url->path ;
      if ( $path eq "/service" ) {

         my %json ;

         if ( defined $sock and $sock->connected ) {
            %json = &www_service ($sock) ;
         } else {
            $json{Error} = "ERROR: No connection to $global{Config}{velbus}{HOST} port $global{Config}{velbus}{PORT}" ;
         }

         if ( defined $global{cgi}{params}{html} ) {
            $response->header(-type=>'text/html') ;
            my $html ;
            foreach my $key (sort keys %json) {
               $html .= "$key: $json{$key}\n" ;
            }
            $response->content($html) ;
         } else {
            $response->header('type' => 'application/json') ;
            my $encoder = JSON::XS->new();
            $encoder->allow_nonref();
            my $json = $encoder->encode(\%json);
            $response->content($json) ;
            if ( defined $json{Status} ) {
               if ( $json{Status} eq "" ) {
                  &log("webserver",&timestamp . " $global{cgi}{params}{Item}: No Status") ;
               } else {
                  &log("webserver",&timestamp . " $global{cgi}{params}{Item}: Status = $json{Status}") ;
               }
            } else {
               &log("webserver",&timestamp . sprintf("[%s] %s %s", $c->peerhost, $r->method, $r->uri->as_string)) ;
               &log("webserver",&timestamp . " ERROR: $json") ;
            }
         }

      } elsif ( $path =~ /include\/(.+)/ ) {
         my $file = $global{BaseDir} . "/www/include/$1" ;
         $response->header('type' => 'application/javascript') ;
         if ( -f $file ) {
            my $content ;
            open (FILE, '<', $file) ;
	         while (<FILE>) {
               $content .= $_ ;
	         }
            close FILE ;
            $response->content($content)  ;
         }

      } else {
         &read_all_configs ; # Re-read the config files to pick up possible changes
         my $content = &www_index ;
         $response->content($content)  ;
      }

      $c->send_response($response) ;
      $c->send_crlf ;
   }
   $c->daemon->close ; # close server socket in client
   $c->close ;
}

