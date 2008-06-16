package Ruby::Run;

use strict;
use warnings;
use Ruby qw(rb_eval);


use Filter::Util::Call;

sub import{
	my $class = shift;
	filter_add({});
}

sub filter{
	my $self = shift;

	return 0 if $self->{eof};

	$_ = <<'HEAD' if $self->{line}++ == 0;
Ruby::Run::rb_eval(<<'[RUBY]', __PACKAGE__, __FILE__, __LINE__);
HEAD

	my $status = filter_read();

	if($status == 0){ # EOF
		$_ .= "\n[RUBY]\n";
		$status = 1;
		$self->{eof} = 1;
	}
	return $status;
}
1;
__END__

=head1 NAME

Ruby::Run - Run a ruby script

=head1 SYNOPSIS

	perl -MRuby::Run foo.rb

=head1 SEE ALSO

L<Ruby>.

=cut
