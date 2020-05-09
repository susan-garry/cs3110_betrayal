(** This module parses and executes a room's effects.

    @author: Primary author Isabel Selin, is389. *)

(** The type of player lists *)
type p_list = Player.t option array

(** [exec_effect jlist players p] is a copy of [players] updated according to 
    the effects [jlist] indicates when [p] enters its room. *)
val exec_effects: Yojson.Basic.t list -> p_list * int -> p_list * int

(**
    EFFECT DEFINITIONS:

    nothing
    Effect: nothing happens to any players
*)

(* ----------------------------------- *)

(** [tests] is a list of OUnit test cases for all functions in Tiles. *)
val tests : OUnit2.test list