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

(**[move_player d] returns a player identical to [player] but
   located in the tile in direction [d] relative to its current location *)
val move_player : Command.direction -> Player.t

(**[teleport tile] returns a player with the same attributes as [p] but located
   in [tile], regardless of whether or not [tile] is adjacent to the tile that
   the player is currently located in*)
(* val teleport : exit -> Player.t -> Player.t *)

(**[tests] returns a list of OUnit2 tests for the functions in state*)
val tests : OUnit2.test list