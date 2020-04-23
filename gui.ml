open ANSITerminal
open Command


let start_screen = print_string [red]"\n\nWelcome to Betrayal of CU on the Hill! \n"

let prompt = print_endline "> ";

type gui_tile = {top:string; middle: string; bottom: string}

let parse_a_tile = {
  top = " _____ "; 
  middle = "|     |";
  bottom = "|_____|"
}

let print_a_tile r = 
  print_endline r.top;
  print_endline r.middle;
  print_endline r.bottom

(** print " _____ \n|     |\n|     | \n|_____|" *)

(** print " _____ _____ _____ _____ _____ _____\n|     |     |     |     |     |     |\n|     |     |     |     |     |     |\n|_____|_____|_____|_____|_____|_____|" *)

