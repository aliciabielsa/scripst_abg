use strict;
use warnings;

use lib '/home/alicia/workspaces/MyPerlScripts/scripts_abg';
use Alicia::Directorio;
use Alicia::Fichero;
use Log::Log4perl qw(:easy);

Log::Log4perl->easy_init(

    { level    => 'DEBUG' ,
      file     => "STDOUT",
      layout   => "%d |%p| (%M) - %m%n" 
      },
          { level    => 'DEBUG' ,
      file     => '/home/alicia/workspaces/log/changeScreenSaver.log',
      layout   => "%d |%p| (%M) - %m%n" 
      },
);

my $currentPhotoPath = '/home/alicia/workspaces/data/currentPhoto.txt';
my $directorioFotosPath = '/home/alicia/Pictures/';
my $oldScreensaver = '/home/alicia/Pictures/screensaver.jpg';
my $extensionFoto = 'JPG';

my $directorioFotos = Alicia::Directorio->new({ path => $directorioFotosPath });
my $newScreensaver ='';
my $count = 0;
until( -f $newScreensaver ){
	$newScreensaver  = searchRandomFileByType($directorioFotos);
	DEBUG "Count $count => $newScreensaver";
	$count++;
}




my $newScreensaverFile = Alicia::Fichero->new({ 'fichero' => $newScreensaver  });
my $currentPhotoFile = Alicia::Fichero->new({ 'fichero' =>  $currentPhotoPath  });

$newScreensaverFile->sobreescribir( $oldScreensaver );
$currentPhotoFile->escribirEnFichero( $newScreensaver );

sub searchRandomFileByType {
	my $rootDirectory = shift;
	my @aContent = $rootDirectory->listarContenidoDirectorio();
	
	my $totalContent = scalar(@aContent);

    my $randomInteger =  int(rand($totalContent));
	
	my $newPhotoFound = '';
	DEBUG "Random indice de un total de '$totalContent' fotos  : '$randomInteger'";
	my $randomContent = $rootDirectory->{'path'}.$aContent[$randomInteger];
	DEBUG "RandomContent  '$randomContent'";
	

	if (-d $randomContent){
		my $directorio = Alicia::Directorio->new({ path => $randomContent});

		$newPhotoFound  = searchRandomFileByType( $directorio );
	} elsif ( -f $randomContent && 
					$randomContent  =~ /$extensionFoto$/i &&
					$randomContent ne $oldScreensaver &&
					$randomContent !~  /ignore/){
		INFO "New screensaver  '$randomContent'";
		$newPhotoFound =  $randomContent ;	
	}
	
	return $newPhotoFound ;

}

exit 0;
