open OUnit2
type player_id = int
type player_name = string
<<<<<<< HEAD
type stat = int
=======
type player_stats = {speed:int; might:int; sanity:int; knowledge:int}
>>>>>>> c1c9789b7d6be2acf4a0f51c5ecb9c05a6c17dfd

type t = { name : player_name;
           location : Tiles.t;
<<<<<<< HEAD
           might : stat;
           speed : stat;
           sanity : stat;
           knowledge : stat}
=======
           stats: player_stats;
           next_player : t option ref}
>>>>>>> c1c9789b7d6be2acf4a0f51c5ecb9c05a6c17dfd

exception LastPlayer

let empty = { name = "Player 1";
              location = Tiles.empty;
<<<<<<< HEAD
              might = 4;
              speed = 4;
              sanity = 4;
              knowledge = 4}
=======
              stats = {speed=4; might=4; sanity=4; knowledge=4};
              next_player = ref None}

let get_id p = p.id

let set_id id p = {p with id = id}
>>>>>>> c1c9789b7d6be2acf4a0f51c5ecb9c05a6c17dfd

let get_name p = p.name

let set_name name player = {player with name = name}

let get_loc p = p.location

let move t p = {p with location = t}

<<<<<<< HEAD
=======
let get_next p = !(p.next_player)


>>>>>>> c1c9789b7d6be2acf4a0f51c5ecb9c05a6c17dfd
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