(** This module parses and executes a room's effects.*)

(** [exec_effect jlist players p] is a copy of [players] updated according to 
    the effects [jlist] indicates when [p] enters its room. *)
val exec_effects: Yojson.Basic.t list -> Player.t array -> int -> Player.t array

(* ----------------------------------- *)

(** [tests] is a list of OUnit test cases for all functions in Tiles. *)
val tests : OUnit2.test list