#!/usr/bin/perl

use strict;

use XML::Simple;
use File::Find;
use File::Spec;

use Data::Dumper;

# <craftDB>
#   <craft>
#     <output skill="1" name="Wand of Bling" amount="1"/>
#     <tool tag="lathe"/>
#     <input name="Burnt Out Wand"/>
#     <input name="Gold Ingot"/>
#   </craft>
# <craft>

my $parser = new XML::Simple;
my @craftFiles;

my $path = shift @ARGV;

if(not defined $path) {
	print "Please specify the full path to the application configuration files\n";
	exit;
}

print $path;

find(\&wantedCraft,$path);
find(\&wantedCrust,$path);
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

print Dumper(\%tool);

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

