open OUnit2
open Cards
open Rooms
open House

let cards_tests = [

]

let rooms_tests = [

]

let house_tests = [

]

let suite =
  "test suite for A2"  >::: List.flatten [
    cards_tests;
    rooms_tests;
    house_tests;
  ]

let _ = run_test_tt_main suite