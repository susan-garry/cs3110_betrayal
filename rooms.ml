open Yojson.Basic.Util
open OUnit2

type room_id = string
type eff_lst = int list

type t = {id: room_id; desc: string; effects: eff_lst}

let from_json json =
  let j_assoc = json |> to_assoc in
  {id = j_assoc |> List.assoc "id" |> to_string;
   desc = j_assoc |> List.assoc "description" |> to_string;
   effects = j_assoc |> List.assoc "effects" |> to_list 
             |> List.mapi (fun j_int -> to_int)}

let room_id r = r.id

let room_desc r = r.desc

let room_effects r = r.effects

(* ------------------------------------------------- *)
(* CODE FOR TESTING *)

(** [make_room_effects_test name room expected_output] constructs an OUnit
    test named [name] that asserts the quality of [expected_output]
    with [room_effects room]. *)
let make_room_effects_test  
    (name: string)
    (room: t)
    (expected_output : int list) : test = 
  name >:: (fun _ -> assert_equal expected_output (room_effects room))

let test_rooms = "test_rooms.json" |> Yojson.Basic.from_file |> member "deck"
                 |> Yojson.Basic.Util.to_list
let room0 = List.hd test_rooms |> from_json
let room1 = List.nth test_rooms 1 |> from_json
let room2 = List.nth test_rooms 2 |> from_json

let tests = [
  "room_id_test" >:: (fun _ -> assert_equal "None" (room_id room0));
  "room_desc_test" >:: (fun _ -> 
      assert_equal "You used none room. It wasn't very effective." 
        (room_desc room0));
  make_room_effects_test "No effects" room0 [];
  make_room_effects_test "One effect" room1 [1];
  make_room_effects_test "Multiple effects" room2 [0;-1;1];
]