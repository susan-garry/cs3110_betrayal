open Tiles
open OUnit2

type player_stats = {speed:int; might:int; sanity:int; knowledge:int}

type t = { name : string;
           id: int;
           location : Tiles.t;
           stats: player_stats; }

exception UnknownStatus


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

let set_stat sts s change = 
  let stat_changed = 
    match s with
    | "speed" -> {sts with speed = change}
    | "might" -> {sts with might = change}
    | "sanity" -> {sts with sanity = change}
    | "knowledge" -> {sts with knowledge = change}
    | _ -> raise UnknownStatus
  in stat_changed

let player_lose p count = 
  (p.stats.speed <= count || p.stats.might <= count || p.stats.sanity <= count || p.stats.knowledge <= count)

let player_win p count = 
  (p.stats.speed >= count || p.stats.might >= count || p.stats.sanity >= count || p.stats.knowledge >= count)

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