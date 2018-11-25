#!/opt/perl/bin/perl

#######################################
# LIBRERIAS
#######################################
use strict;
use warnings;
use Data::Dumper;
use Log::Log4perl qw(:easy);
use Alicia::Comandos;
use Alicia::Comun::Funciones;
use Alicia::Sistemas::BlockDevice;
use Readonly;
use File::Basename;

Readonly::Hash my %HASH_ID_TYPE_SETTER  => (
                           'UUID' => 'setUUID',
                           'TYPE' => 'setIdType',
                           'PARTLABEL' => 'setPartLabel',
                           'PARTUUID' => 'setPartUUID'                  
                            );

Log::Log4perl->easy_init(

    { level    => 'DEBUG' ,
      file     => "STDOUT",
      layout   => "%d |%p| (%M) - %m%n" 
      },
);



my $comandos =  Alicia::Comandos->new();
#lsblk - list block devices
my $comandoListBlocks = 'lsblk';
#blkid - locate/print block device attributes
my $comandoBlockId    = 'blkid';
#sudo fdisk -l /dev/sda - List the partition tables for the specified devices and then exit.
my $comandoPartitionTableList = 'sudo fdisk -l /dev/';


my @aListBlocks = $comandos->capturarComando($comandoListBlocks);
my $header = shift(@aListBlocks);
my @aHeader = split ( /\s+/ ,$header );
my %hBlockDevices =();
my $previousDevice = '';

foreach my $blockLine (@aListBlocks){
  $blockLine = Alicia::Comun::Funciones::eliminarEspacios($blockLine);
  my @aBlockLine = split (/\s+/ ,$blockLine );
  my $parent;
  if ($aBlockLine[0] =~ /^[^\w]+(\S+)/){
	$aBlockLine[0]=$1;
	$parent = $previousDevice;
  }
  $previousDevice= $aBlockLine[0];
  INFO "Block line '$blockLine'";
  my $blockDevice = Alicia::Sistemas::BlockDevice->new({
					$aHeader[0]  =>  $aBlockLine[0],
					$aHeader[1]  =>  $aBlockLine[1],
					$aHeader[2]  =>  $aBlockLine[2], 
					$aHeader[3]  =>  $aBlockLine[3],
					$aHeader[4]  =>  $aBlockLine[4],
					$aHeader[5]  =>  $aBlockLine[5],
					$aHeader[6]  =>  $aBlockLine[6],
					'PARENT'     =>  $parent
					});
	$hBlockDevices{$aBlockLine[0]} = $blockDevice;


}


my @aBlockIds =  $comandos->capturarComando($comandoBlockId);
foreach my $blockIdLine (@aBlockIds){
	#/dev/mapper/ubuntu--vg-swap_1: UUID="74a21d21-9e76-4757-ae9f-3a28d22c8a76" TYPE="swap"
	$blockIdLine = Alicia::Comun::Funciones::eliminarEspacios($blockIdLine);
	DEBUG "Block ID line '$blockIdLine'";
	my @aBlockIdLine = split (/:/ ,$blockIdLine );
	my $deviceFile = $aBlockIdLine[0];
	DEBUG "Device File '$deviceFile'";
	
	my $blockDevice = $hBlockDevices{basename($deviceFile)};
	$blockDevice->setDeviceFile($deviceFile);
	unless (ref($blockDevice) eq 'Alicia::Sistemas::BlockDevice'){
		LOGDIE "Cannot find block device for device file '$deviceFile'";
	}
	$aBlockIdLine[1] = Alicia::Comun::Funciones::eliminarEspacios($aBlockIdLine[1]);
	#TODO  UUID="D8C2-06BF" TYPE="vfat" PARTLABEL="EFI System Partition" PARTUUID="a481d5f2-05c2-4c37-8c6d-c5c10216b68d"'

	my @aBlockAttribute = split (/\s+/, $aBlockIdLine[1]);
	foreach my $blockAttribute ( @aBlockAttribute ){
		DEBUG "Block Attribute '$blockAttribute'";
		my ($key, $value) =  split( /=/ ,$blockAttribute);
		if (exists($HASH_ID_TYPE_SETTER{$key}) && $HASH_ID_TYPE_SETTER{$key} ){
			my $setter = $HASH_ID_TYPE_SETTER{$key};
			$blockDevice->$setter($value);
		} else {
			WARN "Key '$key' is not recognised";
		}	
	} 

}



foreach my $blockDevice (sort keys %hBlockDevices){
	my $oBlockDevice = $hBlockDevices{$blockDevice};
	if ($oBlockDevice->getUUID()){	
		$oBlockDevice->printBlockDeviceInformation();
	}
	
	if ($oBlockDevice->getTYPE() eq 'disk'){	
	    #print Dumper($oBlockDevice);

		my @aListPartitionTable = $comandos->capturarComando($comandoPartitionTableList.$blockDevice );
		#print Dumper(\@aListPartitionTable);
		my @aHeader =();
		foreach my $listPartitionLine(@aListPartitionTable){
		    $listPartitionLine = Alicia::Comun::Funciones::eliminarEspacios($listPartitionLine);
			if($listPartitionLine =~ /:/ ){
			     my @aListParticionDetails = split (/:/ ,$listPartitionLine );
			} elsif (!scalar(@aHeader)) {			
				 @aHeader = split ( /\s+/ ,$listPartitionLine );
			} else {
				
			}
			
		}
		
	
	}
}







exit 0;