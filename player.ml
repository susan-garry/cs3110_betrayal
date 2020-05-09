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

let get_stat_sanity p = p.stats.sanity

let get_stat_insight p = p.stats.insight

let get_stat_strength p = p.stats.strength

let get_stat_hunger p = p.stats.hunger

let set_stat_sanity change p = 
  let changed_stats = {p.stats with sanity = change} 
  in {p with stats = changed_stats}

let set_stat_insight change p = 
  let changed_stats = {p.stats with insight = change} 
  in {p with stats = changed_stats}

let set_stat_strength change p = 
  let changed_stats = {p.stats with strength = change} 
  in {p with stats = changed_stats}

let set_stat_hunger change p = 
  let changed_stats = {p.stats with hunger = change} 
  in {p with stats = changed_stats}


let player_win_loss p =
  if (p.stats.sanity >=8 ) then "You feel very sane and suddenly realize how to escape this house." else
  if (p.stats.sanity <=0 ) then "You lose all your sanity" else
  if (p.stats.insight <= 0) then "You lose all your insight" else 
  if (p.stats.strength <= 0) then "" else 
  if (p.stats.hunger <= 0) then "" else ""

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

let make_get_name_test 
    (name : string)
    (player: t)
    (ex : string) =
  name >:: (fun _ -> assert_equal ex (get_name player))

let make_get_loc_test
    (name : string)
    (player: t)
    (ex: Tiles.t) =
  name >:: (fun _ -> assert_equal ex (get_loc player))

let make_get_stat_sanity_test
    (name : string)
    (player: t)
    (ex: int) =
  name >:: (fun _ -> assert_equal ex (get_stat_sanity player))

let make_get_stat_insight_test
    (name : string)
    (player: t)
    (ex: int) =
  name >:: (fun _ -> assert_equal ex (get_stat_insight player))

let make_get_stat_strength_test
    (name : string)
    (player: t)
    (ex: int) =
  name >:: (fun _ -> assert_equal ex (get_stat_strength player))

let make_get_stat_hunger_test
    (name : string)
    (player: t)
    (ex: int) =
  name >:: (fun _ -> assert_equal ex (get_stat_hunger player))

let make_player_lose_test
    (name : string)
    (player: t)
    (ex: bool) =
  name >:: (fun _ -> assert_equal ex (player_lose player))

let make_player_win_test
    (name : string)
    (player: t)
    (ex: bool) =
  name >:: (fun _ -> assert_equal ex (player_win player))


let player1 = empty |> set_name "Player 1"
let player2 = player1 |> set_name "Davis" |> set_stat_sanity 3 |> set_stat_insight 9 |> set_stat_strength 2 |> set_stat_hunger 10
let player3 = player2 |> set_name "Marshell" |> set_stat_sanity 0 |> set_stat_insight 1 |> set_stat_strength 7 |> set_stat_hunger 5
let player4 = player1 |> set_stat_strength (get_stat_strength player1 + 4) |> set_stat_hunger (get_stat_hunger player1 + 4) |> set_stat_sanity (get_stat_sanity player1 + 4) |> set_stat_insight (get_stat_insight player1 + 4)

let name_tests = [
  make_get_name_test "1st Player name" player1 "Player 1";
  make_get_name_test "Different name" player2 "Davis";
]

let loc_tests = [
  make_get_loc_test "Empty tile" player1 Tiles.empty;
]

let stat_tests = [
  make_get_stat_sanity_test "Sanity Stat" player1 4;
  make_get_stat_sanity_test "Sanity Maxed" player2 3;
  make_get_stat_sanity_test "Sanity Zero" player3 0;
  make_get_stat_sanity_test "Advanced Sanity" player4 8;

  make_get_stat_insight_test "Insight Stat" player1 4;
  make_get_stat_insight_test "Insight Maxed" player2 9;
  make_get_stat_insight_test "Insight Low" player3 1;
  make_get_stat_insight_test "Advanced Insight" player4 8;
]

let condition_tests = [
  make_player_lose_test "Player playing 1" player1 false;
  make_player_win_test "Player playing 1" player1 false
]

let tests = List.flatten [
    name_tests;
    loc_tests;
    stat_tests;
    condition_tests
  ]