#!/usr/bin/perl
use strict;
use warnings;
use FindBin '$Bin';
## Copy@right Alisam Technology see License.txt

## PRINT BANNER 
our ($nobanner, $output);
if (!defined $nobanner) { banner(); }

## PASS LOGIN ##
our $scriptPass;
if (-e $scriptPass) { require "$Bin/inc/functions/log.pl"; }

## NO ARGUMENTS ##
our ($dork, $help, $Target, $mmd5, $mencode64, $checkVersion, $data, $uninstall, $pass, $updtd, $toolInfo);
our @NoArg=($dork, $help, $Target, $mmd5, $mencode64, $checkVersion, $data, $uninstall, $pass, $updtd, $toolInfo);
my $NoArg=0;
for (@NoArg) { $NoArg++ if defined $_; }
advise() if $NoArg<1;

## CLEAN OUTPUT 
if (defined $output) { unlink $output if -e $output; }

## GET FUNCTIONS 
require "$Bin/inc/funcs.pl";

## TEST INTERNET CONNECTION 
require "$Bin/inc/functions/testConnection.pl";

## COMMANDE LINE ERRORS 
require "$Bin/inc/errors/useErrors.pl";

## RENEW PROXY
require "$Bin/inc/functions/newIdentity.pl";

## DEFINE HTML CMS 
require "$Bin/inc/functions/checkCmsType.pl";

## CHECK IF THERE ANY ERROR IN HTML 
require "$Bin/inc/functions/checkErrors.pl";
## PORTS SCAN PROCESS
require "$Bin/inc/functions/scanPorts.pl";

## ENCODE DECODE SCAN PROCESS 
require "$Bin/inc/functions/encode.pl";

## GET ALL PARAMS TO SCAN 
require "$Bin/inc/functions/makeScan.pl";

## PRINT AND BUILD RESULTS 
require "$Bin/inc/search/print.pl";

## SERACH AND SCANS PROCESS 
require "$Bin/inc/search/process.pl";

## INDEX
require "$Bin/inc/index.pl";

1;
