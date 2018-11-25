use strict;
use warnings;
use v5.10;
use lib '/home/alicia/.cpan/build/DBIx-Class-0.082841-0/examples/Schema';

use DBIx::Class;
use Path::Class 'file';
use MyApp::Schema qw();
use Data::Dumper;


#Tables          Columns
#artist          artistid
#                name
#cd              cdid
#                artistid
#                title
#                year
#track           trackid
#                cdid
#                title


my $db_fn = file($INC{'MyApp/Schema.pm'})->dir->parent->file('db/example.db');

say "Conecting to Database full name '$db_fn'";
my $schema = MyApp::Schema->connect("dbi:SQLite:$db_fn");

#Introspecting the schema classes
my @aSourcesFound = $schema->sources;                       
say "Sources/Tables: '@aSourcesFound'";

foreach my $sourceFound (@aSourcesFound){
	say "------------------------------";
	say "Table: '$sourceFound'";
	my @aColumnsFound = $schema->source($sourceFound)->columns;
	say "Columns: '@aColumnsFound'";
	my @aRelationshipsFound = $schema->source($sourceFound)->relationships; 
	say "Relationships: '@aRelationshipsFound'";
	say "------------------------------";

}


#Retreiving data ( search - select )
my $resultSetArtist = $schema->resultset('Artist');
#print Dumper($resultSetArtist);
my $artists_starting_with_m = $resultSetArtist->search(
    {
        name => { like => 'M%' }
    }
);
#Display results
for my $artist ($artists_starting_with_m->all) {
    say $artist->artistid();
    say $artist->name;
}


# Adding data

# my $artist_ma = $schema->resultset('Artist')->create({
#     name => 'Massive Attack',
# });
# my $cd_mezz = $artist_ma->create_related(cds => {
#     title => 'Mezzanine',
# });
# for ('Angel', 'Teardrop') {
#     $cd_mezz->create_related(tracks => {
#         title => $_
#     });
# }


get_tracks_by_cd('Bad');



sub get_tracks_by_cd {
    my $cdtitle = shift;
    print "get_tracks_by_cd($cdtitle):\n";
    my $rs = $schema->resultset('Track')->search(
        {
            'cd.title' => $cdtitle
        },
        {
            join     => [qw/ cd /],
        }
    );
    while (my $track = $rs->next) {
        print $track->title . "\n";
    }
    print "\n";
}
