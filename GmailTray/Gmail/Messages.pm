#!/usr/bin/perl

package GmailTray::Gmail::Messages;

BEGIN{
	use strict;
	use GmailTray::Libs::Utils;
	use LWP::UserAgent;
}

my $ua = LWP::UserAgent->new;
my $debugmode = GmailTray::Libs::Utils::debugmode();
$ua->timeout(GmailTray::Libs::Utils::timeout());
$ua->show_progress($debugmode);

sub new{
	my $self = {};
	bless($self);
	return $self;
}
#api document url:
#	https://developers.google.com/gmail/api/v1/reference/users/messages
sub get{
	local ($self, $message_id) = @_;
	local $api_url = 'https://www.googleapis.com/gmail/v1/users/'.GmailTray::Libs::Utils::userid().'/messages/'.$message_id;
	local $auth_header = GmailTray::Libs::Utils::token_type().' '.GmailTray::Libs::Utils::access_token();
	$ua->env_proxy(1) if GmailTray::Libs::Utils::get_proxy();
	local $response = $ua->get($api_url, 'Authorization' => $auth_header);
	if($response->is_success){
		return $response->content;
	}else{
		return 0;
	}
}
sub list{
	local $api_url = 'https://www.googleapis.com/gmail/v1/users/'.GmailTray::Libs::Utils::userid().'/messages';
	local $auth_header = GmailTray::Libs::Utils::token_type().' '.GmailTray::Libs::Utils::access_token();
	$ua->env_proxy(1) if GmailTray::Libs::Utils::get_proxy();
	local $response = $ua->get($api_url, 'Authorization' => $auth_header);
	if($response->is_success){
		return $response->content;
	}else{
		return 0;
	}
}

1;
