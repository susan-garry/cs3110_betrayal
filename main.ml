open Yojson.Basic
open State
open Gui


let start_screen = ANSITerminal.(print_string [blue]"\n\nWelcome to Betrayal of CU on the Hill! \n")

(** [setUp ()] will set up some of the parameters of the game by asking things like how many players are playing and their names. *)
let setUp n () = 
  print_string "What is Player"; print_int n; print_endline "'s name?";
  ()

(** [parse_input ()] is [i] only if i is a well-formed command. 
    Otherwise, it will prompt the user again for input. *)
let rec parse_input () =
  match Command.parse (read_line ()) with
  | exception Command.Empty -> 
    print_endline "Where would you like to go?"; 
    print_string "> ";
    parse_input ()
  | exception _ -> 
    print_endline "I don't understand that."; 
    print_string "> ";
    parse_input ()
  | c -> c

(** [parse_move d state] is a new state [st] only if State.move_player in direction [d] in state [state] is a valid move. 
    Otherwise, the state remains unchanged. *)
let parse_move d state =
  match move_player d state with 
  | exception NoDoor -> 
    print_endline "You can't go that way! Go elsewhere.";
    state
  | exception EmptyTile -> 
    print_endline "Something went wrong, it's empty!";
    state
  | exception _ -> 
    print_endline "Something went wrong! Oh no. ";
    print_newline ();
    state
  | st -> st

(** [play st] resumes play from the game state in [state]. *)
let rec play state = 
  (** TODO: -print the board 
            -prompt the user, print a description of the room*)
  print_endline (room_desc state);
  print_newline ();
  print_string "It is "; print_string (player_desc state); 
  print_endline "'s turn.";
  print_string "> ";
  match parse_input () with
  | Quit -> exit 0
  | Map -> print_board (corner_tile state); play state
  | Stats -> print_current_player state; play state;
    (** call [print_player p] for the current player in play *)
  | Go d -> play (parse_move d state)

(** [main ()] prompts for the game to play, then starts it. *)
let main () =
  start_screen;
  play ("test_game.json" |> Yojson.Basic.from_file |> from_json)

(* Execute the game engine. *)
let () = main ()