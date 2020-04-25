open Tiles

open OUnit2

type t

type player_id = string

exception LastPlayer

(**[empty] returns a bare-bones player with minimum attributes*)
val empty : t

(**[move p t] returns a player identical to [p] but located in [t]*)
val move : Tiles.t -> t -> t

(**[player_id p] returns the id of [p]*)
val player_id : t -> player_id

(**[player_location p] returns the tile where [player] is currently located*)
val player_loc : t -> Tiles.t

(**[get_next p] returns the next player in the turn lineup.
   Raises LastPlayer if p is the last player in the lineup. *)
val get_next : t -> t

(**[tests] returns the list of test cases for the Player module *)
val tests : OUnit2.test list
