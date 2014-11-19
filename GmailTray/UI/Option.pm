#!/usr/bin/perl

package GmailTray::UI::Option;

BEGIN{
	use strict;
	#add include directory to search path
	use utf8;
	use threads;
	use threads::shared;
	use Gtk2 qw/-init/;
	use GmailTray::UI::Language qw/%language/;
	use GmailTray::Libs::Utils;
}

sub new{
	my $self = {};
	bless($self);
	create_main_window();
	return $self;
}

#private variables
local $proxy_entry;
sub create_main_window{
	{#create option dialog
		local $option_dialog = Gtk2::Dialog->new ('GmailTray Option',
			undef,
			[qw/modal destroy-with-parent/],
			'gtk-ok'     => 'accept',
			'gtk-cancel' => 'reject');
		local $hbox = Gtk2::HBox->new(0, 0);        
		$hbox->set_border_width(4);              
		$option_dialog->get_content_area()->pack_start($hbox, 0, 0, 0);
		{#create basic info frame area
			local $vbox = Gtk2::VBox->new(0, 4);        
			$hbox->pack_start($vbox, 0, 0, 4);       
			local $frame_login = Gtk2::Frame->new($language{'basic_info_frame_title'});
			local $basic_info_table = Gtk2::Table->new(3,2, 0);
			$frame_login->add($basic_info_table);
			$vbox->pack_start($frame_login, 0, 0, 4);

			#proxy label and input
			local $proxy_label = Gtk2::Label->new($language{'proxy_label'});
			$proxy_label->set_alignment(0, 0.5);
			$proxy_entry = Gtk2::Entry->new();
			$proxy_entry->set_width_chars(15);
			$proxy_entry->set_alignment(0);
			$proxy_entry->append_text(GmailTray::Libs::Utils::get_proxy()) if GmailTray::Libs::Utils::get_proxy() ne '';      
			$proxy_label->set_mnemonic_widget ($proxy_entry);
			$basic_info_table->attach_defaults($proxy_label, 0, 1, 0, 1);
			$basic_info_table->attach_defaults($proxy_entry, 1, 2, 0, 1);

			#save password checkbox
			local $savepwd_button = Gtk2::CheckButton->new_with_label($language{'savepwd_button'});
			$basic_info_table->attach_defaults($savepwd_button, 1, 2, 1, 2 );
		}
		{#mailbox check option frame
			local $vbox2 = Gtk2::VBox->new(0, 4);
			$hbox->pack_start($vbox2, 0, 0, 4);
			local $frame_check = Gtk2::Frame->new($language{'check_option_frame_title'});
			local $checkoption_table = Gtk2::Table->new(2, 2, 0);
			$frame_check->add($checkoption_table);
			$vbox2->pack_start($frame_check, 0, 0, 4);

			local $checkfreq_label = Gtk2::Label->new_with_mnemonic($language{'checkfreq_label'});
			$checkfreq_label->set_alignment(0, 0.5);
			$checkoption_table->attach_defaults($checkfreq_label, 0, 1, 0, 1);
			local $checkfreq_entry = Gtk2::Entry->new();
			$checkfreq_entry->set_width_chars(4);
			$checkfreq_entry->set_alignment(0.5);
			$checkfreq_entry->append_text(GmailTray::Libs::Utils::get_checkfreq()) if GmailTray::Libs::Utils::get_checkfreq() ne '';      
			$checkfreq_label->set_mnemonic_widget($checkfreq_entry);
			$checkoption_table->attach_defaults($checkfreq_entry, 1, 2, 0, 1);

			local $message_dismiss_label = Gtk2::Label->new_with_mnemonic($language{'message_dismiss_label'});
			$message_dismiss_label->set_alignment(0, 0.5);
			$checkoption_table->attach_defaults($message_dismiss_label, 0, 1, 1, 2);
			local $message_dismiss_entry = Gtk2::Entry->new();
			$message_dismiss_entry->set_width_chars(4);
			$message_dismiss_entry->set_alignment(0.5);
			$message_dismiss_entry->append_text(GmailTray::Libs::Utils::get_dismiss_delay()) if GmailTray::Libs::Utils::get_dismiss_delay() ne '';      
			$message_dismiss_label->set_mnemonic_widget($message_dismiss_entry);
			$checkoption_table->attach_defaults($message_dismiss_entry, 1, 2, 1, 2);

			local $fulltime_button = Gtk2::CheckButton->new_with_label($language{'fulltime_button'});
			$checkoption_table->attach_defaults($fulltime_button, 0, 1, 2, 3 );
		}
		$option_dialog->show_all();
		local $response = $option_dialog->run();
		if($response eq 'accept') {
			{
				$proxy = $proxy_entry->get_text();
			}
			require GmailTray::UI::Authentication;
			local $auth_window = GmailTray::UI::Authentication->new();
		}
		GmailTray::Libs::Utils::dump();
		$option_dialog->destroy();
	}
}



1;
