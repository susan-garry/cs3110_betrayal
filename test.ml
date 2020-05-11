open OUnit2
open Command
open Effects
open Player
open Rooms
open State
open Tiles

let suite = "test suite for Betrayal"  >::: 
            List.flatten [ Command.tests;
                           Effects.tests;
                           Player.tests;
                           Rooms.tests; 
                           State.tests;
                           Tiles.tests; ]

let _ = run_test_tt_main suite