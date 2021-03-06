use CSS::LESSp;
use strict;
use EV;

opendir(DIR, '.') || die('Cannot open directory'); 

warn 'CSS-compilation started';

my $w = EV::periodic 0, 2, 0, sub {
	my @styles = grep { /^\S+\.less$/i && -f $_ } readdir DIR;
	rewinddir DIR;
	for my $less(@styles) {
		open STLESS => "<$less";
			my $buffer = do { local $/ ; <STLESS>};
		close STLESS;
		$less =~s/less/css/gi;
		open STCSS => ">$less";
			print STCSS join '' => CSS::LESSp->parse($buffer) if (length($buffer) > 0);
		close STCSS;
	}
};

my $q = EV::signal 'QUIT', sub {
	closedir DIR;
};

EV::loop;