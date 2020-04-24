open ANSITerminal
open Tiles
open OUnit2


type gui_tile = {top:string; middle: string; bottom: string; players:string option list}
type tile_floor = gui_tile list
type player_icon = {icon: string}


let player_count_question = "How many players are playing?"

let rec player_count n = 
  begin match n with 
    | 0 -> "umm, no. Please try again.";
    | 1 | 2 | 3 | 4 | 5 | 6 -> "Perfect! Then let's get started."
    | _ -> "Sorry, We need 1-6 players. Please try again."
  end

let rec e_ith_lst e i lst = 
  match lst with 
  | [] -> e::[]
  | h::t -> if (i==0) then h::e::t else h::(e_ith_lst e (i-1) t)

let parse_tile = {
  top = " _____ "; 
  middle = "|     |";
  bottom = "|_____|";
  players = []
}

let parse_empty_tile = {
  top = "       "; 
  middle = "       ";
  bottom = "       ";
  players = []
}


let print_tile t = 
  print_endline t.top;
  print_endline t.middle;
  print_endline t.bottom


let into_tile t = 
  failwith "Unimplemented"

let out_of_tile t = 
  failwith "Unimplemented"

(** If I want to add another floor above, I'll need to change the top of the floor below to work as the above floor's bottom. And if I want to add a floor below, i need the to use the floor's bottom as the below's top. *)



(** print " _____ \n|     |\n|     | \n|_____|" *)

(** print " _____ _____ _____ _____ _____ _____\n|     |     |     |     |     |     |\n|     |     |     |     |     |     |\n|_____|_____|_____|_____|_____|_____|" *)


(* ------------------------------------------------- *)
(* CODE FOR TESTING *)

(** [make_parse_test name input expected_output] constructs an 
    OUnit test named [name] that asserts the quality of [expected_output] with [parse input]. *)
let make_parse_tile_test 
    (name : string)
    (expected_output : gui_tile) : test = 
  name >:: (fun _ -> assert_equal expected_output (parse_tile))

let parse_test = [
  make_parse_tile_test "parse_room_tile" {top = " _____ ";middle = "|     |";bottom = "|_____|";players = []};
  make_parse_tile_test "parse_empty_tile" {top = "       "; middle = "       "; bottom = "       "; players = []}
]

let into_tile_test = [

]

let out_of_tile_test = [

]

let tests = List.flatten [
    parse_test;
    into_tile_test;
    out_of_tile_test
  ]