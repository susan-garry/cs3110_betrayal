open ANSITerminal
open State
open OUnit2


type player_icon = {icon: string}

(** *)
let top_options = ["       "; " _____ "; " _   _ "]
let middle_options = ["       "; "|     |"; "|      "; "      |"]
let bottom_options = ["       "; "|_____|"; "|_   _|"]


(** [e_ith_lst e i lst] is a list with element [e] in the [i]th position of list [lst] *)
let rec e_ith_lst e i lst = 
  match lst with 
  | [] -> e::[]
  | h::t -> if (i==0) then h::e::t else h::(e_ith_lst e (i-1) t)

(** I got to account for when the tile is None *)
let parse_top til =
  match Tiles.get_n til with 
  | (Nonexistent, _) -> List.nth top_options 1
  | (_,_) -> List.nth top_options 2

let parse_top_II til = 
  match Tiles.get_n til with 
  | (_, _) -> List.nth middle_options 1

let parse_middle til =
  match Tiles.get_w til, Tiles.get_e til with 
  | (Nonexistent, _), (Nonexistent, _) -> List.nth middle_options 1
  | (Nonexistent,_), (_,_) -> List.nth middle_options 2
  | (_, _), (Nonexistent, _) -> List.nth middle_options 3
  | (_, _), (_,_) -> List.nth middle_options 0

let parse_bottom til =
  match Tiles.get_s til with 
  | (Nonexistent, _) -> List.nth bottom_options 1
  | (_, _) -> List.nth bottom_options 2

(** [go_corner t] is the tile that does not have a tile above or to the left of it.  *)
let rec go_corner t = 
  let the_top =
    begin match Tiles.get_n t  with
      | (_, None) -> t
      | (_, Some til) -> go_corner til
    end
  in let the_leftest =
       begin match Tiles.get_w the_top with 
         | (_, None) -> t
         | (_, Some til_2) -> go_corner til_2
       end
  in the_leftest

(** *)
let corner_tile st =
  go_corner (State.first_tile st)

(** *)
let rec print_row_side func t =
  let room_side =
    match Tiles.get_room t with 
    | Some r -> Stdlib.print_string (func t);
    | None -> Stdlib.print_string (List.nth middle_options 0);
  in
  room_side;
  match Tiles.get_e t with
  | (_, Some til) -> print_row_side func til
  | (_, None) -> () 


let print_row t =
  print_row_side parse_top t;
  print_newline ();
  print_row_side parse_top_II t; 
  print_newline ();
  print_row_side parse_middle t;
  print_newline ();
  print_row_side parse_bottom t;
  print_newline ();
  ()

let rec print_board t =
  print_row t;
  match Tiles.get_s t with 
  | (_, Some til) -> print_board til
  | (_, None) -> ()



(*
let into_tile t = 
  failwith "Unimplemented"

let out_of_tile t = 
  failwith "Unimplemented"
*)

(** If I want to add another floor above, I'll need to change the top of the floor below to work as the above floor's bottom. And if I want to add a floor below, i need the to use the floor's bottom as the below's top. *)



(** print " _____ \n|     |\n|     | \n|_____|" *)

(** print " _____ _____ _____ _____ _____ _____\n|     |     |     |     |     |     |\n|     |     |     |     |     |     |\n|_____|_____|_____|_____|_____|_____|" *)

(** For printing a good square in utop, use this:
    print_endline "  _____ \n |     | \n |     |\n |_____|";;; *)

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

(*
let empty_state = "test_game.json" |> Yojson.Basic.from_file |> State.from_json *)

(** [make_go_corner_test name input expected_output] constructs an 
    OUnit test named [name] that asserts the quality of [expected_output] with [parse input].
    let make_go_corner_tile_test 
    (name : string)
    (input: Tiles.t)
    (expected_output : Tiles.exit_qual) : test = 
    name >:: (fun _ -> assert_equal expected_output (go_corner input |> Tiles.get_n |> fst))
*)

let go_corner_test = [
  (*  make_go_corner_tile_test "first test" (State.first_tile empty_state) Nonexistent*)
]

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