open OUnit2
type player_id = int
type player_name = string
type status = int

type player_stats = {speed:int; might:int; sanity:int; knowledge:int}

type t = { name : player_name;
           location : Tiles.t;
           stats: player_stats }

exception LastPlayer

let empty = { name = "Player 1";
              location = Tiles.empty;
              stats = {speed=4; might=4; sanity=4; knowledge=4}
            }

let get_name p = p.name

let set_name name player = {player with name = name}

let get_loc p = p.location

let move t p = {p with location = t}

(*-------------------------------------------*)
(*Code for testing here*)

let make_get_loc_test
    (name : string)
    (player: t)
    (ex: Tiles.t) =
  name >:: (fun _ -> assert_equal ex (get_loc player))

let player1 = empty |> set_name "Player 1"

let tests = [
  make_get_loc_test "Empty tile" player1 Tiles.empty;
]