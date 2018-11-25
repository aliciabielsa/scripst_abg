package Alicia::Fichero;

use strict;
use warnings;
use Log::Log4perl qw(:easy);
use Data::Dumper;
use File::Copy;
use English qw( -no_match_vars ) ;
use File::Basename;
########################################
# ATTRIBUTOS
########################################
my %attributes = (

  fichero            => undef,
  _aLineas           => undef,
  ficheroExiste      => undef, 
  
);

########################################
# METODOS
########################################
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

  die "Error: El atributo fichero no esta definido\n"  unless (defined($self->{'fichero'})  && $self->{'fichero'} ) ;  
  @{ $self->{'_aLineas'} } =();
  
  return $self;
}


sub escribirEnFichero {
  my $self = shift;
  my $valorAEscribir =  shift;

 
  open (my $fh_fichero , '>' , $self->{'fichero'}) or (  die "Error al escribir en el fichero '".$self->{'fichero'}."', motivo: ".$ERRNO);
  print $fh_fichero "$valorAEscribir\n";
  close ($fh_fichero);
    
  return 1;
}

sub annadirTextoAFichero {
  my $self = shift;
  my $valorAAnnadir=  shift;

 
  DEBUG "Annadimos en el fichero  '".$self->{'fichero'}."' el valor '$valorAAnnadir'";
  open (my $fh_fichero , '>>' , $self->{'fichero'}) or (  die "Error al escribir en el fichero '".$self->{'fichero'}."', motivo: ".$ERRNO);
  print $fh_fichero "$valorAAnnadir";
  close ($fh_fichero);
    
  return 1;
}

sub leerPrimeraLinea {
  my $self = shift;
  my $primeraLinea = '';  
  
  open (my $fh_fichero , '<', $self->{'fichero'}) or die "No se pudo leer el fichero '".$self->{'fichero'}."', motivo: ".$ERRNO;
  while (my $linea = <$fh_fichero>){
    chomp ($linea);
    $primeraLinea = $linea;
    last;
  }  
  close ($fh_fichero);
  
  return $primeraLinea;
}


sub copiar {
  my $self = shift;
  my $directorioDestino = shift;

  # verificamos que existe el directorio de destino
  if (! -d $directorioDestino){
    WARN "No existe el directorio de destino '$directorioDestino'";
    # creamos el directorio de destino
    mkdir ($directorioDestino) or die "ERROR creando el directorio '$directorioDestino', motivo:".$ERRNO;
  }
  
  #movemos el fichero al directorio de destino
  copy ($self->{'fichero'}, $directorioDestino) or die "ERROR copiando el fichero '".$self->{'fichero'}."' al directorio '$directorioDestino', motivo:".$ERRNO;;

  INFO "Copiamos el fichero '".$self->{'fichero'}."' al directorio '$directorioDestino'";
  
  return $directorioDestino.basename($self->{'fichero'}) ; 
  
}


sub mover {
  my $self = shift;
  my $directorioDestino = shift;
  
  # verificamos que existe el directorio de destino
  if (! -d $directorioDestino){
    WARN "No existe el directorio de destino '$directorioDestino'";
    # creamos el directorio de destino
    mkdir ($directorioDestino) or die "ERROR creando el directorio '$directorioDestino', motivo:".$ERRNO;
  }
  
  #movemos el fichero al directorio de destino
  move($self->{'fichero'}, $directorioDestino)or die "ERROR moviendo el fichero '".$self->{'fichero'}."' al directorio '$directorioDestino', motivo:".$ERRNO;;
  
  INFO "Movemos el fichero '".$self->{'fichero'}."' al directorio '$directorioDestino'";
  #actualizamos el attributo fichero
  $self->{'fichero'} = $directorioDestino.'/'.basename($self->{'fichero'});
  
  
  
  return $self->{'fichero'};


}

sub renombrar {
  my $self = shift;
  my $newName = shift;
  


  move($self->{'fichero'}, $newName)or die "ERROR renombrando el fichero '".$self->{'fichero'}."' como '$newName', motivo:".$ERRNO;;
  
  INFO "Renombramos el fichero '".$self->{'fichero'}."' como '$newName'";
  #actualizamos el attributo fichero
  $self->{'fichero'} = $newName;
  
  
  
  return $self->{'fichero'};


}

sub sobreescribir {
  my $self = shift;
  my $ficheroDestino = shift;


  copy ($self->{'fichero'}, $ficheroDestino) or die "ERROR copiando el fichero '".$self->{'fichero'}."' al fichero '$ficheroDestino', motivo:".$ERRNO;;

  INFO "Copiamos el fichero '".$self->{'fichero'}."' al fichero '$ficheroDestino'";
  
  return $ficheroDestino ; 
  
}

sub moverDirectorioPadre {
  my $self = shift;
  my $directorioDestino = shift;
  
  

  
  my($filename, $directorioPadre) = fileparse($self->{'fichero'});
  
  if ( $directorioDestino  eq $directorioPadre ){
    WARN "El directorio de destino '$directorioDestino' es igual al directorio padre '$directorioPadre'";
    return $self->{'fichero'};
  }
    
  move($directorioPadre, $directorioDestino) or 
  die "ERROR moviendo el directorio '$directorioPadre' al directorio '$directorioDestino', motivo:".$ERRNO;
  
  
  
  $self->{'fichero'} = $directorioDestino.basename($self->{'fichero'});
 
  return $self->{'fichero'};
}


sub setFichero {
  my $self = shift;
  my $fichero = shift;
  $self->{'fichero'} = $fichero;
  return ;
}


sub getFichero {
  my $self = shift;
  
  if (defined($self->{'fichero'})){
  
    return $self->{'fichero'};
  
  }
  return '';
}


sub comprobarSiFicheroExiste {
  my $self = shift;
  my $fichero = shift;
  
  if ( !defined($fichero)){
    $fichero = $self->{'fichero'};
  }
  
  
  if (!defined($fichero)){
    DEBUG "No esta definido el fichero";
    return 0;
  }
 
  if (!  -f $fichero){ 
  
    DEBUG "El fichero no existe '$fichero'";  
    $self->{'ficheroExiste'} = 0;
    return 0;
  }
  
  $self->{'ficheroExiste'} = 1;
  
  return 1;

}


sub borrarFichero {
  my $self = shift;
  my $fichero = shift;
  
  if ( !defined($fichero)){
    $fichero = $self->{'fichero'};
  }
  
  if ( -f $fichero){
    unlink ( $fichero ) or die "Error al intentar eliminar el fichero '".$fichero."'";
  }
  return ;   
  
}

sub borrarLinea {
    my $self = shift;
    
    return;
}

sub _setStats {
  my $self = shift;
  
 
  my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
            $atime,$mtime,$ctime,$blksize,$blocks)
               = stat($self->{'fichero'});
               
  $self->{'size'} = $size  ;          

  return;
               
}


sub getSize {
  my $self = shift;
  
  $self->_setStats();
  
 
  DEBUG "Size del fichero '".$self->{'fichero'}."' es '".$self->{'size'}."'";
  
  return $self->{'size'};
}


sub getLineas {
  my $self = shift;

  return @{ $self->{'_aLineas'} }  ;

}


sub ponerFicheroEnArray {
  my $self = shift;
  
  my @aLineas = ();
  open ( my $fhAttr , '<' , $self->{'fichero'} ) or die "Error al leer el fichero '".$self->{'fichero'}."'"; 
  while ( my $linea  = <$fhAttr>){
    chomp($linea);
 
    push ( @aLineas, $linea);
  }
  close ($fhAttr);
  

  @{ $self->{'_aLineas'} } = @aLineas;
  
  return  ;

}

sub getFileExtension {
  my $self = shift;

  
  my @aSuffixList = ('.txt', '.tar', '.tar.Z', '.zip', '.lst');
  my ($name,$path,$fileExtension) = fileparse($self->{'fichero'},@aSuffixList);
  
  return  $fileExtension;
}




1;