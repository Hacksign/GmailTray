#!/usr/bin/perl

package GmailTray::UI::Systray;

BEGIN{
	use strict;
	use Gtk2 -init;
	use Gtk2::TrayIcon;
	use GmailTray::Libs::Utils;
}

sub new{
	my $self = {};
	bless($self);
	create_main_window();
	return $self;
}

sub create_main_window{
	local $systray = Gtk2::TrayIcon->new("GmailTray");
	local $trayevent = Gtk2::EventBox->new();
	local $icon_nomail = Gtk2::Image->new_from_file(GmailTray::Libs::Utils::get_img("nomail"));
	$trayevent->signal_connect('button-press-event' => sub{
		use Data::Dump;
		local ($eventwidget) = @_;
		local $icon_newmail = Gtk2::Image->new_from_file(GmailTray::Libs::Utils::get_img("newmail"));
		$eventwidget->remove($icon_nomail);
		$eventwidget->add($icon_newmail);
		$systray->show_all();
	});
	$trayevent->add($icon_nomail);
	$systray->add($trayevent);
	$systray->show_all();
	Gtk2->main();
}


1;
