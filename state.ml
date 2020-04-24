open Rooms
open Tiles
open Player
open OUnit2

open Yojson.Basic.Util

(**The abstract type for values representing a game state *)
type t = {first_tile: Tiles.t;
          x_dim : int;
          y_dim : int;
          deck  : Rooms.t list;
          player : Player.t;
         }

exception NonemptyTile

type dir = North | South | East | West

(** [create_deck deck] returns a Rooms.t list containing all of the rooms that
    it is possible to access during the game*)
let create_deck deck =
  deck |> to_list |> List.map Rooms.from_json

(**[dir_char d] returns the character associated with that direction *)
let dir_char = function
  |North -> 'N'
  |South -> 'S'
  |East -> 'E'
  |West -> 'W'

(**[start_coord s] returns the coordinates of the first room in [s]*)
let first_coord s = s.first_tile |> get_coords

(** [add_row d t s] returns a [state] with the new appropriate start tile and
    alters the exits of other tiles on the board
    to reference a new row of tiles in direction [d] if and only if the exit 
    from [t] leading towards direction [d] is Nonexistent *)
let add_row (d:dir) (t:Tiles.t) (s:t): t = 
  let t2 = Tiles.new_tile t (dir_char d) in 
  let rec add_mult e t acc num =
    if acc = num then t
    else add_mult e (Tiles.new_tile t e) (acc+1) num
  in 
  match d with
  |North | South -> 
    let r_x_coord = t2 |> Tiles.get_coords |> fst in
    let f_x_coord = s |> first_coord |> fst in
    ignore (add_mult 'W' t2 0 (r_x_coord - f_x_coord));
    if d = North then
      (ignore (add_mult 'E' t2 0 (f_x_coord + s.x_dim - r_x_coord));
       {s with y_dim = s.y_dim + 1})
    else  {s with 
           first_tile = add_mult 'E' t2 0 (f_x_coord + s.x_dim - r_x_coord);
           y_dim = s.y_dim + 1}
  |East | West ->
    let r_y_coord = t2 |> Tiles.get_coords |> snd in
    let f_y_coord = s |> first_coord |> snd in
    ignore (add_mult 'S' t2 0 (f_y_coord + s.y_dim - r_y_coord));
    if d = East then
      (ignore (add_mult 'N' t2 0 (r_y_coord - f_y_coord));
       {s with x_dim = s.x_dim + 1})
    else 
      {s with 
       first_tile = add_mult 'N' t2 0 (r_y_coord - f_y_coord);
       x_dim = s.x_dim + 1}

(**[from_json json] takes a json file and creates the initial game state*)
let from_json json = { 
  first_tile = json |> member "start_room" |> Rooms.from_json 
               |> Tiles.fill_tile Tiles.empty;
  x_dim = 3;
  y_dim = 3;
  deck = json |> member "deck" |> create_deck;
  player = Player.empty
}

let get_first_tile s = s.first_tile

(**[add_room room exit] adds [room] to the tile through [exit] if there is
   not already a room in that tile.
   Raises [NonemptyTile] exception if a room already exists. *)
let add_room room exit =
  match exit with
  |(Nonexistent, Some(t)) |(Undiscovered, Some(t)) -> Tiles.fill_tile t room
  |(Discovered,_)  -> raise NonemptyTile
  | _ -> failwith "Cannot add a room if there is no tile"

let move_player tile player = 
  match Tiles.get_room tile with
  |None -> raise EmptyTile
  |Some r -> Player.move tile player

(**[next_turn player state] cycles through the players so that the current
   player's turn ends and the next player's turn begins*)
let next_player player state =
  {state with player = Player.get_next player}

let move_player exit =
  failwith "Unimplemented"

(* ------------------------------------------------- *)
(* CODE FOR TESTING *)

let get_first_tile_test 
    (name : string)
    (state: t)
    (ex : Tiles.t) =
  name >:: (fun _ -> 
      assert_equal ex (get_first_tile state))

let tests = []