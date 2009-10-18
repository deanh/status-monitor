#!/usr/bin/env perl -w

use strict;
use FindBin;
use lib "$FindBin::Bin/../lib";
use status_monitor_client;

my $sm   = StatusMonitorClient->new('127.0.0.1', 3333);
$sm->{'slug'} = slug();

print $sm->{'slug'}, "\n";
my $load = load();

if ($load < 3) {
  $sm->info("LoadData", $load, "1 minute load average: $load");
} elsif ($load < 6) {
  $sm->warn("LoadData", $load, "1 minute load average: $load");
} elsif ($load < 8) {
  $sm->error("LoadData", $load, "1 minute load average: $load");
} else {
  $sm->fatal("LoadData", $load, "1 minute load average: $load");
}


sub load {
  my $uptime = `uptime`;
  chomp($uptime);
  my $load = (split /,/, $uptime)[3];
  $load =~ /(\d+\.\d+)\D/;
  return $1;
}

sub slug {
  my $host = `uname -n`;

  chomp $host;
  $host =~ tr/A-Z/a-z/;
  
  return "$host/uptime";
}

