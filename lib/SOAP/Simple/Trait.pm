package SOAP::Simple::Trait;

use Moose::Role;

use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;

sub add_wsdl {
  my ($self,$wsdl,%options) = @_;

  $wsdl = $self->_coerce_wsdl ($wsdl);

  my $service = $self->_wsdl_pick_one ('service',[ $wsdl->findDef ('service') ],$options{ service });

  my $port = $self->_wsdl_pick_one ('port',$service->{ wsdl_port },$options{ port });

  my $binding = $wsdl->findDef (binding => $port->{ binding });

  foreach my $operation (@{ $binding->{ wsdl_operation } }) {
    my $client = $wsdl->compileClient (
      operation => $operation->{ name },
      service   => $service->{ name },
      port      => $port->{ name },
    );

    $self->add_method ($operation->{ name } => sub { shift; goto $client });
  }

  return;
}

sub _wsdl_pick_one {
  my ($self,$description,$items,$key) = @_;

  confess "No $description found in the WSDL" unless @$items;

  my $item; 
  if (defined $key) {
    ($item) = grep { $_->{ name } eq $key } @$items;

    confess "No $description by the name ($key), but try one of (" . join (", ",map { $_->{ name } } @$items) . ") instead" unless defined $item;
  } else {
    confess "Multiple choices for $description found, please pick from (" . join (", ",map { $_->{ name } } @$items) . ")" if @$items > 1;

    ($item) = @$items;
  }

  return $item;
}

sub _coerce_wsdl {
  my ($self,$wsdl) = @_;

  # Obviously wsdl can't be undefined

  confess "First argument must be defined (And preferably related to a WSDL)" unless defined $wsdl;

  # Feed whatever we're fed to XML::Compile::WSDL11 if it's not
  # already an instance of that.

  return $wsdl if blessed $wsdl && $wsdl->isa ('XML::Compile::WSDL11');

  # Except if it's a non-ref string starting with https?://

  $wsdl = $self->_fetch_wsdl ($wsdl) if ! ref $wsdl && $wsdl =~ m{^https?://};

  return XML::Compile::WSDL11->new ($wsdl);
}

sub _fetch_wsdl {
  confess "Remote fetching not implemented yet";
}

1;

