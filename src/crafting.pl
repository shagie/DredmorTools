#!/usr/bin/perl

use strict;

use XML::Simple;
use File::Find;
use File::Spec;

use Getopt::Long;

use Data::Dumper;

my $parser = new XML::Simple;
my @craftFiles;

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

find(\&wantedCraft,$appdir);
find(\&wantedCrust,$appdir);
my @craft;

my %components;
my %tool;

foreach my $item (@craft) {
	my $tool = $item->{'tool'}{'tag'};
	my @out;
	if(defined $item->{'output'}{'name'}) {
		push @out, {
			'name' => $item->{'output'}{'name'},
			'skill' => $item->{'output'}{'skill'},
			'amount' => $item->{'output'}{'amount'},
		};
	} else {
		foreach my $name (keys %{$item->{'output'}}) {
			push @out, {
				'name' => $name,
				'skill' => $item->{'output'}{$name}{'skill'},
				'amount' => $item->{'output'}{$name}{'amount'},
			}
		}
	}

	print Dumper($item);
		
	foreach my $key (keys %{$item->{'input'}}) {
		my $input;
		if($key eq 'name') {
			$input = $item->{'input'}{'name'};
		} else {
			$input = $key;
		}
		foreach my $out (@out) {
			print "$input -> $out->{'name'} ($tool $out->{'skill'})\n";
			push @{$components{$input}{$tool}{$out->{'skill'}}},
				$out->{'name'};
			push @{$tool{$tool}{$out->{'skill'}}{$input}}, $out->{'name'};
		}
	}
}

print Dumper(\%components);

exit;
foreach my $comp (keys %components) {
	print "$comp:\n";
	foreach my $tool (sort keys %{$components{$comp}}) {
		print "\t$tool\n";
		foreach my $skill (sort keys %{$components{$comp}{$tool}}) {
			print "\t\t$skill\n";
		}
	}
}

exit;

# for File::Find
sub wantedCraft {
	return unless /craftDB.xml/;
	my $ref = $parser->XMLin($File::Find::name);
	push @craft, @{$ref->{'craft'}};
}

sub wantedCrust {
	return unless /encrustDB.xml/;
	#my $ref = $parser->XMLin($File::Find::name);
	# push @craft, @{$ref->{'craft'}};
}

