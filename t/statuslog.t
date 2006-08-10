#!/usr/local/bin/perl -w
use strict;
use Test::More;
use lib qw( ../lib ./lib );
BEGIN { plan tests => 136 }

use_ok( 'Nagios::StatusLog' );

my $config = 't/status.log';
ok( my $log = Nagios::StatusLog->new( $config ), "new()" );
ok( $log->update(), "update()" );

ok( my $host = $log->host('spaceghost'), "->host()" );
ok( my $svc  = $log->service('localhost','SSH'), "->service()" );
ok( my $pgm  = $log->program(), "->program()" );

is( $host->host_name(), 'spaceghost', "\$host->host_name() returns correct value" );
is( $svc->description(), 'SSH', "\$svc->description() returns correct value" );

my %hndls = ( Host => $host, Service => $svc, Program => $pgm );

foreach my $tag ( qw( Service Host Program ) ) {
    my $class = "Nagios::${tag}::Status";
    foreach my $method ( $class->list_tags() ) {
        can_ok( $hndls{$tag}, $method );
        ok( length($hndls{$tag}->$method()), "$method non-zero-length output" );
    }
}

exit 0;
