(** @author: Primary author, Daphne Rios, dr434
             Additional contributor: Susan Garry, shg64
*)

(* Gives user prompts, takes user commands as input *)

(* Will likely use ASCII representation for displaying the map of the board and user interface 
    __ __ _____
   |     |     |
    4 x 2   1
   |__ __|_____|

*)

(**[print_board] prints an ASCII representation of the board with player_id's
    denoting each player's locations and returns unit*)
val print_board : State.t -> unit

(**[tests] returns a list of OUnit2 tests for the functions in state*)
val tests : OUnit2.test list
