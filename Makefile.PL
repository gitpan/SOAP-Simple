use inc::Module::Install;

name 'SOAP-Simple';

all_from 'lib/SOAP/Simple.pm';

requires 'Moose'              => 0.73;
requires 'XML::Compile::SOAP' => 2.03;

WriteAll;

