(** This module parses and executes a room's effects.*)

(** [exec_effect json players p] is a copy of [players] with stats updated
    according to the effect [json] indicates when [p] enters its room. *)
val exec_effect: Yojson.Basic.t -> Player.t array -> Player.t -> Player.t array

(* ----------------------------------- *)

(** [tests] is a list of OUnit test cases for all functions in Tiles. *)
val tests : OUnit2.test list