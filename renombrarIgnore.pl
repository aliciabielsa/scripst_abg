#!/usr/bin/perl
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
      file     => "/home/alicia/workspaces/log/renombrarIgnore.log",
      layout   => "%d |%p| (%M) - %m%n" 
      },
);


my $currentPhotoPath = '/home/alicia/workspaces/data/currentPhoto.txt';
my $currentPhotoFile = Alicia::Fichero->new({ 'fichero' => $currentPhotoPath  });

my $currentPhotoName = $currentPhotoFile->leerPrimeraLinea();
my $newPhotoName = $currentPhotoName ;
DEBUG "Current Photo is '$currentPhotoName'";
$newPhotoName =~  s%.jpg%_ignore.jpg%i;
DEBUG "New Photo '$newPhotoName'";

my $fileToRename = Alicia::Fichero->new({ 'fichero' => $currentPhotoName  });
$fileToRename->renombrar($newPhotoName);

exit 1;
