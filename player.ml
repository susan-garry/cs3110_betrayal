open Tiles
open OUnit2

type player_stats = {sanity:int; insight:int; strength:int; hunger:int}
type player_condition = Winner | Loser |Playing

type t = { name : string;
           location : Tiles.t;
           stats: player_stats;
           condition: player_condition
         }


let empty = { name = "Player 1";
              location = Tiles.empty;
              stats = {sanity=4; insight=4; strength=4; hunger=4};
              condition = Playing
            }

let get_name p = p.name

let set_name name player = {player with name = name}

let get_loc p = p.location

let get_condition p = p.condition

let set_condition p con = {p with condition = con}

let move t p = {p with location = t}

let set_stat_sanity p change = 
  let changed_stats = {p.stats with sanity = change} 
  in {p with stats = changed_stats}

let set_stat_insight p change = 
  let changed_stats = {p.stats with insight = change} 
  in {p with stats = changed_stats}


let set_stat_strength p change = 
  let changed_stats = {p.stats with strength = change} 
  in {p with stats = changed_stats}


let set_stat_hunger p change = 
  let changed_stats = {p.stats with hunger = change} 
  in {p with stats = changed_stats}


let player_lose p = 
  (p.stats.strength <= 0 || p.stats.hunger <= 0 || p.stats.sanity <= 0 || p.stats.insight <= 0)

let player_win p = 
  (p.stats.strength >= 8 || p.stats.hunger >= 8 || p.stats.sanity >= 8 || p.stats.insight >= 8)

(** [print_stats sts] is unit;  *)
let print_stats sts = 
  print_string "Sanity: "; print_int sts.sanity; print_newline ();
  print_string "Insight: "; print_int sts.insight; print_newline ();
  print_string "Strength: "; print_int sts.strength; print_newline ();
  print_string "Hunger: "; print_int sts.hunger; print_newline ();
  ()

let print_player p =
  let locale = 
    begin match (p.location |> Tiles.get_room) with 
      | None -> "Unknown"
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