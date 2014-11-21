#!/usr/bin/perl

package GmailTray::Gmail::OAuth2;

BEGIN{
	use strict;
	use JSON;
	use LWP::Protocol::socks;
	use GmailTray::Libs::Utils;
}

local $access_code = '';

sub new{
	my $self = {};
	(my $package_name, $access_code) = @_;
	bless($self);
	return $self;
}

sub access_token{
	use LWP::UserAgent;
	local $url = "https://accounts.google.com/o/oauth2/token";
	local $post_data = {
		"client_id" => GmailTray::Libs::Utils::client_id(),
		"client_secret" => GmailTray::Libs::Utils::client_secret(),
		"redirect_uri" => "urn:ietf:wg:oauth:2.0:oob",
		"grant_type" => "authorization_code",
		"code" => $access_code
	};
	local $ua = LWP::UserAgent->new();
	$ua->show_progress(GmailTray::Libs::Utils::debugmode());
	$ua->env_proxy(1) if GmailTray::Libs::Utils::get_proxy();
	local $response = $ua->post($url,$post_data);
	if($response->is_success()){
		local $json_parser = JSON->new();
		local $json_response = $json_parser->decode($response->content);
		return %$json_response;
	}

	return 0;
}

sub refresh_token{
	($refresh_token) = @_;
	use LWP::UserAgent;
	local $url = "https://accounts.google.com/o/oauth2/token";
	local $post_data = {
		"client_id" => GmailTray::Libs::Utils::client_id(),
		"client_secret" => GmailTray::Libs::Utils::client_secret(),
		"grant_type" => "refresh_token",
		"refresh_token" => $refresh_token
	};
	local $ua = LWP::UserAgent->new();
	$ua->show_progress(GmailTray::Libs::Utils::debugmode());
	$ua->env_proxy(1) if GmailTray::Libs::Utils::get_proxy();
	local $response = $ua->post($url,$post_data);
	if($response->is_success()){
		local $json_parser = JSON->new();
		local $json_response = $json_parser->decode($response->content);
		return %$json_response;
	}

	return 0;
}

1;
