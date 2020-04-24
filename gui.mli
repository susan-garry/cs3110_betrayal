(* Gives user prompts, takes user commands as input *)

(* Will likely use ASCII representation for displaying the map of the board and user interface 
    __ __ _____
   |     |     |
    4 x 2   1
   |__ __|_____|

*)

type gui_tile

val start_screen : unit

val prompt : unit

val parse_a_title : gui_tile

val print_a_tile : gui_tile -> unit