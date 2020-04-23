open OUnit2
open Command
open Effects
open Gui
open Player
open Rooms
open State
open Tiles

let command_tests = [

]

let effects_tests = [

]

let gui_tests = [

]

let player_tests = [

]

(** [make_room_effects_test name room expected_output] constructs an OUnit
    test named [name] that asserts the quality of [expected_output]
    with [room_effects room]. *)
let make_room_effects_test  
    (name: string)
    (room: Rooms.t)
    (expected_output : int list) : test = 
  name >:: (fun _ -> assert_equal expected_output (room_effects room))

let test_rooms = "test_rooms.json" |> Yojson.Basic.from_file 
                 |> Yojson.Basic.Util.to_list
let room0 = List.hd test_rooms |> Rooms.from_json
let room1 = List.nth test_rooms 1 |> Rooms.from_json
let room2 = List.nth test_rooms 2 |> Rooms.from_json

let rooms_tests = [
  "room_id_test" >:: (fun _ -> assert_equal "None" (room_id room0));
  "room_desc_test" >:: (fun _ -> 
      assert_equal "You used none room. It wasn't very effective." 
        (room_desc room0));
  make_room_effects_test "No effects" room0 [];
  make_room_effects_test "One effect" room1 [1];
  make_room_effects_test "Multiple effects" room2 [0;-1;1];
]

let state_tests = [

]

let tiles_tests = [

]

let suite =
  "test suite for A2"  >::: List.flatten [
    command_tests;
    effects_tests;
    gui_tests;
    player_tests;
    rooms_tests;
    state_tests;
    tiles_tests;
  ]

let _ = run_test_tt_main suite