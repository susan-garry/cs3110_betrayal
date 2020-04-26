open ANSITerminal
open State
open OUnit2


type player_icon = {icon: string}

(** *)
type gui_tile = {top: string; middle:string; bottom:string; players: player_icon option list}
type gui_row = gui_tile list

(** *)
let top_options = ["       "; " _____ "; " _   _ "]
let middle_options = ["       "; "|     |"; "|      "; "      |"]
let bottom_options = ["       "; "|_____|"; "|_   _|"]


let rec e_ith_lst e i lst = 
  match lst with 
  | [] -> e::[]
  | h::t -> if (i==0) then h::e::t else h::(e_ith_lst e (i-1) t)


let parse_empty_tile = 
  {
    top = List.nth top_options 0;
    middle = List.nth middle_options 0;
    bottom = List.nth bottom_options 0;
    players = [None]
  }


let parse_tile til =
  let top_side =
    begin 
      match Tiles.get_n til with 
      | (Nonexistent, _) -> List.nth top_options 1
      | (_,_) -> List.nth top_options 2
    end in 
  let middle_side =
    begin 
      match Tiles.get_w til, Tiles.get_e til with 
      | (Nonexistent, _), (Nonexistent, _) -> List.nth middle_options 1
      | (Nonexistent,_), (_,_) -> List.nth middle_options 2
      | (_, _), (Nonexistent, _) -> List.nth middle_options 3
      | (_, _), (_,_) -> List.nth middle_options 0
    end in
  let bottom_side =
    begin 
      match Tiles.get_s til with 
      | (Nonexistent, _) -> List.nth bottom_options 1
      | (_, _) -> List.nth bottom_options 2
    end
  in {top = top_side;
      middle = middle_side;
      bottom = bottom_side;
      players = [None]
     }


let print_tile t = 
  print_endline t.top;
  print_endline t.middle;
  print_endline t.bottom


(** from one tile, i need to go north and west enough until there are no more north nor west tiles *)
let rec go_corner t = 
  let the_top =
    begin match Tiles.get_n t  with
      | (Nonexistent, _) -> t
      | (_, Some til) -> go_corner til
      | (_,_ ) -> t
    end
  in let the_leftest =
       begin match Tiles.get_w the_top with 
         | (Nonexistent, _) -> t
         | (_, Some til_2) -> go_corner til_2
         | (_,_ ) -> t
       end
  in the_leftest

let thing st =
  State.first_tile

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