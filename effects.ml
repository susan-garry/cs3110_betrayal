open Yojson.Basic.Util
open Player

(** [update_p changes player] is [player] with stats updated according to 
    [changes] where its entries correspond to changes in strength, hunger, 
    sanity and insight in that order.
    Requires: [changes] is a list of length 4. *)
let update_p changes player = 
  match changes with 
  | str::hun::san::ins::[] ->
    let update1 = player |> set_stat_strength (get_stat_strength player + str)
    in let update2 = update1 |> set_stat_hunger (get_stat_hunger update1 + hun)
    in let update3 = update2 |> set_stat_sanity (get_stat_sanity update2 + san)
    in update3 |> set_stat_insight (get_stat_insight update3 + ins)
  |_ -> failwith "Malformed stat change array"

(** [eff_auto j_assoc player players] is [players] with the automatic stat 
    changes indicated by [j_assoc] when [player] enters its room.*)
let eff_auto j_assoc players p =
  let self_ch = 
    try (j_assoc |> List.assoc "self_changes" |> to_list |> List.map to_int)
    with Not_found -> 
      failwith {|Automatic effects must have field "self_changes|} 
  in Array.set players p (update_p self_ch (Array.get players p));
  (* CODE FOR WHEN MULTIPLAYER IS IMPLEMENTED *)
  (*let other_ch = 
    try (j_assoc |> List.assoc "other_changes" |> to_list |> List.map to_int)
    with Not_found -> 
      failwith {|Automatic effects must have field "other_changes|} 
    in Random.self_init ();
    let o = Random.int 8 |> (fun n -> (if (n = p) then (n+1) mod 9 else n)) in
    Array.set players o (update_p other_ch (Array.get players o));*)
  players


(** [exec_eff j_assoc player players] is [players] with stats updated according 
    to the effect [j_assoc] indicates when [player] enters its room.*)
let exec_eff j_assoc players p = 
  let j_name = 
    try (j_assoc |> List.assoc "id" |> to_string) 
    with Not_found -> failwith {|Effects must have field "id." |} in
  match j_name with
  |"automatic" -> eff_auto j_assoc players p
  |"nothing" -> print_endline "For now, you are safe."; players
  |_ -> failwith ("effect " ^ j_name ^ " not yet implemented")

let rec exec_effects jlist players p =
  match jlist with
  |[] -> Array.copy players
  |hd::tl -> let p_step = exec_eff (hd|>to_assoc) (Array.copy players) p
    in exec_effects tl p_step p

(* ------------------------------------------------- *)
(* CODE FOR TESTING *)

(** [make_room_test name tile expected_output] constructs an OUnit
    test named [name] that asserts the quality of [expected_output]
    with [get_room tile]. 
    let make_exec_effects_test  
    (name: string)
    (jlist: Yojson.Basic.t list)
    (players: Player)
    (expected_output : Rooms.t option) : test = 
    name >:: (fun _ -> assert_equal expected_output (get_room tile))*)

let tests = []