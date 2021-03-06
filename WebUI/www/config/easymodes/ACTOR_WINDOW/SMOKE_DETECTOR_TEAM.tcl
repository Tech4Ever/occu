#!/bin/tclsh

source [file join $env(DOCUMENT_ROOT) config/easymodes/em_common.tcl]
source [file join $env(DOCUMENT_ROOT) config/easymodes/EnterFreeValue.tcl]
source [file join $env(DOCUMENT_ROOT) config/easymodes/etc/options.tcl]
source [file join $env(DOCUMENT_ROOT) config/easymodes/SWITCH/mapping/SMOKE_DETECTOR_TEAM_map.tcl]

set PROFILES_MAP(0)	"\${expert}"
set PROFILES_MAP(1)	"\${openWindowA}"
set PROFILES_MAP(2)	"\${closeWindowA}"
set PROFILES_MAP(3) 	"\${no_action}"


set PROFILE_0(UI_HINT)	0
set PROFILE_0(UI_DESCRIPTION)		"Expertenprofil"
set PROFILE_0(UI_TEMPLATE)			"Expertenprofil"

set PROFILE_1(SHORT_CT_RAMPOFF)   1
set PROFILE_1(SHORT_CT_RAMPON)    2
set PROFILE_1(SHORT_CT_OFFDELAY)	1
set PROFILE_1(SHORT_CT_ONDELAY)		2
set PROFILE_1(SHORT_CT_OFF)			1
set PROFILE_1(SHORT_CT_ON)			2
set PROFILE_1(SHORT_COND_VALUE_LO)	50
set PROFILE_1(SHORT_COND_VALUE_HI)	180 
set PROFILE_1(SHORT_ONDELAY_TIME)	0
set PROFILE_1(SHORT_ON_TIME_A)		111600
set PROFILE_1(SHORT_OFFDELAY_TIME)	0
set PROFILE_1(SHORT_OFF_TIME)		111600
set PROFILE_1(SHORT_ON_TIME_MODE)	0
set PROFILE_1(SHORT_OFF_TIME_MODE)	0
set PROFILE_1(SHORT_ACTION_TYPE)	1
set PROFILE_1(SHORT_JT_OFF)			1
set PROFILE_1(SHORT_JT_ON)			{3 4} ;# direkte Verkn. = 3, per Zentrale verkn. = 4
set PROFILE_1(SHORT_JT_OFFDELAY)	2
set PROFILE_1(SHORT_JT_ONDELAY)		{3 4} ;# siehe SHORT_JT_ON
set PROFILE_1(SHORT_JT_RAMPOFF)    2
set PROFILE_1(SHORT_JT_RAMPON)     4
set PROFILE_1(UI_DESCRIPTION)	""
set PROFILE_1(UI_TEMPLATE)		$PROFILE_1(UI_DESCRIPTION) 
set PROFILE_1(UI_HINT)	1

set PROFILE_2(SHORT_CT_RAMPOFF)   1
set PROFILE_2(SHORT_CT_RAMPON)    1
set PROFILE_2(SHORT_CT_OFFDELAY)	1
set PROFILE_2(SHORT_CT_ONDELAY)		1
set PROFILE_2(SHORT_CT_OFF)			1
set PROFILE_2(SHORT_CT_ON)			1
set PROFILE_2(SHORT_COND_VALUE_LO)	50
set PROFILE_2(SHORT_COND_VALUE_HI)	180 
set PROFILE_2(SHORT_ONDELAY_TIME)	0
set PROFILE_2(SHORT_ON_TIME_A)		111600
set PROFILE_2(SHORT_OFFDELAY_TIME)	0
set PROFILE_2(SHORT_OFF_TIME)		111600
set PROFILE_2(SHORT_ON_TIME_MODE)	0
set PROFILE_2(SHORT_OFF_TIME_MODE)	0
set PROFILE_2(SHORT_ACTION_TYPE)	1
set PROFILE_2(SHORT_JT_OFF)			5
set PROFILE_2(SHORT_JT_ON)			5
set PROFILE_2(SHORT_JT_OFFDELAY)	5
set PROFILE_2(SHORT_JT_ONDELAY)		5
set PROFILE_2(SHORT_JT_RAMPOFF)    5
set PROFILE_2(SHORT_JT_RAMPON)     5
set PROFILE_2(UI_DESCRIPTION)	""
set PROFILE_2(UI_TEMPLATE)		$PROFILE_2(UI_DESCRIPTION) 
set PROFILE_2(UI_HINT)	2


#set SUBSET_1(NAME)					"nur auslösender Rauchmelder"
set SUBSET_1(NAME)					"\${subset_1}"
set SUBSET_1(SUBSET_OPTION_VALUE)	1
set SUBSET_1(SHORT_COND_VALUE_LO)	50
set SUBSET_1(SHORT_COND_VALUE_HI)	180
set SUBSET_1(SHORT_CT_ON)			2

set SUBSET_2(NAME)					"\${subset_2}"
set SUBSET_2(SUBSET_OPTION_VALUE)	2
set SUBSET_2(SHORT_COND_VALUE_LO)	0
set SUBSET_2(SHORT_COND_VALUE_HI)	200
set SUBSET_2(SHORT_CT_ON)	4

proc set_htmlParams {iface address pps pps_descr special_input_id peer_type} {
	global dev_descr_sender dev_descr_receiver  
	upvar PROFILES_MAP  PROFILES_MAP
	upvar HTML_PARAMS   HTML_PARAMS
	upvar PROFILE_PNAME PROFILE_PNAME
	upvar $pps          ps      
	upvar $pps_descr    ps_descr
	

	foreach pro [array names PROFILES_MAP] {
		upvar PROFILE_$pro PROFILE_$pro
	}
 		
	set cur_profile [get_cur_profile2 ps PROFILES_MAP PROFILE_TMP $peer_type]

	#global SUBSETS
	set name "x"
	set i 1
	while {$name != ""} {
		upvar SUBSET_$i SUBSET_$i
		array set subset [array get SUBSET_$i]
		set name ""
		catch {set name $subset(NAME)}
		array_clear subset
		incr i
	}
#	die Texte der Platzhalter einlesen
	puts "<script type=\"text/javascript\">getLangInfo('$dev_descr_sender(TYPE)', '$dev_descr_receiver(TYPE)');</script>"
	set prn 0	
	append HTML_PARAMS(separate_$prn) "<div id=\"param_$prn\"><textarea id=\"profile_$prn\" style=\"display:none\">"
	append HTML_PARAMS(separate_$prn) [cmd_link_paramset2 $iface $address ps_descr ps "LINK" ${special_input_id}_$prn]
	append HTML_PARAMS(separate_$prn) "</textarea></div>"
#1
	incr prn
	set pref 1
	if {$cur_profile == $prn} then {array set PROFILE_$prn [array get ps]}
	append HTML_PARAMS(separate_$prn) "<div id=\"param_$prn\"><textarea id=\"profile_$prn\" style=\"display:none\">"
	append HTML_PARAMS(separate_$prn) "\${description_$prn}"
	append HTML_PARAMS(separate_$prn) "<table class=\"ProfileTbl\">"

	append HTML_PARAMS(separate_$prn) "<tr><td>\${DEF_ACK_ALARM}</td><td>"
	append HTML_PARAMS(separate_$prn) [subset2combobox {SUBSET_1 SUBSET_2} subset_$prn\_$pref separate_${special_input_id}_$prn\_$pref PROFILE_$prn] 
	append HTML_PARAMS(separate_$prn) "</td></tr>"

	incr pref ;# 2
	append HTML_PARAMS(separate_$prn) "<tr><td>\${WINDOW_OPEN_TIME}</td><td>"
	option LENGTH_OF_STAY
	append HTML_PARAMS(separate_$prn) [get_ComboBox options SHORT_ON_TIME separate_${special_input_id}_$prn\_$pref PROFILE_$prn SHORT_ON_TIME "onchange=\"ActivateFreeTime(\$('${special_input_id}_profiles'),$pref);\""]
	EnterTime_h_m_s $prn $pref ${special_input_id} ps_descr SHORT_ON_TIME
	append HTML_PARAMS(separate_$prn) "</td></tr>"
	append HTML_PARAMS(separate_$prn) "</table></textarea></div>"

#2
  incr prn
  set pref 1
  if {$cur_profile == $prn} then {array set PROFILE_$prn [array get ps]}
  append HTML_PARAMS(separate_$prn) "<div id=\"param_$prn\"><textarea id=\"profile_$prn\" style=\"display:none\">"
  append HTML_PARAMS(separate_$prn) "\${description_$prn}"
  append HTML_PARAMS(separate_$prn) "<table class=\"ProfileTbl\">"

  append HTML_PARAMS(separate_$prn) "<tr><td>\${DEF_ACK_ALARM}</td><td>"
  append HTML_PARAMS(separate_$prn) [subset2combobox {SUBSET_1 SUBSET_2} subset_$prn\_$pref separate_${special_input_id}_$prn\_$pref PROFILE_$prn]
  append HTML_PARAMS(separate_$prn) "</td></tr>"
  append HTML_PARAMS(separate_$prn) "</table></textarea></div>"

#3
	incr prn
	append HTML_PARAMS(separate_$prn) "<div id=\"param_$prn\"><textarea id=\"profile_$prn\" style=\"display:none\">"
	append HTML_PARAMS(separate_$prn) "\${description_$prn}"
	append HTML_PARAMS(separate_$prn) "</textarea></div>"

}

constructor
	
	
