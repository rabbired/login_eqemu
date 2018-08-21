#!/usr/bin/perl
use Config::IniFiles;

$line = iniread("./login.ini");

if($line == 1){
  check_db();
  system ("rm -rf logs/*.log");
  system ("./loginserver");
}

sub iniread
{
        my $cfg = new Config::IniFiles( -file => "$_[0]" );
        $host = $cfg->val( "database", "host" );
        $port = $cfg->val( "database", "port" );
        $user = $cfg->val( "database", "user" );
        $password = $cfg->val( "database", "password" );
        $db = $cfg->val( "database", "db" );
        return 1;
}

sub check_db
{
  my $tsdb = "mysql -h$host -P$port -u$user -p$password -N -B -e \"create database $db\" > /dev/null 2>&1";
  my $run = system ("$tsdb");
  if($run == 0)
  {
    print "Emu LoginServer Database created.\n";
    my $eqdb = "mysql -h$host -P$port -u$user -p$password -N -B -e \"use $db;source ./tblLoginServerAccounts.sql;\" > /dev/null 2>&1";
    system ("$eqdb");
    my $eqdb = "mysql -h$host -P$port -u$user -p$password -N -B -e \"use $db;source ./tblServerAdminRegistration.sql;\" > /dev/null 2>&1";
    system ("$eqdb");
    my $eqdb = "mysql -h$host -P$port -u$user -p$password -N -B -e \"use $db;source ./tblServerListType.sql;\" > /dev/null 2>&1";
    system ("$eqdb");
    my $eqdb = "mysql -h$host -P$port -u$user -p$password -N -B -e \"use $db;source ./tblWorldServerRegistration.sql;\" > /dev/null 2>&1";
    system ("$eqdb");
  }
  else
  {
  print "Emu LoginServer Database already exists and does not need to create.\n";
  }
}
