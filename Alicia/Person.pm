package Alicia::Person;
use Moose;
use Moose::Util::TypeConstraints;

subtype 'Alicia::Person::Type::Sex'
	=> as 'Str'
	=> where { $_ eq 'f' or $_ eq 'm' }
	=> message { "($_) is not a valid sex. Valid values are 'f' and 'm'." };

coerce 'Alicia::Person::Type::Sex'
    => from 'Str'
    => via { lc substr($_, 0, 1) };

has 'name' => (is => 'rw');
has 'year' => (isa => 'Int', is => 'rw');
has 'birthday' => (isa => 'DateTime', is => 'rw');
has 'sex'      => (isa => 'Alicia::Person::Type::Sex', is => 'rw', coerce => 1);
 
1;