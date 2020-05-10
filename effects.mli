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
    Effect: nothing happens to any players.
    Use: rooms with no stat change or abnormal turn alteration.

    next
    Effect: cycles to the next player's turn.
    Use: all rooms when turns aren't repeated or skipped.
    WARNING: rooms will not cycle to the next player without this effect.

    repeat
    Effect: gives the current player another turn

    skip
    Effect: skips the next player's turn

    automatic
    Effect: Automatically changes the current player's and/or a random other 
        player's stats
    Param "self changes": the int list of changes to the current player's stats
        in order of [strength, hunger, sanity, insight]. A zero indicates no 
        change.
    Param "other changes": an optional int list of changes to a ranom other
        player's stats. The same rules apply as for "self changes"

    choice
    Effect: Prompts the player to make a choice (yes or no), then carries out
        stat changes if yes.
    Param "choice": the string to print before the choice is made
    Param "result": the string to print after the player chooses yes
    Param "self changes": see automatic effect
    Param "other changes": see automatic effect
*)

(* ----------------------------------- *)

(** [tests] is a list of OUnit test cases for all functions in Tiles. *)
val tests : OUnit2.test list