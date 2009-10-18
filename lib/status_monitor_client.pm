package StatusMonitorClient;

use strict;
use IO::Socket;

use constant INFO => 'i';
use constant WARN => 'w';
use constant ERROR => 'e';
use constant FATAL => 'f';

sub new {
  my $class = shift;
  my ($host, $port) = @_;
  my $self = {};
  my $sm = IO::Socket::INET->new("$host:$port") or
    die "Could not connect to status monitor: $!\n";
    
  $self->{'sm'} = $sm;
  
  bless $self, $class;
}

sub info() {
  my ($self, $type, $meas, $msg) = @_;
  $self->_log($type, INFO, $meas, $msg);
}

sub warn() {
  my ($self, $type, $meas, $msg) = @_;
  $self->_log($type, WARN, $meas, $msg);
}

sub error() {
  my ($self, $type, $meas, $msg) = @_;
  $self->_log($type, ERROR, $meas, $msg);
}

sub fatal() {
  my ($self, $type, $meas, $msg) = @_;
  $self->_log($type, FATAL, $meas, $msg);
}

sub _log {
  my ($self, $type, $level, $meas, $msg) = @_;
  my ($sm, $slug) = ($self->{'sm'}, $self->{'slug'});
  
  $sm->print( "$slug,$type,$level,$meas,$msg\n" );
  $sm->getline;
}

sub DESTROY {
  close($_[0]->{'sm'});
}

1;
