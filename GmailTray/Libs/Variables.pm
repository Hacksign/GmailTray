#!/usr/bin/perl
#do NOT use this package directly
#use GmailTray::Libs::Utils to handle all variables in this package
#this file contain all global variables of GmailTray

package GmailTray::Libs::Variables;

BEGIN{
	use strict;
	#add include directory to search path
	use FindBin qw/$Bin/;
	push @INC,$Bin;
	use threads::shared;
	use Exporter;
	our @ISA = qw/Exporter/;
	our @EXPORT = qw/$user $checkfreq $dismiss_delay $proxy $debug_mode $client_id $client_secret $access_token $refresh_token $access_token_expire $token_gain_time $no_mail_img $new_mail_img/;
}

our $user :shared; #email address of current user
our $proxy :shared; #proxy server address
our $dismiss_delay :shared; #notify dismiss time delay
our $checkfreq :shared; #in second, how often check email
our $debug_mode :shared; #is debug mode
our $no_mail_img :shared; #trayicon image when no mail
our $new_mail_img :shared; #trayicon image when new mail

#for Goolge OAuth 2.0
our $client_id :shared; #GmilTray client_id from 'Google API Console'
our $client_secret :shared; #GmilTray client_secret from 'Google API Console'
our $access_token :shared; #OAuth2.0 parameter
our $refresh_token :shared;#OAuth2.0 parameter
our $access_token_expire :shared;#OAuth2.0 parameter
our $token_gain_time :shared;#unix timestamp to indicate when gained access_token

1;
