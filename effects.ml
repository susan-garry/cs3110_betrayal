open Yojson.Basic.Util

(** [update_p changes players p_idx] *)
let update_p changes players p_idx = 
  failwith "update_p unimplemented (needs players to have stat setters)"


(** [eff_auto j_assoc player players] is [players] with the automatic stat 
    changes indicated by [j_assoc] when [player] enters its room.*)
let eff_auto j_assoc players p =
  let self_ch = 
    j_assoc |> List.assoc "self_changes" |> to_list |> List.map to_int in
  Array.set players p (update_p self_ch players p); players
(* CODE FOR WHEN MULTIPLAYER IS IMPLEMENTED *)
(*let other_ch = 
  j_assoc |> List.assoc "other_changes" |> to_list |> List.map to_int in
  Random.self_init ();
  let o = Random.int 8 |> (fun n -> (if (n = p) then (n+1) mod 9 else n)) in
  Array.set players o (update_p other_ch players o); players*)


(** [exec_eff j_assoc player players] is [players] with stats updated according 
    to the effect [j_assoc] indicates when [player] enters its room.*)
let exec_eff j_assoc players p = 
  let j_name = j_assoc |> List.assoc "id" |> to_string in
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