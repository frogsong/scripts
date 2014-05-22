#!/usr/bin/perl

## Converts a folder of HTML files (eg export from PBworks)
## to a MediaWiki XML import file.

use warnings;
use strict;
use HTML::WikiConverter;
use POSIX qw(strftime);

my $wc = new HTML::WikiConverter (
    dialect => 'MediaWiki',
    wiki_uri => [ qr/^([a-zA-Z0-9(?%20)-]+)$/ ]
);

my $in = 'latest/';
my $out = 'wiki.xml';
open (XMLOUT, '>', $out);

print XMLOUT '<mediawiki xml:lang="en">'."\n";
opendir (DIR, $in);
for (readdir (DIR) )
{
	my $f = $_;
	if (/(.*).html/)
	{
		print XMLOUT "
	<page>
		<title>$1</title>
		<revision>
			<timestamp>
				";
		print XMLOUT POSIX::strftime("%Y-%m-%dT%H:%M:%SZ", gmtime);
		print XMLOUT "
			</timestamp>
			<contributor><username>html2wiki</username></contributor>
			<comment>Imported from HTML</comment>
			<text><![CDATA[
";
		print XMLOUT $wc->html2wiki(file => $in.$f);
		print XMLOUT "
			]]></text>
		</revision>
	</page>";
	}
}
print XMLOUT '</mediawiki>';
