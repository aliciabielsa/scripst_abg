#Survivor
#There are 50 people standing in a circle in position 1 to 50. The person standing at position 1 has a sword. He kills the next person i.e. standing at position 2 and pass on the sword to the immediate next i.e. person standing at position 3. Now the person at position 3 does the same and it goes on until only one survives.
#
#Write a script to find out the survivor.
use strict;
use warnings;
use Data::Dumper;

my $ALIVE = 1;
my $DEAD = 0;
my $numberPeople = 10;
my $numberPeopleAlive = $numberPeople;
my @aPeople = ();
foreach my $position (1..$numberPeople){
    my $nextPosition = $position == $numberPeople ? 1 : $position +1;
    my %hTmp = ( 'state' => $ALIVE , 'nextPosition' => $nextPosition);
    push (@aPeople, \%hTmp);
}

#print Dumper(\@aPeople);
my $swordPosition  = 1;
while ($numberPeopleAlive > 1){    
    my $positionKilled  = killNextPerson($aPeople[$swordPosition-1]->{'nextPosition'});   
    $swordPosition  = passSword($aPeople[$positionKilled-1]->{'nextPosition'});
} 

print "Last Position Alive : $swordPosition\n";

sub killNextPerson {
    my $position = shift;    
    if ($aPeople[ $position - 1 ]->{'state'} ==  $ALIVE){      
        $aPeople[ $position -1 ]->{'state'} = $DEAD;
        $numberPeopleAlive--;
        return  $position ;
    } 
    return killNextPerson($aPeople[ $position -1 ]->{'nextPosition'});
}

sub passSword {
    my $position = shift;
    if ($aPeople[ $position - 1 ]->{'state'} ==  $ALIVE){
        return  $position ;
    }
    return passSword($aPeople[ $position -1 ]->{'nextPosition'});
}