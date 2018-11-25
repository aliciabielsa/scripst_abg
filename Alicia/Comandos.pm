package Alicia::Comandos;

use strict;
use warnings;
use Log::Log4perl qw(:easy);
use Data::Dumper;
use English;
use Readonly;
use DateTime; 



########################################
# ATTRIBUTOS
########################################
my %attributes = (
  so => undef,
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

sub capturarComando {
  my $self = shift;
  my $comando = shift;
  
  DEBUG "";
  if (wantarray){
	DEBUG "Wantarray for comand '$comando'";
	my @aResultado =();
	@aResultado = `$comando`;
	return @aResultado;
	
  } else {

	my $resultado = ''; 
	chomp($resultado);
	$resultado  = `$comando`;	
	chomp($resultado);
	return $resultado ;
  }
  
  


}

sub ejecutarComando {
  my $self = shift;
  my $comando = shift;
  my $returnCode = '';
  
  #system: Fork first and the parent process waits for the child to finish. 
  #The return value is the exit status of the program as returned by the wait call. 
  #To get the actual exit value, shift right by eight 
  $returnCode = system($comando)  ;

  return $returnCode ;

}



1;