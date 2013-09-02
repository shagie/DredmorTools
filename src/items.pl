#!/usr/bin/perl

use strict;

use XML::Simple;
use File::Find;
use File::Spec;

use Getopt::Long;

use Data::Dumper;

use Dredmor::Item;

my $parser = new XML::Simple;

# Option parsing

my $appdir;
my $builddir;
my $help;

my $result = GetOptions (
	"builddir=s" => \$builddir,
	"appdir=s"   => \$appdir,
	"help!"      => \$help,
	);

if($help) {
	print << "--EOHELP--";
Help file here
--EOHELP--
	exit;
}

if(not defined $appdir) {
	print "Please specify the full path to the application configuration files\n";
	exit;
}

# Application Setup

my %files = (
	'itemDB.xml'    => [],
	'craftDB.xml'   => [],
	'encrustDB.xml' => [],
);

find(\&wanted, $appdir);

my %items = ();

# first, open up the items and process them

foreach my $file (@{$files{'itemDB.xml'}}) {
	my $ref = $parser->XMLin($file);
	while(my ($name, $data) = each %{$ref->{'item'}}) {
		print "$name: ",ref $data,"\n";
		$items{$name} = new Dredmor::Item($name, $data);
	}
}

foreach my $item (values %items) {
	print $item->toString;
}

exit;

# for File::Find

sub  wanted {
	return unless defined $files{$_};
	push @{$files{$_}}, $File::Find::name;
}