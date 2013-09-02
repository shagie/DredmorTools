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
		
		'make' => new Dredmor::CookBook(),
		'use'  => new Dredmor::CookBook(),
	};
	
	$self->{'name'} = shift;
	my $data = shift;
#	print Dumper($data);
	
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
}

# A way to make the item (a steel ingot is made with iron, coal, and chalk)
sub addMake {
	my $self = shift;
}

sub toString {
	my $self = shift;
	
	return << "--EOSTR--";
$self->{'name'}
	$self->{'desc'}

--EOSTR--
}

1;