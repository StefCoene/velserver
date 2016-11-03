
sub www_print_modules () {
   my $html ;
   $html .= "<h1>All modules on bus</h1>\n" ;

   $html .= "<!--\n" ;
   $html .= Dumper \%{$global{Vars}{Modules}{Address}} ;
   $html .= "-->\n" ;

   foreach my $status (sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerStatus}})) {
      next if $status eq "Start scan" ;

      $html .= "<h2>$status</h2>\n" ;

      $html .= "<table border=1>\n" ;
      $html .= "<thead>\n" ;
      $html .= "  <tr>\n" ;
      $html .= "    <th>Address</th>\n" ;
      $html .= "    <th>Type</th>\n" ;
      $html .= "    <th>Info</th>\n" ;
      $html .= "    <th>Date</th>\n" ;
      #$html .= "    <th>Name</th>\n" ;
      $html .= "  </tr>\n" ;
      $html .= "</thead>\n" ;

      $html .= "<tbody>\n" ;
      my $html2 ;
      foreach my $address ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerStatus}{$status}}) ) {
         $html .= "  <tr>\n" ;
         if ( defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr} ) {
            my $SubAddr = join ",", @{$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr}} ;
            $html .= "    <th>$address ($SubAddr)</th>\n" ;
         } else {
            $html .= "    <th>$address</th>\n" ;
         }
         my $type = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{'type'} ; # Handier var
         $html .= "    <td>$global{Cons}{ModuleTypes}{$type}{Type} ($type)</td>\n" ;
         $html .= "    <td>$global{Cons}{ModuleTypes}{$type}{Info}</td>\n" ;
         $html .= "    <td>$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{'date'}</td>\n" ;
         #$html .= "    <td>$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{'name'}</td>\n" ;

         if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo} ) {

            my $type = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{'type'} ; # Handier var
            $html2 .= "<h3>Channel info for $global{Cons}{ModuleTypes}{$type}{Type}: $global{Cons}{ModuleTypes}{$type}{Info} ($address)</h3>\n" ;

            $html2 .= "<table border=1>\n" ;
            $html2 .= "<thead>\n" ;
            $html2 .= "  <tr>\n" ;
            $html2 .= "    <th>Channel</th>\n" ;
            $html2 .= "    <th>Key</th>\n" ;
            $html2 .= "    <th>Value</th>\n" ;
            $html2 .= "  </tr>\n" ;
            $html2 .= "</thead>\n" ;

            $html2 .= "<tbody>\n" ;
            foreach my $Channel ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{Address}{$address}{ChannelInfo}}) ) {
               foreach my $KeyChannel ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}}) ) {
                  $html2 .= "  <tr>\n" ;
                  $html2 .= "    <th>$Channel</th>\n" ;
                  $html2 .= "    <th>$KeyChannel</th>\n" ;
                  $html2 .= "    <td>$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{$KeyChannel}</td>\n" ;
                  $html2 .= "  </tr>\n" ;
               }
            }
            $html2 .= "</tbody>\n" ;
            $html2 .= "</table>\n" ;

         }
         $html .= "  </tr>\n" ;
      }
      $html .= "</tbody>\n" ;
      $html .= "</table>\n" ;
      $html .= $html2 if defined $html2 ;
   }
   print $html ;
}

sub www_print_velbus_protocol () {
   if ( defined $global{cgi}{params}{ModuleType} ) {
      &www_print_velbus_protocol_print_moduleType($global{cgi}{params}{ModuleType}) ;
   } else {
      &www_print_velbus_protocol_print_modules ;
   }
}

sub www_print_velbus_protocol_print_moduleType () {
   my $ModuleType = $_[0] ;
   $html .= "<h2>$global{Cons}{ModuleTypes}{$ModuleType}{Type} ($ModuleType): $global{Cons}{ModuleTypes}{$ModuleType}{Info}</h2>\n" ;

   if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels} ) {
      $html .= "<h3>Available channels on module</h3>\n" ;
      $html .= "<table border=1 class=\"datatable oggle1\">\n" ;
      $html .= "<thead>\n" ;
      $html .= "  <tr>\n" ;
      $html .= "    <th>Channel</th>\n" ;
      $html .= "    <th>Name</th>\n" ;
      $html .= "  </tr>\n" ;
      $html .= "</thead>\n" ;

      $html .= "<tbody>\n" ;
      foreach my $Channel ( sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}{$ModuleType}{Channels}}) ) {
         $html .= "  <tr>\n" ;
         $html .= "    <th>$Channel</th>\n" ;
         $html .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}</td>\n" ;
         $html .= "  </tr>\n" ;
      }
      $html .= "</tbody>\n" ;
      $html .= "</table>\n" ;
   }

   if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages} ) {
      $html .= "<h3>Possible messages</h3>\n" ;
      $html .= "<table border=1 class=\"datatable oggle1\">\n" ;
      $html .= "<thead>\n" ;
      $html .= "  <tr>\n" ;
      $html .= "    <th>Message</th>\n" ;
      $html .= "    <th>Name</th>\n" ;
      $html .= "    <th>Info</th>\n" ;
      $html .= "    <th>MessageType</th>\n" ;
      $html .= "  </tr>\n" ;
      $html .= "</thead>\n" ;

      $html .= "<tbody>\n" ;
      my $html2 ;
      my %Messages ;

      foreach my $Message ( sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}{$ModuleType}{Messages}}) ) {
         $html .= "  <tr>\n" ;
         $html .= "    <th>$Message</th>\n" ;
         $html .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Name}</td>\n" ;
         $html .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Info}</td>\n" ;
         $html .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{MessageType}</td>\n" ;
         $html .= "  </tr>\n" ;

         if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data} ) {
            $html2 .= "<h4>Databytes for message $Message ($global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Name}: $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Info})</h4>\n" ;
            $html2 .= "<table border=1 class=\"datatable oggle1\">\n" ;
            $html2 .= "<thead>\n" ;
            $html2 .= "  <tr>\n" ;
            $html2 .= "    <th>DataByte</th>\n" ;
            $html2 .= "    <th>Name</th>\n" ;
            $html2 .= "    <th>Type</th>\n" ;
            $html2 .= "    <th>Parser: result</th>\n" ;
            $html2 .= "  </tr>\n" ;
            $html2 .= "</thead>\n" ;
      
            $html2 .= "<tbody>\n" ;
            foreach my $DataByte (  sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}}) ) {
               $html2 .= "  <tr>\n" ;
               $html2 .= "    <th>$DataByte</th>\n" ;
               $html2 .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}{$DataByte}{Name}</td>\n" ;
               $html2 .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}{$DataByte}{Type}</td>\n" ;
               $html2 .= "    <td>\n" ;
               foreach my $Parser ( sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}{$DataByte}{Match}}) ) {
                  $html2 .= "$Parser: $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}{$DataByte}{Match}{$Parser}{Info}<br />\n" ;
               }
               $html2 .= "    </td>\n" ;
               $html2 .= "  </tr>\n" ;
            }
            $html2 .= "</tbody>\n" ;
            $html2 .= "</table>\n" ;
         }
      }
      $html .= "</tbody>\n" ;
      $html .= "</table>\n" ;
      $html .= $html2 if defined $html2 ;
   }
   print $html ;
}

sub www_print_velbus_protocol_print_modules () {
   my $html ;
   $html .= "<h1 class=\"\">All known modules</h1>\n" ;
   $html .= "<table border=1 class=\"datatable oggle1\">\n" ;
   $html .= "<thead>\n" ;
   $html .= "  <tr>\n" ;
   $html .= "    <th>Module</th>\n" ;
   $html .= "    <th>Type</th>\n" ;
   $html .= "    <th>Info</th>\n" ;
   $html .= "  </tr>\n" ;
   $html .= "</thead>\n" ;

   foreach my $ModuleType (sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}})) {
      $html .= "  <tr>\n" ;
      $html .= "    <th>$ModuleType</th>\n" ;
      $html .= "    <td><a href=$global{cgi}{url}&ModuleType=$ModuleType>$global{Cons}{ModuleTypes}{$ModuleType}{Type}</a></td>\n" ;
      $html .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Info}</td>\n" ;
      $html .= "  </tr>\n" ;
   }

   $html .= "<tbody>\n" ;
   $html .= "</tbody>\n" ;
   $html .= "</table>\n" ;
   print $html ;
}

sub www_scan () {
   my $sock = &open_socket ;
   &scan($sock) ;
}

sub www_status () {
   my $sock = &open_socket ;
   &get_modules_status($sock) ;
}

return 1 ;
