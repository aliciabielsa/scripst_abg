package Alicia::Sistemas::Kernel;
#######################################
# LIBRERIAS
#######################################
use warnings;
use strict;
use Log::Log4perl qw(:easy);
use English qw( -no_match_vars ) ; 
use Data::Dumper;
use Cwd;
    
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

#	die "Error: El atributo NAME no esta definido\n"  unless (defined($self->{'NAME'})  && $self->{'NAME'} ) ;  



  
	return $self;
}

sub printAttributes {
	my $self = shift;

	print "--------------------------------------------------------\n";	
	foreach my $attribute (sort keys (%attributes)){
		print "$attribute\t";
		if (defined($self->{$attribute }) && $self->{$attribute }){
			print $self->{$attribute }."\n";
		}
	}
	print "--------------------------------------------------------\n";
	return;	
	
	

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
