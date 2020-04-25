open OUnit2
type player_id = string

type t = { name : player_id;
           location : Tiles.t;
           next_player : t option ref}

exception LastPlayer

let empty = { name = "Player 1";
              location = Tiles.empty;
              next_player = ref None}

let player_id p = p.name

let player_loc p = p.location

let move t p = {p with location = t}

let get_next p = !(p.next_player)

(*-------------------------------------------*)
(*Code for testing here*)

let make_location_test
    (name : string)
    (player: t)
    (ex: Tiles.t) =
  name >:: (fun _ -> assert_equal ex (player_loc player))

let tests = [
  make_location_test "Empty tile" empty Tiles.empty;
]