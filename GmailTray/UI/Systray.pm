#!/usr/bin/perl

package GmailTray::UI::Systray;

BEGIN{
	use strict;
	use utf8;
	use Encode qw/decode encode from_to/;
	use Gtk2 -init;
	use Gtk2::TrayIcon;
	use Glib qw/TRUE FALSE/;
	use GmailTray::Libs::Utils;
	use GmailTray::Gmail::Threads;
	use GmailTray::Gmail::Messages;
	use JSON;
	use MIME::Base64;
	#set proxy if there is one
	if(GmailTray::Libs::Utils::get_proxy()){
		$ENV{HTTPS_PROXY} = GmailTray::Libs::Utils::get_proxy();
	}
	binmode STDOUT,':utf8';
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
	local $json_parser = JSON->new();
	local $event = Gtk2::Gdk::Event->new ('button-press');
	local $access_token = GmailTray::Libs::Utils::access_token(); 
	if($access_token){
		local $gmailapi = GmailTray::Gmail::Messages->new();
		$list = $gmailapi->list();
		$json = $json_parser->decode($list);
		foreach $each_item(@{$json->{'messages'}}){
			$content = $json_parser->decode($gmailapi->get($each_item->{'id'}));
			foreach $each_part(@{$content->{'payload'}{'parts'}}){
				print decode_base64($each_part->{'body'}{'data'});
			}
		}
	}else{
		print "no token\n";
	}

	return TRUE;
}

sub show_tray_menu{
	local $traymenu = Gtk2::Menu->new();
	local $option_item = Gtk2::ImageMenuItem->new_from_stock ('gtk-preferences', undef);
	local $refresh_item = Gtk2::ImageMenuItem->new_from_stock ('gtk-refresh', undef);
	local $new_item = Gtk2::ImageMenuItem->new_from_stock ('gtk-new', undef);
	local $about_item = Gtk2::ImageMenuItem->new_from_stock ('gtk-about', undef);
	local $quit_item = Gtk2::ImageMenuItem->new_from_stock ('gtk-quit', undef);
	$refresh_item->signal_connect('activate' => sub{ check_email_timer_routine(); });
	$quit_item->signal_connect('activate' => sub{ Gtk2->main_quit()});
	$option_item->signal_connect('activate' => sub{
		use GmailTray::UI::Option;
		local $option_dialog = GmailTray::UI::Option->new();
	});
	$traymenu->append(Gtk2::SeparatorMenuItem->new());
	$traymenu->append($new_item);
	$traymenu->append($refresh_item);
	$traymenu->append($option_item);
	$traymenu->append(Gtk2::SeparatorMenuItem->new());
	$traymenu->append($about_item);
	$traymenu->append($quit_item);
	$traymenu->append(Gtk2::SeparatorMenuItem->new());
	$traymenu->popup(undef,undef,undef,undef,0,0);
	$traymenu->show_all();
}

sub change_icon{
	local ($traywidget) = @_;
	$traywidget->remove($$current_icon_ref);
	if($current_icon_ref == \$icon_newmail){
		$traywidget->add($icon_nomail);
		$current_icon_ref = \$icon_nomail;
	}else{
		$traywidget->add($icon_newmail);
		$current_icon_ref = \$icon_newmail;
	}
	$systray->show_all();
}

sub event_handler{
		local ($eventwidget, $eventbutton) = @_;
		if($eventbutton->button == 3){#mouse right button triggered
			show_tray_menu();
		}elsif($eventbutton->button == 1){#mouse left button triggered
			change_icon($eventwidget);
		}else{
			print "other event.\n";
		}
}

sub create_main_window{
	$button_press_event_id = $trayevent->signal_connect('button-press-event' => \&event_handler);
	$trayevent->add($icon_nomail);
	$current_icon_ref = \$icon_nomail;
	$systray->add($trayevent);
	$systray->show_all();
	Glib::Timeout->add(GmailTray::Libs::Utils::get_checkfreq(), \&check_email_timer_routine);
	Gtk2->main();
}


1;
