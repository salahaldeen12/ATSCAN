#!/usr/bin/perl
use strict;
use warnings;
use FindBin '$Bin';
## Copy@right Alisam Technology see License.txt

## LOGIN
our $updtd;
if (!defined $updtd) {
  our (@AUTH, @c, $scriptPass);
  use Term::ReadKey;
  open (PSS, $scriptPass);
  while (my $PS=<PSS>) { 
    chomp $PS;    
    print $c[4]."[!] $AUTH[0] ";
    ReadMode 2;
    chomp(my $passwd=ReadLine(0));
    ReadMode 0; 
    $passwd=Digest::MD5->md5_hex($passwd);
    if ($PS ne $passwd) { print $c[2]."\n[!] $AUTH[1]\n"; logoff(); }else{ print "$c[3] Logged in!\n"; mtak(); }
  }
}

1;
