open Command
open Player
open Tiles

(**The abstract type for values representing a game state *)
type t

exception NonemptyTile
exception NoDoor

(**[from_json json] takes a json file and creates the initial game state*)
val from_json : Yojson.Basic.t -> t

(**[get_first_tile t] returns the upper left corner tile in [t] *)
val first_tile : t -> Tiles.t

(**[room_id st] returns the name of the room occupied by the player who is 
   currently in play. 
   Raises EmptyTile if that tile is empty. *)
val room_id : t -> string

(**[get_room_descr st] returns the description of the room occupied by the
   player who is currently in play. 
   Raises EmptyTile if that tile is empty. *)
val room_desc : t -> string

(**[player_name st] returns the name of the player who is currently in play *)
val player_name : t -> string

(**[player_id st] returns the id of the player who is currently in play *)
val player_desc : t -> string

(**[get_locs st] returns an association list of tile coordinates and 
   player lists, where a tile coordinate maps to a list of the players contained
   within it if there is at least one player inside of that room; otherwise it
   has no binding in the association list. *)
val get_locs : t -> (Tiles.coord * int list) list

(**[move_player d st] returns a state identical to [st] but with the player
   currently in play located in the tile in direction [d] relative to its 
   current location and the next player in the play order in play *)
val move_player : Command.direction -> t -> t

(**[teleport tile] returns a player with the same attributes as [p] but located
   in [tile], regardless of whether or not [tile] is adjacent to the tile that
   the player is currently located in*)
(* val teleport : exit -> Player.t -> Player.t *)

(**[tests] returns a list of OUnit2 tests for the functions in state*)
val tests : OUnit2.test list