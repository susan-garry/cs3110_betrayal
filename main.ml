open Rooms
open Command
open State
open Gui

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


let rec play st = 
  (** TODO: print the board *)
  print_string "> ";
  match parse_input () with
  | Quit -> exit 0
  | Go d -> State.move_player d

(** [play_game f] starts the adventure in file [f]. *)
let rec play_game f =
  let state = State.from_json f in
  play state


(** [main ()] prompts for the game to play, then starts it. *)
let main () =
  start_screen;
  prompt;
  begin
    match read_line () with
    | exception End_of_file -> ()
    | f -> play_game test_rooms.json
  end

(* Execute the game engine. *)
let () = main ()