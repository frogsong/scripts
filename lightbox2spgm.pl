#!/usr/bin/perl
# Usage: $0 lightbox_page images_dir out_dir

use warnings;
use strict;
use autodie;
use File::Copy;

if ($#ARGV + 1 != 3) {
	die "3 arguments must be provided";
}

my ($in_page, $src_dir, $out_dir) = @ARGV;

open IN_PAGE, $in_page;
open PIC_DESC, ">$out_dir/pic-desc.txt";
open PIC_SORT, ">$out_dir/pic-sort.txt";
print PIC_DESC "; Do not remove this comment (used for UTF-8 compliance)\n\n";
print PIC_SORT "; Do not remove this comment (used for UTF-8 compliance)\n\n";

while (<IN_PAGE>) {
	# Get image names and captions
	if (/images\/(.*?\.(?:jpg|png|gif)).*?title="(.*?)"/) {
		# Copy image
		copy ("$src_dir/$1", $out_dir);
		# Write to pic-desc and pic-sort
		print PIC_DESC "$1 | $2\n";
		print PIC_SORT "$1\n";
	}	
}
close IN_PAGE;

# Create thumbnail directory (user will have to use genthumb)
mkdir "$out_dir/thumbnails";

# Create blank index.html
open FH, ">$out_dir/index.html";
close FH;

# Create gal-desc.txt
open FH, ">$out_dir/gal-desc.txt";
close FH;

=head1 NAME

lightbox2spgm - create an SPGM gallery from a Lightbox-enabled webpage

=head1 SYNOPSIS

lightbox2spgm lightbox_page images_dir gallery_dir

=head1 ARGUMENTS

=over

=item lightbox_page

HTML source file equipped for Lightbox
(L<http://www.lokeshdhakar.com/projects/lightbox2/>) or similar.

=item images_dir

Directory containing image files referenced by the webpage.

=item gallery_dir

An empty directory into which the gallery's files will be placed.

=back

=head1 BUGS

The script assumes that the Lightbox page will reference images in the "images/"
directory. It also expects the <a> tag to be contained on one line.

An empty "thumbnails" directory will be created in the gallery directory for
convenience, but a tool such as the "genthumb" script included with SPGM will
have to be used to actually create thumbnails.

=cut
