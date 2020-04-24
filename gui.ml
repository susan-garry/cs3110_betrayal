open ANSITerminal


type gui_tile = {top:string; middle: string; bottom: string; players:string list}
type player_icon = {icon: string}


let player_count_question = "How many players are playing?"

let rec player_count n = 
  begin match n with 
    | 0 -> "umm, no. Please try again.";
    | 1 | 2 | 3 | 4 | 5 | 6 -> "Perfect! Then let's get started."
    | _ -> "Sorry, We need 1-6 players. Please try again."
  end

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

