package Dredmor::Item;

use strict;

use Data::Dumper;

use Dredmor::CookBook;

sub new {
	my $class = shift;
	my $self = {
		'name' => '',
		'icon' => '',
		'level' => '',
		'type' => '',
		'special' => '',
		'price' => '',
		'desc'  => '',
		
		'make' => [],
		'use'  => [],
	};
	
	$self->{'name'} = shift;
	my $data = shift;
	my $path = shift;
	
	$self->{'icon'} = $data->{'iconFile'};
	$self->{'desc'} = $data->{'description'}{'text'};
	$self->{'level'} = $data->{'level'};
	$self->{'type'} = $data->{'type'};

	bless $self, $class;
	return $self;
}

# A use of the item (steel ingot is USED to make an steel sword)
sub addUse {
	my $self = shift;
	push @{$self->{'use'}}, shift;
}

# A way to make the item (a steel ingot is made with iron, coal, and chalk)
sub addMake {
	my $self = shift;
	push @{$self->{'make'}}, shift;
}

sub getName {
	my $self = shift;
	return $self->{'name'};
}

sub toString {
	my $self = shift;
	my $ret =  "$self->{'name'}\n\t$self->{'desc'}\n";
	print "$self->{'name'}";
	
	$ret .= "Make:\n" . join("\n", map { $_->toString } @{$self->{'make'}}) . "\n";
	$ret .= "Use:\n"  . join("\n", map { $_->toString } @{$self->{'use'}})  . "\n";

	$ret .= "\n";
}

1;