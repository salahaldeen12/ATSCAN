#!/usr/bin/perl
use strict;
use warnings;
use FindBin '$Bin';
## ALISAM TECHNOLOGY 2015
######################################################################################################################################################################################################
######################################################################################################################################################################################################
our ($WpSites, $JoomSites, $xss, $lfi, $JoomRfi, $WpAfd, $adminPage, $subdomain, $mupload, $mzip, $searchIps, $eMails, $regex, $port, $command, $data, $mmd5,
     $mdecode64, $mencode64, $checkVersion, $help, $pass);
######################################################################################################################################################################################################
######################################################################################################################################################################################################
## VERIFY TARGETS AND PRESCAN
our ($mlevel, $Target, $dork, @c, @DT, @TODO, @V_TODO, @SCAN_TITLE);
if (defined $mlevel) {
  if ($mlevel < 10) { print $c[4]."[!] $DT[26]\n"; logoff(); }
  if ((defined $dork) || (defined $Target)) { msearch(); }
}else{
  if (defined $Target) {
    scanDetail(); my $k=getK(0, 0);    
    if (!$k) { makeSscan("3", "", "", \@TODO, \@V_TODO, $SCAN_TITLE[1], "", "", "", "", "", "", "", ""); }else{ Menu(); }
  }
}
######################################################################################################################################################################################################
######################################################################################################################################################################################################
sub Menu {
  if (defined $WpSites) { WpSites(); }
  if (defined $JoomSites) { JoomSites(); }
  if (defined $xss) { xss(); }
  if (defined $lfi) { lfi(); }
  if (defined $JoomRfi) { JoomRfi(); }
  if (defined $WpAfd) { WpAfd(); }
  if (defined $adminPage) { adminPage(); }
  if (defined $subdomain) { subdomain(); }
  if (defined $mupload) { uploadSites(); }
  if (defined $mzip) { zipSites(); }
  if (defined $searchIps) { Ips(); }
  if (defined $eMails) { eMails(); }
  if (defined $regex) { Regex(); }
  if (defined $port) { ports(); } 
  if (defined $command) { mcommand(); }
  if (defined $data) { mdata(); }
}

if ((defined $mmd5) || (defined $mdecode64) || (defined $mencode64)) {
if (defined $mmd5) { mmd5();
}elsif (defined $mencode64) { mencode64(); } }

if (defined $pass) { pass(); }
if (defined $checkVersion) { checkVersion(); }
if (defined $help) { help(); }

######################################################################################################################################################################################################
######################################################################################################################################################################################################
1;
######################################################################################################################################################################################################
######################################################################################################################################################################################################