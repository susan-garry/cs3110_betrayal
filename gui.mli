(* Gives user prompts, takes user commands as input *)

(* Will likely use ASCII representation for displaying the map of the board and user interface 
    __ __ _____
   |     |     |
    4 x 2   1
   |__ __|_____|

*)

(** *)
type player_icon

(** *)
val corner_tile: State.t -> Tiles.t

(** *)
val print_row : Tiles.t -> unit

(** *)
val print_board : Tiles.t -> unit

(**[tests] returns a list of OUnit2 tests for the functions in state*)
val tests : OUnit2.test list
