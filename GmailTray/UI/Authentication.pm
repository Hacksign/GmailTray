#!/usr/bin/perl

package GmailTray::UI::Authentication;

BEGIN{
	use strict;
	#add include directory to search path
	use Gtk2 -init;
	use Gtk2::WebKit;
	use GmailTray::Libs::Utils;
}

sub new{
	my $self = {};
	bless($self);
	create_main_window();
	return $self;
}

sub create_main_window{
	local $glogin_dialog = Gtk2::Dialog->new ('GmailTray Option',
		undef,
		[qw/modal destroy-with-parent/],
		'gtk-cancel' => 'reject');
	$glogin_dialog->set_default_size(600, 650);
	local $view   = Gtk2::WebKit::WebView->new;
	local $url		 = 'https://accounts.google.com/o/oauth2/auth?client_id=913987392517-qkintaca6vvmp0a8ofnvbkf0trnrrda8.apps.googleusercontent.com&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&scope=https://www.googleapis.com/auth/gmail.readonly';

	$glogin_dialog->get_content_area()->add($view);
	$view->signal_connect('onload-event' => sub{
			local ($webwidget) = @_;
			if($webwidget->get_title() =~ /Success code=/){
				local $auth_code = $webwidget->get_title();
				$auth_code =~ s/Success code=//;
				chomp $auth_code;
				require GmailTray::Gmail::OAuth2;
				$gmail_oauth = GmailTray::Gmail::OAuth2->new($auth_code);
				local %access_json = $gmail_oauth->access_token();
				GmailTray::Libs::Utils::update_token(%access_json);
				$glogin_dialog->destroy();
			}
		});
	$view->open($url);

	$glogin_dialog->show_all();
	local $response = $glogin_dialog->run();
	if($response eq 'reject'){
		$glogin_dialog->destroy();
	}
}


1;
