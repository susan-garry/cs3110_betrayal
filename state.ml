open Yojson.Basic.Util

(**The abstract type for values representing a game state *)
type t = {first_tile : tile;
          x_dim: int;
          y_dim: int;
          deck : room list;
          players: player list;
         }

(**[add_room room exit state] adds a room to the board from [exit] of [room]*)
let add_room room exit state = failwith "Unimplemented"

(**[from_json json] takes a json file and creates the initial game state*)
let from_json json = {first_tile = }

(**[move_player player room state] moves [player] to [room], regardless
   of whether or not [room] is accessible from [player]'s current location *)
let move_player player room state = failwith "Unimplemented"

(**[next_turn player state] cycles through the players so that the current
   player's turn ends and the next player's turn begins*)
let next_turn player state = failwith "Unimplemented"
