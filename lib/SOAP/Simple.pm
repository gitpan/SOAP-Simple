package SOAP::Simple;

use Moose;

use Moose::Meta::Class;
use SOAP::Simple::Base;

our $VERSION = '0.00_03';

sub new {
  shift;

  my ($wsdl,%options);

  if (@_ % 2) {
    if (ref $_[0] eq 'HASH') {
      %options = %{ shift () };
    } else {
      $wsdl = shift;
    }
  } else {
    %options = @_;
  }

  $wsdl ||= $options{ wsdl };

  my $new_metaclass = Moose::Meta::Class->create_anon_class (superclasses => [ 'SOAP::Simple::Base' ]);

  $new_metaclass->add_wsdl ($wsdl,%options);

  my $self = $new_metaclass->name->new (%options);

  return $self;
};

1;

__END__

=pod

=head1 NAME

SOAP::Simple - To the extent that SOAP can be simple

=head1 SYNOPSIS

  my $soap = SOAP::Simple->new($wsdlfile);

  print Dumper($soap->myMethod(%args));

=head1 DESCRIPTION

Let's face it. SOAP is painfull. It's a dumb idea, the only reason you
should ever consider using SOAP is if someone holds a gun to your head
or pay you a lot of money for it.

As anyone with experience in commercial software development knows,
both of these situations will unfortunately occur rather frequent, so
this module is an attempt to reduce the pain involved with simple use
cases. It is not an attempt to cover every possible situation, but
considering that the most trivial uses of SOAP in perl today involves
goat sacrifice, I hope that it may help some people.

This module is a wrapper around L<XML::Compile::SOAP> which is a much
more complete module, but has an API that can be difficult to use and
not to mention integrate in other solutions. That being said; If this
module does not suit your needs, I strongly recommend you have a look
at L<XML::Compile::SOAP> or L<SOAP::WSDL>. Many SOAP services simply
are buggy or incomplete. They will not work with this module no matter
how hard you try because the WSDL is invalid in some way (It is
remarkably easy to end up with a bad WSDL when trying to create
a SOAP service. Java and .NET services tend to be especially nasty).
To be able to work with these services, you need to hand code parts
or even the complete interface, something which I intentionally do
not want to support with this module. This module is aiming to be
a simple module for simple cases where you can find a good WSDL file.

=head1 METHODS

=head2 new

  my $soap = SOAP::Simple->new($wsdl, %options);

Constructs an instance with methods found in the $wsdl. The wsdl
argument may be an L<XML::Compile::WSDL11> object, or anything that
module accepts. This does not currently include the url to a WSDL
file, but this will be implemented in this wrapper in the future.

=over 4

=item L

=head2 soap methods

The methods generated for the SOAP interface takes perfectly normal
perl structures like scalars, hashes, and lists, and converts them
into whatever data type the SOAP service expects you to provide it
with. The same is the case for what you get in return, but keep in
mind that while you do get a perl structure, just how it looks
varies a lot from service to service.

  my $result = $soap->hello(world => 1);

  print Dumper($result); # The easiest way to learn

If you or the server violate the WSDL in any way, you will be given
a message by L<XML::Compile::SOAP> description what it perceives to be
the problem. As stated earlier, keep in mind that many SOAP services
can be very ugly to deal with and if you keep getting error messages
that you are unable to correct, you probably want to have a look at
other SOAP modules as this module intentionally doesn't have the
neccesary flexibility to get around buggy SOAP services.

=head1 MOOSE

This module tries to take adventage of the possibilities that L<Moose>
has to offer without abusing them violently like certain other modules
(Several found in the MooseX namespace) has done. If this section
does not make any sense to you, don't worry, you don't need to
understand anything here in order to use this module.

It implements a metaclass trait called L<SOAP::Simple::Trait> which 
adds an add_wsdl method to the module metaclass. This method takes the
exact same arguments as the constructor method for L<SOAP::Simple>,
but simply just adds the methods found to the class instead of
spitting out a new instance. This is also where all the real work is
done and the other modules are pretty much just convinience wrappers
around this trait.

=head1 SEE ALSO

=over 4

=item L<XML::Compile::SOAP>

=item L<Moose>

=item L<SOAP::WSDL>

=back

=head1 BUGS

This module currently has no tests. SOAP sh^H^Hcould also be
considered a bug.

=head1 AUTHOR

Anders Nor Berle E<lt>berle@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Anders Nor Berle.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut

