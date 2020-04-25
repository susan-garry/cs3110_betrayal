open Command
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
          first_player : Player.t;
          player : Player.t;
         }

exception EmptyTile
exception NonemptyTile
exception NoDoor

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
let from_json json = 
  let start_tile = json |> member "start room" |> Rooms.from_json 
                   |> Tiles.fill_tile Tiles.empty
  in
  let p = Player.move start_tile Player.empty in
  let s' = { 
    first_tile = start_tile;
    x_dim = 3;
    y_dim = 3;
    deck = json |> member "deck" |> create_deck;
    first_player = p;
    player = p
  }
  in s' |> add_row South s'.first_tile |> add_row East s'.first_tile 
     |> add_row West s'.first_tile |> add_row North s'.first_tile

let first_tile s = s.first_tile

let room_id s =
  match Tiles.get_room s.first_tile with 
  |Some r -> Rooms.room_id r
  |None -> raise EmptyTile

let room_desc s = 
  match s.player |> get_loc |> Tiles.get_room with 
  |Some r -> Rooms.room_desc r
  |None -> raise EmptyTile

let player_id s = Player.get_id s.player

let player_name s = Player.get_name s.player

(**[next_player state] returns a state where the player is 
   the player who's turn begins after the current player's turn ends *)
let next_player state =
  let p =
    match Player.get_next state.player with 
    |Some p' -> p'
    |None -> state.first_player
  in
  {state with player = p}

let move_player (dir:Command.direction) state =
  let loc = Player.get_loc state.player in
  let e =
    match dir with 
    |Up -> get_n loc
    |Down -> get_s loc
    |Left -> get_e loc
    |Right -> get_w loc
  in match e with
  | (Discovered, Some(tile)) -> 
    {state with player = Player.move tile state.player}
  | (Undiscovered, Some(tile)) -> 
    begin match state.deck with 
      | h::t ->
        {state with player = Player.move (Tiles.fill_tile tile h) state.player;
                    deck = t}
      | [] -> failwith "There are no more rooms to discover" end
  | (Nonexistent,_) -> raise NoDoor
  | _ -> failwith "Impossible because discovered and undiscovered exits
      must contain a tile"

(* ------------------------------------------------- *)
(* CODE FOR TESTING *)

let first_tile_test 
    (name : string)
    (state: t)
    (ex : Tiles.t) =
  name >:: (fun _ -> 
      assert_equal ex (first_tile state))



(*let test_state = from_json (Yojson.Basic.from_file "test_rooms.json")*)

let player1 = Player.(empty |> set_id 1 |> set_name "Player 1")

let tests = []