open ANSITerminal
open Command


type gui_tile = {top:string; middle: string; bottom: string; players:string list}


let start_screen = ANSITerminal.(print_string [blue]"\n\nWelcome to Betrayal of CU on the Hill! \n")

let prompt = print_endline "> "

let parse_a_tile = {
  top = " _____ "; 
  middle = "|     |";
  bottom = "|_____|";
  players = []
}

let print_a_tile t = 
  print_endline t.top;
  print_endline t.middle;
  print_endline t.bottom

(** If I want to add another floor above, I'll need to change the top of the floor below to work as the above floor's bottom. And if I want to add a floor below, i need the to use the floor's bottom as the below's top. *)



(** print " _____ \n|     |\n|     | \n|_____|" *)

(** print " _____ _____ _____ _____ _____ _____\n|     |     |     |     |     |     |\n|     |     |     |     |     |     |\n|_____|_____|_____|_____|_____|_____|" *)

