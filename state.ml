open Rooms
open Tiles
open Player

open Yojson.Basic.Util

(**The abstract type for values representing a game state *)
type t = {first_room: Tiles.t;
          x_dim : int;
          y_dim : int;
          deck  : Rooms.t list;
          players: Player.t list;
         }

type dir = North | South | East | West

(** [create_deck deck] returns a Rooms.t list containing all of the rooms that
    it is possible to access during the game*)
let create_deck deck =
  deck |> to_list |> List.map Rooms.from_json

(** [add_row d t] returns a tile identical to t except with a new row of tiles 
    adjacent in direction [d] if and only if the exit from [t] leading towards
    direction [d] is Nonexistent *)
let add_row (d:dir) (t:Tiles.t) : Tiles.t = 
  let e =
    match d with
    | North -> Tiles.get_n t
    | South -> Tiles.get_s t
    | East -> Tiles.get_e t
    | West -> Tiles.get_w t
  in if (e <> Tiles.Nonexistent None) then t else 
    let repeat_add d t acc stop =
      if acc = stop then Tiles.new_tile t d
      else Tiles.new_tile (Tiles.new_tile t d) d

(**[from_json json] takes a json file and creates the initial game state*)
let from_json json = { 
  first_room = json |> member "start_room" |> Rooms.from_json 
               |> Tiles.from_room Tiles.empty;
  x_dim = 3;
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
