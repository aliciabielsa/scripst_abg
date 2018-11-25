package Alicia::Objeto;
#######################################
# LIBRERIAS
#######################################
use warnings;
use strict;
use Log::Log4perl qw(:easy);
use English qw( -no_match_vars ) ; 
use Data::Dumper;

    
#######################################
# ATRIBUTOS
#######################################

my %attributes = (

); 


sub new {
	my $this = shift;  
	my $hAttributos = shift;

	#Construccion del objeto  
	my $class = $this || ref($this);
	my $self = { %attributes };
	bless $self, $class;
  
  
	foreach my $attributo (sort keys %{ $hAttributos }){
		$self->{$attributo}  = $hAttributos->{$attributo};
	}


  
	return $self;
}




sub printObject {
	my $self = shift;
	print Dumper ($self);

	print "--------------------------------------------------------\n";	
	foreach my $attribute (sort keys (%{$self})){
		print "$attribute\t";
		if (defined($self->{$attribute }) && $self->{$attribute }){
			print $self->{$attribute }."\n";
		}
	}
	print "--------------------------------------------------------\n";
	return;	
	
	

}

    
    
1;
