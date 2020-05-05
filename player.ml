open Tiles
open OUnit2

type player_id = int
type player_stats = {speed:int; might:int; sanity:int; knowledge:int}

type t = { name : string;
           id: player_id;
           location : Tiles.t;
           stats: player_stats; }


exception LastPlayer

let empty = { name = "Player 1";
              id = 1;
              location = Tiles.empty;
              stats = {speed=4; might=4; sanity=4; knowledge=4};
            }

let get_id p = p.id

let set_id id p = {p with id = id}

let get_name p = p.name

let set_name name player = {player with name = name}

let get_loc p = p.location

let move t p = {p with location = t}

let get_stats p = [p.speed; p.might; p.sanity; p.knowledge]

let player_lose p = 
  (p.stats.speed == 0 || p.stats.might == 0 || p.stats.sanity == 0 || p.stats.knowledge == 0)

let player_win p = 
  (p.stats.speed >= 8 || p.stats.might >= 8 || p.stats.sanity >= 8 || p.stats.knowledge >= 8)

(** [print_stats sts] is unit;  *)
let print_stats sts = 
  print_endline "Player Stats:";
  print_endline "Speed: "; print_int sts.speed;
  print_endline "Might: "; print_int sts.might;
  print_endline "Sanity: "; print_int sts.sanity;
  print_endline "Knowledge: "; print_int sts.knowledge;
  ()

let print_player p =
  let locale = 
    begin match (p.location |> Tiles.get_room) with 
      | None -> "Unknon"
      | Some r -> Rooms.room_id r
    end in
  print_endline "Player"; print_string p.name;
  print_endline "Location"; print_string locale;
  print_stats p.stats;
  ()
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