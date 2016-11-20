
sub log_openHAB () {
   my $text = shift ;
   if ( defined $global{Config}{openHAB}{logdir} ) {
      mkdir "$global{Config}{BaseDir}/$global{Config}{openHAB}{logdir}" if ! -d "$global{Config}{BaseDir}/$global{Config}{openHAB}{logdir}" ;
      open (LOG, ">>$global{Config}{BaseDir}/$global{Config}{openHAB}{logdir}/openHAB.log") ;
      $timestamp = &timestamp ;
      print LOG "$timestamp $text\n" ;
      close LOG ;
   }
}

sub log_mysql () {
   my $text = shift ;
   if ( defined $global{Config}{mysql}{logdir} ) {
      mkdir "$global{Config}{BaseDir}/$global{Config}{mysql}{logdir}" if ! -d "$global{Config}{BaseDir}/$global{Config}{mysql}{logdir}" ;
      open (LOG, ">>$global{Config}{BaseDir}/$global{Config}{mysql}{logdir}/mysql.log") ;
      $timestamp = &timestamp ;
      print LOG "$timestamp $text\n" ;
      close LOG ;
   }
}

return 1 ;
