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

let rooms_tests = [
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
