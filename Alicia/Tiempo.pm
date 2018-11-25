package Alicia::Tiempo;

use strict;
use warnings;
use Log::Log4perl qw(:easy);
use Data::Dumper;
use English;
use Readonly;
use DateTime; 

Readonly::Hash my %HASH_DIAS_SEMANA => (
                                '1' => 'L',
                                '2' => 'M',
                                '3' => 'MI',
                                '4' => 'J',
                                '5' => 'V',
                                '6' => 'S',
                                '0' => 'D',
);


########################################
# ATTRIBUTOS
########################################
my %attributes = (
  
);




########################################
# METODOS
########################################
sub new {
  my $this = shift;  


  #Construccion del objeto  
  my $class = $this || ref($this);
  my $self = { %attributes };
  bless $self, $class; 
  

    
  return $self;
}

sub getweekOfMonth  {
  my (@argumentos) = @_;
  if (ref($argumentos[0]) eq __PACKAGE__){
    shift @argumentos;
  }
  my $dt = DateTime->now;
  my $weekOfMonth = $dt->week_of_month();

  return $weekOfMonth;

}

sub getCurrentISOYearWeek {
  my (@argumentos) = @_;
  if (ref($argumentos[0]) eq __PACKAGE__){
    shift @argumentos;
  }
  my $dt = DateTime->now;  
  my ($week_year, $week_number) = $dt->week;   
  
  return $week_year.$week_number;
}

sub getNextISOYearWeek {
  my (@argumentos) = @_;
  if (ref($argumentos[0]) eq __PACKAGE__){
    shift @argumentos;
  }
  my $dt = DateTime->now;  
  $dt->add( days => 7 );
  my ($week_year, $week_number) = $dt->week;   
  
  return $week_year.$week_number;
}

sub getTimestamp {
  my (@argumentos) = @_;
  if (ref($argumentos[0]) eq __PACKAGE__){
    shift @argumentos;
  }
  my $variacionDias =  $argumentos[0];
  my $formato = $argumentos[1];
  my $timestamp ='';

  
  if ( ! defined($variacionDias)){
    $variacionDias = 0;
  }
  
  DEBUG "La variacion de dias es '$variacionDias'";
  
  my $variacionSegundos = $variacionDias  * 24 * 60 * 60;
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime( time  + $variacionSegundos) ;
  $year += 1900;
  $mon  += 1;
  $mon  = sprintf("%02d", $mon );
  $mday = sprintf("%02d", $mday );
  $hour = sprintf("%02d", $hour );
  $min  = sprintf("%02d", $min );
  $sec  = sprintf("%02d", $sec );
  
  if (defined($formato) && $formato){
    DEBUG "El formato es '$formato'";
	INFO "weekday is '$wday'";
    my $shortYear = substr ( $year, 2, 2); 
    $formato =~ s/DD/$mday/i;
    $formato =~ s/MM/$mon/;
    $formato =~ s/YYYY/$year/i;
    $formato =~ s/YY/$shortYear/i;
    $formato =~ s/hh/$hour/i;
    $formato =~ s/mm/$min/;
    $formato =~ s/ss/$sec/;
    $formato =~ s/weekday/$HASH_DIAS_SEMANA{$wday}/;
    $timestamp  = $formato;
  } else {
    $timestamp = "$year$mon$mday$hour$min$sec";
  }

  DEBUG "Devolvemos la fecha '$timestamp' ";
  return $timestamp; 
  
}

sub traducirAMinutos {
  my (@argumentos) = @_;
  if (ref($argumentos[0]) eq __PACKAGE__){
    shift @argumentos;
  }
  my $hora =  $argumentos[0];
  my $numeroMinutos = 0;
  
  if ($hora eq '00'){
    return $numeroMinutos;
  } else {
    return $hora * 60;
  }
}



1;