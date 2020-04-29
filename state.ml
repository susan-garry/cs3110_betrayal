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

(**[shuffle deck] returns a list containing all of the same elements as [deck]
   but in a randomized order. *)
let shuffle deck =
  Random.self_init ();
  let rec shuffle_helper acc deck n =
    match n with 
    |0 -> assert (List.length deck = 0); acc
    |_ -> let i = Random.int n in
      (steal i acc deck) (n-1)

  and steal n l1 l2 =
    let rec steal_helper n l1 p2 =
      match n, p2 with
      | 0, (h::t, l3)-> shuffle_helper (h::l1) (List.rev_append t l3)
      | _, (h::t, l3) -> steal_helper (n-1) l1 (t, h::l3)
      | _ -> failwith "There are more than n + 1 elements in the list"
    in steal_helper n l1 (l2, [])

  in shuffle_helper [] deck (List.length deck)


(**[dir_char d] returns the character associated with that direction *)
let dir_char = function
  |North -> 'N'
  |South -> 'S'
  |East -> 'E'
  |West -> 'W'

(**[start_coord s] returns the coordinates of the first room in [s]*)
let first_coord s = s.first_tile |> get_coords

(**[add_mult d t n] adds n tile off of tile [t] in direction [d] and returns
   the last tile that gets added, e.i. the one furthest in direction [d]*)
let add_mult d t n =
  let rec add_mult_helper d t acc n =
    if acc = n then t
    else add_mult_helper d (Tiles.new_tile t d) (acc+1) n
  in add_mult_helper d t 0 n

let add_n_row t s = 
  let t2 = 
    try Tiles.new_tile t 'N' with
    |_ -> failwith "a tile already exists there!"
  in 
  let rx_coord = t2 |> Tiles.get_coords |> fst in
  let fx_coord = s |> first_coord |> fst in
  ignore (add_mult 'E' t2 (fx_coord + s.x_dim - 1 - rx_coord));
  {s with first_tile = add_mult 'W' t2 (rx_coord - fx_coord);
          y_dim = s.y_dim + 1}

let add_s_row t s = 
  let t2 = 
    try Tiles.new_tile t 'S' with
    |_ -> failwith "a tile already exists there!"
  in 
  let rx_coord = t2 |> Tiles.get_coords |> fst in
  let fx_coord = s |> first_coord |> fst in
  ignore (add_mult 'E' t2 (fx_coord + s.x_dim - 1 - rx_coord));
  ignore (add_mult 'W' t2 (rx_coord - fx_coord));
  {s with y_dim = s.y_dim + 1}

let add_e_row t s = 
  let t2 = 
    try Tiles.new_tile t 'E' with
    |_ -> failwith "a tile already exists there!"
  in
  let ry_coord = t2 |> Tiles.get_coords |> snd in
  let fy_coord = s |> first_coord |> snd in
  ignore (add_mult 'S' t2 (ry_coord + s.y_dim - 1 - fy_coord));
  ignore (add_mult 'N' t2 (fy_coord - ry_coord));
  {s with x_dim = s.x_dim + 1}

let add_w_row t s = 
  let t2 = 
    try Tiles.new_tile t 'W' with
    |_ -> failwith "a tile already exists there!"
  in
  let ry_coord = t2 |> Tiles.get_coords |> snd in
  let fy_coord = s |> first_coord |> snd in
  ignore (add_mult 'S' t2 (ry_coord + s.y_dim - 1 - fy_coord));
  {s with first_tile = add_mult 'N' t2 (fy_coord - ry_coord);
          x_dim = s.x_dim + 1}

(** [add_row d t s] returns a [state] with the new appropriate start tile and
    alters the exits of other tiles on the board
    to reference a new row of tiles in direction [d] if and only if the exit 
    from [t] leading towards direction [d] is Nonexistent *)
let add_row (d:dir) (t:Tiles.t) (s:t): t = 
  match d with 
  |North -> add_n_row t s
  |South -> add_s_row t s
  |East -> add_e_row t s
  |West -> add_w_row t s

(**[from_json json] takes a json file and creates the initial game state*)
let from_json json = 
  let start_tile = json |> member "start room" |> Rooms.from_json 
                   |> Tiles.fill_tile Tiles.empty
  in
  let p = Player.move start_tile Player.empty in
  let s' = { 
    first_tile = start_tile;
    x_dim = 1;
    y_dim = 1;
    deck = json |> member "deck" |> create_deck |> shuffle;
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
    |Left -> get_w loc
    |Right -> get_e loc
  in match e with
  | (Discovered, Some(tile)) -> 
    {state with player = Player.move tile state.player}
  | (Undiscovered, Some(tile)) -> 
    begin match state.deck with 
      | [] -> failwith "There are no more rooms to discover"
      | h::t ->
        let s' =
          {state with player = Player.move (Tiles.fill_tile tile h) state.player;
                      deck = t}
        in
        let t_coord = Tiles.get_coords tile in 
        let f_coord = first_coord s' in
        if fst t_coord = fst f_coord then
          add_w_row tile s' else 
        if snd t_coord = snd f_coord 
        then 
          add_n_row tile s' else
        if fst t_coord + 1 = fst f_coord + s'.x_dim then s' |> add_e_row tile 
        else
        if tile |> Tiles.get_s |> snd = None then s' |> add_s_row tile
        else s'
    end
  | (Nonexistent,_) -> raise NoDoor
  | _ -> failwith "Impossible because discovered and undiscovered exits \
                   must contain a tile"

(* ------------------------------------------------- *)
(* CODE FOR TESTING *)

let tile_exists e =
  match e with 
  | (_, None) -> false
  | (_, Some t) -> true

let make_shuffle_test
    (name : string)
    (deck : int list) =
  name >:: (fun _ ->
      let compare a b = if a > b then 1 else if a < b then -1 else 0 in
      assert_equal (List.sort compare deck) (List.sort compare (shuffle deck)))

let add_n_row_test
    (name : string) 
    (tile : Tiles.t)
    (state: t) 
    (ex_fail : bool )=
  name >:: (fun _ -> 
      if ex_fail = true then 
        assert_raises (Failure "tile already exists") 
          (fun () -> add_row North tile state)
      else 
        let state' = add_row North tile state
        in assert_equal (state.y_dim + 1) state'.y_dim;
        (*let ft' = 
          match Tiles.get_n tile with 
          |(_,Some t) -> t
          |(_,None) -> failwith "Tile does not exist"
          in
          assert_equal state'.first_tile ft' *) )

let first_tile_test 
    (name : string)
    (state: t)
    (ex : Tiles.t) =
  name >:: (fun _ -> 
      assert_equal ex (first_tile state))

let player1 = Player.(empty |> set_id 1 |> set_name "Player 1")

let empty_state = { first_tile = Tiles.empty;
                    x_dim = 1;
                    y_dim = 1;
                    deck = [];
                    first_player = player1;
                    player = player1;
                  }

let tests = [ 
  (*add_n_row_test "State with one tile" empty_state.first_tile empty_state false*)
  make_shuffle_test "shuffle []" [];
  make_shuffle_test "shuffle [2;4;8;9]" [2;4;8;9];
  make_shuffle_test "shuffle [4;29;38;7;21;0]" [4;29;38;7;21;0];
]