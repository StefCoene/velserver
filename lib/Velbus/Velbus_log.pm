
sub log () {
   my $type = shift ;
   my $text = shift ;
   if ( defined $global{Config}{velbus}{LOGDIR} ) {
      mkdir "$global{Config}{BaseDir}/$global{Config}{velbus}{LOGDIR}" if ! -d "$global{Config}{BaseDir}/$global{Config}{velbus}{LOGDIR}" ;
      open (LOG, ">>$global{Config}{BaseDir}/$global{Config}{velbus}{LOGDIR}/$type.log") ;
      $timestamp = &timestamp ;
      print LOG "$timestamp $text\n" ;
      close LOG ;
   }
}

return 1 ;
