open OUnit2
type player_id = int
type player_name = string
type player_stats = {speed:int; might:int; sanity:int; knowledge:int}

type t = { id : player_id;
           name : player_name;
           location : Tiles.t;
           stats: player_stats;
           next_player : t option ref}

exception LastPlayer

let empty = { id = 0;
              name = "Player 1";
              location = Tiles.empty;
              stats = {speed=4; might=4; sanity=4; knowledge=4};
              next_player = ref None}

let get_id p = p.id

let set_id id p = {p with id = id}

let get_name p = p.name

let set_name name player = {player with name = name}

let get_loc p = p.location

let move t p = {p with location = t}

let get_next p = !(p.next_player)


(*-------------------------------------------*)
(*Code for testing here*)

let make_get_id_test
    (name : string)
    (player: t)
    (ex: int) =
  name >:: (fun _ -> assert_equal ex (get_id player))

let make_get_loc_test
    (name : string)
    (player: t)
    (ex: Tiles.t) =
  name >:: (fun _ -> assert_equal ex (get_loc player))

let player1 = empty |> set_id 1 |> set_name "Player 1"

let tests = [
  make_get_id_test "Get ID Test for empty player" empty 0;
  make_get_id_test "Get ID Test for Player 1" player1 1;

  make_get_loc_test "Empty tile" player1 Tiles.empty;
]