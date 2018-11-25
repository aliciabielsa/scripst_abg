#!/opt/perl/bin/perl
use strict;
use warnings;
use Test::More tests => 15;
use Data::Dumper;
use Readonly;
use Sys::Hostname;
use Test::Exception;




if ( defined($ARGV[0]) &&   $ARGV[0] eq 'LOG'){

  Log::Log4perl->easy_init(

    { level    => 'DEBUG' ,
      file     => "STDOUT",
      layout   => "%d |%p| (%M) - %m%n" 
      },
  );
}

my @aFunciones = ();
push (@aFunciones, 'new');
push (@aFunciones, 'getTimestamp');
push (@aFunciones, 'traducirAMinutos');
push (@aFunciones, 'getweekOfMonth');
push (@aFunciones, 'getCurrentISOYearWeek');
push (@aFunciones, 'getNextISOYearWeek');


my $objetoOK =  Alicia::Tiempo->new();
my $currentTimestamp = Alicia::Tiempo::getTimestamp();
my $currentTimestampObjeto = $objetoOK->getTimestamp();
my $DDMMYYYY = $objetoOK->getTimestamp(0, 'DDMMYYYY');
my $DDMMYY = $objetoOK->getTimestamp(-1, 'DDMMYY');
my $DD_MM_YYYY = $objetoOK->getTimestamp(-2, 'DD/MM/YYYY');
my $HHMM = $objetoOK->getTimestamp(0, 'hh:mm');
my $weekday = $objetoOK->getTimestamp(0, 'weekday');
my $weekOfMonth =  $objetoOK->getweekOfMonth();
my $minutosEnHora00 = $objetoOK->traducirAMinutos('00');
my $minutosEnHora01 = $objetoOK->traducirAMinutos('01');
my $currentWeek = Alicia::Tiempo::getCurrentISOYearWeek();
my $nextWeek = Alicia::Tiempo::getNextISOYearWeek();

BEGIN {
    use_ok('Alicia::Tiempo');
}
isa_ok($objetoOK, 'Alicia::Tiempo');
can_ok($objetoOK, @aFunciones);
ok ($currentTimestamp , "Alicia::Tiempo::getTimestamp() Hoy Formato YYYYMMDDHHMMSS '$currentTimestamp'");
ok ($currentTimestampObjeto , "getTimestamp() Hoy Formato YYYYMMDDHHMMSS '$currentTimestampObjeto'");
ok ($DDMMYYYY , "getTimestamp() Hoy Formato DDMMYYYY '$DDMMYYYY'");
ok ($DDMMYY , "getTimestamp() Ayer Formato DDMMYY '$DDMMYY'");
ok ($DD_MM_YYYY , "getTimestamp() Antes de ayer Formato DDMMYYYY '$DD_MM_YYYY'");
ok ($HHMM  =~ /\d{2}:\d{2}/, "getTimestamp() Hoy Formato mm:ss '$HHMM'");
ok ($weekday ,"getTimestamp() Formato weekday '$weekday'");
ok ($weekOfMonth ,"getweekOfMonth() '$weekOfMonth'");
ok ($minutosEnHora00 == 0, "traducirAMinutos() '$minutosEnHora00'");
ok ($minutosEnHora01 == 60, "traducirAMinutos() '$minutosEnHora01'");
ok ($currentWeek , "getCurrentISOWeek() $currentWeek");
ok ($currentWeek , "getCurrentISOWeek() $nextWeek");
1;