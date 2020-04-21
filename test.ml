open OUnit2
open Rooms
open Command
open State

let rooms_tests = [

]

let commands_tests = [

]

let state_tests = [

]

let suite =
  "test suite for A2"  >::: List.flatten [
    rooms_tests;
    commands_tests;
    state_tests;
  ]

let _ = run_test_tt_main suite