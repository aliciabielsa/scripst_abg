package Alicia::Sistemas::BlockDevice;
#######################################
# LIBRERIAS
#######################################
use warnings;
use strict;
use Log::Log4perl qw(:easy);
use English qw( -no_match_vars ) ; 
use Data::Dumper;
use Cwd;
use parent 'Alicia::Objeto';
    
#######################################
# ATRIBUTOS
#######################################

my %attributes = (
	'NAME' => undef,
	'MAJ:MIN' => undef,
	'RM' => undef,
	'SIZE'=> undef,
	'RO' => undef,
	'TYPE' => undef,
	'MOUNTPOINT'=> undef, 
	'PARENT'=> undef, 
	'UUID' =>  undef, 
    'IDTYPE' =>  undef, 
    'PARTLABEL' =>  undef, 
    'PARTUUID' =>  undef, 
	'deviceFile'=>  undef, 
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

	die "Error: El atributo NAME no esta definido\n"  unless (defined($self->{'NAME'})  && $self->{'NAME'} ) ;  
	die "Error: El atributo MAJ:MIN no esta definido\n"  unless (defined($self->{'MAJ:MIN'})  && $self->{'MAJ:MIN'} ) ; 
	die "Error: El atributo RM no esta definido\n"  unless (defined($self->{'RM'}) ) ; 
	die "Error: El atributo SIZE no esta definido\n"  unless (defined($self->{'SIZE'})  && $self->{'SIZE'} ) ; 
	die "Error: El atributo RO no esta definido\n"  unless (defined($self->{'RO'})) ;   
	die "Error: El atributo TYPE no esta definido\n"  unless (defined($self->{'TYPE'})  && $self->{'TYPE'} ) ; 


  
	return $self;
}

sub printBlockDeviceInformation {
	my $self = shift;

	print "--------------------------------------------------------\n";
	print "Device name is ".$self->{'NAME'}."\n";
	if (defined($self->{'PARENT'}) && $self->{'PARENT'}){
		print "Device parent is ".$self->{'PARENT'}."\n";
	}
	print "Major and minor device number. ".$self->{'MAJ:MIN'}."\n";
	print "Device is ";
	if (!$self->{'RM'}){
		print "NOT ";
	}	
	print "removable\n";
	print "Size of the device is ".$self->{'SIZE'}."\n";
	print "Device is ";
	if (!$self->{'RO'}){
		print "NOT ";
	}	
	print "read-only\n";
	print "Device type is ".$self->{'TYPE'}."\n";
	if ($self->{'MOUNTPOINT'}){
		print "Mountpoint is ".$self->{'MOUNTPOINT'}."\n";
	} else {
		print "It has no mountpoint\n";
	}
	if (defined($self->{'UUID'}) && $self->{'UUID'}){
		print "UUID is ".$self->{'UUID'}."\n";
	}
	
	if (defined($self->{'IDTYPE'}) && $self->{'IDTYPE'}){
		print "IDTYPE is ".$self->{'IDTYPE'}."\n";
	}
	
	if (defined($self->{'PARTLABEL'}) && $self->{'PARTLABEL'}){
		print "PARTLABEL is ".$self->{'PARTLABEL'}."\n";
	}
	
	if (defined($self->{'PARTUUID'}) && $self->{'PARTUUID'}){
		print "PARTUUID is ".$self->{'PARTUUID'}."\n";
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


sub setIdType{
	my $self = shift;
	my $value = shift;
	if  (defined($value) && $value  ){
		$self->{'IDTYPE'} = $value;
	}
	
	return ;
	
}
sub setPartLabel{
	my $self = shift;
	my $value = shift;
	if  (defined($value) && $value  ){
		$self->{'PARTLABEL'} = $value;
	}
	
	return ;
	
}
sub setPartUUID{
	my $self = shift;
	my $value = shift;
	if  (defined($value) && $value  ){
		$self->{'PARTUUID'} = $value;
	}
	
	return ;
	
}

sub getTYPE{
	my $self = shift;

	if  (defined($self->{'TYPE'}) && $self->{'TYPE'} ){
		return $self->{'TYPE'};
	}	
	return '';
}



sub getDeviceFile{
	my $self = shift;

	if  (defined($self->{'deviceFile'}) && $self->{'deviceFile'} ){
		return $self->{'deviceFile'};
	}	
	return '';
}

sub setDeviceFile{
	my $self = shift;
	my $deviceFile = shift;

	if  (defined($deviceFile) && $deviceFile){
		$self->{'deviceFile'} = $deviceFile;
	}	
	return ;
}




    
    
1;
