#!/usr/bin/perl

use Data::Dumper ;

my $file = $ARGV[0] ;

my %data ;

if ( -f $file ) {
  foreach my $line (`pdf2txt $file`) {
    if ( $line =~ /DATABYTE1 = (.+) \(H’(..)’\)/ ) {
      $data{$2} = $1 ;
    }
  }
}
  
foreach my $key (sort keys(%data)) {
  print "\${'$key'}{Name} = \"$data{$key}\" ; \n" ;
}
