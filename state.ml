open Rooms
open Tiles
open Player

open Yojson.Basic.Util

(**The abstract type for values representing a game state *)
type t = {x_dim : int;
          y_dim : int;
          deck  : Rooms.t list;
          players: Player.t list;
         }

let create_deck deck =
  deck |> to_list |> List.map Rooms.from_json

(**[from_json json] takes a json file and creates the initial game state*)
let from_json json = { x_dim = 3;
                       y_dim = 3;
                       deck = json |> member "deck" |> create_deck;
                       players = []
                     }

(**[add_room room exit state] adds a room to the board from [exit] of [room]*)
let add_room room exit state = failwith "Unimplemented"

(**[move_player player room state] moves [player] to [room], regardless
   of whether or not [room] is accessible from [player]'s current location *)
let move_player player room state = failwith "Unimplemented"

(**[next_turn player state] cycles through the players so that the current
   player's turn ends and the next player's turn begins*)
let next_turn player state = failwith "Unimplemented"
