use strict;
use warnings;
use v5.10;
use Sys::Filesystem ();
use Alicia::Sistemas::Filesystem;
use Data::Dumper;


# Method 1
my $fs = Sys::Filesystem->new();
# get list of filesystems
my @aFilesystems = $fs->filesystems();

my @aMountedFilesystems = $fs->mounted_filesystems();
# Returns a list of all filesystems which can be verified as currently being mounted.

my @aUnmountedFilesystems = $fs->unmounted_filesystems();
# Returns a list of all filesystems which cannot be verified as currently being mounted.

my @aSpecialFilesystems = $fs->special_filesystems();
# Returns a list of all fileystems which are considered special. This will usually contain meta and swap partitions like /proc and /dev/shm on Linux.

my @aRegularFilesystems = $fs->regular_filesystems();
# Returns a list of all filesystems which are not considered to be special.

#print Dumper(\@aFilesystems);
          # '/',
          # '/boot/efi',
          # '/dev',
          # '/dev/hugepages',
          # '/dev/mqueue',
          # '/dev/pts',
          # '/dev/shm',
          # '/proc',
foreach my $filesystem (@aSpecialFilesystems){
	print "-------------Special------------\n";
	print "Mount Point: '".$fs->mount_point($filesystem )."'\n";
	print "Format: '".$fs->format($filesystem )."'\n";
	print "Device: '".$fs->device($filesystem )."'\n";
	
}
print "-------------Totals------------\n";
print "All:'".scalar(@aFilesystems)."'\n";
print "Mounted:'".scalar(@aMountedFilesystems)."'\n";
print "Unmounted:'".scalar(@aUnmountedFilesystems)."'\n";
print "Special:'".scalar(@aSpecialFilesystems)."'\n";
print "Regular:'".scalar(@aRegularFilesystems)."'\n";
