open Tiles

open OUnit2

type t

type player_id = int
type player_name = string
type stat = int

exception LastPlayer

(**[empty] returns a bare-bones player with minimum attributes*)
val empty : t

(**[move p t] returns a player identical to [p] but located in [t]*)
val move : Tiles.t -> t -> t

(**[get_name p] returns the name of [p]*)
val get_name : t -> player_name

(**[set_id n p] returns a player identical to [p] but whose name is [n]*)
val set_name : player_name -> t -> t

(**[player_location p] returns the tile where [player] is currently located*)
val get_loc : t -> Tiles.t

(**[tests] returns the list of test cases for the Player module *)
val tests : OUnit2.test list
