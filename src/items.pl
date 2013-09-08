#!/usr/bin/perl

use strict;

use XML::Simple;
use File::Find;
use File::Spec;

use Getopt::Long;

use Data::Dumper;

use Dredmor::Item;
use Dredmor::Recipe;

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
		$items{$name} = new Dredmor::Item($name, $data, );
	}
}

foreach my $file (@{$files{'craftDB.xml'}}) {
	my $ref = $parser->XMLin($file);
	foreach my $craft (@{$ref->{'craft'}}) {
		my $rec = new Dredmor::Recipe;
		
		# need grep fix
		my @inputs = map { $items{$_}}
			grep { defined $craft->{'input'}{$_} }
			keys %items;
				
		if(ref $craft->{'tool'} eq "HASH") {
			$rec->setTool($craft->{'tool'}{'tag'})
		} else {
			$rec->setTool($craft->{'tool'});
		}
		$rec->setInput(@inputs);
		
		if(defined $craft->{'output'}{'name'}) {
			$rec->setOutput($items{$craft->{'output'}{'name'}});
			$rec->setSkill($craft->{'output'}{'skill'});
			if(defined $craft->{'output'}{'amount'}) {
				$rec->setQty($craft->{'output'}{'amount'});
			} else {
				$rec->setQty(1);
			}

			$items{$craft->{'output'}{'name'}}->addMake($rec);
		} else {
			foreach my $key (keys %{$craft->{'output'}}) {
				$rec->setOutput($items{$key});
				$rec->setSkill($craft->{'output'}{$key}{'skill'});
				if(defined $craft->{'output'}{$key}{'amount'}) {
					$rec->setQty($craft->{'output'}{$key}{'amount'});
				} else {
					$rec->setQty(1);
				}

				$items{$key}->addMake($rec);
			}
		}
		
		foreach my $item (@inputs) {
			$item->addUse($rec);
		}
	}
}

foreach my $item (values %items) {
	print "------------------\n";
	print $item->toString;
}

exit;

# for File::Find

sub  wanted {
	return unless defined $files{$_};
	push @{$files{$_}}, $File::Find::name;
}