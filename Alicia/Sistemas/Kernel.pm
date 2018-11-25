package Alicia::Sistemas::Kernel;
#######################################
# LIBRERIAS
#######################################
use warnings;
use strict;
use Log::Log4perl qw(:easy);
use English qw( -no_match_vars ) ; 
use Data::Dumper;
use parent 'Alicia::Objeto';
    
#######################################
# ATRIBUTOS
#######################################

my %attributes = (

); 


sub new {
  my $class = shift;  
  my $hAttributos = shift;

  my $self =  $class->SUPER::new($hAttributos);
  
  foreach my $attribute  (sort keys %attributes ){
    if (exists($hAttributos->{$attribute})){
      $self->{$attribute}  = $hAttributos->{$attribute};
    }    
  }

	#die "Error: El atributo NAME no esta definido\n"  unless (defined($self->{'NAME'})  && $self->{'NAME'} ) ;  



  
	return $self;
}



sub setUUID{
	my $self = shift;
	my $value = shift;
	if  (defined($value) && $value  ){
		$self->{'UUID'} = $value;
	}
	
	return ;
	
}

sub getUUID{
	my $self = shift;

	if  (defined($self->{'UUID'}) && $self->{'UUID'} ){
		return $self->{'UUID'};
	}	
	return '';
}



    
    
1;
