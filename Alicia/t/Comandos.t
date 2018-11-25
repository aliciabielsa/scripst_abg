#!/opt/perl/bin/perl
use strict;
use warnings;
use Test::More tests => 3;
use Data::Dumper;
use Test::Exception;




if ( defined($ARGV[0]) &&   $ARGV[0] eq 'LOG'){

  Log::Log4perl->easy_init(

    { level    => 'DEBUG' ,
      file     => "STDOUT",
      layout   => "%d |%p| (%M) - %m%n" 
      },
  );
}

my $expectedHostname = "wonderland";

my @aFunciones = ();
push (@aFunciones, 'new');
push (@aFunciones, 'ejecutarComando');
push (@aFunciones, 'capturarComando');



my $objetoOK =  Alicia::Comandos->new();
my $returnCode = $objetoOK->ejecutarComando("pwd");
my $hostnameObtained = $objetoOK->capturarComando("hostname");


BEGIN {
    use_ok('Alicia::Comandos');
}
isa_ok($objetoOK, 'Alicia::Comandos');
can_ok($objetoOK, @aFunciones);
is ($returnCode ,0, "ejecutarComando()  Return code '$returnCode'");
is ($expectedHostname , $hostnameObtained, "capturarComando() '$expectedHostname' = '$hostnameObtained'");

1;