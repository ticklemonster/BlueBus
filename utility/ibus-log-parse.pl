#!env perl
use strict;

my %bus = (
	"00" => "GM",	# Body module
	"08" => "SDH",	# Tilt/Slide Sunroof
	"18" => "CDC",	# CD Changer
	"24" => "HKM",	# Trunk Lid Module
	"28" => "FUH",	# Radio controlled clock
	"2E" => "EDC",	# Electronic Damper Control
	"30" => "CCM",	# Check control module
	"3B" => "GT",	# Graphics driver (in navigation system)
	"3F" => "DIA",	# Diagnostic
	"43" => "GTR",	# Graphics driver for rear screen (in navigation system)
	"44" => "EWS",	# EWS (Immobiliser)
	"46" => "CID",	# Central information display (flip-up LCD screen)
	"50" => "MFL",	# Multi function steering wheel
	"51" => "SM1",	# Seat memory - 1
	"53" => "MUL",	# Multicast, broadcast address
	"5B" => "IHK",	# HVAC
	"60" => "PDC",	# Park Distance Control
	"66" => "ALC",	# Active Light Control
	"68" => "RAD",	# Radio
	"69" => "EKM",	# Electronic Body Module
	"6A" => "DSP",	# DSP
	"6B" => "HEAT",	# Webasto
	"71" => "SM0",	# Seat memory - 0
	"72" => "SM0",	# Seat memory - 0
	"73" => "SDRS",	# Sirius Radio
	"76" => "CDCD",	# CD changer, DIN size.
	"7F" => "NAVE",	# Navigation (Europe)
	"80" => "IKE",	# Instrument cluster electronics
	"A0" => "MIDR",	# Rear Multi-info display
	"A4" => "MRS",	# Multiple Restraint System
	"B0" => "SES",	# Speech Input System
	"BB" => "NAVJ",	# Navigation (Japan)
	"BF" => "GLO",	# Global, broadcast address
	"C0" => "MID",	# Multi-info display
	"C8" => "TEL",	# Telephone
	"CA" => "TCU",	# BMW Assist
	"D0" => "LCM",	# Light control module
	"E0" => "IRI",	# Integrated radio information system
	"E7" => "ANZ",	# Displays Multicast
	"E8" => "RLS",	# Rain/Driving Light Sensor
	"EA" => "DSPC",	# DSP Controler
	"ED" => "VM",	# Video Module
	"F0" => "BMBT",	# On-board monitor
	"FF" => "LOC"	# Local
);

my %cmd = (
	"00" => "GET_STATUS",
	"01" => "STATUS_REQ",
	"02" => "STATUS_RESP",
	"07" => "PDC_STATUS",
	"0B" => "IO_STATUS",
	"0C" => "DIA_JOB_REQUEST",
	"10" => "IGN_STATUS_REQ",
	"11" => "IGN_STATUS_RESP",
	"12" => "SENSOR_REQ",
	"13" => "SENSOR_RESP",
	"14" => "REQ_VEHICLE_TYPE",
	"15" => "RESP_VEHICLE_CONFIG",
	"18" => "SPEED_RPM_UPDATE",
	"19" => "TEMP_UPDATE",
	"20" => "MODE",
	"GT_20" => "GT_CHANGE_UI_REQ",
	"21" => "MAIN_MENU",
	"GT_21" => "GT_WRITE_MENU", 
	"TEL_21" => "TEL_MAIN_MENU",
	"RAD_21" => "RAD_C43_SCREEN_UPDATE",
	"MID_21" => "RAD_WRITE_MID_MENU",
	"22" => "WRITE_RESPONSE",
	"23" => "WRITE_TITLE",
	"IKE_23" => "IKE_WRITE_TITLE",
	"GT_23" => "GT_WRITE_TITLE",
	"TEL_23" => "TEL_TITLETEXT",
	"RAD_23" => "RAD_UPDATE_MAIN_AREA",
	"24" => "OBC_TEXT",
	"27" => "SET_MODE",
	"2A" => "OBC_STATUS",
	"2B" => "LED_STATUS",
	"2C" => "TEL_STATUS",
	"31" => "MENU_SELECT",
	"32" => "VOLUME",
	"36" => "CONFIG_SET",
	"37" => "DISPLAY_RADIO_TONE_SELECT",
	"38" => "REQUEST",
	"39" => "RESPONSE",
	"3B" => "BTN_PRESS",
	"40" => "OBC_INPUT",
	"41" => "OBC_CONTROL",
	"42" => "OBC_REMOTE_CONTROL",
	"45" => "SCREEN_MODE_SET",
	"46" => "SCREEN_MODE_REQUEST",
	"47" => "SOFT_BUTTON",
	"48" => "BUTTON",
	"49" => "DIAL_KNOB",
	"4A" => "LED_TAPE_CTRL",
	"4E" => "TV_STATUS",
	"4F" => "MONITOR_CONTROL",
	"53" => "LCM_REQ_REDUNDANT_DATA",
	"54" => "LCM_RESP_REDUNDANT_DATA",
	"59" => "RLS_STATUS",
	"5A" => "LCM_INDICATORS_REQ",
	"5A" => "LCM_INDICATORS_RESP",
	"5C" => "INSTRUMENT_BACKLIGHTING",
	"60" => "WRITE_INDEX",
	"61" => "WRITE_INDEX_TMC",
	"62" => "WRITE_ZONE",
	"63" => "WRITE_STATIC",
	"74" => "IMMOBILISER_STATUS",
	"7A" => "DOORS_FLAPS_STATUS_RESP",
	"9F" => "DIA_DIAG_TERMINATE",
	"A0" => "DIA_DIAG_RESPONSE",
	"A2" => "TELEMATICS_COORDINATES",
	"A4" => "TELEMATICS_LOCATION",
	"A5" => "WRITE_WITH_CURSOR",
	"A7" =>	"TMC_REQUEST",
	"A8" =>	"TMC_RESPONSE",
	"A9" =>	"BMW_ASSIST_DATA",
	"AA" => "NAV_CONTROL_REAR",
	"AB" => "NAV_CONTROL_FRONT",
	"C0" => "C43_SET_MENU_MODE"
);

sub hex_string_to_array {
	my ($string) = @_;
	my @data;
	foreach(split(" ",$string)) {
		push(@data, hex($_));
	}
	return @data;
}

sub data_parsers_module_status {
	my ($src, $dst, $string, $data) = @_;
	my $announce = $data->[0] & 0b00000001;
	my $variant = ($data->[0] & 0b11111000) >> 3;

	my %variants = (
		"BMBT" => {
			0b00000 => "BMBT_4_3",
			0b00110 => "BMBT_16_9",
			0b01110 => "BMBT_16_9"
			},
		"TEL" => {
			0b00111 => "Everest+Bluetooth",
			0b00110 => "Motorola V-Series",
			0b00000 => "CMT3000"
			},
		"NAVE" => {
			0b01000 => "NAV_MK4",
			0b11000 => "NAV_MK4_ASSIST"
			},
		"GT" => {
			0b00010 => "GT_VM",
			0b01000 => "GT_NAV"
			}
	);

	$variant = $variants{$src}{$variant} || $variant;
	return "announce=$announce, variant=$variant";
};

sub data_parsers_mfl_buttons {
	my ($src, $dst, $string, $data) = @_;
	my $button = $data->[0] & 0b1100_1001;
	my $state = $data->[0] & 0b0011_0000;

	my %states = (
		0b0000_0000 => "PRESS",
		0b0001_0000 => "HOLD",
		0b0010_0000 => "RELEASE",
	);

	my %buttons = (
		0b0000_0001 => "FORWARD",
		0b0000_1000 => "BACK",
		0b0100_0000 => "RT",
		0b1000_0000 => "TEL"
	);

	$button = $buttons{$button} || $button;
	$state = $states{$state} || $state;

	return "button=$button, state=$state";
}

sub data_parsers_bmbt_buttons {
	my ($src, $dst, $string, $data) = @_;
	my $button = $data->[0] & 0b0011_1111;
	my $state = $data->[0] & 0b1100_0000;

	my %states = (
		0b0000_0000 => "PRESS",
		0b0100_0000 => "HOLD",
		0b1000_0000 => "RELEASE",
	);

	my %buttons = (
		0b00_0100 => "TONE",
		0b10_0000 => "SEL",
		0b01_0000 => "PREV",
		0b00_0000 => "NEXT",
		0b01_0001 => "PRESET_1",
		0b00_0001 => "PRESET_2",
		0b01_0010 => "PRESET_3",
		0b00_0010 => "PRESET_4",
		0b01_0011 => "PRESET_5",
		0b00_0011 => "PRESET_6",
		0b10_0001 => "AM",
		0b11_0001 => "FM",
		0b10_0011 => "MODE_PREV",
		0b11_0011 => "MODE_NEXT",
		0b11_0000 => "OVERLAY",
		0b00_0110 => "POWER",
		0b10_0100 => "EJECT",
		0b01_0100 => "SWITCH_SIDE",
		0b11_0010 => "TP",
		0b10_0010 => "RDS",

		0b00_1000 => "TELEPHONE",
		0b00_0111 => "AUX_HEAT",

		0b11_0100 => "MENU",
		0b00_0101 => "CONFIRM",

	);

	$button = $buttons{$button} || $button;
	$state = $states{$state} || $state;

	return "button=$button, state=$state";
}

sub data_parsers_bmbt_soft_buttons {
	my ($src, $dst, $string, $data) = @_;
	my $button = $data->[1] & 0b0011_1111;
	my $state = $data->[1] & 0b1100_0000;

	my %states = (
		0b0000_0000 => "PRESS",
		0b0100_0000 => "HOLD",
		0b1000_0000 => "RELEASE",
	);

	my %buttons = (
		0b00_1111 => "SELECT",
		0b11_1000 => "INFO",
	);
	$button = $buttons{$button} || $button;
	$state = $states{$state} || $state;

	return "button=$button, state=$state, extra=$data->[0]";
}

sub data_parsers_volume {
	my ($src, $dst, $string, $data) = @_;
	my $direction = $data->[0] & 0b0000_0001;
	my $steps = ($data->[0] & 0b1111_0000) >> 4;

	return "volume_change=".(($direction==0)?'-':'+').$steps;
}

sub data_parsers_navi_knob {
	my ($src, $dst, $string, $data) = @_;
	my $direction = $data->[0] & 0b1000_0000;
	my $steps = $data->[0] & 0b0000_1111;

	return "turn=".(($direction==0)?'-':'+').$steps;
}

sub data_parsers_monitor_control {
	my ($src, $dst, $string, $data) = @_;

	my $source = $data->[0] & 0b0000_0011;
	my $power = ($data->[0] & 0b0001_0000) >> 4;
	my $encoding = $data->[1] & 0b0000_0011;
	my $aspect = ($data->[1] & 0b0011_0000) >> 4;

	my %sources = (
		0b0000_0000 => "NAV_GT",
		0b0000_0001 => "TV",
		0b0000_0010 => "VID_GT",
	);

	my %encodings = (
		0b0000_0010 => "PAL",
		0b0000_0001 => "NTSC",
	);

	my %aspects = (
		0b0000_0000 => "4:3",
		0b0000_0001 => "16:9",
		0b0000_0011 => "ZOOM",
	);

	$source = $sources{$source} || $source;
	$encoding = $encodings{$encoding} || $encoding;
	$aspect = $aspects{$aspect} || $aspect;

	return "power=$power, source=$source, aspect=$aspect, enc=$encoding";
}

sub data_parsers_request_screen {
	my ($src, $dst, $string, $data) = @_;

	my $priority = $data->[0] & 0b0000_0001;
	my $hide_header = ($data->[0] & 0b0000_0010) >> 1;
	my $hide_body = $data->[0] & 0b0000_1100;

	my %bodies = (
		0b0000_0100 => "HIDE_BODY_SEL",
		0b0000_1000 => "HIDE_BODY_TONE",
		0b0000_1100 => "HIDE_BODY_MENU",
	);

	$hide_body = $bodies{$hide_body} || $hide_body;

	return "priority=".(($priority==0)?"RAD":"GT").", hide_header=".(($hide_header==1)?"HIDE":"SHOW").", hide=$hide_body";
}

sub data_parsers_set_radio_ui {
	my ($src, $dst, $string, $data) = @_;

	my $priority = $data->[0] & 0b0000_0001;
	my $audio_obc = ($data->[0] & 0b0000_0010) >> 1;
	my $new_ui = ($data->[0] & 0b0001_0000) >> 4;
	my $new_ui_hide = ($data->[0] & 0b1000_0000) >> 7;

	return "priority=".(($priority==0)?"RAD":"GT").", audio+obc=$audio_obc, new_ui=$new_ui, new_ui_hide=$new_ui_hide";
}

sub data_parsers_gt_write {
	my ($src, $dst, $string, $data) = @_;

	my $layout = $data->[0];
	my $function = $data->[1];
	my $index = $data->[2] & 0b0001_1111;
	my $clear = ($data->[2] & 0b0010_0000 ) >> 5;
	my $buffer = ($data->[2] & 0b0100_0000 ) >> 6;
	my $highlight = ($data->[2] & 0b1000_0000 ) >> 7;

	my $text = "";
	for (my $i = 3; $i<length(\$data); $i++) {
		$text .= chr($data->[$i]);
	}

	my %layouts = (
		0x42 => "DIAL",
		0x43 => "DIRECTORY",
		0x60 => "WRITE_INDEX",
		0x61 => "WRITE_INDEX_TMC",
		0x62 => "WRITE_ZONE",
		0x63 => "WRITE_STATIC",
		0x80 => "TOP-8",
		0xf0 => "LIST",
		0xf1 => "DETAIL"
	);

	my %functions = (
		0x00 => "NULL",
		0x01 => "CONTACT",
		0x05 => "SOS",
		0x07 => "NAVIGATION",
		0x08 => "INFO"
	);

	$layout = $layouts{$layout} || $layout;
#	$function = $functions{$function} || $function;

	$text =~ s/\x06/<nl>/go;
	$text =~ s/\xB0/ /go;
	return "layout=$layout, func/pos=$function, index=$index, clear=$clear, buffer=$buffer, highlight=$highlight, text=\"$text\"";

}

my %data_parsers = (
	"BMBT_STATUS_RESP" => \&data_parsers_module_status,
	"TEL_STATUS_RESP" => \&data_parsers_module_status,
	"NAVE_STATUS_RESP" => \&data_parsers_module_status,
	"GT_STATUS_RESP" => \&data_parsers_module_status,

	"BMBT_MONITOR_CONTROL" => \&data_parsers_monitor_control,

	"TEL_BTN_PRESS" => \&data_parsers_mfl_buttons,
	"RAD_BTN_PRESS" => \&data_parsers_mfl_buttons,

	"GT_BUTTON" => \&data_parsers_bmbt_buttons,
	"BMBT_BROADCAST_BUTTON" => \&data_parsers_bmbt_buttons,
	"RAD_BUTTON" => \&data_parsers_bmbt_buttons,

	"BMBT_SOFT_BUTTON" => \&data_parsers_bmbt_soft_buttons,

	"RAD_VOLUME" => \&data_parsers_volume,
	"TEL_VOLUME" => \&data_parsers_volume,

	"BMBT_DIAL_KNOB" => \&data_parsers_navi_knob,
	"GT_DIAL_KNOB" => \&data_parsers_navi_knob,

	"GT_SCREEN_MODE_REQUEST" => \&data_parsers_request_screen,
	"RAD_SCREEN_MODE_SET" => \&data_parsers_set_radio_ui,

	"GT_WRITE_WITH_CURSOR" => \&data_parsers_gt_write,
	"GT_WRITE_MENU" => \&data_parsers_gt_write,

);



while (<>) {
	my $line = $_;
	if (/^\[(\d+)\]\s+DEBUG:\s+IBus:\s+RX\[(\d+)\]:\s+?(..)\s+..\s+(..)\s+(..)\s*(.*?)[\s\r\n]+$/osi) {	
#		print $line;
		my $time = $1;
		my $len = $2;
		my $src = $bus{$3} || "0x".$3;
		my $dst = $bus{$4} || "0x".$4;
		my $cmd_raw = $5;
		my $data = $6;

		my $cmd_assumed;
		my $cmd;
		my $broadcast = " ";

		if ($dst eq "LOC" || $dst eq "GLO" || $dst eq "MUL" || $dst eq "ANZ") {
			$broadcast = "B";

			$cmd_assumed = $src."_BROADCAST_".$cmd_raw;
			if ($cmd{$cmd_assumed}) {
				$cmd = $cmd{$cmd_assumed};
			} elsif ($cmd{$cmd_raw}) {
				$cmd = $src."_BROADCAST_".$cmd{$cmd_raw};
			} else { 
				$cmd = $cmd_assumed;
			};
		} elsif ($cmd{$cmd_raw} =~ /RESP/i) {
				$cmd = $src."_".$cmd{$cmd_raw};
		} else {
			$cmd_assumed = $dst."_".$cmd_raw;
			if ($cmd{$cmd_assumed}) {
				$cmd = $cmd{$cmd_assumed};
			} else {
				$cmd_assumed = $src."_".$cmd_raw;
				if ($cmd{$cmd_assumed}) {
					$cmd = $cmd{$cmd_assumed};
				} elsif ($cmd{$cmd_raw}) {
					$cmd = $dst."_".$cmd{$cmd_raw};
				} else { 
					$cmd = $dst."_".$cmd_raw;
				};
			}
		}

		my $self = " ";

		if ($data =~ s/\s+\[SELF\]//o) {
			$self = "*";
		}

		$data =~ s/\s*..$//;

		my $sec = ($time % (60*1000))/1000;
		my $min = int($time/(60*1000)) % 60;
		my $hour = int($time/(60*60*1000));

		my $data_parsed;
		if ($data_parsers{$cmd}) {
			my @data = hex_string_to_array($data);
			if (length(@data) > 0) {
				$data_parsed = $data_parsers{$cmd}->($src,$dst, $data, \@data);
			} else {
				$data_parsed = "";
			}
		} else {
			$data_parsed = $data;
		}
		printf ("%3d:%02d:%06.3f %1s%1s %4s -> %-4s %2s %s\n". ' 'x 30 ."%s (%s)\n\n", $hour, $min, $sec, $self, $broadcast, $src, $dst, $cmd_raw, $data, $cmd, $data_parsed);

	} else {
#		print;
	}
};