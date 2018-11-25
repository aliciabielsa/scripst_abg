package Alicia::Directorio;

use strict;
use warnings;
use Log::Log4perl qw(:easy :no_extra_logdie_message);
use Data::Dumper;
use English;
use File::Path qw(make_path remove_tree);
use File::Copy;
use Alicia::Tiempo;

########################################
# ATTRIBUTOS
########################################
my %attributes = (
  path => undef,  
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

  
  die "El atributo path no esta definido\n" unless  (defined ( $self->{'path'}) &&  $self->{'path'} );
  $self->_corregirPath();
  
  return $self;
}


sub existeDirectorio {
  my $self = shift;
  my $existeDirectorio = 0;
  if ( -d $self->{'path'}){
    $existeDirectorio = 1;
    DEBUG "Directorio de proceso correcto '".$self->{'path'}."'";
  } else {
    WARN "Directorio de proceso no existe '".$self->{'path'}."'";
  }
  
  return  $existeDirectorio;
}


sub checkCreaDirectorio {
  my $self = shift;
  my $directorioCreado = 0;
  
  if (! -d $self->{'path'}){
    make_path ($self->{'path'}, { mode => 0755 } )  or die ("No se pudo crear  el directorio '".$self->{'path'}."'");
    DEBUG "Creado el directorio de proceso '".$self->{'path'}."'";
    $directorioCreado = 1;
  }else{
    DEBUG "Directorio de proceso correcto '".$self->{'path'}."'";
  }

  return $directorioCreado;
}


sub checkBorraDirectorio {
  my $self = shift;
  my $directorioBorrado = 0;
  #borramos el directorio temporal si existe  
  if ( -d $self->{'path'}){
    remove_tree($self->{'path'}) or die ("No se pudo borrar el directorio '".$self->{'path'}."'");
    $directorioBorrado = 1;
  } 

  return $directorioBorrado;
}


sub listarContenidoDirectorio {
  my $self = shift;
  my $regexp = shift;  
  my @aListadoContenido =();
  my @aListadoContenidoFiltrado = ();
  
  if (!defined($regexp)){
    $regexp = '';
  }
  
  opendir (my $fh_directorio,  $self->{'path'}) or die "Error no se puede leer el directorio '".$self->{'path'}."', motivo: ". $ERRNO;
  @aListadoContenido = grep { /$regexp/i }  readdir($fh_directorio);
  closedir ($fh_directorio);  
  
  foreach my $contenido (@aListadoContenido){
    if ($contenido eq '.' || $contenido eq '..'){
      next;
    } 
    push (@aListadoContenidoFiltrado, $contenido);
  }
  
  return @aListadoContenidoFiltrado;
}


sub listarFicherosCaducados {
  my $self = shift;
  my $regexp = shift; 
  my $diasCaducidad = shift; 
  my @aFicherosCaducados =();
  
  
  if (!defined( $diasCaducidad ) || !$diasCaducidad ){
    WARN "Metodo listarFicherosCaducados necesita un parametro con los dias de caducidad";
    return 0;
  }  
  
  unless (defined($regexp)  && $regexp){
    WARN "Metodo listarFicherosCaducados necesita de una expresion regular que seleccione la fecha formato YYYYMMDD";
    return 0;
  }
  
  my @aListaFicherosCaducados = ();
    
  my @aFicheros = $self->listarContenidoDirectorio($regexp);
  
  my $fechaCaducada = Alicia::Tiempo::getTimestamp( -$diasCaducidad  );
  $fechaCaducada = substr ( $fechaCaducada, 0, 8);

  foreach my $fichero ( @aFicheros ) {
    my ( $fechaFichero)  =  $fichero =~ /$regexp/ ;
    DEBUG "Fecha del fichero es '$fechaFichero'";
    if ($fechaFichero <= $fechaCaducada ){
      push (@aListaFicherosCaducados , $fichero );
    } 
  }  
  return  @aListaFicherosCaducados ;  

}


sub _corregirPath {
  my $self = shift;
  
  if ($self->{'path'} !~  /\/$/){
    $self->{'path'} .= '/';
  }
  
  return;

}


sub mover {
  my $self = shift;
  my $directorioDestino = shift;
  
 
  move($self->{'path'}, $directorioDestino) or 
  die "ERROR moviendo el directorio '".$self->{'path'}."' al directorio '$directorioDestino', motivo:".$ERRNO;
  
  INFO "Movemos el directorio '".$self->{'path'}."' al directorio '$directorioDestino'";

  $self->{'path'} = $directorioDestino;
  
  $self->_corregirPath();
  
  return $self->{'path'};


}


1;