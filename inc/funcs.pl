#!/usr/bin/perl
use strict;
use warnings;
use FindBin '$Bin';
## Copy@right Alisam Technology see License.txt

## FUNCTS
our ($payloads, $exploit, $data, $mlevel, $dork, $Target, $V_RANG, $noQuery, $mdom, $replace, $with, $full, $unique, $ifinurl, $pat2, $limit, $ifendour, $port, $output, $ifend);
our (@aTscans, @data, @userArraysList, @exploits, @dorks, @aTsearch, @aTcopy, @aTtargets, @c, @OTHERS, @DS, @DT, @TT, @proxies);

## PRINT FILES 
sub printFile {
  my ($File, $context)=@_;
  open (FILE, '>>', $File); print FILE "$context\n"; close(FILE);
}

## CHECK EMPTY FORDERS
sub is_folder_empty {
  my $dirname = $_[0];
  opendir(my $dh, $dirname);
  return scalar(grep { $_ ne "." && $_ ne ".." } readdir($dh)) == 0;
}

## BUILT ARRAYS
sub buildArraysLists {
  my $buildArrays=$_[0];
  my @buildArrays=();
  if (-e $buildArrays) {
    open (UAL, $buildArrays);
    while (my $buildArray=<UAL>) {
      chomp $buildArray;
      push @buildArrays, $buildArray;
    }
  }else{
    $buildArrays=~s/\s+$//g;
    $buildArrays=~s/^\[OTHER]//g;
    @buildArrays=split /\[OTHER\]/, $buildArrays;
  }
  return @buildArrays;
}

## BUILD PROXIES ARRAY
our ($proxy, $prandom);
sub getProx {
  my $getProx=$_[0];
  if ($getProx=~/:/) { @proxies=split / /, $getProx; }
  else{ @proxies=buildArraysLists($getProx); }
  return @proxies;
}

## SET PROXY
if (defined $proxy) { @proxies=getProx($proxy); }
if (defined $prandom) { @proxies=getProx($prandom); }
our $psx=$proxies[rand @proxies];

## USER ARRAYS
if (defined $payloads) { @userArraysList=buildArraysLists($payloads); }

## EXPLOITS ARRAYS
if (defined $exploit) { @exploits=buildArraysLists($exploit); }

## DATA ARRAYS
if (defined $data) { @data=buildArraysLists($data); }

## DORKS & TARGETS ARRAYS
if (defined $mlevel) {
  if (defined $dork) { @dorks=buildArraysLists($dork); }
  elsif (defined $Target) {
    if (($Target=~/$V_RANG/)&&($1<=255 && $2<=255 && $3<=255 && $4<=255 && $5<=255 && $6<=255 && $7<=255 && $8<=255)) { 
      my $startIp=$1.".".$2.".".$3.".".$4;
      my $endIp=$5.".".$6.".".$7.".".$8;  
      my (@ip,@newIp,$i,$newIp,$j,$k,$l);
      @ip=split(/\./,$startIp);
      for($i=$ip[0];$i<=$5;$i++) { 
	    $ip[0]=0 if($i == $5);
        for($j=$ip[1];$j<=$6;$j++) { 
          $ip[1]=0 if($j == $6);
          for($k=$ip[2];$k<=$7;$k++) { 
            $ip[2]=0 if($k == $7);
            for($l=$ip[3];$l<=$8;$l++) { 
              $ip[3]=0 if($l == $8);
              $newIp=join('.',$i,$j,$k,$l);
              $newIp="ip%3A".$newIp;             
              push @dorks, $newIp;
            }
	      }
	    }
      }
    }else{
      @dorks=buildArraysLists($Target);
    }
  }
}else{
  if (defined $Target) {
    if (($Target=~/$V_RANG/)&&($1<=255 && $2<=255 && $3<=255 && $4<=255 && $5<=255 && $6<=255 && $7<=255 && $8<=255)) { 
      my $startIp=$1.".".$2.".".$3.".".$4;
      my $endIp=$5.".".$6.".".$7.".".$8;
      my (@ip,@newIp,$i,$newIp,$j,$k,$l);
      @ip=split(/\./,$startIp);
      for($i=$ip[0];$i<=$5;$i++) { 
	    $ip[0]=0 if($i == $5);
        for($j=$ip[1];$j<=$6;$j++) { 
          $ip[1]=0 if($j == $6);
          for($k=$ip[2];$k<=$7;$k++) { 
            $ip[2]=0 if($k == $7);
            for($l=$ip[3];$l<=$8;$l++) { 
              $ip[3]=0 if($l == $8);
              $newIp=join('.',$i,$j,$k,$l);
              push @aTsearch, $newIp;
            }
          }
	    }
      }
    }else{ @aTsearch=buildArraysLists($Target); }
  }
}

## TIMER
sub timer { our $date; print "[$date]"; }

## CHECK VERSION LOG
sub compareme {
  my ($same);
  our ($logUrl, $script_bac, $scriptv);
  my ($response, $html, $status, $serverheader)=getHtml($logUrl, "");
  if ($response->is_success) {
    unlink $script_bac if -e $script_bac;
    printFile($script_bac, $response->content);    
    use File::Compare;      
    if (compare($script_bac, $scriptv) == 0) {
      $same="1";
      unlink $script_bac;
    }
  }
  return ($same, $response);
}

## RETURN NEGATIVE SCAN
sub negative { ltak(); print $c[4]."[!] $DT[1]\n"; }

## DESCLAIMER
sub desclaimer {
  our ($nobanner, $checkVersion);
  if (defined $nobanner) { mtak(); ptak(); }
  print $c[10]."  $OTHERS[11] \n  $OTHERS[12]  \n  $OTHERS[13] \n"; 
  if (defined $dork || defined $Target) {
    our $uplog;
    if (-e $uplog) { require "$Bin/inc/conf/upad.pl"; }
  }
  mtak(); ptak();
  if (defined $dork || defined $Target || defined $checkVersion) {    
    testConnection();
  }
}

## BGN SCAN TITLE
sub scanTitleBgn { print $c[11]."[!] "; timer(); print " ::: $DS[67] "; }

## END SCAN TITLE
sub scanTitleEnd { print $c[11]." $DS[4] :::\n"; ptak(); }

## GET CLEAN TARGETS DOMAINE
sub IfDup { my @aTsearch=(); @aTsearch=@aTtargets; @aTtargets=(); }

## GET DOMMAINE AND REMOVE PROTOCOL
sub removeDupNoProtocol {
  for my $URL(@aTsearch) { $URL=removeProtocol($URL); $URL=~s/www.//s; saveCopy($URL); }
  my @aTsearch=checkDuplicate(@aTsearch); IfDup();
}

## MEKE SEARCH COPY
sub makeCopy { my @aTcopy=(); push @aTcopy, @aTsearch; }

## RESTAURE SEARCH COPY
sub restaureSearch { my @aTsearch=(); push @aTsearch, @aTcopy; @aTcopy=(); }

## REMOVE DUPLICATE DOMAINES WPAFD/JOOMRFI/SUBDOMAINS/ADMIN
sub removeDupDom { 
  makeCopy();
  for my $URL(@aTsearch) { $URL=removeProtocol($URL); $URL=~s/\/.*//s; $URL=checkUrlSchema($URL); saveCopy($URL); }
  my @aTsearch=checkDuplicate(@aTsearch); IfDup();
}

## SAVE NON DUPLICATE DOMAINES
sub saveCopy { my $URL=$_[0]; push @aTtargets, $URL; }

## REMOVE DUPLICATE RESULTS
sub checkDuplicate { 
  my @AS=@_;
  my @AS2;
  for my $as(@AS) { $as=~s/(\%27|\<|\>|\%25|\')(.*)//ig; push @AS2, $as; }
  my %seen;
  @AS2=grep{ not $seen{$_}++ } @_;
  return @AS2;
}

## REMOVE URLS PROTOCOL
sub removeProtocol { 
  my $URL=$_[0];
  my %replace=('http://' => '', 'https://'=>'', 'ftp://'=>'', 'ftps://'=>'', 'socks(4|5)?://'=>'');
  $URL=~s/$_/$replace{ $_}/g for keys %replace;
  return $URL;
}

## REMOVE QUERY STRING
sub removeQuery { 
  my $URL=$_[0];
  $URL=removeProtocol($URL);
  $URL=~s/=.*/=/g;
  $URL=checkUrlSchema($URL);	
  return $URL;
}

## CHECK TARGETS FOR REPLACE OPTION
sub control {
  my $URL=$_[0];
  if (defined $noQuery) {
    $URL=removeQuery($URL);
  }
  if (defined $mdom) {               
	$URL=removeProtocol($URL);
    $URL=~s/\/.*//s;
  }
  if (defined $replace) {
	if (index($URL, $replace) != -1) {
      $URL=~s/$replace(.*)/$replace/g if defined $full; 
      $URL=~s/$replace/$with/ig;
    }
  }    
  $URL=checkUrlSchema($URL);
  return $URL;
}

## CLEAN URL
sub cleanURL {
  my $URL=$_[0];
  my %replace=( 'http://' => '', 'https://' => '', 'www.' => '', 'ftp://' => '', 'ftps://' => '');
  $URL=~s/$_/$replace{ $_}/g for keys %replace;
  $URL=~s/\/.*//s;
  return $URL;
}

## CHECK URL PARTS
sub checkUrlSchema { 
  my $URL=$_[0];
  if ($URL!~/(https?|ftp):\/\//) { $URL="http://$URL"; }; return $URL;
}

## GET FILTERS
sub checkFilters {
  my $dorkToCheeck=$_[0];
  my $dmn="";
  if ($dorkToCheeck=~/(site:(.*)\+|\+site:(.*))/) {
    $dmn=$1;
    $dmn=~s/\+//g;
    $dmn=~s/site:/\./g;
  }
  $dorkToCheeck=~s/:\s/:/g;
  $dorkToCheeck=~s/$pat2//g;
  return ($dorkToCheeck);
}

## GET FILTRED URLS
sub filterUr {
  my ($URL, $dorkToCheeck)=@_;
  if (defined $unique) {
    if (index($URL, $dorkToCheeck) != -1) { $URL=$URL; }else{ $URL=""; }
  }
  if (defined $ifinurl) {
    if (index($URL, $ifinurl) != -1) { $URL=$URL; }else{ $URL=""; }
  }
  return $URL;
}

## VALIDATE URL PARTS
sub validateURL {
  my $vURL=$_[0];
  $vURL=cleanURL($vURL);
  return $vURL if $vURL=~/([a-zA-Z0-9\-\_]\.)?([a-zA-Z0-9\-\_]\.)[a-zA-Z]/;
}

## CHECK SCANS HEADERS
sub checkHeaders {
  my ($ct, $dt, $et)=@_;
  if ($ct) { scanTitleBgn(); }
  if ($dt) { removeDupDom(); }
  if ($et) { removeDupNoProtocol(); }
}

## COUNT RESULTS
sub OO { my $o=scalar(grep { defined $_} @aTscans); return $o; }


## END SCAN PROCESS
sub subfin {
  print $c[2]."[!] "; timer(); print " $DT[3]!\n";
  if (defined $ifend) { print chr(7); }
}

## COUNT SCAN RESULTS
sub countResultLists {
  my $o=OO();
  if ($o==$limit) { print $c[4]."[!] $DT[34] ($limit)!\n"; }
  print $c[3]."[!] ".$o." $DT[4]\n";
}

## SEARCH REGEX FILTER
sub doRegex { 
  my $searchRegex=$_[0];
  for my $URL(@aTsearch) {
    if ($URL=~/$searchRegex/) { saveCopy($URL); }
  }
}

## EXTRAT INFO PROCESS SCAN
sub checkExtraInfo { 
  my $URL3=$_[0];
  my $ip;
  if (!defined $port) {
    $URL3=cleanURL($URL3);
    use Socket;
    $ip=inet_aton($URL3);
  }
  return $ip;
}

## BUILT POSITIVE SCAN RESULTS LIST
sub saveme { 
  my ($URL1, $sep)=@_;
  my $o=OO();
  if ($o<$limit) {
    push @aTscans, $URL1;
    if (defined $output) { printFile("$output", " $URL1"); }
  }
}

## SCAN TITLE
sub title { 
  if (defined $output) { my $SCAN_TITLE=$_[0];  printFile("$output", "="x30 ."\n$SCAN_TITLE\n"."="x30); }
}

## CHECK IF THERE MORE SCANS TO DO
our ($WpSites, $JoomSites, $xss, $lfi, $JoomRfi, $WpAfd, $adminPage, $subdomain, $mupload, $mzip, $searchIps, $eMails, $regex, $command);
our @z=($WpSites, $JoomSites, $xss, $lfi, $JoomRfi, $WpAfd, $adminPage, $subdomain, $mupload, $mzip, $searchIps, $eMails, $regex, $port, $data, $command);
sub getK {
  our @z;
  my ($x, $y)=@_; my $k=0; splice @z, $x, $y;
  for (@z) { if (defined $_) { $k++; } } return $k;  
}

## UPDATE
sub nochmod {
  my ($path, $action)=@_;
  sleep(1);
  print $c[2]."[!] Couldn't have write permitions: $path !\n";
  if ($action) { logoff(); } 
}
sub cc { sleep(1); print $c[3]."OK\n"; }
sub bb { sleep(1); print $c[4]."Failed!\n"; }
sub dd { sleep(1); print $c[4]."[!] $DT[8]\n"; }

1;
