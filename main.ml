open Rooms
open Command
open State
open Gui

let start_screen = ANSITerminal.(print_string [blue]"\n\nWelcome to Betrayal of CU on the Hill! \n")
let prompt = print_endline "> "

(** [main ()] prompts for the game to play, then starts it. *)
let main () =
  start_screen;
  prompt;
  match read_line () with
  | exception End_of_file -> ()
  | _ -> print_endline "Very nice!"

(* Execute the game engine. *)
let () = main ()