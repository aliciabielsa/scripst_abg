use strict;
use warnings;

open (my $fh_file , '<', $0 ) or die "Error reading file";
while (my $line = <$fh_file>){
     print $line;
}
close ($fh_file);
