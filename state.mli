open Command
open Player
open Tiles

(**The abstract type for values representing a game state *)
type t

exception NonemptyTile

(**[from_json json] takes a json file and creates the initial game state*)
val from_json : Yojson.Basic.t -> t

(**[get_first_tile t] returns the upper left corner tile in [t] *)
val get_first_tile : t -> Tiles.t

(**[go_exit d p] returns a player with the same attributes as [p] but located
   in the tile through the exit [e] and if necessary updates the 
   board if the tile [t] through [e] is undiscoverd and applies any effects
   associated with the room located in [t]*)
val go_exit : exit -> Player.t -> Player.t

(**[move_player player room] returns a player identical to [player] but
   located in tile [tile], regardless
   of whether or not [tile] is adjacent to [player]'s current location but
   if and only if the tile contains a room. Throws [EmptyTile] if
   the tile does not contain a room. *)
val move_player : Command.direction -> Player.t

(**[tests] returns a list of OUnit2 tests for the functions in state*)
val tests : OUnit2.test list