(**************************************************************************)
(*  Copyright 2003, 2002 b8_bavard, b8_zoggy, , b52_simon INRIA            *)
(*                                                                        *)
(*    This file is part of mldonkey.                                      *)
(*                                                                        *)
(*    mldonkey is free software; you can redistribute it and/or modify    *)
(*    it under the terms of the GNU General Public License as published   *)
(*    by the Free Software Foundation; either version 2 of the License,   *)
(*    or (at your option) any later version.                              *)
(*                                                                        *)
(*    mldonkey is distributed in the hope that it will be useful,         *)
(*    but WITHOUT ANY WARRANTY; without even the implied warranty of      *)
(*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the       *)
(*    GNU General Public License for more details.                        *)
(*                                                                        *)
(*    You should have received a copy of the GNU General Public License   *)
(*    along with mldonkey; if not, write to the Free Software             *)
(*    Foundation, Inc., 59 Temple Place, Suite 330, Boston,               *)
(*    MA  02111-1307  USA                                                 *)
(*                                                                        *)
(**************************************************************************)

(** A class for the state. *)

open Printf2
open Chat_types
open Chat_proto

let (!!) = Chat_options.(!!)


class data pred (conf : Chat_config.config) (com : Chat_proto.com) =
  object(self)
    val mutable people = ([] : (id * host * port * state * bool) list)
	(** list of known people : 
	   id * host * port * connected/not_connected * temporary or friend *)

    method people = people

    val mutable rooms = ([] : (id * ((id * host * port) list) * bool) list)
	(** list of known rooms : id * temporary or not *)

    method rooms = rooms

    method pred = pred

    (** merge current people list with [conf#people].*)
    method update_people =
      let l = conf#people in
      let rec iter = function
	  [] -> []
	| (id,host,port,s,t) :: q ->
	    let b = List.exists (pred (id,host,port)) l in
	    (id,host,port,s,not b) :: (iter q)
      in
      let l2 = iter people in
      let rec iter2 = function
	  [] -> []
	| (id,host,port) :: q ->
	    if List.exists 
		(fun(i,h,p,_,_) -> pred (id,host,port) (i,h,p))
		l2
	    then iter2 q
	    else (id,host,port,Not_connected,false) :: (iter2 q)
      in
      people <- l2 @ (iter2 l)

    method set_connected id host port =
      let rec iter = function
	  [] -> [id, host, port, Connected, true]
	| ((i,h,p,s,t) as a) :: q ->
	    if pred (id,host,port) (i,h,p) then
	      (id,h,port,Connected,t) :: q
	    else
	      a :: (iter q)
      in
      people <- iter people

    method set_not_connected id host port =
      let rec iter = function
	  [] -> []
	| ((i,h,p,s,t) as a) :: q ->
	    if pred (id,host,port) (i,h,p) then
	      (id,h,port,Not_connected,t) :: q
	    else
	      a :: (iter q)
      in
      people <- iter people

    method print_people =
      List.iter
	(fun (i,h,p,_,_) -> 
	  lprintf "%s@%s\n:%d\n" i h p)
	people
			   

    method add_people id host port =
      if List.exists (pred (id,host,port)) conf#people
      then
	()
      else
	(
	 let rec iter = function
	     [] -> [id,host,port,Not_connected,false]
	   | ((i,h,p,s,t) as a) :: q ->
	       if pred (id,host,port) (i,h,p) then
		 (id,h,port,s,false) :: q
	       else
		 a :: (iter q)
	 in
	 people <- iter people;
	 conf#set_people (conf#people @ [id,host,port]);
	 conf#save
	)

    method remove_people ?(kill=false) id host port =
      let rec iter = function
	  [] -> []
	| ((i,h,p,s,t) as a) :: q ->
	    if pred (id,host,port) (i,h,p) then
	      if kill then 
		iter q 
	      else
		(id,h,port,s,true) :: (iter q)
	    else
	      a :: (iter q)
      in
      people <- iter people;
      conf#set_people
	(List.filter (fun (i,h,p) -> not (pred (i, h, p) (id, host, port))) conf#people);
      conf#save

    (** get all information on the given people. *)
    method get_complete_people id host port =
      try 
	List.find
	  (fun (i,h,p,_,_) -> 
	    pred (id,host,port) (i,h,p))
	  people
      with Not_found -> (id,host,port,Not_connected,true)


    method com = com
    method conf = conf

    initializer
      people <- List.map (fun (i,h,p) -> (i,h,p,Not_connected,false)) 
	  conf#people
  end