open Rooms
open Command
open State
(*open Gui*)
open Yojson.Basic

let start_screen = ANSITerminal.(print_string [blue]"\n\nWelcome to Betrayal of CU on the Hill! \n")
let prompt = print_endline "> "


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


(** [play st] resumes play from the game state in [state]. *)
let rec play state = 
  (** TODO: -print the board 
            -prompt the user, print a description of the room*)
  print_endline (State.room_desc state);
  print_string "> ";
  match parse_input () with
  | Quit -> exit 0
  | Go d -> play (State.move_player d state)

(** [main ()] prompts for the game to play, then starts it. *)
let main () =
  start_screen;
  (*prompt;*)
  (*begin
    match read_line () with
    | exception End_of_file -> ()
    | f -> play ("test_rooms.json" |> Yojson.Basic.from_file |> State.from_json)
    end *)
  play ("test_game.json" |> Yojson.Basic.from_file |> State.from_json)

(* Execute the game engine. *)
let () = main ()