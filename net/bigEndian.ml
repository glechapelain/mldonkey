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

open Int32ops
  
let const_int32_255 = Int32.of_int 255

(* int 8 bits *)
  
let buf_int32_8 buf i =
  Buffer.add_char buf (char_of_int (Int32.to_int (
        Int32.logand i const_int32_255)))
      
let get_int32_8 s pos =
  Int32.of_int (int_of_char s.[pos])

let buf_int8 buf i =
  Buffer.add_char buf (char_of_int (i land 255))

let get_int8 s pos = 
  int_of_char s.[pos]

(* int 16 bits *)
  
let buf_int16 buf i =
  Buffer.add_char buf (char_of_int (i land 255));
  Buffer.add_char buf (char_of_int ((i land 65535) lsr 8))

let str_int16 s pos i =
  s.[pos] <- char_of_int (i land 255);
  s.[pos+1] <- char_of_int ((i lsr 8) land 255)

let get_int16 s pos =
  let c1 = int_of_char s.[pos] in
  let c2 = int_of_char s.[pos+1] in
  c1 + c2 * 256

(* int 32 bits *)
  
let buf_int32_32 oc i =
  buf_int32_8 oc i;
  buf_int32_8 oc (right32 i  8);
  buf_int32_8 oc (right32 i  16);
  buf_int32_8 oc (right32 i  24)

let get_int32_32 s pos = 
  let c1 = get_int32_8 s pos in
  let c2 = get_int32_8 s (pos+1) in
  let c3 = get_int32_8 s (pos+2) in
  let c4 = get_int32_8 s (pos+3) in
  c1 +. (left32 c2 8) +. (left32 c3 16) +. (left32 c4 24)           

  
(* int 31 bits *)
  
let buf_int buf i = 
  buf_int8 buf i;
  buf_int8 buf (i lsr 8);
  buf_int8 buf (i lsr 16);
  buf_int8 buf (i lsr 24)

let str_int s pos i =
  s.[pos] <- char_of_int (i land 255);
  s.[pos+1] <- char_of_int ((i lsr 8) land 255);
  s.[pos+2] <- char_of_int ((i lsr 16) land 255);
  s.[pos+3] <- char_of_int ((i lsr 24) land 255)

let get_int s pos =
  Int32.to_int (get_int32_32 s pos)

(* IP addresses *)
  
let get_ip s pos =
  let c1 = int_of_char s.[pos] in
  let c2 = int_of_char s.[pos+1] in
  let c3 = int_of_char s.[pos+2] in
  let c4 = int_of_char s.[pos+3] in
  Ip.of_ints (c1, c2, c3, c4)

let buf_ip buf ip =
  let (ip0,ip1,ip2,ip3) = Ip.to_ints ip in
  buf_int8 buf ip0;
  buf_int8 buf ip1;
  buf_int8 buf ip2;
  buf_int8 buf ip3

(* md4 *)
  
let buf_md4 buf s = Buffer.add_string buf (Md4.direct_to_string s)

let get_md4 s pos =
  try Md4.direct_of_string (String.sub s pos 16)  with e ->
      Printf.printf "exception in get_md4 %d" pos; print_newline ();
      raise e

      
let dump s =
  let len = String.length s in
  Printf.printf "ascii: [";
  for i = 0 to len - 1 do
    let c = s.[i] in
    let n = int_of_char c in
    if n > 31 && n < 127 then
      Printf.printf " %c" c
    else
      Printf.printf "(%d)" n
  done;
  Printf.printf "]\n";
  Printf.printf "dec: [";
  for i = 0 to len - 1 do
    let c = s.[i] in
    let n = int_of_char c in
    Printf.printf "(%d)" n            
  done;
  Printf.printf "]\n"

let dump_sub s pos len =
  Printf.printf "dec: [";
  for i = 0 to len - 1 do
    let c = s.[pos+i] in
    let n = int_of_char c in
    Printf.printf "(%d)" n            
  done;
  Printf.printf "]\n";
  print_newline ()