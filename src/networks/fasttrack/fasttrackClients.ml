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



(*
SENDING REQUEST: GET FastTrack://62.175.4.76:2798/.hash=9c1e0c03f1a38ba838feaf4b8ac0d560b43bc148 HTTP/1.1\013\nHost: 62.175.4.76:2798\013\nUser-Agent: MLDonkey 2.4-1\013\nRange: bytes=0-262143\013\n\013\n
Asking 00000000000000000000000000000000 For Range 0-262143
Disconnected from source
CLIENT PARSE HEADER
HEADER FROM CLIENT:
ascii: [ H T T P / 1 . 0   5 0 1   N o t   I m p l e m e n t e d(10) X - K a z a a - U s e r n a m e :   r c b(13)(10) X - K a z a a - N e t w o r k :   K a Z a A(13)(10) X - K a z a a - I P :   1 6 8 . 2 2 6 . 1 1 2 . 1 3 5 : 1 9 5 9(13)(10) X - K a z a a - S u p e r n o d e I P :   2 0 0 . 7 5 . 2 2 9 . 2 1 2 : 1 2 1 4(13)(10)]


ascii: [ H T T P / 1 . 0   5 0 3   S e r v i c e   U n a v a i l a b l e(10) R e t r y - A f t e r :   2 8 4(13)(10) X - K a z a a - U s e r n a m e :   j o h n l(13)(10) X - K a z a a - N e t w o r k :   K a Z a A(13)(10) X - K a z a a - I P :   6 2 . 2 5 1 . 1 1 5 . 2 9 : 1 4 5 7(13)(10) X - K a z a a - S u p e r n o d e I P :   1 9 5 . 1 6 9 . 2 1 1 . 2 5 : 3 5 3 4(13)(10)]

  ascii: [ H T T P / 1 . 1   2 0 6   P a r t i a l   C o n t e n t(13)(10) C o n t e n t - R a n g e :   b y t e s   3 1 4 5 7 2 8 - 3 4 0 7 8 7 1 / 6 1 2 8 4 5 3(13)(10) C o n t e n t - L e n g t h :   2 6 2 1 4 4(13)(10) A c c e p t - R a n g e s :   b y t e s(13)(10) D a t e :   T h u ,   1 5   M a y   2 0 0 3   2 2 : 2 8 : 3 8   G M T(13)(10) S e r v e r :   K a z a a C l i e n t   N o v     3   2 0 0 2   2 0 : 2 9 : 0 3(13)(10) C o n n e c t i o n :   c l o s e(13)(10) L a s t - M o d i f i e d :   S a t ,   2 2   F e b   2 0 0 3   1 9 : 5 8 : 5 2   G M T(13)(10) X - K a z a a - U s e r n a m e :   d e f a u l t u s e r(13)(10) X - K a z a a - N e t w o r k :   K a Z a A(13)(10) X - K a z a a - I P :   2 1 2 . 8 . 7 4 . 2 4 : 1 2 1 4(13)(10) X - K a z a a - S u p e r n o d e I P :   1 9 3 . 2 0 4 . 3 4 . 2 1 4 : 2 0 9 3(13)(10) X - K a z a a T a g :   4 = A   s o l a s   c o n   m i   c o r a z o n(13)(10) X - K a z a a T a g :   6 = R o s a(13)(10) X - K a z a a T a g :   8 = R o s a(13)(10) X - K a z a a T a g :   1 4 = P o p(13)(10) X - K a z a a T a g :   1 = 2 0 0 2(13)(10) X - K a z a a T a g :   2 6 = h t t p : / / w w w . e l i t e m p 3 . n e t(13)(10) X - K a z a a T a g :   1 0 = e s(13)(10) X - K a z a a T a g :   1 2 = 1(186)   a l b u m   -   2 9 - 0 4 - 2 0 0 2(13)(10) X - K a z a a T a g :   5 = 3 8 6(13)(10) X - K a z a a T a g :   2 1 = 1 2 8(13)(10) X - K a z a a T a g :   3 = = q y W z R b 1 Q v n k 4 m t a B y t I M 1 i H Q u K 8 =(13)(10) C o n t e n t - T y p e :   a u d i o / m p e g(13)(10)(13)]

HTTP/1.1 206 Partial Content\n\nContent-Range: bytes 0-262143/3937679\n\nContent-Length: 262144\n\nAccept-Ranges: bytes\n\nDate: Thu, 15 May 2003 22:18:12 GMT\n\nServer: KazaaClient Nov  3 2002 20:29:03\n\nConnection: close\n\nLast-Modified: Mon, 05 May 2003 04:14:57 GMT\n\nX-Kazaa-Username: shaz2003\n\nX-Kazaa-Network: KaZaA\n\nX-Kazaa-IP: 81.103.29.119:3641\n\nX-Kazaa-SupernodeIP: 131.111.202.241:2674\n\nX-KazaaTag: 5=246\n\nX-KazaaTag: 21=128\n\nX-KazaaTag: 4=Fighter\n\nX-KazaaTag: 6=Christina Aguliera\n\nX-KazaaTag: 8=Stripped\n\nX-KazaaTag: 14=Other\n\nX-KazaaTag: 1=2002\n\nX-KazaaTag: 26=� christinas_eyedol 2002\n\nX-KazaaTag: 12=album version, stripped, fighter, real, christina, aguilera\n\nX-KazaaTag: 10=en\n\nX-KazaaTag: 18=Video Clip\n\nX-KazaaTag: 28=div3\n\nX-KazaaTag: 17=24\n\nX-KazaaTag: 9=241229701\n\nX-KazaaTag: 24=http://www.MusicInter.com\n\nX-KazaaTag: 3==kd8c6QgrXm0wvCYl5Uo0Aa9C7qg=\n\nContent-Type: audio/mpeg\n\n\n

  
*)
  
open CommonShared
open CommonUploads
open Printf2
open CommonOptions
open CommonDownloads
open Md4
open CommonInteractive
open CommonClient
open CommonComplexOptions
open CommonTypes
open CommonFile
open Options
open BasicSocket
open TcpBufferedSocket

open CommonGlobals
open CommonSwarming  
open FasttrackTypes
open FasttrackOptions
open FasttrackGlobals
open FasttrackComplexOptions

open FasttrackProtocol

let download_finished file = 
  file_completed (as_file file.file_file);
  FasttrackGlobals.remove_file file;
  old_files =:= (file.file_name, file_size file) :: !!old_files;
  List.iter (fun c ->
      c.client_downloads <- remove_download file c.client_downloads
  ) file.file_clients
  
let disconnect_client c =
  match c.client_sock with
  | Connection sock -> 
      (try
          if !verbose_msg_clients then begin
              lprintf "Disconnected from source\n"; 
            end;
          c.client_requests <- [];
          connection_failed c.client_connection_control;
          set_client_disconnected c;
          close sock "closed";
          c.client_sock <- NoConnection;
          if c.client_reconnect then
            Fifo.put reconnect_clients c
      with e -> 
          lprintf "Exception %s in disconnect_client\n"
            (Printexc2.to_string e))
  | _ -> ()

let max_range_size = Int64.of_int (1 * 1024 * 1024)
let min_range_size = Int64.of_int (256 * 1024)
  
let range_size file =
  let range =  file_size file // (Int64.of_int 10) in
  max (min range max_range_size) min_range_size

let max_queued_ranges = 1
  
let rec client_parse_header c gconn sock header = 
  if !verbose_msg_clients then begin
      lprintf "CLIENT PARSE HEADER\n"; 
    end;
  try
    set_lifetime sock 3600.;
    let d = 
      match c.client_requests with 
        [] -> failwith "No download request !!!"
      | d :: tail ->
          c.client_requests <- tail;
          d
    in
    connection_ok c.client_connection_control;
    set_client_state c Connected_initiating;    
    if !verbose_msg_clients then begin
        lprintf "HEADER FROM CLIENT:\n";
        AnyEndian.dump_ascii header; 
      end;
    let file = d.download_file in
    let size = file_size file in
    
    let endline_pos = String.index header '\n' in
    let http, code = 
      match String2.split (String.sub header 0 endline_pos
        ) ' ' with
      | http :: code :: ok :: _ -> 
          let code = int_of_string code in
          if not (String2.starts_with (String.lowercase http) "http") then
            failwith "Not in http protocol";
          http, code
      | _ -> failwith "Not a HTTP header line"
    in
    if !verbose_msg_clients then begin
        lprintf "GOOD HEADER FROM CONNECTED CLIENT\n";
      end;
    
    set_rtimeout sock 120.;
(*              lprintf "SPLIT HEADER...\n"; *)
    let lines = Http_client.split_header header in
(*              lprintf "REMOVE HEADLINE...\n"; *)
    let headers = match lines with
        [] -> raise Not_found        
      | _ :: headers -> headers
    in
(*                  lprintf "CUT HEADERS...\n"; *)
    let headers = Http_client.cut_headers headers in
(*                  lprintf "START POS...\n"; *)
    
    if  code < 200 || code > 299 then
      failwith "Bad HTTP code";
    
    
    let start_pos, end_pos = 
      try
        let (range,_) = List.assoc "content-range" headers in
        try
          let npos = (String.index range 'b')+6 in
          let dash_pos = try String.index range '-' with _ -> -10 in
          let slash_pos = try String.index range '/' with _ -> -20 in
          let star_pos = try String.index range '*' with _ -> -30 in
          if star_pos = slash_pos-1 then
            Int64.zero, size (* "bytes */X" *)
          else
          let x = Int64.of_string (
              String.sub range npos (dash_pos - npos) )
          in
          let len = String.length range in
          let y = Int64.of_string (
              String.sub range (dash_pos+1) (slash_pos - dash_pos - 1))
          in
          if slash_pos = star_pos - 1 then 
            x,y ++ Int64.one (* "bytes x-y/*" *)
          else
          let z = Int64.of_string (
              String.sub range (slash_pos+1) (len - slash_pos -1) )
          in
          if y = z then x -- Int64.one, size else 
            x,y ++ Int64.one
        with 
        | e ->
            lprintf "Exception %s for range [%s]\n" 
              (Printexc2.to_string e) range;
            raise e
      with e -> 
          try
            if code <> 206 then raise Not_found;
            let (len,_) = List.assoc "content-length" headers in
            let len = Int64.of_string len in
            lprintf "Specified length: %Ld\n" len;
            match d.download_ranges with
              [] -> raise Not_found
            | (start_pos,end_pos,r) :: _ -> 
                lprintf "WARNING: Assuming client is replying to range\n";
                if len <> end_pos -- start_pos then
                  begin
                    lprintf "\n\nERROR: bad computed range: %Ld-%Ld/%Ld \n%s\n"
                      start_pos end_pos len
                      (String.escaped header);
                    raise Not_found
                  end;
                (start_pos, end_pos)
          with _ -> 
(* A bit dangerous, no ??? *)
              lprintf "ERROR: Could not find/parse range header (exception %s), disconnect\nHEADER: %s\n" 
                (Printexc2.to_string e)
              (String.escaped header);
              disconnect_client c;
              raise Exit
    in 
    (try
        let (len,_) = List.assoc "content-length" headers in
        let len = Int64.of_string len in
        lprintf "Specified length: %Ld\n" len;
        if len <> end_pos -- start_pos then
          begin
            failwith "\n\nERROR: bad computed range: %Ld-%Ld/%Ld \n%s\n"
              start_pos end_pos len
              (String.escaped header);
          end
      with _ -> 
          lprintf "[WARNING]: no Content-Length field\n%s\n"
            (String.escaped header)
    );
    
    lprintf "Receiving range: %Ld-%Ld (len = %Ld)\n%s\n"    
      start_pos end_pos (end_pos -- start_pos)
    (String.escaped header)
    ;
    set_client_state c (Connected_downloading);
    let counter_pos = ref start_pos in
(* Send the next request !!! *)
    for i = 1 to max_queued_ranges do
      if List.length d.download_ranges <= max_queued_ranges then
        (try get_from_client sock c with _ -> ());
    done;
    gconn.gconn_handler <- Reader (fun gconn sock ->
        let b = TcpBufferedSocket.buf sock in
        let to_read = min (end_pos -- !counter_pos) 
          (Int64.of_int b.len) in
        (*
        lprintf "Reading: end_pos %Ld counter_pos %Ld len %d = to_read %Ld\n"
end_pos !counter_pos b.len to_read;
   *)
        let to_read_int = Int64.to_int to_read in
(*
  lprintf "CHUNK: %s\n" 
          (String.escaped (String.sub b.buf b.pos to_read_int)); *)
        let old_downloaded = 
          Int64Swarmer.downloaded file.file_swarmer in
        List.iter (fun (_,_,r) -> Int64Swarmer.free_range r) 
        d.download_ranges;
        
        Int64Swarmer.received file.file_swarmer
          !counter_pos b.buf b.pos to_read_int;
        c.client_reconnect <- true;
        List.iter (fun (_,_,r) ->
            Int64Swarmer.alloc_range r) d.download_ranges;
        let new_downloaded = 
          Int64Swarmer.downloaded file.file_swarmer in
        
        (match d.download_ranges with
            [] -> lprintf "EMPTY Ranges !!!\n"
          | r :: _ -> 
(*
              let (x,y) = Int64Swarmer.range_range r in
              lprintf "Received %Ld [%Ld] (%Ld-%Ld) -> %Ld\n"
                !counter_pos to_read
                x y 
                (new_downloaded -- old_downloaded)
*)        
              ()
        );
        
        if new_downloaded = file_size file then
          download_finished file;
        if new_downloaded <> old_downloaded then
          add_file_downloaded file.file_file
            (new_downloaded -- old_downloaded);
        (*
lprintf "READ %Ld\n" (new_downloaded -- old_downloaded);
lprintf "READ: buf_used %d\n" to_read_int;
  *)
        TcpBufferedSocket.buf_used sock to_read_int;
        counter_pos := !counter_pos ++ to_read;
        if !counter_pos = end_pos then begin
            match d.download_ranges with
              [] -> assert false
            | (_,_,r) :: tail ->
                (*
                lprintf "Ready for next chunk (version %s)\nHEADER:%s\n" http
                  (String.escaped header);
                *)
                Int64Swarmer.free_range r;
                d.download_ranges <- tail;
                gconn.gconn_handler <- HttpHeader
                  (client_parse_header c);
          end)
    
  with e ->
      lprintf "Exception %s in client_parse_header\n" (Printexc2.to_string e);
      AnyEndian.dump header;      
      disconnect_client c;
      raise e

and get_from_client sock (c: client) =
  match c.client_downloads with
    [] -> 
      if !verbose_msg_clients then
        lprintf "No other download to start\n";
      raise Not_found
  | d :: tail ->
      if !verbose_msg_clients then begin
          lprintf "FINDING ON CLIENT\n";
        end;
      let file = d.download_file in
      if !verbose_msg_clients then begin
          lprintf "FILE FOUND, ASKING\n";
        end;
      
      if !verbose_swarming then begin
          lprintf "Current download:\n  Current chunks: "; 
          List.iter (fun (x,y) -> lprintf "%Ld-%Ld " x y) d.download_chunks;
          lprintf "\n  Current ranges: ";
          List.iter (fun (x,y,r) ->
(*              let (x,y) = Int64Swarmer.range_range r               in *)
              lprintf "%Ld-%Ld " x y) d.download_ranges;
          lprintf "\n  Current blocks: ";
          List.iter (fun b -> Int64Swarmer.print_block b) d.download_blocks;
          lprintf "\n\nFinding Range: \n";
        end;
      let range = 
        try
          let rec iter () =
            match d.download_block with
              None -> 
                if !verbose_swarming then
                  lprintf "No block\n";
                let b = Int64Swarmer.get_block d.download_blocks in
                if !verbose_swarming then begin
                    lprintf "Block Found: "; Int64Swarmer.print_block b;
                  end;
                d.download_block <- Some b;
                iter ()
            | Some b ->
                if !verbose_swarming then begin
                    lprintf "Current Block: "; Int64Swarmer.print_block b;
                  end;
                try
                  let r = Int64Swarmer.find_range b 
                      d.download_chunks (List.map 
                        (fun (_,_,r) -> r)d.download_ranges)
                    (range_size file) in
                  let (x,y) = Int64Swarmer.range_range r in 
                  d.download_ranges <- d.download_ranges @ [x,y,r];
                  Int64Swarmer.alloc_range r;
                  Printf.sprintf "%Ld-%Ld" x (y -- Int64.one)
                with Not_found ->
                    if !verbose_swarming then 
                      lprintf "Could not find range in current block\n";
                    d.download_blocks <- List2.removeq b d.download_blocks;
                    d.download_block <- None;
                    iter ()
          in
          iter ()
        with Not_found -> 
            lprintf "Unable to get a block !!";
            raise Not_found
      in
      let buf = Buffer.create 100 in
      (match d.download_uri with
          FileByUrl url -> Printf.bprintf buf "GET %s HTTP/1.0\r\n" url
        | FileByIndex (index, name) -> 
            Printf.bprintf buf "GET /get/%d/%s HTTP/1.1\r\n" index
              name);
      (match c.client_host with
          None -> ()
        | Some (ip, port) ->
            Printf.bprintf buf "Host: %s:%d\r\n" 
              (Ip.to_string ip) port);
(*      Printf.bprintf buf "User-Agent: %s\r\n" user_agent; *)
      Printf.bprintf buf "X-Kazaa-Network: %s\r\n" network_name;
      Printf.bprintf buf "X-Kazaa-Username: %s\r\n" !!client_name;
(* fst_http_request_set_header (request, "Connection", "close"); *)
      Printf.bprintf buf "Range: bytes=%s\r\n" range;
      Printf.bprintf buf "\r\n";
      let s = Buffer.contents buf in
      if !verbose_msg_clients then
        lprintf "SENDING REQUEST: %s\n" (String.escaped s);
      write_string sock s;
      c.client_requests <- c.client_requests @ [d];
      if !verbose_msg_clients then 
        lprintf "Asking %s For Range %s\n" (Md4.to_string c.client_user.user_uid) 
        range

let init_client sock =
  TcpBufferedSocket.set_read_controler sock download_control;
  TcpBufferedSocket.set_write_controler sock upload_control;
  ()
  
let connect_client c =
  match c.client_sock with
  | Connection sock -> ()
  | ConnectionWaiting -> ()
  | ConnectionAborted -> c.client_sock <- ConnectionWaiting;
  | NoConnection ->
      add_pending_connection (fun _ ->
          match c.client_sock with
            ConnectionAborted -> c.client_sock <- NoConnection
          | Connection _ | NoConnection -> ()
          | _ ->
              try
                if !verbose_msg_clients then begin
                    lprintf "connect_client\n";
                  end;
                match c.client_user.user_kind with
                  Indirect_location _ -> ()
                | Known_location (ip, port) ->
                    if !verbose_msg_clients then begin
                        lprintf "connecting %s:%d\n" (Ip.to_string ip) port; 
                      end;
                    c.client_reconnect <- false;
                    let sock = connect "gnutella download" 
                        (Ip.to_inet_addr ip) port
                        (fun sock event ->
                          match event with
                            BASIC_EVENT (RTIMEOUT|LTIMEOUT) ->
                              disconnect_client c
                          | BASIC_EVENT (CLOSED _) ->
                              disconnect_client c
                          | _ -> ()
                      )
                    in
                    init_client sock;                
                    c.client_host <- Some (ip, port);
                    set_client_state c Connecting;
                    c.client_sock <- Connection sock;
                    TcpBufferedSocket.set_closer sock (fun _ _ ->
                        disconnect_client c
                    );
                    set_rtimeout sock 30.;
                    match c.client_downloads with
                      [] -> 
(* Here, we should probably browse the client or reply to
an upload request *)
                        
                        if !verbose_msg_clients then begin
                            lprintf "NOTHING TO DOWNLOAD FROM CLIENT\n";
                          end;
                        disconnect_client c;                
                        
                | d :: _ ->
                    if !verbose_msg_clients then begin
                        lprintf "READY TO DOWNLOAD FILE\n";
                      end;
                    
                    get_from_client sock c;
                    set_fasttrack_sock sock !verbose_msg_clients
                      (HttpHeader (client_parse_header c))
          
          with e ->
              lprintf "Exception %s while connecting to client\n" 
                (Printexc2.to_string e);
              disconnect_client c
      );
      c.client_sock <- ConnectionWaiting


let current_downloads = ref []

let push_handler cc gconn sock header = 
  if !verbose_msg_clients then begin
      lprintf "PUSH HEADER: [%s]\n" (String.escaped header);
    end;
  try
    let (ip, port) = TcpBufferedSocket.host sock in
    
    if String2.starts_with header "GIV" then begin
        if !verbose_msg_clients then begin    
            lprintf "PARSING GIV HEADER\n"; 
          end;
        let colon_pos = String.index header ':' in
        let slash_pos = String.index header '/' in
        let uid = Md4.of_string (String.sub header (colon_pos+1) 32) in
        let index = int_of_string (String.sub header 4 (colon_pos-4)) in
        if !verbose_msg_clients then begin
            lprintf "PARSED\n";
          end;
        let c = try
            Hashtbl.find clients_by_uid (Indirect_location ("", uid)) 
          with _ ->
              try
                Hashtbl.find clients_by_uid (Known_location (ip,port))
              with _ ->
                  new_client  (Indirect_location ("", uid)) 
        in
        c.client_host <- Some (ip, port);
        match c.client_sock with
        | Connection _ -> 
            if !verbose_msg_clients then begin
                lprintf "ALREADY CONNECTED\n"; 
              end;
            close sock "already connected";
            raise End_of_file
        | _ ->
            if !verbose_msg_clients then begin
                lprintf "NEW CONNECTION\n";
              end;
            cc := Some c;
            c.client_sock <- Connection sock;
            connection_ok c.client_connection_control;
            try
              if !verbose_msg_clients then begin
                  lprintf "FINDING FILE %d\n" index; 
                end;
              let d = find_download_by_index index c.client_downloads in
              if !verbose_msg_clients then begin
                  lprintf "FILE FOUND\n";
                end;
              
              c.client_downloads <- d :: (List2.removeq d c.client_downloads);
              get_from_client sock c;
              gconn.gconn_handler <- HttpHeader (client_parse_header c)
            with e ->
                lprintf "Exception %s during client connection\n"
                  (Printexc2.to_string e);
                disconnect_client c;
                raise End_of_file
      end
    else begin
(*        lprintf "parse_head\n";    *)
        let r = Http_server.parse_head (header ^ "\n") in
        let url = r.Http_server.get_url in
        lprintf "Header parsed: %s ... %s\n"
          (r.Http_server.request) (url.Url.file);
(* "/get/num/filename" *)
        assert (r.Http_server.request = "GET");
        
(* First of all, can we accept this request ???? *)
        
        let rec iter list rem =
          match list with 
            [] ->
              if List.length rem >= !!max_available_slots then
                failwith "All Slots Used";
              sock :: rem
          | s :: tail ->
              if s == sock then list @ rem
              else
              if closed sock then
                iter tail rem
              else
                iter tail (s :: rem)
        in
        current_downloads := iter !current_downloads [];
        let file = url.Url.file in                    
        let sh = 
          if file = "/uri-res/N2R" then
            match url.Url.args with
              [(urn,_)] ->
                lprintf "Found /uri-res/N2R request\n";
                Hashtbl.find shareds_by_uid urn
                
            | _ -> failwith "Cannot parse /uri-res/N2R request"
          else
          let get = String.lowercase (String.sub file 0 5) in
          assert (get = "/get/");
          let pos = String.index_from file 5 '/' in
          let num = String.sub file 5 (pos - 5) in
          let filename = String.sub file (pos+1) (String.length file - pos - 1) in
          lprintf "Download of file %s, filename = %s\n" num filename;
          let num = int_of_string num in
          lprintf "Download of file %d, filename = %s\n" num filename;
          CommonUploads.find_by_num num
        in

(*
BUG:
  * check whether a range is requested, and we need to
  * to send a correct reply
*)
        let no_range = Int64.zero, sh.shared_size in
        let chunk_pos, chunk_end = 
          try
            let range, _, _ = List.assoc "Range" r.Http_server.headers in
            match parse_range range with
              x, None, _ -> x, sh.shared_size
            | x, Some y, Some z ->
                if y = z then (* some vendor bug *)
                  x -- Int64.one, y
                else
                  x, y ++ Int64.one
            | x, Some y, None ->
                x, y ++ Int64.one
          with _ -> no_range
        in
        let uc = {
            uc_sock = sock;
            uc_file = sh;
(* BUG: parse the range header *)
            uc_chunk_pos = chunk_pos;
            uc_chunk_len = chunk_end -- chunk_pos;
            uc_chunk_end = chunk_end;
          } in
        let header_sent = ref false in
        
        let impl = sh.shared_impl in
        impl.impl_shared_requests <- impl.impl_shared_requests + 1;
        shared_must_update_downloaded (as_shared impl);
        
        let rec refill sock =
          lprintf "refill called\n";
          if uc.uc_chunk_pos = uc.uc_chunk_end then begin
              match gconn.gconn_refill with
                []  -> ()
              | [_] -> gconn.gconn_refill <- []
              | _ :: ((refill :: _ ) as tail) -> 
                  gconn.gconn_refill <- tail;
                  refill sock
            end else
          if not !header_sent then begin
(* BUG: send the header *)
              let buf = Buffer.create 100 in
              Printf.bprintf buf "HTTP/1.1 200 OK\r\n";
              Printf.bprintf buf "Server: %s\r\n" user_agent;
              Printf.bprintf buf "Content-type:application/binary\r\n";
              Printf.bprintf buf "Content-length: %Ld\r\n" uc.uc_chunk_len;
              if (chunk_pos, chunk_end) <> no_range then begin
                  Printf.bprintf buf "Accept-Ranges: bytes\r\n";
                  Printf.bprintf buf "Content-range: bytes=%Ld-%Ld/%Ld\r\n"
                    chunk_pos (uc.uc_chunk_end -- Int64.one)
                  sh.shared_size;
                end;
              Buffer.add_string buf "\r\n";
              let s = Buffer.contents buf in
              TcpBufferedSocket.write_string sock s;
              lprintf "Sending Header:\n";
              AnyEndian.dump s;
              lprint_newline ();
              header_sent:=true;
            end;
          let len = remaining_to_write sock in
          let can = maxi (8192 - len) 0 in
          let slen = sh.shared_size in
          let pos = uc.uc_chunk_pos in
          if pos < uc.uc_chunk_end && can > 0 then
            let rlen = 
              let rem = slen --  pos in
              if rem > Int64.of_int can then can else Int64.to_int rem
            in
            let upload_buffer = String.create rlen in
            Unix32.read sh.shared_fd pos upload_buffer 0 rlen;
            TcpBufferedSocket.write sock upload_buffer 0 rlen;
            
            let impl = sh.shared_impl in
            impl.impl_shared_uploaded <- 
              impl.impl_shared_uploaded ++ (Int64.of_int rlen);
            shared_must_update_downloaded (as_shared impl);

            uc.uc_chunk_pos <- uc.uc_chunk_pos ++ (Int64.of_int rlen);
            if remaining_to_write sock = 0 then refill sock
        in
        gconn.gconn_refill <- refill :: gconn.gconn_refill;
        match gconn.gconn_refill with
          refill :: tail ->
(* First refill handler, must be called immediatly *)
            refill sock
        | _ -> (* Already a refill handler, wait for it to finish its job *)
            ()
      end
  with e ->
      lprintf "Exception %s in push_handler: %s\n" (Printexc2.to_string e)
      (String.escaped header);
      (match !cc with Some c -> disconnect_client c | _ -> ());
      raise e

      (*
let client_parse_header2 c sock header = 
    match !c with
    Some c ->
      client_parse_header c sock header
  | _ -> assert false
      

let client_reader2 c sock nread = 
  match !c with
    None -> assert false
  | Some c ->
      match c.client_file with
        None -> assert false
      | Some d ->
          Download.download_reader d sock nread
            *)

let listen () =
  try
    let sock = TcpServerSocket.create "gnutella client server" 
        Unix.inet_addr_any
        !!client_port
        (fun sock event ->
          match event with
            TcpServerSocket.CONNECTION (s, 
              Unix.ADDR_INET(from_ip, from_port)) ->
              lprintf "CONNECTION RECEIVED FROM %s FOR PUSH\n"
                (Ip.to_string (Ip.of_inet_addr from_ip))
              ; 
              
              lprintf "*********** CONNECTION ***********\n";
              let sock = TcpBufferedSocket.create
                  "gnutella client connection" s 
                  (fun sock event -> 
                    match event with
                      BASIC_EVENT (RTIMEOUT|LTIMEOUT) -> close sock "timeout"
                    | _ -> ()
                )
              in
              TcpBufferedSocket.set_read_controler sock download_control;
              TcpBufferedSocket.set_write_controler sock upload_control;

              let c = ref None in
              TcpBufferedSocket.set_closer sock (fun _ s ->
                  match !c with
                    Some c ->  disconnect_client c
                  | None -> ()
              );
              BasicSocket.set_rtimeout (TcpBufferedSocket.sock sock) 30.;
              set_fasttrack_sock sock !verbose_msg_clients
                (HttpHeader (push_handler c));
          | _ -> ()
      ) in
    listen_sock := Some sock;
    ()
  with e ->
      lprintf "Exception %s while init gnutella server\n" 
        (Printexc2.to_string e)
    
