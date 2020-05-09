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

val player_locs : State.t -> (Tiles.coord * int list) list

(** *)
val print_row : Tiles.t -> int list -> unit

(** *)
val print_board : Tiles.t -> (Tiles.coord * int list) list -> unit

(**[tests] returns a list of OUnit2 tests for the functions in state*)
val tests : OUnit2.test list
