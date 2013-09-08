package Dredmor::Recipe;

sub new {
	my $class = shift;
	my $self = {
		'skill'  => '',
		'tool'   => '',
		'items'  => [],
		'output' => '',
		'qty'    => '',
	};
	
	bless $self, $class;
	return $self;
}

sub setTool {
	my $self = shift;
	$self->{'tool'} = shift;
}

sub setOutput {
	my $self = shift;
	$self->{'output'} = shift;
}

sub setInput {
	my $self = shift;
	$self->{'items'} = [ @_ ];
}

sub setSkill {
	my $self = shift;
	$self->{'skill'} = shift;
}

sub setQty {
	my $self = shift;
	$self->{'qty'} = shift;
}

sub toString {
	my $s = shift;
	return "$s->{'tool'} ($s->{'skill'}): " .
		join(" + ", map  { $_->getName } @{$s->{'items'}}) .
		" = " . $s->{'output'}->getName . 
		($self->{'qty'} > 1 ? "($self->{'qty'})" : '') .
		"\n";
}

1;