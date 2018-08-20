#!/usr/bin/perl

$line = iniread("./login.ini");

if($line == 1){
        $tsdb = "mysql -h$host -P$port -u$user -p$password -N -B -e \"create database $db\" > /dev/null 2>&1";
        $run = system ("$tsdb");
                if($run == 0)
                {
                    print "Emu LoginServer Database created.\n";
                    $eqdb = "mysql -h$host -P$port -u$user -p$password -N -B -e \"use $db;source ./tblLoginServerAccounts.sql;\" > /dev/null 2>&1";
                    system ("$eqdb");
                    $eqdb = "mysql -h$host -P$port -u$user -p$password -N -B -e \"use $db;source ./tblServerAdminRegistration.sql;\" > /dev/null 2>&1";
                    system ("$eqdb");
                    $eqdb = "mysql -h$host -P$port -u$user -p$password -N -B -e \"use $db;source ./tblServerListType.sql;\" > /dev/null 2>&1";
                    system ("$eqdb");
                    $eqdb = "mysql -h$host -P$port -u$user -p$password -N -B -e \"use $db;source ./tblWorldServerRegistration.sql;\" > /dev/null 2>&1";
                    system ("$eqdb");
                }
                else
                {
                         print "Emu LoginServer Database already exists and does not need to create.\n";

                }
system ("rm -rf logs/*.log");
system ("./loginserver");
}

sub iniread
 {
  my $ini = $_[0];
  my $t = 1;
  open (INI, "$ini") || die "Can't open $ini: $!\n";
    while (<INI>) {
        $t++;
        chomp;
        if (/^\s*(.*?)\s*\=\s*(.*)/){
                $$1 = $2;
        }
        if ($t == 7){
                close (INI);
                return 1;
        }
    }
}
