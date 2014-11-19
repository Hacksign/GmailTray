#!/usr/bin/perl

package GmailTray::UI::Language;

use strict;
use Encode;
use Exporter;
our @ISA = qw/Exporter/;
our @EXPORT_OK = qw/%language/;

our %language = (
	'basic_info_frame_title' => '登录设置',
	'check_option_frame_title' => '检查设置',
	'username_label' => '用户名',
	'password_label' => '密码',
	'savepwd_button' => '保存密码',
	'proxy_label' => '代理',
	'checkfreq_label' => '检查频率(秒)',
	'fulltime_button' => '24小时时钟',
	'message_dismiss_label' => '通知消失延迟(秒)',
);

#decode all chracters with utf8
foreach my $_lkey(keys %language){
	$language{$_lkey} = Encode::decode('utf8', $language{$_lkey});
}

1;
