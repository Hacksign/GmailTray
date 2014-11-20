#!/usr/bin/perl

package GmailTray::UI::Systray;

BEGIN{
	use strict;
	use Gtk2 -init;
	use Gtk2::TrayIcon;
	use Glib qw/TRUE FALSE/;
	use GmailTray::Libs::Utils;
}

my $systray = Gtk2::TrayIcon->new("GmailTray");
my $trayevent = Gtk2::EventBox->new();
my $icon_nomail = Gtk2::Image->new_from_file(GmailTray::Libs::Utils::get_img("nomail"));
my $icon_newmail = Gtk2::Image->new_from_file(GmailTray::Libs::Utils::get_img("newmail"));
my $button_press_event_id;
my $current_icon_ref;

sub new{
	local $self = {};
	bless($self);
	create_main_window();
	return $self;
}

#this is an demo
sub check_email_timer_routine{
	local $event = Gtk2::Gdk::Event->new ('button-press');
	$trayevent->signal_emit ('button_press_event', $event);
	print "event launched.\n";
}

sub change_icon{
		local ($eventwidget, $eventbutton, $new_icon) = @_;
		$eventwidget->remove($$current_icon_ref);
		$eventwidget->signal_handler_disconnect($button_press_event_id);
		if($new_icon eq 'newmail'){
			$eventwidget->add($icon_newmail);
			$current_icon_ref = \$icon_newmail;
			$button_press_event_id = $eventwidget->signal_connect('button-press-event' => \&change_icon, 'nomail');
		}elsif($new_icon eq 'nomail'){
			$eventwidget->add($icon_nomail);
			$current_icon_ref = \$icon_nomail;
			$button_press_event_id = $eventwidget->signal_connect('button-press-event' => \&change_icon, 'newmail');
		}
		$systray->show_all();
}

sub create_main_window{
	$button_press_event_id = $trayevent->signal_connect('button-press-event' => \&change_icon, 'newmail');
	$trayevent->add($icon_nomail);
	$current_icon_ref = \$icon_nomail;
	$systray->add($trayevent);
	$systray->show_all();
	Glib::Timeout->add(3000, \&check_email_timer_routine);
	Gtk2->main();
}


1;
