open OUnit2

type t = { name : string;
           location : Tiles.t;
           next_player : t ref}

exception LastPlayer

let empty = { name = "Player 1";
              location = Tiles.empty;
              next_player = ref (raise LastPlayer)}

let location p = p.location

let move t p = {p with location = t}

let get_next p = !(p.next_player)

(*-------------------------------------------*)
(*Code for testing here*)

let make_location_test
    (name : string)
    (player: t)
    (ex: Tiles.t) =
  name >:: (fun _ -> assert_equal ex (location player))

let tests = [
  make_location_test "Empty tile" empty Tiles.empty;
]