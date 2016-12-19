
sub log () {
   my $type = shift ;
   my $text = shift ;
   if ( defined $global{Config}{openHAB}{logdir} ) {
      mkdir "$global{Config}{BaseDir}/$global{Config}{openHAB}{logdir}" if ! -d "$global{Config}{BaseDir}/$global{Config}{openHAB}{logdir}" ;
      open (LOG, ">>$global{Config}{BaseDir}/$global{Config}{openHAB}{logdir}/$type.log") ;
      $timestamp = &timestamp ;
      print LOG "$timestamp $text\n" ;
      close LOG ;
   }
}

return 1 ;
