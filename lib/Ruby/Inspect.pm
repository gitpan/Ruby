package Ruby::Inspect;

use strict;
use warnings;

our $VERSION = '0.01';

use Scalar::Util qw(blessed reftype refaddr looks_like_number);

our $in_inspect = 0;

sub inspect
{
	return 'undef' unless defined $_[0];

	local $in_inspect = $in_inspect + 1;

	my $obj = $_[0];

	unless($_[1]){
		push @_, { };
	}

	my $seen = $_[1];
	
	if(ref $obj and $seen->{ refaddr $obj }++){
		my $reftype = reftype($obj);
		if($reftype eq 'HASH'){
			return '{...}';
		}
		elsif($reftype eq 'ARRAY'){
			return '[...]';
		}
		else{
			return '(...)';
		}
	}

	if($in_inspect <= 1 and blessed($obj)){
		if(my $inspect = $obj->can('inspect')){
			return scalar( $obj->$inspect() );
		}
	}

	return &basic_inspect;
}

my %esc = (
	"\a" => '\a',
	"\b" => '\b',
	"\n" => '\n',
	"\r" => '\r',
	"\t" => '\t',
	"\f" => '\f',
	"\e" => '\e',
	"\0" => '\0',
	"\\" => '\\\\',
	"\"" => '\"',
);
my $esc = join('', values %esc);
sub basic_inspect
{
	my $obj = $_[0];

	# reference
	if(ref $obj){
		my $reftype = reftype($obj);

		my $result = '';

		if(my $class = blessed($obj)){
			$result .= "${class}=";

			if($class eq 'Regexp'){
				$result .= $obj;
				return $result;
			}
		}

		no strict 'refs';
		my $inspector = \&{$reftype};

		if(defined &$inspector){
			$result .= &$inspector;
		}
		else{
			$result .= sprintf('%s(0x%x)', $reftype, refaddr($obj));
		}
		return $result;
	}
	# primitive string or numeric or type glob
	else{
		my $type = reftype(\$obj);

		if($type eq 'GLOB'){
			return sprintf '*%s%s', *{$obj}{PACKAGE} eq 'main' ? '' : *{$obj}{PACKAGE}.'::', *{$obj}{NAME};
		}
		elsif(looks_like_number($obj)){
			return "$obj";
		}
		else{
			$obj =~ s/([$esc])/$esc{$1}/go;
			return qq("$obj");
		}
	}
}

sub HASH{
	my $hr = $_[0];

	my $result = '';

	while(my($key, $val) = each %$hr){

		$result .= inspect($key, $_[1]);
		$result .= ' => ';
		$result .= inspect($val, $_[1]);
		$result .= ",";
	}

	chop $result;

	return "{$result}";
}

sub ARRAY{
	my $ar = $_[0];

	my $result = '';

	foreach (@$ar){
		$result .= inspect($_, $_[1]);
		$result .= ",";
	}
	chop $result;

	return "[$result]";
}
sub SCALAR{
	my $sr = $_[0];

	return '\\' . inspect($$sr, $_[1]);

}
sub REF{
	my $rr = $_[0];

	return '\\' . inspect($$rr, $_[1]);
}
sub GLOB{
	my $gr = $_[0];

	return '\\' . inspect(*$gr, $_[1]);
}

sub CODE{
	my $cr = $_[0];

	require B::Deparse;
	my $deparser = B::Deparse->new(qw(-sC -si0));

	my $result = $deparser->coderef2text($cr);

	if($result eq ';'){
		$result = '{ (XSUB) }';
	}
	else{
		$result =~ tr/\n/ /;
	}

	return "sub " . $result;
}


1;