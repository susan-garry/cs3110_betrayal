(* Gives user prompts, takes user commands as input *)

(* Will likely use ASCII representation for displaying the map of the board and user interface 
    __ __ _____
   |     |     |
    4 x 2   1
   |__ __|_____|

*)


type gui_tile
type gui_row


val go_corner: Tiles.t -> Tiles.t

(**[tests] returns a list of OUnit2 tests for the functions in state*)
val tests : OUnit2.test list
(*
val parse_tile : walls -> gui_tile

val parse_empty_tile: gui_tile

val print_tile : gui_tile -> unit

val into_tile : gui_tile -> gui_tile

val out_of_tile : gui_tile -> gui_tile
*)