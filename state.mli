open Player
open Tiles

(**The abstract type for values representing a game state *)
type t

(**[from_json json] takes a json file and creates the initial game state*)
val from_json : Yojson.Basic.t -> t

(**[move_player player tile state] moves [player] to [tile], regardless
   of whether or not [tile] is accessible from [player]'s current location. 
   Throws [] if tile is not Tile of Room*)
val move_player : Player.t -> Rooms.t -> t -> t

(**[add_room room exit state] adds a room to the board from [exit] of [room].
   Throws [] if a room already exists through that exit. *)
val add_room : Rooms.t -> Tiles.exit -> t -> t