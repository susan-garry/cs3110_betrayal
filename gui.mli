(* Gives user prompts, takes user commands as input *)

(* Will likely use ASCII representation for displaying the map of the board and user interface 
    __ __ _____
   |     |     |
    4 x 2   1
   |__ __|_____|

*)

type gui_tile

val parse_tile : gui_tile

val parse_empty_tile: gui_tile

val print_a_tile : gui_tile -> unit