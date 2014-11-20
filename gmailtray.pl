#!/usr/bin/perl

BEGIN{
	use strict;
	use Data::Dump;
	use FindBin qw/$Bin/;
	push @INC,$Bin;
}

use Data::Dump;
use GmailTray::UI::Systray;

$w = GmailTray::UI::Systray->new();
