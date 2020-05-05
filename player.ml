open Tiles
open OUnit2

type player_stats = {speed:int; might:int; sanity:int; knowledge:int}
type player_condition = Winner | Loser |Playing

type t = { name : string;
           location : Tiles.t;
           stats: player_stats;
           condition: player_condition
         }

exception UnknownStatus


let empty = { name = "Player 1";
              location = Tiles.empty;
              stats = {speed=4; might=4; sanity=4; knowledge=4};
              condition = Playing
            }

let get_name p = p.name

let set_name name player = {player with name = name}

let get_loc p = p.location

let get_condition p = p.condition

let set_condition p con = {p with condition = con}

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
  print_string "Speed: "; print_int sts.speed; print_newline ();
  print_string "Might: "; print_int sts.might; print_newline ();
  print_string "Sanity: "; print_int sts.sanity; print_newline ();
  print_string "Knowledge: "; print_int sts.knowledge; print_newline ();
  ()

let print_player p =
  let locale = 
    begin match (p.location |> Tiles.get_room) with 
      | None -> "Unknon"
      | Some r -> Rooms.room_id r
    end in
  print_string "Player: "; print_endline p.name;
  print_string "Location: "; print_endline locale;
  print_stats p.stats;
  print_string "Room: ";
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