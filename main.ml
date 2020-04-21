open Rooms
open Command
open State

(** [main ()] prompts for the game to play, then starts it. *)
let main () =
  ANSITerminal.(print_string [red]
                  "\n\nWelcome to Betrayal of CU on the Hill! \n");
  print_endline "What is your nickname? \n";
  print_string  "> ";
  match read_line () with
  | exception End_of_file -> ()
  | _ -> print_endline "Very nice!"

(* Execute the game engine. *)
let () = main ()