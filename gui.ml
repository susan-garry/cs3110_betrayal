open ANSITerminal
open Command


let start_screen = print_string [red]"\n\nWelcome to Betrayal of CU on the Hill! \n"

let prompt = print_endline "> ";

type gui_tile = {top:string; middle: string; bottom: string; players:string list}

let parse_a_tile = {
  top = " _____ "; 
  middle = "|     |";
  bottom = "|_____|";
  players = []
}

let print_a_tile r = 
  print_endline r.top;
  print_endline r.middle;
  print_endline r.bottom

(** If I want to add another floor above, I'll need to change the top of the floor below to work as the above floor's bottom. And if I want to add a floor below, i need the to use the floor's bottom as the below's top. *)



(** print " _____ \n|     |\n|     | \n|_____|" *)

(** print " _____ _____ _____ _____ _____ _____\n|     |     |     |     |     |     |\n|     |     |     |     |     |     |\n|_____|_____|_____|_____|_____|_____|" *)

