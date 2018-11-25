use strict;
use warnings;
use v5.10;

use Alicia::Person;
use DateTime;


my $teacher = Alicia::Person->new( name => 'Joe');
say $teacher->name;
$teacher->sex('female');   # should be accepted as 'f'
say $teacher->sex;

my $student =  Alicia::Person->new( name => 'Alicia' );
$student->year(1976);
say $student->year;
$student->birthday( DateTime->new( year => 1976, month => 4, day => 17) );
say $student->birthday;
$student->sex('f');
say $student->sex;
