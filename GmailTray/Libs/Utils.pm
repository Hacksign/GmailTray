#!/usr/bin/perl

package GmailTray::Libs::Utils;

BEGIN{
	use strict;
	use Data::Dump;
	use GmailTray::Libs::Variables;
}

#initiate default value of global vairables
#TODO:this should be parsed from xml config file,modify it later!
BEGIN{
	$user = 'evilsign@gmail.com';
	$proxy = "socks://127.0.0.1:9050";
	$checkfreq = 3000;
	$timeout = 10;
	$dismiss_delay = 3;
	$debug_mode = 1;
	$client_id = "913987392517-qkintaca6vvmp0a8ofnvbkf0trnrrda8.apps.googleusercontent.com";
	$client_secret = "4ASaYcTNVgdrpoH2FjXSLnfx";

	$no_mail_img	=	"/home/hacksign/Code/GitHub/GmailTray/GmailTray/Res/Img/nomail.png";
	$new_mail_img = "/home/hacksign/Code/GitHub/GmailTray/GmailTray/Res/Img/newmail.png";
}

sub update_token{
	local (%access_json) = @_;
	lock($access_token);
	lock($refresh_token);
	lock($access_token_expire);
	lock($token_gain_time);
	lock($auth_type);
	$access_token = $access_json{'access_token'} if defined($access_json{'access_token'});
	$refresh_token = $access_json{'refresh_token'} if defined($access_json{'refresh_token'});
	$access_token_expire = $access_json{'expires_in'} if defined($access_json{'expires_in'});
	$token_type = $access_json{'token_type'} if defined($access_json{'token_type'});
	$token_gain_time = time() if $access_json{'access_token'} or defined($access_json{'refresh_token'});
}
sub access_token{
	return $access_token;
}
sub refresh_token{
	return $refresh_token;
}
sub token_type{
	return $token_type;
}

sub client_id{
	return $client_id;
}
sub client_secret{
	return $client_secret;
}

sub userid{
	return $user;
}
sub timeout{
	return $timeout;
}

sub get_proxy{
	return $proxy;
}

sub get_checkfreq{
	return $checkfreq;
}

sub get_dismiss_delay{
	return $dismiss_delay;
}

sub debugmode{
	return $debug_mode;
}

sub get_img{
	local ($img_file_name) = @_;
	chomp $img_file_name;
	$img_file_name = lc($img_file_name);
	if($img_file_name eq 'nomail'){
		return $no_mail_img;
	}elsif($img_file_name eq 'newmail'){
		return $new_mail_img;
	}else{
		return 0;
	}
}

sub dump{
	print "access_token => ";
	dd $access_token;
	print "refresh_token => ";
	dd $refresh_token;
	print "access_token_expire => ";
	dd $access_token_expire;
	print "token_gain_time => ";
	dd $token_gain_time;
}

1;
