#!/usr/bin/perl

BEGIN{
	use strict;
	use Data::Dump;
	use FindBin qw/$Bin/;
	push @INC,$Bin;
}

use Data::Dump;
use GmailTray::UI::Option;

$option_window = GmailTray::UI::Option->new();
