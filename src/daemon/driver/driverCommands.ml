(* Copyright 2001, 2002 b8_bavard, b8_fee_carabine, INRIA *)
(*
    This file is part of mldonkey.

    mldonkey is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    mldonkey is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with mldonkey; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*)

open Printf2
open Md4
open CommonMessages
open CommonGlobals
open CommonShared
open CommonSearch
open CommonClient
open CommonServer
open CommonNetwork
open GuiTypes
open CommonTypes
open CommonFile
open CommonComplexOptions
open Options
open BasicSocket
open TcpBufferedSocket
open DriverInteractive
open CommonOptions
open CommonInteractive
open CommonEvent

  
let execute_command arg_list output cmd args =
  let buf = output.conn_buf in
  try
    let rec iter list =
      match list with
        [] -> 
          Gettext.buftext buf no_such_command cmd
      | (command, arg_kind, help) :: tail ->
          if command = cmd then
            Buffer.add_string buf (
              match arg_kind, args with
                Arg_none f, [] -> f output
              | Arg_multiple f, _ -> f args output
              | Arg_one f, [arg] -> f arg  output
              | Arg_two f, [a1;a2] -> f a1 a2 output
              | Arg_three f, [a1;a2;a3] -> f a1 a2 a3 output
              | _ -> !!bad_number_of_args
            )
          else
            iter tail
    in
    iter arg_list
  with Not_found -> ()


let list_options_html o list = 
  let buf = o.conn_buf in
     html_mods_table_header buf "voTable" "vo" [ 
		( "0", "srh", "Option name", "Name (Help=mouseOver)" ) ; 
		( "0", "srh", "Option value", "Value" ) ; 
		( "0", "srh", "Option default", "Default" ) ] ; 
  
  let counter = ref 0 in
  
  List.iter (fun (name, value, def, help) ->
      incr counter;
      if (!counter mod 2 == 0) then Printf.bprintf buf "\\<tr class=\\\"dl-1\\\"\\>"
      else Printf.bprintf buf "\\<tr class=\\\"dl-2\\\"\\>";
      
      if String.contains value '\n' then 
        Printf.bprintf buf "
                  \\<td title=\\\"%s\\\" class=\\\"sr\\\"\\>%s\\<form action=/submit target=\\\"$S\\\"\\> 
                  \\<input type=hidden name=setoption value=q\\>
                  \\<input type=hidden name=option value=%s\\>\\</td\\>\\<td\\>\\<textarea 
					name=value rows=5 cols=20 wrap=virtual\\> 
                  %s   
                  \\</textarea\\>\\<input type=submit value=Modify\\>
                  \\</td\\>\\<td class=\\\"sr\\\"\\>%s\\</td\\>\\</tr\\>
                  \\</form\\>
                  " help name name value def
      
      else  
        
        begin
          
          Printf.bprintf buf "
              \\<td title=\\\"%s\\\" class=\\\"sr\\\"\\>%s\\</td\\>
		      \\<td class=\\\"sr\\\"\\>\\<form action=/submit target=\\\"$S\\\"\\>\\<input type=hidden 
				name=setoption value=q\\>\\<input type=hidden name=option value=%s\\>"  help name name;
          
          if value = "true" || value = "false" then 
            
            Printf.bprintf buf "\\<select style=\\\"font-family: verdana; font-size: 10px;\\\"
									name=\\\"value\\\" onchange=\\\"this.form.submit()\\\"\\>
									\\<option selected\\>%s\\<option\\>%s\\</select\\>"
              value 
              (if value="true" then "false" else "true")
          else
            
            Printf.bprintf buf "\\<input style=\\\"font-family: verdana; font-size: 10px;\\\" 
				type=text name=value size=20 value=\\\"%s\\\"\\>"
              value;
          
          Printf.bprintf buf "
              \\</td\\>
              \\<td class=\\\"sr\\\"\\>%s\\</td\\>
			  \\</tr\\>\\</form\\>
              " def
        end;
      
      
  )list;
    Printf.bprintf  buf "\\</table\\>\\</div\\>"


let list_options o list = 
  let buf = o.conn_buf in
  if o.conn_output = HTML then
    Printf.bprintf  buf "\\<table border=0\\>";
  List.iter (fun (name, value) ->
      if String.contains value '\n' then begin
          if o.conn_output = HTML then
            Printf.bprintf buf "
                  \\<tr\\>\\<td\\>\\<form action=/submit $S\\> 
                  \\<input type=hidden name=setoption value=q\\>
                  \\<input type=hidden name=option value=%s\\> %s \\</td\\>\\<td\\>
                  \\<textarea name=value rows=10 cols=70 wrap=virtual\\> 
                  %s
                  \\</textarea\\>
                  \\<input type=submit value=Modify\\>
                  \\</td\\>\\</tr\\>
                  \\</form\\>
                  " name name value
        end
      else
      if o.conn_output = HTML then
        Printf.bprintf buf "
              \\<tr\\>\\<td\\>\\<form action=/submit $S\\> 
\\<input type=hidden name=setoption value=q\\>
\\<input type=hidden name=option value=%s\\> %s \\</td\\>\\<td\\>
              \\<input type=text name=value size=40 value=\\\"%s\\\"\\>
\\</td\\>\\</tr\\>
\\</form\\>
              " name name value
      else
        Printf.bprintf buf "$b%s$n = $r%s$n\n" name value)
  list;
  if o.conn_output = HTML then
    Printf.bprintf  buf "\\</table\\>"
  
let commands = [

(*
    "dump_heap", Arg_none (fun o ->
        Heap.print_memstats ();
        "heap dumped"
    ), ":\t\t\t\tdump heap for debug";
    
    "dump_usage", Arg_none (fun o ->
        Heap.dump_usage ();
        "usage dumped"
    ), ":\t\t\t\tdump main structures for debug";
*)
    
    "close_fds", Arg_none (fun o ->
        Unix32.close_all ();
        "All files closed"
    ), ":\t\t\t\tclose all files (use to free space on disk after remove)";
    
    "commit", Arg_none (fun o ->
        List.iter (fun file ->
            file_commit file
        ) !!done_files;
        "Commited"
    ) , ":\t\t\t\t$bmove downloaded files to incoming directory$n";
    
    "vd", Arg_multiple (fun args o -> 
        let buf = o.conn_buf in
        match args with
          [arg] ->
            let num = int_of_string arg in
            if o.conn_output = HTML then
              begin
                Printf.bprintf  buf "\\<a href=/files\\>Display all files\\</a\\>  ";
                Printf.bprintf  buf "\\<a href=/submit?q=verify_chunks+%d\\>Verify chunks\\</a\\>  " num;
		Printf.bprintf  buf "\\<a href=/submit?q=preview+%d\\>Preview\\</a\\>  " num;
                if !!html_mods then
                  Printf.bprintf  buf "\\<a href=\\\"javascript:window.location.reload()\\\"\\>Reload\\</a\\>\\<br\\>\n";
              end;
            List.iter 
              (fun file -> if (as_file_impl file).impl_file_num = num then 
                  CommonFile.file_print file o)
            !!files;
            List.iter
              (fun file -> if (as_file_impl file).impl_file_num = num then 
                  CommonFile.file_print file o)
            !!done_files;
            ""
        | _ ->
            DriverInteractive.display_file_list buf o;
            ""    
    ), "<num> :\t\t\t\t$bview file info$n";
    
    "downloaders", Arg_none (fun o ->
        let buf = o.conn_buf in
        
        if use_html_mods o then
          html_mods_table_header buf "downloadersTable" "downloaders" [ 
            ( "1", "srh ac", "Client number (click to add as friend)", "Num" ) ; 
            ( "0", "srh", "Client state", "CS" ) ; 
            ( "0", "srh", "Client name", "Name" ) ; 
            ( "0", "srh", "Client brand", "CB" ) ; 
            ( "0", "srh", "Overnet [T]rue, [F]alse", "O" ) ; 
            ( "1", "srh ar", "Connected time (minutes)", "CT" ) ; 
            ( "0", "srh", "Connection [I]ndirect, [D]irect", "C" ) ; 
            ( "0", "srh", "IP address", "IP address" ) ; 
            ( "1", "srh ar", "Total UL bytes to this client for all files", "UL" ) ; 
            ( "1", "srh ar", "Total DL bytes from this client for all files", "DL" ) ; 
            ( "0", "srh", "Filename", "Filename" ) ]; 
        
        let counter = ref 0 in
        
        List.iter 
          (fun file -> 
            if (CommonFile.file_downloaders file o !counter) then counter := 0 else counter := 1;
        ) !!files;
        
        if use_html_mods o then Printf.bprintf buf "\\</table\\>\\</div\\>";
        
        ""
    ) , ":\t\t\t\tdisplay downloaders list";
    
    "verify_chunks", Arg_multiple (fun args o -> 
        let buf = o.conn_buf in
        match args with
          [arg] ->
            let num = int_of_string arg in
            if o.conn_output = HTML then
              List.iter 
                (fun file -> if (as_file_impl file).impl_file_num = num then 
                    begin
                      Printf.bprintf  buf "Verifying Chunks of file %d" num;
                      file_check file; 
                    end
              )
              !!files;
            ""
        | _ -> ();
            "done"    
    ), "<num> :\t\t\tverify chunks of file <num>";
    
    
    "preview", Arg_one (fun arg o ->
        
        let num = int_of_string arg in
	let file = file_find num in
        file_preview file;
        "done"
    ), "<file number> :\t\t\tstart previewer for file <file number>";

    "vm", Arg_none (fun o ->
        CommonInteractive.print_connected_servers o;
        ""), ":\t\t\t\t\t$blist connected servers$n";
    
    "q", Arg_none (fun o ->
        raise CommonTypes.CommandCloseSocket
    ), ":\t\t\t\t\t$bclose telnet$n";
    
    "debug_socks", Arg_none (fun o ->
        BasicSocket.print_sockets o.conn_buf;
        "done"), ":\t\t\t\tfor debugging only";
    
    "kill", Arg_none (fun o ->
        CommonGlobals.exit_properly 0;
        "exit"), ":\t\t\t\t\t$bsave and kill the server$n";
    
    "save", Arg_none (fun o ->
        DriverInteractive.save_config ();
        "saved"), ":\t\t\t\t\tsave";
    
    "vo", Arg_none (fun o ->
        let buf = o.conn_buf in
        if use_html_mods o then begin
            
            Printf.bprintf buf "\\<div class=\\\"friends\\\"\\>\\<table class=main cellspacing=0 cellpadding=0\\> 
\\<tr\\>\\<td\\>
\\<table cellspacing=0 cellpadding=0  width=100%%\\>\\<tr\\>
\\<td class=downloaded width=100%%\\>\\</td\\>
\\<td nowrap class=fbig\\>\\<a onclick=\\\"javascript:window.location.href='/submit?q=shares'\\\"\\>Shares\\</a\\>\\</td\\>
\\<td nowrap class=fbig\\>\\<a onclick=\\\"javascript:window.location.href='/submit?q=html_mods'\\\"\\>Toggle html_mods\\</a\\>\\</td\\>
\\<td nowrap class=fbig\\>\\<a onclick=\\\"javascript:window.location.href='/submit?q=voo+1'\\\"\\>Full Options\\</a\\>\\</td\\>
\\<td nowrap class=\\\"fbig pr\\\"\\>\\<a onclick=\\\"javascript:parent.fstatus.location.href='/submit?q=save'\\\"\\>Save\\</a\\>\\</td\\>
\\</tr\\>\\</table\\>
\\</td\\>\\</tr\\>
\\<tr\\>\\<td\\>";
            
            list_options_html o  (
              [
                strings_of_option_html max_hard_upload_rate; 
                strings_of_option_html max_hard_download_rate;
                strings_of_option_html telnet_port; 
                strings_of_option_html gui_port; 
                strings_of_option_html http_port;
                strings_of_option_html client_name;
                strings_of_option_html allowed_ips;
                strings_of_option_html set_client_ip; 
                strings_of_option_html force_client_ip; 
              ] );
            
            Printf.bprintf buf "\\</td\\>\\<tr\\>\\</table\\>\\</div\\>"
          end
        
        else
          list_options o  (
            [
              strings_of_option max_hard_upload_rate; 
              strings_of_option max_hard_download_rate;
              strings_of_option telnet_port; 
              strings_of_option gui_port; 
              strings_of_option http_port;
              strings_of_option client_name;
              strings_of_option allowed_ips;
              strings_of_option set_client_ip; 
              strings_of_option force_client_ip; 
            ]
          );        
        
        "\nUse '$rvoo$n' for all options"    
    ), ":\t\t\t\t\t$bdisplay options$n";
    
    "html_mods", Arg_none (fun o ->
        let buf = o.conn_buf in
        
        if !!html_mods then 
          begin
            Options.set_simple_option expert_ini "html_mods" "false";
            Options.set_simple_option expert_ini "commands_frame_height" "140"
          end
        else
          begin 
            Options.set_simple_option expert_ini "html_mods" "true";
            Options.set_simple_option expert_ini "commands_frame_height" "80";
            Options.set_simple_option expert_ini "html_mods_style" "0";
            Options.set_simple_option expert_ini "use_html_frames" "true"
          end;
        
        "\\<script language=Javascript\\>top.window.location.reload();\\</script\\>"
    ), ":\t\t\t\ttoggle html_mods";
    
    
    "html_mods_style", Arg_multiple (fun args o ->
        let buf = o.conn_buf in
        if args = [] then begin
			Array.iteri (fun i h -> 
             Printf.bprintf buf "%d: %s\n" i (fst h);
			) !html_mods_styles;
			""
        end
        else begin
            Options.set_simple_option expert_ini "html_mods" "true";
            Options.set_simple_option expert_ini "use_html_frames" "true";
            let num = int_of_string (List.hd args) in

			if num >= 0 && num < (Array.length !html_mods_styles) then begin
				Options.set_simple_option expert_ini "commands_frame_height" (Printf.sprintf "%d" (snd !html_mods_styles.(num)));
				Options.set_simple_option expert_ini "html_mods_style" (Printf.sprintf "%d" num);
				CommonMessages.colour_changer ();
			end
			else begin
				Options.set_simple_option expert_ini "commands_frame_height" (Printf.sprintf "%d" (snd !html_mods_styles.(0)));
               Options.set_simple_option expert_ini "html_mods_style" "0";
               CommonMessages.colour_changer ();
            end;
            "\\<script language=Javascript\\>top.window.location.reload();\\</script\\>"
        end
    
    ), ":\t\t\tselect html_mods_style <#>";
    
    
    
    "voo", Arg_multiple (fun args o ->
        let buf = o.conn_buf in
        if use_html_mods o then begin

                Printf.bprintf buf "\\<script language=javascript\\>
\\<!-- 
function submitHtmlModsStyle() {
var formID = document.getElementById(\\\"htmlModsStyleForm\\\")
parent.fstatus.location.href='/submit?q=html_mods_style+'+formID.modsStyle.value;
}
//--\\>
\\</script\\>";
            
            Printf.bprintf buf "\\<div class=\\\"vo\\\"\\>\\<table class=main cellspacing=0 cellpadding=0\\> 
\\<tr\\>\\<td\\>
\\<table cellspacing=0 cellpadding=0  width=100%%\\>\\<tr\\>
\\<td class=downloaded width=100%%\\>\\</td\\>
\\<td nowrap class=fbig\\>\\<a onclick=\\\"javascript:window.location.href='/submit?q=voo+1'\\\"\\>Client\\</a\\>\\</td\\>
\\<td nowrap class=fbig\\>\\<a onclick=\\\"javascript:window.location.href='/submit?q=voo+2'\\\"\\>Ports\\</a\\>\\</td\\>
\\<td nowrap class=fbig\\>\\<a onclick=\\\"javascript:window.location.href='/submit?q=voo+3'\\\"\\>html\\</a\\>\\</td\\>
\\<td nowrap class=fbig\\>\\<a onclick=\\\"javascript:window.location.href='/submit?q=voo+4'\\\"\\>Delays\\</a\\>\\</td\\>
\\<td nowrap class=fbig\\>\\<a onclick=\\\"javascript:window.location.href='/submit?q=voo+5'\\\"\\>Files\\</a\\>\\</td\\>
\\<td nowrap class=fbig\\>\\<a onclick=\\\"javascript:window.location.href='/submit?q=voo+6'\\\"\\>Mail\\</a\\>\\</td\\>
\\<td nowrap class=fbig\\>\\<a onclick=\\\"javascript:window.location.href='/submit?q=voo+7'\\\"\\>Net\\</a\\>\\</td\\>
\\<td nowrap class=\\\"fbig pr\\\"\\>\\<a onclick=\\\"javascript:window.location.href='/submit?q=voo'\\\"\\>All\\</a\\>\\</td\\>
\\</tr\\>\\</table\\>
\\</td\\>\\</tr\\>
\\<tr\\>\\<td\\>";
            
            list_options_html o (
              match args with
                [] | _ :: _ :: _ -> CommonInteractive.all_simple_options_html ()
              | [tab] ->
                  let tab = int_of_string tab in
                  match tab with
                    1 -> 
                      [
                        strings_of_option_html client_name; 
                        strings_of_option_html set_client_ip; 
                        strings_of_option_html force_client_ip; 
                        strings_of_option_html run_as_user; 
                        strings_of_option_html run_as_useruid; 
                        strings_of_option_html max_upload_slots; 
                        strings_of_option_html dynamic_slots; 
                        strings_of_option_html max_hard_upload_rate; 
                        strings_of_option_html max_hard_download_rate; 
                        strings_of_option_html max_opened_connections; 
                        strings_of_option_html max_concurrent_downloads; 
                      ] 
                  
                  | 2 -> 
                      [
                        strings_of_option_html gui_bind_addr; 
                        strings_of_option_html telnet_bind_addr; 
                        strings_of_option_html http_bind_addr; 
                        strings_of_option_html chat_bind_addr; 
                        strings_of_option_html gui_port; 
                        strings_of_option_html telnet_port; 
                        strings_of_option_html http_port; 
                        strings_of_option_html chat_port; 
                        strings_of_option_html http_realm; 
                        strings_of_option_html allowed_ips; 
                      ] 
                  | 3 -> 
                      [
                        strings_of_option_html html_mods_use_relative_availability; 
                        strings_of_option_html html_mods_human_readable; 
                        strings_of_option_html html_mods_vd_network; 
                        strings_of_option_html html_mods_vd_active_sources; 
                        strings_of_option_html html_mods_vd_age; 
                        strings_of_option_html html_mods_vd_last; 
                        strings_of_option_html html_mods_vd_prio; 
                        strings_of_option_html html_mods_vd_queues; 
                        strings_of_option_html html_mods_show_pending; 
                        strings_of_option_html html_mods_load_message_file; 
                        strings_of_option_html html_mods_max_messages; 
                        strings_of_option_html commands_frame_height; 
                        strings_of_option_html display_downloaded_results; 
                        strings_of_option_html vd_reload_delay; 
                        strings_of_option_html max_name_len; 
                      ] 
                  | 4 -> 
                      [
                        strings_of_option_html save_options_delay; 
                        strings_of_option_html update_gui_delay; 
                        strings_of_option_html server_connection_timeout; 
                        strings_of_option_html client_timeout; 
                        strings_of_option_html ip_cache_timeout; 
                        strings_of_option_html compaction_delay; 
                        strings_of_option_html min_reask_delay; 
                        strings_of_option_html max_reask_delay; 
                        strings_of_option_html buffer_writes; 
                        strings_of_option_html buffer_writes_delay; 
                        strings_of_option_html buffer_writes_threshold; 
                      ] 
                  | 5 -> 
                      [
                        strings_of_option_html previewer; 
                        strings_of_option_html incoming_directory; 
                        strings_of_option_html temp_directory; 
                        strings_of_option_html file_completed_cmd; 
                        strings_of_option_html allow_browse_share; 
                        strings_of_option_html auto_commit; 
                        strings_of_option_html log_file; 
                      ] 
                  | 6 -> 
                      [
                        strings_of_option_html mail; 
                        strings_of_option_html smtp_port; 
                        strings_of_option_html smtp_server; 
                        strings_of_option_html add_mail_brackets; 
                        strings_of_option_html filename_in_subject; 
                      ] 
                  | 7 -> 
                      [
                        strings_of_option_html enable_server; 
                        strings_of_option_html enable_overnet; 
                        strings_of_option_html enable_donkey; 
                        strings_of_option_html enable_bittorrent; 
                        strings_of_option_html enable_opennap; 
                        strings_of_option_html enable_soulseek; 
                        strings_of_option_html enable_audiogalaxy; 
                        strings_of_option_html enable_gnutella; 
                        strings_of_option_html enable_directconnect; 
                        strings_of_option_html enable_openft; 
                        strings_of_option_html tcpip_packet_size; 
                        strings_of_option_html mtu_packet_size; 
                        strings_of_option_html minimal_packet_size; 
                        strings_of_option_html network_update_url; 
                        strings_of_option_html mlnet_redirector; 
                      ] 
                  
                  | _ -> CommonInteractive.all_simple_options_html ()
            );

Printf.bprintf buf "
\\</td\\>\\</tr\\>
\\<tr\\>\\<td\\>
\\<table cellspacing=0 cellpadding=0  width=100%%\\>\\<tr\\>
\\<td class=downloaded width=100%%\\>\\</td\\>
\\<td nowrap class=\\\"fbig fbigb\\\"\\>\\<a onclick=\\\"javascript:window.location.href='/submit?q=shares'\\\"\\>Shares\\</a\\>\\</td\\>
\\<td nowrap class=\\\"fbig fbigb\\\"\\>\\<a onclick=\\\"javascript:parent.fstatus.location.href='/submit?q=save'\\\"\\>Save\\</a\\>\\</td\\>
\\<td nowrap class=\\\"fbig fbigb\\\"\\>\\<a onclick=\\\"javascript:window.location.href='/submit?q=html_mods'\\\"\\>toggle html_mods\\</a\\>\\</td\\>
\\<td nowrap class=\\\"fbig fbigb pr\\\"\\>
\\<form style=\\\"margin: 0px;\\\" name=\\\"htmlModsStyleForm\\\" id=\\\"htmlModsStyleForm\\\" 
action=\\\"javascript:submitHtmlModsStyle();\\\"\\>
\\<select id=\\\"modsStyle\\\" name=\\\"modsStyle\\\"
style=\\\"font-size: 8px; font-family: verdana\\\" onchange=\\\"this.form.submit()\\\"\\>
\\<option value=\\\"0\\\"\\>html style\n";

			Array.iteri (fun i h -> 
             Printf.bprintf buf "\\<option value=\\\"%d\\\"\\>%s\n" i (fst h);
			) !html_mods_styles;

Printf.bprintf buf "
\\</select\\>\\</td\\>
\\</tr\\>\\</table\\>";
            Printf.bprintf buf "\\</td\\>\\</tr\\>\\</table\\>\\</div\\>";
          end
        else list_options o  (CommonInteractive.all_simple_options ());
        
        ""
    ), ":\t\t\t\t\tprint all options";
    
    "options", Arg_multiple (fun args o ->
        let buf = o.conn_buf in
        match args with
          [] ->
            let sections = ref [] in
            Printf.bprintf buf "Available sections for options: \n";
            List.iter (fun  (section, message, option, optype) ->
                if not (List.mem section !sections) then begin
                    Printf.bprintf buf "  $b%s$n\n" section;
                    sections := section :: !sections
                  end
            ) gui_options_panel;
            
            List.iter (fun (section, list) ->
                if not (List.mem section !sections) then begin
                    Printf.bprintf buf "  $b%s$n\n" section;
                    sections := section :: !sections
                  end)
            ! CommonInteractive.gui_options_panels;
            "\n\nUse 'options section' to see options in this section"
        
        | sections -> 
            List.iter (fun s ->
                Printf.bprintf buf "Options in section $b%s$n:\n" s;
                List.iter (fun (section, message, option, optype) ->
                    if s = section then
                      Printf.bprintf buf "  %s [$r%s$n]= $b%s$n\n" 
                        message option 
                        (get_fully_qualified_options option)
                ) gui_options_panel;
                
                List.iter (fun (section, list) ->
                    if s = section then                    
                      List.iter (fun (message, option, optype) ->
                          Printf.bprintf buf "  %s [$b%s$n]= $b%s$n\n" 
                            message option 
                            (get_fully_qualified_options option)
                      ) list)
                ! CommonInteractive.gui_options_panels;
            ) sections;
            "\nUse '$rset option \"value\"$n' to change a value where options is
the name between []"
    ), ":\t\t\t\t$bprint options values by section$n";
    
    "upstats", Arg_none (fun o ->
        let buf = o.conn_buf in
        
        if use_html_mods o then Printf.bprintf buf "\\<div class=\\\"upstats\\\"\\>"
        else Printf.bprintf buf "Upload statistics:\n";
        Printf.bprintf buf "Total: %s uploaded\n" 
          (size_of_int64 !upload_counter);
        
        let list = ref [] in
        shared_iter (fun s ->
            let impl = as_shared_impl s in
            list := impl :: !list
        );
        
        if use_html_mods o then 
          html_mods_table_header buf "upstatsTable" "upstats" [ 
            ( "1", "srh", "Total file requests", "Reqs" ) ; 
            ( "1", "srh", "Total bytes sent", "Total" ) ; 
            ( "0", "srh", "Filename", "Filename" ) ]; 
        
        let counter = ref 0 in 
        
        let list = Sort.list (fun f1 f2 ->
              (f1.impl_shared_requests = f2.impl_shared_requests &&
                f1.impl_shared_uploaded > f2.impl_shared_uploaded) ||
              (f1.impl_shared_requests > f2.impl_shared_requests )
          ) !list in
        
        List.iter (fun impl ->
            if use_html_mods o then
              begin
                incr counter;
                
                let ed2k = Printf.sprintf "ed2k://|file|%s|%s|%s|/" 
                    impl.impl_shared_codedname 
                    (Int64.to_string impl.impl_shared_size)
                  (Md4.to_string impl.impl_shared_id) in
                
                Printf.bprintf buf "\\<tr class=\\\"%s\\\"\\>"
                  (if (!counter mod 2 == 0) then "dl-1" else "dl-2";);

				html_mods_td buf [
				("", "sr ar", Printf.sprintf "%d" impl.impl_shared_requests);
				("", "sr ar", size_of_int64 impl.impl_shared_uploaded);
				("", "sr", Printf.sprintf "\\<a href=\\\"%s\\\"\\>%s\\</a\\>" 
					ed2k impl.impl_shared_codedname) ];
 				Printf.bprintf buf "\\</tr\\>\n";
              end
            else
              Printf.bprintf buf "%-50s requests: %8d bytes: %10s\n"
                impl.impl_shared_codedname impl.impl_shared_requests
                (Int64.to_string impl.impl_shared_uploaded);
        ) list;
        
        if use_html_mods o then Printf.bprintf buf "\\</table\\>\\</div\\>\\</div\\>";
        
        
        "done"
    ), ":\t\t\t\tstatistics on upload";
    
    "set", Arg_two (fun name value o ->
        try
          try
            let buf = o.conn_buf in
            CommonInteractive.set_fully_qualified_options name value;
            Printf.sprintf "option %s value changed" name

(*
            let pos = String.index name '-' in
            let prefix = String.sub name 0 pos in
            let name = String.sub name (pos+1) (String.length name - pos-1) in
            networks_iter (fun n ->
                match n.network_config_file with
                  None -> ()
                | Some opfile ->
                    List.iter (fun p ->
                        if p = prefix then begin
                            set_simple_option opfile name value;
                            Printf.bprintf buf "option %s :: %s value changed" 
                            n.network_name name
                            
                          end)
                    n.network_prefixes      
);
  *)
          with _ -> 
              Options.set_simple_option downloads_ini name value;
              Printf.sprintf "option %s value changed" name
        with e ->
            Printf.sprintf "Error %s" (Printexc2.to_string e)
    ), "<option_name> <option_value> :\t$bchange option value$n";
    
    "vr", Arg_multiple (fun args o ->
        let buf = o.conn_buf in
        let user = o.conn_user in
        match args with
          num :: _ -> 
            List.iter (fun num ->
                let num = int_of_string num in
                let s = search_find num in
                DriverInteractive.print_search buf s o) args;
            ""
        | [] ->   
            begin
              match user.ui_user_searches with
                [] -> "No search to print"
              | s :: _ ->
                  DriverInteractive.print_search buf s o;
                  ""
            end;
    ), "[<num>] :\t\t\t\t$bview results of a search$n";
    
    "s", Arg_multiple (fun args o ->
        let buf = o.conn_buf in
        let user = o.conn_user in
        let query = CommonSearch.search_of_args args in
        ignore (CommonInteractive.start_search user
            (let module G = GuiTypes in
            { G.search_num = 0;
              G.search_query = query;
              G.search_max_hits = 10000;
              G.search_type = RemoteSearch;
            }) buf);
        ""
    ), "<query> :\t\t\t\tsearch for files on all networks\n
\tWith special args:
\t-minsize <size>
\t-maxsize <size>
\t-media <Video|Audio|...>
\t-Video
\t-Audio
\t-format <format>
\t-title <word in title>
\t-album <word in album>
\t-artist <word in artist>
\t-field <field> <fieldvalue>
\t-not <word>
\t-and <word> 
\t-or <word>

";
    
    "ls", Arg_multiple (fun args o ->
        let buf = o.conn_buf in
        let user = o.conn_user in
        let query = CommonSearch.search_of_args args in
        ignore (CommonInteractive.start_search user
            (let module G = GuiTypes in
            { G.search_num = 0;
              G.search_query = query;
              G.search_max_hits = 10000;
              G.search_type = LocalSearch;
            }) buf);
        ""
    ), "<query> :\t\t\t\t$bsearch for files on all networks$n\n
\tWith special args:
\t-minsize <size>
\t-maxsize <size>
\t-media <Video|Audio|...>
\t-Video
\t-Audio
\t-format <format>
\t-title <word in title>
\t-album <word in album>
\t-artist <word in artist>
\t-field <field> <fieldvalue>
\t-not <word>
\t-and <word> 
\t-or <word>

";
    
    "d", Arg_multiple (fun args o ->
        List.iter (fun arg ->
            CommonInteractive.download_file o arg) args;
        ""),
    "<num> :\t\t\t\t$bfile to download$n";
    
    "force_download", Arg_none (fun o ->
        let buf = o.conn_buf in
        match !CommonGlobals.aborted_download with
          None -> "No download to force"
        | Some r ->
            CommonResult.result_download (CommonResult.result_find r) [] true;
            "download forced"
    ), ":\t\t\tforce download of an already downloaded file";
    
    "vs", Arg_none (fun o ->
        let buf = o.conn_buf in
        let user = o.conn_user in
        Printf.bprintf  buf "Searching %d queries\n" (
          List.length user.ui_user_searches);
        List.iter (fun s ->
            Printf.bprintf buf "%s[%-5d]%s %s %s\n" 
              (if o.conn_output = HTML then 
                Printf.sprintf "\\<a href=/submit\\?q=forget\\+%d\\>[Forget]\\</a\\> \\<a href=/submit\\?q=vr\\+%d\\>" s.search_num s.search_num
              else "")
            s.search_num 
              (if o.conn_output = HTML then "\\</a\\>" else "")
            s.search_string
              (if s.search_waiting = 0 then "done" else
                string_of_int s.search_waiting)
        ) user.ui_user_searches; ""), ":\t\t\t\t\tview all queries";
    
    "view_custom_queries", Arg_none (fun o ->
        let buf = o.conn_buf in
        if o.conn_output <> HTML then
          Printf.bprintf buf "%d custom queries defined\n" 
            (List.length !!customized_queries);
        List.iter (fun (name, q) ->
            if o.conn_output = HTML then
              begin        
                
                if use_html_mods o then  
                  Printf.bprintf buf 
                    "\\<a href=/submit\\?custom=%s target=\\\"$O\\\"\\>%s\\</a\\> " 
                    (Url.encode name) name
                
                else
                  Printf.bprintf buf 
                    "\\<a href=/submit\\?custom=%s $O\\> %s \\</a\\>\n" 
                    (Url.encode name) name;
              end
            else
              
              Printf.bprintf buf "[%s]\n" name
        ) !! customized_queries; 
        
        if use_html_mods o then  
          Printf.bprintf buf "\\<a 
            href=\\\"http://www.jigle.com\\\" target=\\\"$O\\\"\\>Jigle\\</a\\> \\<a 
            href=\\\"http://www.sharereactor.com/search.php\\\" name=\\\"ShareReactor\\\" target=\\\"$O\\\"\\>SR\\</a\\> \\<a
            href=\\\"http://www.filenexus.com/\\\" name=\\\"FileNexus\\\" target=\\\"$O\\\"\\>FN\\</a\\> \\<a
            href=\\\"http://www.fileheaven.org/\\\" name=\\\"FileHeaven\\\" target=\\\"$O\\\"\\>FH\\</a\\> \\<a
            href=\\\"http://www.filedonkey.com\\\" name=\\\"FileDonkey\\\" target=\\\"$O\\\"\\>FD\\</a\\> \\<a
            href=\\\"http://bitzi.com/search/\\\" name=\\\"Bitzi\\\" target=\\\"$O\\\"\\>Bitzi\\</a\\> ";
        
        ""
    ), ":\t\t\tview custom queries";
    
    "cancel", Arg_multiple (fun args o ->
        if args = ["all"] then
          List.iter (fun file ->
              file_cancel file
          ) !!files
        else
          List.iter (fun num ->
              let num = int_of_string num in
              List.iter (fun file ->
                  if (as_file_impl file).impl_file_num = num then begin
                      lprintf "TRY TO CANCEL FILE"; lprint_newline ();
                      file_cancel file
                    end
              ) !!files) args; 
        ""
    ), "<num> :\t\t\t\tcancel download (use arg 'all' for all files)";
    
    "shares", Arg_none (fun o ->
        
        let buf = o.conn_buf in
        
        if use_html_mods o then begin
            Printf.bprintf buf "\\<div class=\\\"shares\\\"\\>\\<table class=main cellspacing=0 cellpadding=0\\> 
\\<tr\\>\\<td\\>
\\<table cellspacing=0 cellpadding=0  width=100%%\\>\\<tr\\>
\\<td class=downloaded width=100%%\\>\\</td\\>
\\<td nowrap class=\\\"fbig pr\\\"\\>\\<a onclick=\\\"javascript: { 
                   var getdir = prompt('Input: <priority#> <directory> (surround dir with quotes if necessary)','0 /home/mldonkey/share')
                   var reg = new RegExp (' ', 'gi') ;
                   var outstr = getdir.replace(reg, '+');
                   parent.fstatus.location.href='/submit?q=share+' + outstr;
                   setTimeout('window.location.reload()',1000);
                    }\\\"\\>Add Share\\</a\\>
\\</td\\>
\\</tr\\>\\</table\\>
\\</td\\>\\</tr\\> 
\\<tr\\>\\<td\\>";

          html_mods_table_header buf "sharesTable" "shares" [ 
            ( "0", "srh ac", "Click to unshare directory", "Unshare" ) ; 
            ( "1", "srh ar", "Priority", "P" ) ; 
            ( "0", "srh", "Directory", "Directory" ) ]; 
            
            let counter = ref 0 in
            
            Printf.bprintf buf "\\<tr class=\\\"dl-1\\\"\\>\\<td title=\\\"Incoming directory is always shared\\\" class=\\\"srb\\\"\\>Incoming\\</td\\>
\\<td class=\\\"sr ar\\\"\\>0\\</td\\>\\<td title=\\\"Incoming\\\" class=\\\"sr\\\"\\>%s\\</td\\>\\</tr\\>" !!incoming_directory;
            
            List.iter (fun (dir, prio) -> 
                incr counter;
                Printf.bprintf buf "\\<tr class=\\\"%s\\\"\\>
		\\<td title=\\\"Click to unshare this directory\\\" 
        onMouseOver=\\\"mOvr(this);\\\" 
        onMouseOut=\\\"mOut(this);\\\"
		onClick=\\\'javascript:{ 
		parent.fstatus.location.href=\\\"/submit?q=unshare+\\\\\\\"%s\\\\\\\"\\\"; 
        setTimeout(\\\"window.location.reload()\\\",1000);}'
		class=\\\"srb\\\"\\>Unshare\\</td\\>
		\\<td class=\\\"sr ar\\\"\\>%d\\</td\\>
		\\<td class=\\\"sr\\\"\\>%s\\</td\\>\\</tr\\>" 
                  (if !counter mod 2 == 0 then "dl-1" else "dl-2") dir prio dir;
            )
            !!shared_directories;
            
            Printf.bprintf buf "\\</table\\>\\</td\\>\\<tr\\>\\</table\\>\\</div\\>";
          end
        else 
          begin
            
            Printf.bprintf buf "Shared directories:\n";
            Printf.bprintf buf "  %d %s\n" !!incoming_directory_prio !!incoming_directory;
            List.iter (fun (dir, prio) -> Printf.bprintf buf "  %d %s\n" prio dir)
            !!shared_directories;
          
          end;
        ""
    ), ":\t\t\t\tprint shared directories";
    
    "share", Arg_multiple (fun args o ->
       let (prio, arg) = match args with
            [prio; arg] -> int_of_string prio, arg
	  | [arg] -> 0, arg
	  | _  -> failwith "Bad number of arguments"
	in
        
        if Unix2.is_directory arg then
          if not (List.mem_assoc arg !!shared_directories) then begin
              shared_directories =:= (arg, prio) :: !!shared_directories;
              shared_add_directory (arg, prio);
              "directory added"
            end else if not (List.mem (arg, prio) !!shared_directories) then begin
              shared_directories =:= (arg, prio) :: List.remove_assoc arg !!shared_directories;
              shared_add_directory (arg, prio);
              "prio changed"
            end else
            "directory already shared"
        else
          "no such directory"
    ), "<prio> <dir> :\t\t\tshare directory <dir> with <prio>";
    
    "unshare", Arg_one (fun arg o ->
        if List.mem_assoc arg !!shared_directories then begin
            shared_directories =:= List.remove_assoc arg !!shared_directories;
            CommonShared.shared_check_files ();
            "directory removed"
          end else
          "directory already unshared"
    
    ), "<dir> :\t\t\t\tshare directory <dir>";
    
    "pause", Arg_multiple (fun args o ->
        if args = ["all"] then
          List.iter (fun file ->
              file_pause file;
          ) !!files
        else
          List.iter (fun num ->
              let num = int_of_string num in
              List.iter (fun file ->
                  if (as_file_impl file).impl_file_num = num then begin
                      file_pause file
                    end
              ) !!files) args; ""
    ), "<num> :\t\t\t\tpause a download (use arg 'all' for all files)";
    
    "resume", Arg_multiple (fun args o ->
        if args = ["all"] then
          List.iter (fun file ->
              file_resume file
          ) !!files
        else
          List.iter (fun num ->
              let num = int_of_string num in
              List.iter (fun file ->
                  if (as_file_impl file).impl_file_num = num then begin
                      file_resume file
                    end
              ) !!files) args; ""
    ), "<num> :\t\t\t\tresume a paused download (use arg 'all' for all files)";
    
    "c", Arg_multiple (fun args o ->
        match args with
          [] ->
            networks_iter network_connect_servers;
            "connecting more servers"
        | _ ->
            List.iter (fun num ->
                let num = int_of_string num in
                let s = server_find num in
                server_connect s
            ) args;
            "connecting server"
    ),
    "[<num>] :\t\t\t\tconnect to more servers (or to server <num>)";
    
    "vc", Arg_multiple (fun args o ->
        if args = ["all"] then begin 
            let buf = o.conn_buf in
            
            html_mods_table_header buf "vcTable" "vc" [ 
              ( "1", "srh ac", "Client number", "Num" ) ; 
              ( "0", "srh", "Network", "Network" ) ; 
              ( "0", "srh", "IP address", "IP address" ) ; 
              ( "0", "srh", "Client name", "Client name" ) ]; 
            
            let counter = ref 0 in
            let all_clients_list = clients_get_all () in
            List.iter (fun num ->
                let c = client_find num in
                if use_html_mods o then Printf.bprintf buf "\\<tr class=\\\"%s\\\" 
			 title=\\\"Add as friend\\\" 
			 onClick=\\\"parent.fstatus.location.href='/submit?q=friend_add+%d'\\\" 
            onMouseOver=\\\"mOvr(this);\\\" 
            onMouseOut=\\\"mOut(this);\\\"\\>" 
                    (if (!counter mod 2 == 0) then "dl-1" else "dl-2") num;
                client_print c o;
                if use_html_mods o then Printf.bprintf buf "\\</tr\\>"
                else Printf.bprintf buf "\n";
                incr counter;
            ) all_clients_list;
            if use_html_mods o then Printf.bprintf buf "\\</table\\>\\</div\\>";
          end
        else 
          List.iter (fun num ->
              let num = int_of_string num in
              let c = client_find num in
              client_print c o;
          ) args;
        ""
    ), "<num> :\t\t\t\tview client (use arg 'all' for all clients)";
    
    "vfr", Arg_none (fun o ->
        List.iter (fun c ->
            client_print c o) !!friends;
        ""
    ), ":\t\t\t\t\tview friends";
    
    "gfr", Arg_one (fun num o ->
        let num = int_of_string num in
        let c = client_find num in
        client_browse c true;        
        "client browse"
    ), "<client num> :\t\t\task friend files";
    
    "x", Arg_one (fun num o ->
        let num = int_of_string num in
        let s = server_find num in
        (match server_state s with
            NotConnected _ -> ()
          | _ ->   server_disconnect s);
        ""
    ), "<num> :\t\t\t\tdisconnect from server";
    
    "use_poll", Arg_one (fun arg o ->
        let b = bool_of_string arg in
        BasicSocket.use_poll b;
        Printf.sprintf "poll: %s" (string_of_bool b)
    ), "<bool> :\t\t\tuse poll instead of select";
    
    "vma", Arg_none (fun o ->
        let buf = o.conn_buf in       
        let nb_servers = ref 0 in
        
        if use_html_mods o then server_print_html_header buf; 
        Intmap.iter (fun _ s ->
            try
              incr nb_servers;
              if use_html_mods o then Printf.bprintf buf "\\<tr class=\\\"%s\\\"\\>"
                  (if (!nb_servers mod 2 == 0) then "dl-1" else "dl-2");
              server_print s o
            with e ->
                lprintf "Exception %s in server_print"
                  (Printexc2.to_string e); lprint_newline ();
        ) !!servers;
        if use_html_mods o then Printf.bprintf buf "\\</table\\>\\</div\\>";
        
        
        Printf.sprintf "Servers: %d known\n" !nb_servers
    ), ":\t\t\t\t\tlist all known servers";
    
    "reshare", Arg_none (fun o ->
        let buf = o.conn_buf in
        shared_check_files ();
        "check done"
    ), ":\t\t\t\tcheck shared files for removal";
    
    "priority", Arg_multiple (fun args o ->
        let buf = o.conn_buf in
        match args with
          p :: files ->
            let absolute, p = if String2.check_prefix p "=" then
                true, int_of_string (String2.after p 1)
              else false, int_of_string p in
            List.iter (fun arg ->
                try
                  let file = file_find (int_of_string arg) in
                  let priority = if absolute then p 
                    else (file_priority file) + p in
                  let priority = if priority < -100 then -100 else
                    if priority > 100 then 100 else priority in
                  file_set_priority file priority;
                  Printf.bprintf buf "Setting priority of %s to %d\n"
                    (file_best_name file) (file_priority file);
                with _ -> failwith (Printf.sprintf "No file number %s" arg)
            ) files;
            force_download_quotas ();
            "Done"
        | [] -> "Bad number of args"
    
    ), "<priority> <files numbers> :\tchange file priorities";
    
    "version", Arg_none (fun o ->
        if use_html_mods o then Printf.sprintf "\\<P\\>" ^ 
            CommonGlobals.version () else CommonGlobals.version ()
    ), ":\t\t\t\tprint mldonkey version";
    
    "forget", Arg_one (fun num o ->
        let buf = o.conn_buf in
        let user = o.conn_user in
        let num = int_of_string num in
        CommonSearch.search_forget user (CommonSearch.search_find num);
        ""  
    ), "<num> :\t\t\t\tforget search <num>";
    
    "close_all_sockets", Arg_none (fun o ->
        BasicSocket.close_all ();
        "All sockets closed"
    ), ":\t\t\tclose all opened sockets";
    
    "message_log", Arg_multiple (fun args o ->
        let buf = o.conn_buf in
        let counter = ref 0 in
        
        (match args with
            [arg] ->
              let refresh_delay = int_of_string arg in
              if use_html_mods o && refresh_delay > 1 then
                Printf.bprintf buf "\\<meta http-equiv=\\\"refresh\\\" content=\\\"%d\\\"\\>" 
                  refresh_delay;
          | _ -> ());

(* rely on GC? *)
        
        while (Fifo.length chat_message_fifo) > !!html_mods_max_messages  do
          let foo = Fifo.take chat_message_fifo in ()
        done;
        
        if use_html_mods o then Printf.bprintf buf "\\<div class=\\\"messages\\\"\\>";
        
		last_message_log := last_time();
        Printf.bprintf buf "%d logged messages\n" (Fifo.length chat_message_fifo);
        
        if Fifo.length chat_message_fifo > 0 then
          begin
            
            if use_html_mods o then
              html_mods_table_header buf "serversTable" "servers" [ 
                ( "0", "srh", "Timestamp", "Time" ) ; 
                ( "0", "srh", "IP address", "IP address" ) ; 
                ( "1", "srh", "Client number", "Num" ) ; 
                ( "0", "srh", "Client name", "Client name" ) ; 
                ( "0", "srh", "Message text", "Message" ) ] ; 
            
            Fifo.iter (fun (t,i,num,n,s) ->
                if use_html_mods o then begin
                  	Printf.bprintf buf "\\<tr class=\\\"%s\\\"\\>"
                    (if (!counter mod 2 == 0) then "dl-1" else "dl-2");
					html_mods_td buf [
					("", "sr", Date.simple (BasicSocket.date_of_int t));
					("", "sr",  i);
					("", "sr", Printf.sprintf "%d" num);
					("", "sr", n);
					("", "srw", (String.escaped s)) ];
                  	Printf.bprintf buf "\\</tr\\>" 
					end
                else
                  Printf.bprintf buf "\n%s [client #%d] %s(%s): %s\n"
                    (Date.simple (BasicSocket.date_of_int t)) num n i s;
                incr counter;
            ) chat_message_fifo;
            if use_html_mods o then Printf.bprintf buf
                "\\</table\\>\\</div\\>\\</div\\>";
          
          end;
        
        ""
    ), ":\t\t\t\tmessage_log [refresh delay in seconds]";
    
    "message", Arg_multiple (fun args o ->
        let buf = o.conn_buf in
        match args with
          n :: msglist -> 
            let msg = List.fold_left (fun a1 a2 ->
                  a1 ^ a2 ^ " "
              ) "" msglist in
            let cnum = int_of_string n in
            client_say (client_find cnum) msg;
            Printf.sprintf "Sending msg to client #%d: %s" cnum msg;
        | _ ->  
            if use_html_mods o then begin
                
                Printf.bprintf buf "\\<script language=javascript\\>
\\<!-- 
function submitMessageForm() {
var formID = document.getElementById(\\\"msgForm\\\")
var regExp = new RegExp (' ', 'gi') ;
var msgTextOut = formID.msgText.value.replace(regExp, '+');
parent.fstatus.location.href='/submit?q=message+'+formID.clientNum.value+\\\"+\\\"+msgTextOut;
formID.msgText.value=\\\"\\\";
}
//--\\>
\\</script\\>";
                
                Printf.bprintf buf "\\<iframe id=\\\"msgWindow\\\" name=\\\"msgWindow\\\" height=\\\"80%%\\\"
            width=\\\"100%%\\\" scrolling=yes src=\\\"/submit?q=message_log+20\\\"\\>\\</iframe\\>";
                
                Printf.bprintf buf "\\<form style=\\\"margin: 0px;\\\" name=\\\"msgForm\\\" id=\\\"msgForm\\\" action=\\\"javascript:submitMessageForm();\\\"\\>";
                Printf.bprintf buf "\\<table width=100%% cellspacing=0 cellpadding=0 border=0\\>\\<tr\\>\\<td\\>";
                Printf.bprintf buf "\\<select style=\\\"font-family: verdana;
            font-size: 12px; width: 150px;\\\" id=\\\"clientNum\\\" name=\\\"clientNum\\\" \\>"; 
                
                Printf.bprintf buf "\\<option value=\\\"1\\\"\\>Client/Friend list\n";
                
                let found_nums = ref [] in
                let fifo_list = Fifo.to_list chat_message_fifo in
                let fifo_list = List.rev fifo_list in 
                let found_select = ref 0 in
                List.iter (fun (t,i,num,n,s) ->
                    if not (List.mem num !found_nums) then begin
                        
                        found_nums := num :: !found_nums;
                        Printf.bprintf buf "\\<option value=\\\"%d\\\" %s\\>%d:%s\n"
                          num 
                          (if !found_select=0 then "selected" else "";)
                        num (try
                            let c = client_find num in
                            let g = client_info c in 
                            g.client_name
                          with _ -> "unknown/expired");
                        found_select := 1;
                      end
                ) fifo_list;
                List.iter (fun c ->
                    let g = client_info c in 
                    if not (List.mem g.client_num !found_nums) then begin
                        found_nums := g.client_num :: !found_nums;
                        Printf.bprintf buf "\\<option value=\\\"%d\\\"\\>%d:%s\n"
                          g.client_num g.client_num g.client_name;
                      end
                ) !!friends;
                
                Printf.bprintf buf "\\</select\\>\\</td\\>";
                Printf.bprintf buf "\\<td width=100%%\\>\\<input style=\\\"width: 99%%; font-family: verdana; font-size: 12px;\\\" 
                type=text id=\\\"msgText\\\" name=\\\"msgText\\\" size=50 \\>\\</td\\>";
                Printf.bprintf buf "\\<td\\>\\<input style=\\\"font-family: verdana;
            font-size: 12px;\\\" type=submit value=\\\"Send\\\"\\>\\</td\\>\\</form\\>";
                Printf.bprintf buf "\\<form style=\\\"margin: 0px;\\\" id=\\\"refresh\\\" name=\\\"refresh\\\"
            action=\\\"javascript:msgWindow.location.reload();\\\"\\>
            \\<td\\>\\<input style=\\\"font-family: verdana; font-size: 12px;\\\" type=submit
            Value=\\\"Refresh\\\"\\>\\</td\\>\\</form\\>\\</tr\\>\\</table\\>";
                ""
              end
            else
              Printf.sprintf "Usage: message <client num> <msg>\n";
    
    ), ":\t\t\t\tmessage [<client num> <msg>]";
    
    "friend_add", Arg_one (fun num o ->
        let num = int_of_string num in
        let c = client_find num in
        friend_add c;
        "Added friend"
    ), "<client num> :\t\tadd client <client num> to friends";
    
    "friend_remove", Arg_multiple (fun args o ->
        if args = ["all"] then begin
            List.iter (fun c ->
                friend_remove c
            ) !!friends;
            "Removed all friends"
          end else begin
            List.iter (fun num ->
                let num = int_of_string num in
                let c = client_find num in
                friend_remove c;
            ) args;
            Printf.sprintf "%d friends removed" (List.length args)
          end
    ), "<client numbers> :\tremove friend (use arg 'all' for all friends)";    
    
    "friends", Arg_none (fun o ->
        let buf = o.conn_buf in
        
        if use_html_mods o then begin
          Printf.bprintf buf "\\<div class=\\\"friends\\\"\\>\\<table class=main cellspacing=0 cellpadding=0\\> 
\\<tr\\>\\<td\\>
\\<table cellspacing=0 cellpadding=0  width=100%%\\>\\<tr\\>
\\<td class=downloaded width=100%%\\>\\</td\\>
\\<td nowrap class=fbig\\>\\<a onclick=\\\"javascript:window.location.reload()\\\"\\>Refresh\\</a\\> \\</td\\>
\\<td nowrap class=fbig\\>\\<a onclick=\\\"javascript:
                  { parent.fstatus.location.href='/submit?q=friend_remove+all';
                    setTimeout('window.location.reload()',1000);
                    }\\\"\\>Remove All\\</a\\>
\\</td\\>
\\<td nowrap class=\\\"fbig pr\\\"\\>\\<a onclick=\\\"javascript: { 
                   var getip = prompt('Friend IP [port] ie: 192.168.0.1 4662','192.168.0.1 4662')
                   var reg = new RegExp (' ', 'gi') ;
                   var outstr = getip.replace(reg, '+');
                   parent.fstatus.location.href='/submit?q=afr+' + outstr;
                    setTimeout('window.location.reload()',1000);
                    }\\\"\\>Add by IP\\</a\\>
\\</td\\>
\\</tr\\>\\</table\\>
\\</td\\>\\</tr\\>
\\<tr\\>\\<td\\>";
		html_mods_table_header buf "friendsTable" "friends" [ 
		( "1", "srh", "Client number", "Num" ) ; 
		( "0", "srh", "Remove", "Remove" ) ; 
		( "0", "srh", "Network", "Network" ) ; 
		( "0", "srh", "Name", "Name" ) ; 
		( "0", "srh", "State", "State" ) ] ; 
        end;
        let counter = ref 0 in
        List.iter (fun c ->
            let i = client_info c in
            let n = network_find_by_num i.client_network in
            if use_html_mods o then 
              begin
                
                Printf.bprintf buf "\\<tr class=\\\"%s\\\" 
                onMouseOver=\\\"mOvr(this);\\\" 
                onMouseOut=\\\"mOut(this);\\\"\\>" 
                  (if (!counter mod 2 == 0) then "dl-1" else "dl-2");
                
                incr counter;
                Printf.bprintf buf "
			\\<td title=\\\"Client number\\\"
			onClick=\\\"location.href='/submit?q=files+%d'\\\" 
			class=\\\"srb\\\"\\>%d\\</td\\>            
			\\<td title=\\\"Remove friend\\\"
			onClick=\\\"parent.fstatus.location.href='/submit?q=friend_remove+%d'\\\" 
			class=\\\"srb\\\"\\>Remove\\</td\\>            
			\\<td title=\\\"Network\\\" class=\\\"sr\\\"\\>%s\\</td\\>            
			\\<td title=\\\"Name (click to view files)\\\"
			onClick=\\\"location.href='/submit?q=files+%d'\\\" 
			class=\\\"sr\\\"\\>%s\\</td\\>            
	 		\\<td title=\\\"Click to view files\\\"
            onClick=\\\"location.href='/submit?q=files+%d'\\\" 
            class=\\\"sr\\\"\\>%s\\</td\\>
			\\</tr\\>"
                  i.client_num
                  i.client_num
                  i.client_num
                  n.network_name
                  i.client_num
                  i.client_name
                  i.client_num
                  
                  (let rs = client_files c in
                  if (List.length rs) > 0 then Printf.sprintf "%d Files Listed" (List.length rs)
                  else string_of_connection_state (client_state c) )
              
              end
            
            else 
              Printf.bprintf buf "[%s %d] %s" n.network_name
                i.client_num i.client_name
        ) !!friends;
        
        if use_html_mods o then 
          Printf.bprintf buf " \\</table\\>\\</td\\>\\<tr\\>\\</table\\>\\</div\\>";
        
        ""
    ), ":\t\t\t\tdisplay all friends";
    
    "files", Arg_one (fun arg o ->
        let buf = o.conn_buf in
        let n = int_of_string arg in
        List.iter (fun c ->
            if client_num c = n then begin
                let rs = client_files c in
                
                let rs = List2.tail_map (fun (s, r) ->
                      r, CommonResult.result_info r, 1
                  ) rs in
                o.conn_user.ui_last_results <- [];
                Printf.bprintf buf "Reinitialising download selectors\n";
                DriverInteractive.print_results buf o rs;
                
                ()
              end
        ) !!friends;
        ""), "<client num> :\t\t\tprint files from friend <client num>";
    
    
    "bw_stats", Arg_multiple (fun args o -> 
        let buf = o.conn_buf in
        if use_html_mods o then 
          begin
            
            let refresh_delay = ref 11 in
            if args <> [] then begin 
                let newrd = int_of_string (List.hd args) in
                if newrd > 1 then refresh_delay := newrd;
              end; 
            Printf.bprintf buf "\\<meta http-equiv=\\\"refresh\\\" content=\\\"%d\\\"\\>" !refresh_delay;
            
            let dlkbs = 
              (( (float_of_int !udp_download_rate) +. (float_of_int !control_download_rate)) /. 1024.0) in
            let ulkbs =
              (( (float_of_int !udp_upload_rate) +. (float_of_int !control_upload_rate)) /. 1024.0) in
            
            Printf.bprintf buf "\\<div class=\\\"bw_stats\\\"\\>";
            Printf.bprintf buf "\\<table class=\\\"bw_stats\\\" cellspacing=0 cellpadding=0\\>\\<tr\\>";
            Printf.bprintf buf "\\<td\\>\\<table border=0 cellspacing=0 cellpadding=0\\>\\<tr\\>";

			html_mods_td buf [
			("Download KB/s (UDP|TCP)", "bu bbig bbig1 bb4", Printf.sprintf "Down: %.1f KB/s (%d|%d)" 
				dlkbs !udp_download_rate !control_download_rate);
			("Upload KB/s (UDP|TCP)", "bu bbig bbig1 bb4", Printf.sprintf "Up: %.1f KB/s (%d|%d)"
				ulkbs !udp_upload_rate !control_upload_rate);
			("Total shared bytes (files)", "bu bbig bbig1 bb3", Printf.sprintf "Shared: %s (%d files)"
				(size_of_int64 !upload_counter) !nshared_files) ];
            
            Printf.bprintf buf "\\</tr\\>\\</table\\>\\</td\\>\\</tr\\>\\</table\\>\\</div\\>";
            
            Printf.bprintf buf "\\<script language=\\\"JavaScript\\\"\\>window.parent.document.title='(D:%.1f) (U:%.1f) | %s'\\</script\\>"
              dlkbs ulkbs (CommonGlobals.version ())
          end
        else 
          Printf.bprintf buf "Down: %.1f KB/s ( %d + %d ) | Up: %.1f KB/s ( %d + %d ) | Shared: %d/%s"
            (( (float_of_int !udp_download_rate) +. (float_of_int !control_download_rate)) /. 1024.0)
          !udp_download_rate
            !control_download_rate
            (( (float_of_int !udp_upload_rate) +. (float_of_int !control_upload_rate)) /. 1024.0)
          !udp_upload_rate
            !control_upload_rate
            !nshared_files
            (size_of_int64 !upload_counter);
        ""
    ), ":\t\t\t\tprint current bandwidth stats";
    
    "mem_stats", Arg_none (fun o -> 
        let buf = o.conn_buf in
        Heap.print_memstats buf;
        ""
    ), ":\t\t\t\tprint memory stats";
    
    "rem", Arg_multiple (fun args o ->
        if args = ["all"] then begin
            servers =:= Intmap.empty;
            "Removed all servers"
          end else begin
            List.iter (fun num ->
                let num = int_of_string num in
                let s = server_find num in
                server_remove s
            ) args;
            Printf.sprintf "%d servers removed" (List.length args)
          end
    ), "<server numbers> :\t\t\tremove server (use arg 'all' for all servers)";
    
    "server_banner", Arg_one (fun num o ->
        let buf = o.conn_buf in
        let num = int_of_string num in
        let s = server_find num in
        (match server_state s with
            NotConnected _ -> ()
          | _ ->   server_banner s o);
        ""
    ), "<num> :\t\t\tprint banner of connected server <num>";
    
    "log", Arg_none (fun o ->
        let buf = o.conn_buf in
        (try
            while true do
              let s = Fifo.take lprintf_fifo in
              decr lprintf_size;
              Buffer.add_string buf s
            done
          with _ -> ());
        "------------- End of log"
    ), ":\t\t\t\t\tdump current log state to console";
    
    "ansi", Arg_one (fun arg o ->
        let buf = o.conn_buf in
        let b = bool_of_string arg in
        if b then begin
            o.conn_output <- ANSI;
          end else
          o.conn_output <- TEXT;        
        "$rdone$n"
    ), ":\t\t\t\t\ttoggle ansi terminal (devel)";
    
    "term", Arg_two (fun w h o ->
        let w = int_of_string w in
        let h = int_of_string h in
        o.conn_width <- w;
        o.conn_height <- h;
        "set"), 
    "<width> <height> :\t\t\tset terminal width and height (devel)";
    
    "stdout", Arg_one (fun arg o ->
        let buf = o.conn_buf in
        let b = bool_of_string arg in
        lprintf_to_stdout := b;
        Printf.sprintf "log to stdout %s" 
          (if b then "enabled" else "disabled")
    ), "<true|false> :\t\t\treactivate log to stdout";
    
    "debug_client", Arg_multiple (fun args o ->
        List.iter (fun arg ->
            let num = int_of_string arg in
            debug_clients := Intset.add num !debug_clients;
            (try let c = client_find num in client_debug c true with _ -> ())
        ) args;
        "done"
    ), "<client nums> :\t\tdebug message in communications with these clients";

    "debug_file", Arg_multiple (fun args o ->
        List.iter (fun arg ->
            let num = int_of_string arg in
            let file = file_find num in
            Printf.bprintf o.conn_buf
              "File %d:\n%s" num
              (file_debug file);
        ) args;
        "done"
    ), "<client nums> :\t\tdebug file state";
    
    "clear_debug", Arg_none (fun o ->
        
        Intset.iter (fun num ->
            try let c = client_find num in 
              client_debug c false with _ -> ()
        ) !debug_clients;
        debug_clients := Intset.empty;
        "done"
    ), ":\t\t\t\tclear the table of clients being debugged";
    
    "daemon", Arg_none (fun o ->
        if BasicSocket.has_threads () then
          "Cannot detach process after start, when running with threads"
        else begin
            MlUnix.detach_daemon ();
            "done"
          end
    ), ":\t\t\t\tdetach process from console and run in background";
    
    "log_file", Arg_one (fun arg o ->
        let oc = open_out arg in
        (match !lprintf_output with
            Some oc when oc != stdout -> close_out oc
          | _ -> ());
        lprintf_output := Some oc;
        lprintf_to_stdout := true;
        "log started"
    ), "<file> :\t\t\tstart logging in file <file>";
    
    "close_log", Arg_none (fun o ->
        (match !lprintf_output with
            None -> () | Some oc -> close_out oc);
        lprintf_output := None;
        lprintf_to_stdout := false;
        "log stopped"
    ), ":\t\t\t\tclose logging to file";
    
    "!", Arg_one (fun arg o ->
        let cmd = List.assoc arg !!allowed_commands in
        let tmp = Filename.temp_file "com" ".out" in
        let ret = Sys.command (Printf.sprintf "%s >& %s"
              cmd tmp) in
        let output = File.to_string tmp in
        Sys.remove tmp;
        Printf.sprintf "%s\n---------------- Exited with code %d" output ret 
    ), "<cmd> :\t\t\t\tstart command <cmd> (must be allowed in 'allowed_commands' option";
    
    "add_user", Arg_two (fun user pass o ->
        if o.conn_user = default_user then
          try
            let p = List.assoc user !!users in
            let pass = Md4.string pass in
(* In place replacement....heurk *)
            String.blit (Md4.direct_to_string pass) 0 
              (Md4.direct_to_string p) 0 16;
            "Password changed"
          with _ -> 
              users =:= (user, Md4.string pass) :: !!users;
              "User added"
        else
          "Only 'admin' is allowed to do that"
    ), "<user> <passwd> :\t\tadd a new mldonkey user";
    
    "calendar_add", Arg_two (fun hour action o ->
        calendar =:= ([0;1;2;3;4;5;6;7], [int_of_string hour], action)
        :: !!calendar;
        "action added"
    ), "<hour> \"<command>\" :\tadd a command to be executed every day";
    
    "rename", Arg_two (fun arg new_name o ->
        let num = int_of_string arg in
        try
          let file = file_find num in
          set_file_best_name file new_name;
          Printf.sprintf "Download %d renamed to %s" num new_name
        with _ -> Printf.sprintf "No file number %d" num
    ), "<num> \"<new name>\" :\t\tchange name of download <num> to <new name>";
    
    
    "dllink", Arg_multiple (fun args o ->        
        let buf = o.conn_buf in
        let url = String2.unsplit args ' ' in
        
        if not (networks_iter_until_true
              (fun n -> 
                try 
                  network_parse_url n url
                with e ->
                    Printf.bprintf buf "Exception %s for network %s\n"
                      (Printexc2.to_string e) (n.network_name);
                    false
            )) then
          "Unable to match URL"
        else
          "Done"
    ), "<ed2klink> :\t\t\tdownload ed2k:// link";
    
    "dllinks", Arg_one (fun arg o ->        
        let buf = o.conn_buf in
        
        let file = File.to_string arg in
        let lines = String2.split_simplify file '\n' in
        List.iter (fun line ->
            ignore (networks_iter_until_true (fun n -> 
                  network_parse_url n line))
        ) lines;
        "done"
    ), "<file> :\t\t\tdownload all the links contained in the file";
    
    
    "uploaders", Arg_none (fun o ->
        let buf = o.conn_buf in
        
        let nuploaders = Intmap.length !uploaders in 
        
        if use_html_mods o then
          
          begin
            
            let counter = ref 0 in
            
            Printf.bprintf buf "\\<div class=\\\"uploaders\\\"\\>Total upload slots: %d (%d) | Pending slots: %d\n" nuploaders
              (Fifo.length CommonUploads.upload_clients)
              (Intmap.length !CommonUploads.pending_slots_map);
            
            if nuploaders > 0 then
              
              begin
                
                html_mods_table_header buf "uploadersTable" "uploaders" [ 
                  ( "0", "srh", "Network", "Network" ) ; 
                  ( "0", "srh", "Connection type [I]ndirect [D]irect", "C" ) ;
                  ( "0", "srh", "Client name", "Client name" ) ;
                  ( "0", "srh", "IP address", "IP address" ) ;
                  ( "0", "srh", "Connected time (minutes)", "CT" ) ;
                  ( "0", "srh", "Client brand", "CB" ) ;
                  ( "0", "srh ar", "Total DL bytes from this client for all files", "DL" ) ;
                  ( "0", "srh ar", "Total UL bytes to this client for all files", "UL" ) ;
                  ( "0", "srh", "Filename", "Filename" ) ];
                
                List.iter (fun c ->
                    try
                      let i = client_info c in
                      if is_connected i.client_state then begin
                          incr counter;                        
                          
                          Printf.bprintf buf "\\<tr class=\\\"%s\\\" 
                        title=\\\"[%d] Add as friend (avg: %.1f KB/s)\\\"
                        onMouseOver=\\\"mOvr(this);\\\"
                        onMouseOut=\\\"mOut(this);\\\" 
                        onClick=\\\"parent.fstatus.location.href='/submit?q=friend_add+%d'\\\"\\>"
                        ( if (!counter mod 2 == 0) then "dl-1" else "dl-2";) (client_num c) 
						( float_of_int (Int64.to_int i.client_uploaded / 1024) /. 
 						  float_of_int (max 1 ((last_time ()) - i.client_connect_time)) )
						(client_num c);
                          
                        client_print_html c o;
						html_mods_td buf [
						("", "sr", (try (match i.client_kind with
                              Known_location (ip,_) -> Ip.to_string ip
                            | _ -> i.client_sock_addr)
                        	with _ -> "") );
						("", "sr", Printf.sprintf "%d" (((last_time ()) - i.client_connect_time) / 60));
						("", "sr", i.client_software);
						("", "sr ar", size_of_int64 i.client_downloaded);
						("", "sr ar", size_of_int64 i.client_uploaded);
						("", "sr", (match i.client_upload with
                         		     Some cu -> cu
                            		| None -> "") ) ];
                          
                        Printf.bprintf buf "\\</tr\\>"
                        end
                    with _ -> ()
                ) (List.sort 
                    (fun c1 c2 -> compare (client_num c1) (client_num c2))
                  (Intmap.to_list !uploaders));
                Printf.bprintf buf "\\</table\\>\\</div\\>";
              end;
            
            if !!html_mods_show_pending && Intmap.length !CommonUploads.pending_slots_map > 0 then
              
              begin
                Printf.bprintf buf "\\<br\\>\\<br\\>"; 
                html_mods_table_header buf "uploadersTable" "uploaders" [ 
                  ( "0", "srh", "Network", "Network" ) ; 
                  ( "0", "srh", "Connection type [I]ndirect [D]irect", "C" ) ;
                  ( "0", "srh", "Client name", "Client name" ) ;
                  ( "0", "srh", "Client brand", "CB" ) ;
                  ( "0", "srh ar", "Total DL bytes from this client for all files", "DL" ) ;
                  ( "0", "srh ar", "Total UL bytes to this client for all files", "UL" ) ;
                  ( "0", "srh", "IP address", "IP address" ) ];
                
                Intmap.iter (fun cnum c ->
                    
                    try 
                      let i = client_info c in
                      incr counter;
                      
					Printf.bprintf buf "\\<tr class=\\\"%s\\\" 
					title=\\\"Add as Friend\\\" onMouseOver=\\\"mOvr(this);\\\" onMouseOut=\\\"mOut(this);\\\" 
					onClick=\\\"parent.fstatus.location.href='/submit?q=friend_add+%d'\\\"\\>"
					( if (!counter mod 2 == 0) then "dl-1" else "dl-2";) cnum;
                      
					client_print_html c o;
					
					html_mods_td buf [
					("", "sr", i.client_software);
					("", "sr ar", size_of_int64 i.client_downloaded);
					("", "sr ar", size_of_int64 i.client_uploaded);
					("", "sr", (try (match i.client_kind with
                          		Known_location (ip,_) -> Ip.to_string ip
                          		| _ -> i.client_sock_addr)
                       			with _ -> "") ) ];
                      
					Printf.bprintf buf "\\</tr\\>";
					with _ -> ();
                
                ) !CommonUploads.pending_slots_map;
                Printf.bprintf buf "\\</table\\>\\</div\\>";
              
              end;
            
            Printf.bprintf buf "\\</div\\>";
            ""
          end
        else
          begin
            
            Intmap.iter (fun _ c ->
                try
                  let i = client_info c in
                  
                  client_print c o;
                  Printf.bprintf buf "client: %s downloaded: %s uploaded: %s\n" i.client_software (Int64.to_string i.client_downloaded) (Int64.to_string i.client_uploaded);
                  match i.client_upload with
                    Some cu ->
                      Printf.bprintf buf "      filename: %s\n" cu
                  | None -> ()
                with _ -> 
                   Printf.bprintf buf "no info on client %d\n" (client_num c )
            ) !uploaders;
            
            Printf.sprintf "Total upload slots: %d (%d) | Pending slots: %d\n" nuploaders
              (Fifo.length CommonUploads.upload_clients)
              (Intmap.length !CommonUploads.pending_slots_map);

            
          end
          
    
    ), ":\t\t\t\tshow users currently uploading";

    "nu", Arg_one (fun num o ->
        let buf = o.conn_buf in
        let num = int_of_string num in
        
        if num > 0 then (* we want to disable upload for a short time *)
          let num = mini !CommonUploads.upload_credit num in
          CommonUploads.has_upload := !CommonUploads.has_upload + num;
          CommonUploads.upload_credit := !CommonUploads.upload_credit - num;
          Printf.sprintf
            "upload disabled for %d minutes (remaining credits %d)" 
            !CommonUploads.has_upload !CommonUploads.upload_credit
        else
        
        if num < 0 && !CommonUploads.has_upload > 0 then
(* we want to restart upload probably *)
          let num = - num in
          let num = mini num !CommonUploads.has_upload in
          CommonUploads.has_upload := !CommonUploads.has_upload - num;
          CommonUploads.upload_credit := !CommonUploads.upload_credit + num;
          Printf.sprintf
            "upload disabled for %d minutes (remaining credits %d)" 
            !CommonUploads.has_upload !CommonUploads.upload_credit
        
        else ""
    ), "<m> :\t\t\t\tdisable upload during <m> minutes (multiple of 5)";

    "reload_messages", Arg_none (fun o ->
        CommonMessages.load_message_file ();
        "\\<script language=Javascript\\>top.window.location.reload();\\</script\\>"
    ), ":\t\t\treload messages file";
    
    ]

let _ =
  CommonNetwork.register_commands commands