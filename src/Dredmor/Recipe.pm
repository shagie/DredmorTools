package Dredmor::Recipe;

sub new {
	my $class = shift;
	my $self = {
		'skill'  => '',
		'tool'   => '',
		'items'  => [],
		'output' => '',
	};
	
	bless $self, $class;
	return $self;
}

1;