open OUnit2

type direction = 
  | Right | Left | Up | Down 

type command = 
  | Go of direction 
  | Map
  | Quit

exception Empty

exception Malformed


(** [remove_blanks lst] removes any empty strings in string list [lst]. *)
let rec remove_blanks lst = 
  match lst with 
  | [] -> []
  | h::t -> begin
      match h with 
      | "" -> remove_blanks t
      | _ -> h::(remove_blanks t)
    end

let parse str = 
  let temp = str |> String.trim |> String.escaped |> String.split_on_char ' ' |> remove_blanks in 
  match (temp) with 
  | [] -> raise (Empty)
  | h::t -> begin
      match h with
      | "right" | "east" -> Go Right
      | "left" | "west" -> Go Left
      | "up" | "north" -> Go Up
      | "down" | "south" -> Go Down
      | "map" | "board" | "where" -> Map
      | "quit" -> if (t == []) then Quit else raise (Malformed)
      | _ -> raise (Malformed) end


(* ------------------------------------------------- *)
(* CODE FOR TESTING *)

(** [make_parse_test name input expected_output] constructs an 
    OUnit test named [name] that asserts the quality of [expected_output] with [parse input]. *)
let make_parse_test 
    (name : string) 
    (input: string) 
    (expected_output : command) : test = 
  name >:: (fun _ -> assert_equal expected_output (parse input))

let parse_test = [
  make_parse_test "Going Right" "right" (Go Right);
  make_parse_test "Going Left" "west" (Go Left);
  make_parse_test "Going Up" "up and down and all around" (Go Up);
  make_parse_test "Going Down_with Spaces" " down " (Go Down);
  make_parse_test "Viewing the map" "board game" (Map);
  make_parse_test "Quitting" "quit" (Quit);
]

let tests = List.flatten [
    parse_test
  ]