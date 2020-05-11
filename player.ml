open Tiles
open OUnit2

type player_stats = {sanity:int; insight:int; strength:int; hunger:int}

type player_condition =  
  | Winner of (string -> string)
  | Loser of (string -> string)
  | Playing

type t = { name : string;
           location : Tiles.t;
           stats: player_stats;
         }

let empty = { name = "Player 1";
              location = Tiles.empty;
              stats = {sanity=4; insight=4; strength=4; hunger=4};
            }

let get_name p = p.name

let set_name name player = {player with name = name}

let get_loc p = p.location

let get_condition p = 
  if (p.stats.sanity >=8 ) then 
    Winner (
      fun x -> " You've had enough of this house, and are determined not to 
      \n let it get the best of you anymore. Calm and collected, you're 
      \n ready for any challenge, and eventually, beaten and battered but 
      \n alive, you find your way outside. 
      \n Congratulations, " ^ x ^ " has won! \n \n")
  else if (p.stats.insight >=8 ) then 
    Winner (
      fun x -> "> You have unlocked the secrets of this mansion. Having learned 
      \n It's dark and terrible past, you are now able to bend it to 
      \n you will. However, the knowledge of these secrets has changed 
      \n you, and the thought of returning to the life you knew before 
      \n seems absurd. You haunt the mansion for the rest of your days, 
      \n unharmed, but too troubled to every truly escape it. 
      \n Congratulations, " ^ x ^ " has won! \n \n")
  else if (p.stats.strength >=8 ) then 
    Winner (
      fun x -> " You're surprised to find that you've been in this house so
      \n long, you can actually see a noticeable difference in your 
      \n muscle tone. Apparently fighting monsters has its perks. 
      \n What's more, it seems you've become so strong that you're 
      \n effectively immune to damage, enabling you to eventually 
      \n battle your way outside. 
      \n Congratulations, " ^ x ^ " has won! \n \n")
  else if (p.stats.hunger >=8 ) then 
    Winner (
      fun x ->" You wander the halls of this house for a few more days. 
      \n Although you haven't eaten in a while, hunger esacpes you. 
      \n It seems that you have entered an enlightened state and have 
      \n complete control over your body and mind. Although you 
      \n encounter more attackers, they never seem to land a hit 
      \n against you, and eventually you find your way out of the mansion. 
      \n Congratulations, " ^ x ^ " has won! \n \n") else
  if (p.stats.sanity <=0 ) then 
    Loser (
      fun x -> " That was the last straw. Why is this happening to you? 
      \n You've always been a good and deserving person. Stuff like this 
      \n simply doesn't happen to good and deserving people. This can't 
      \n be happening to you. This isn't happening to you. You must be 
      \n having a bad dream, and the sooner you wake up the better. 
      \n Look, there's a vial of poison! If you drink it, you'll be able 
      \n to wake up from this nightmare! 
      \n You wake up in a dark, unfamiliar room. As your eyes start to 
      \n focus, you realize that you were sleeping upright. How odd. 
      \n As your mind begins to shake off the grogginess, you realize 
      \n that you've been strung up like a puppet, with ropes threaded 
      \n through your wrist so that you cannot undo them. You hear a 
      \n deep, raspy voice cackle, \"Good. Now we can have some fun.\" 
      \n " ^ x ^ " has lost. \n \n") else
  if (p.stats.insight <= 0) then 
    Loser (
      fun x -> " Looking around, you can't seem to remember why you are 
      \n here. After walking around for a few minutes, you see something 
      \n familiar and suddendly remember - you've got to escape! You 
      \n feverishly run around, looking for a way out, then stop. Looking 
      \n around, you can't seem to remember why you are here. 
      \n After walking around for a few minutes, you see something 
      \n familiar and suddendly remember - you've got to escape! You 
      \n feverishly run around, looking for a way out, then stop. Looking 
      \n around, you can't seem to remember why you are here. 
      \n " ^ x ^ " has lost. \n \n") else 
  if (p.stats.strength <= 0) then 
    Loser (
      fun x -> " You collapse! You have lost all strength in your body and can no longer move. 
      \n Shadows flicker in the corner of your eye. You try to look up 
      \n to see who - or what - is there, but no matter how hard you try, 
      \n your body is too exhausted and refuses to obey. 
      \n The shadows grow larger and more numerous as the creatures 
      \n within this house draw closer, sensing your weakness. 
      \n Now helpless prey, they finish you off with ease.
      \n " ^ x ^ " has lost. \n \n")
  else if (p.stats.hunger <= 0) then 
    Loser (
      fun x -> " There's an apple on a table next to you. 
      \n You snatch it off the table and hungrily devour it. 
      \n It turns to ashes on your tongue. 
      \n " ^ x ^ " has lost. \n \n")
  else Playing

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
]

let tests = List.flatten [
    name_tests;
    loc_tests;
    stat_tests;
    condition_tests
  ]