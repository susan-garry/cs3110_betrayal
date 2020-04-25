open ANSITerminal
open Tiles
open OUnit2


type walls = {top: string list; middle: string list; bottom: string list}
type player_icon = {icon: string}

type gui_tile = {top_side: string; middle_side:string; bottom_side:string; players: player_icon option list}
type gui_row = gui_tile list


let top_options = ["       "; " _____ "; " _   _ "]
let middle_options = ["       "; "|     |"; "|      "; "      |"]
let bottom_options = ["       "; "|_____|"; "|_   _|"]



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

(*
let parse_empty_tile = 
  failwith "Unimplemented"
  *)

let parse_tile til =
  let top =
    begin 
      match Tiles.get_n til with 
      | (Nonexistent, _) -> List.nth top_options 1
      | (_,_) -> List.nth top_options 2
    end in 
  let middle =
    begin 
      match Tiles.get_w til, Tiles.get_e til with 
      | (Nonexistent, _), (Nonexistent, _) -> List.nth middle_options 1
      | (Nonexistent,_), (_,_) -> List.nth middle_options 2
      | (_, _), (Nonexistent, _) -> List.nth middle_options 3
      | (_, _), (_,_) -> List.nth middle_options 0
    end in
  let bottom =
    begin 
      match Tiles.get_s til with 
      | (Nonexistent, _) -> List.nth bottom_options 1
      | (_, _) -> List.nth bottom_options 2
    end
  in {top_side = top;
      middle_side = middle;
      bottom_side = bottom;
      players = []
     }


let print_tile t = 
  print_endline t.top_side;
  print_endline t.middle_side;
  print_endline t.bottom_side

(*
let rec print_row lst =
  failwith "Unimplemented"

let into_tile t = 
  failwith "Unimplemented"

let out_of_tile t = 
  failwith "Unimplemented"
*)

(** If I want to add another floor above, I'll need to change the top of the floor below to work as the above floor's bottom. And if I want to add a floor below, i need the to use the floor's bottom as the below's top. *)



(** print " _____ \n|     |\n|     | \n|_____|" *)

(** print " _____ _____ _____ _____ _____ _____\n|     |     |     |     |     |     |\n|     |     |     |     |     |     |\n|_____|_____|_____|_____|_____|_____|" *)


(* ------------------------------------------------- *)
(* CODE FOR TESTING *)

(** [make_parse_test name input expected_output] constructs an 
    OUnit test named [name] that asserts the quality of [expected_output] with [parse input]. *)
(*   
let make_parse_tile_test 
    (name : string)
    (expected_output : gui_tile) : test = 
  name >:: (fun _ -> assert_equal expected_output (parse_tile))
  *)

let parse_test = [

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