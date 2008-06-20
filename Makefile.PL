use 5.008_001;

use constant RUBY_REQUIRE_VERSION_LT => "1.8.6";
use constant RUBY_REQUIRE_VERSION_GT => "1.8.7";

use strict;
use warnings;

use ExtUtils::MakeMaker;
use Config;
use File::Spec;
use File::Basename;

use Getopt::Long;


my $ruby = 'ruby';


GetOptions(
	'ruby=s' => \$ruby,
);

$ruby =~ s/(?:\Q$Config{exe_ext}\E)?$/$Config{exe_ext}/;

unless(-x $ruby){

	foreach my $dir(File::Spec->path){
		my $x = File::Spec->catfile($dir, $ruby);
		if(-x $x){
			$ruby = $x;
			last;
		}
	}
}

unless(-x $ruby){
	die "Executable ruby command is not found, stopped";
}

my $rubysign = `$ruby -v`;

if(!$rubysign or $rubysign !~ /^ruby /){
	die "The command '$ruby' doesn't seem to be ruby, stopped";
}

print "Using $ruby\n";
print $rubysign; 

my $rbver = `$ruby -e "print RUBY_VERSION"`;

if($rbver lt RUBY_REQUIRE_VERSION_LT){
	die "Ruby version ",
		RUBY_REQUIRE_VERSION_LT,
		" required--this is only version $rbver, stopped";
}
if($rbver gt RUBY_REQUIRE_VERSION_GT){
	die "Ruby version $rbver is not supported, stopped";
}

my $archdir    = ruby_config($ruby, "archdir");
my $libruby    = ruby_config($ruby, "LIBRUBY");
my $libdir     = ruby_config($ruby, "libdir");
my $librubyarg = ruby_config($ruby, "LIBRUBYARG");
my $rubyhdrdir = ruby_config($ruby, "rubyhdrdir"); # 1.9.0+

my $lib;

my $prefix = $archdir;
while($prefix){
	$lib = File::Spec->join($prefix, $libruby);
	if(-f $lib){
		last;
	}
	$prefix = dirname $prefix;
}

if(-f $lib){
	$librubyarg =~ s/\Q$libruby/$lib/;
}

print "ruby-inc: $archdir\n";
print "libdir  : $libdir\n";
print "ruby-lib: $librubyarg\n";

if($rubyhdrdir){
	print "ruby-hdr: $rubyhdrdir\n";

	my $arch = ruby_config($ruby, "arch");
	$rubyhdrdir = qq[ -I"$rubyhdrdir" -I"$rubyhdrdir/$arch"];
}



WriteMakefile(
	NAME         => 'Ruby',
	VERSION_FROM => 'Ruby.pm',

	ABSTRACT_FROM => 'lib/Ruby.pod',

	OBJECT       => '$(O_FILES)',

	DEFINE       => join(' ', qq[-DMY_RUBY_VERSION="$rbver"]),

	INC          => qq[-I"$archdir"] . $rubyhdrdir,
	LIBS         => qq[-L$libdir $librubyarg],

	AUTHOR       => 'Goro Fuji',
	LICENSE      => 'perl',
);


sub ruby_config{
	my($ruby, $var) = @_;

	my $s = `$ruby -rrbconfig -e "print Config::CONFIG['$var']"`;
	return $s eq 'nil' ? '' : $s;
}