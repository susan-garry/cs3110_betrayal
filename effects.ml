open Yojson.Basic.Util
open Player
open OUnit2

(** The type of player lists *)
type p_list = Player.t option array

(** [print_change stat diff p] prints a string reporting that player [p]'s stat
    [stat] has changed by [diff] *)
let print_change stat diff p =
  let name = get_name p in
  if diff < 0 then print_endline 
      (name ^ "'s " ^ stat ^ " has decreased by " ^ (string_of_int (-diff)))
  else if diff > 0 then print_endline 
      (name ^ "'s " ^ stat ^ " has increased by " ^ (string_of_int (diff)))
  else ()

(** [update_p changes player] is [player] with stats updated according to 
    [changes] where its entries correspond to changes in strength, hunger, 
    sanity and insight in that order.
    Requires: [changes] is a list of length 4. *)
let update_p changes player = 
  match changes with 
  | str::hun::san::ins::[] -> 
    print_change "strength" str player;
    print_change "hunger" hun player;
    print_change "sanity" san player;
    print_change "insight" ins player;
    player |> set_stat_strength (get_stat_strength player + str) 
    |> set_stat_hunger (get_stat_hunger player + hun) 
    |> set_stat_sanity (get_stat_sanity player + san) 
    |> set_stat_insight (get_stat_insight player + ins) 
  |_ -> failwith "Malformed stat change array"

(** [next_player state idx] returns the occupied index closest to [idx] cycling 
    to the right. *)
let rec next_player players idx=
  match Array.get players idx with 
  |Some p -> idx
  |None -> next_player players ((idx+1) mod 6)

(** [eff_auto j_assoc state] is the players of [state] with the automatic stat 
    changes indicated by [j_assoc] when the current player enters its room.*)
let eff_auto j_assoc state =
  let players = fst state in
  let idx = snd state in
  (* update triggering player *)
  (let self_ch = 
     try (j_assoc |> List.assoc "self changes" |> to_list |> List.map to_int)
     with Not_found -> 
       failwith {|Stat change effects must have field "self changes"|} 
   in match Array.get players idx with
   |Some p -> Array.set players idx (Some (update_p self_ch p))
   |None -> failwith "Current player does not exist, eff_auto");
  if next_player players (idx+1) = idx then players else try(
    let other_ch =
      j_assoc |> List.assoc "other changes" |> to_list |> List.map to_int
    in Random.self_init ();
    let o = next_player players (Random.int 5) 
            |> (fun n -> (if (n = idx) then next_player players (n+1) else n)) 
    in match Array.get players o with
    |Some p -> Array.set players o (Some (update_p other_ch p)); players
    |None -> failwith "Should not happen, eff_auto")
    with Not_found -> players
(*let o = Random.int 5 |> (fun n -> (if (n = p) then (n+1) mod 6 else n)) in
  Array.set players o (update_p other_ch (Array.get players o)); players*)

(** [parse_eff_input ()] is [i] only if i is a well-formed choice. 
    Otherwise, it will prompt the user again for input. *)
let rec parse_eff_input () =
  match Command.eff_parse (read_line ()) with
  | exception _ -> 
    print_endline "You must choose: Yes or No?.";
    print_string "> ";
    parse_eff_input ()
  | c -> c

(** [eff_choice j_assoc state] is the players of [state] if input is "no" or
    the players with the automatic stat changes indicated by [j_assoc] when the 
    current player enters its room if input is "yes".*)
let rec eff_choice j_assoc state =
  let choice = (try (j_assoc |> List.assoc "choice" |> to_string)
                with Not_found -> 
                  failwith {|Choice effects must have field "choice"|}) in
  print_endline choice;
  let result = (try (j_assoc |> List.assoc "result" |> to_string)
                with Not_found -> 
                  failwith {|Choice effects must have field "result"|}) in
  match parse_eff_input () with
  | Yes -> print_endline result; eff_auto j_assoc state
  | No -> fst state

(** [exec_eff j_assoc player players] is [players] with stats updated according 
    to the effect [j_assoc] indicates when [player] enters its room.*)
let exec_eff j_assoc (state: p_list * int): (p_list * int) =
  let players = fst state in
  let idx = snd state in
  let j_name = 
    try (j_assoc |> List.assoc "id" |> to_string) 
    with Not_found -> failwith {|Effects must have field "id." |} in
  match j_name with
  |"automatic" -> (eff_auto j_assoc state), idx
  |"choice" -> (eff_choice j_assoc state), idx
  |"nothing" -> print_endline "For now, you are safe."; state
  |"repeat" -> print_endline "Take another turn."; state
  |"next" -> players, (next_player players (idx+1))
  |"skip" -> players, (next_player players (idx+1) +1 |> next_player players)
  |_ -> failwith ("effect " ^ j_name ^ " not yet implemented")

let rec exec_effects jlist state =
  match jlist with
  |[] -> state
  |hd::tl -> exec_eff (hd|>to_assoc) state |> exec_effects tl

(* ------------------------------------------------- *)
(* CODE FOR TESTING *)

(** [make_room_test name tile expected_output] constructs an OUnit
    test named [name] that asserts the quality of [expected_output]
    with [get_room tile]. *)
let make_update_p_test  
    (name: string)
    (changes: int list)
    (player: Player.t)
    (expected_output : Player.t) : test = 
  name >:: (fun _ -> assert_equal expected_output (update_p changes player))

let tests = [
  make_update_p_test "strength" [1;0;0;0] Player.empty 
    (set_stat_strength 5 empty);
  make_update_p_test "hunger" [0;1;0;0] Player.empty 
    (set_stat_hunger 5 empty);
  make_update_p_test "sanity, negative" [0;0;-1;0] Player.empty 
    (set_stat_sanity 3 empty);
  make_update_p_test "insight" [0;0;0;1] Player.empty 
    (set_stat_insight 5 empty);
]