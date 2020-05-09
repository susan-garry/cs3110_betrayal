open OUnit2
open ANSITerminal
open State


type player_icon = {icon: string}

exception PlayerNumbers

(** *)
let top_options = ["       "; " _____ "; " _   _ "]
let middle_options = ["       "; "|     |"; "|      "; "      |"]
let bottom_options = ["       "; "|_____|"; "|_   _|"]


(** *)
let corner_tile st =
  State.first_tile st
and 
  player_locations st = State.get_locs st

(** [e_ith_lst e i lst] is a list with element [e] in the [i]th position of list [lst] *)
let rec e_ith_lst e i lst = 
  match lst with 
  | [] -> e::[]
  | h::t -> if (i==0) then h::e::t else h::(e_ith_lst e (i-1) t)

(** *)
let players_in_room (til: Tiles.coord) (lst : (Tiles.coord * int list) list) = 
  begin match List.assoc_opt til lst with 
    | None -> []
    | Some v -> v
  end

let first_half bol lst =
  begin match List.length lst with
    | 0 -> lst
    | 1 | 2 | 3 -> if (bol) then lst else raise PlayerNumbers
    | 4 | 5 | 6 -> 
      if (bol) then [List.nth lst 0; List.nth lst 1; List.nth lst 2] 
      else List.tl lst |> List.tl |> List.tl
    | _ -> raise PlayerNumbers
  end

(** Insert player id into a string list *)
let insert_players s_lst lst = 
  let playerInRoom = 
    if (List.length lst >= 1) then e_ith_lst (List.hd lst) 1 s_lst 
    else s_lst
  in 
  let playerInRoom2 =
    if (List.length lst >= 2) then e_ith_lst (List.hd lst) 3 playerInRoom 
    else playerInRoom
  in 
  if (List.length lst <= 3) then e_ith_lst (List.hd lst) 6 playerInRoom2 else playerInRoom2

(** I got to account for when the tile is None *)
let parse_top til =
  match Tiles.get_n til with 
  | (Nonexistent, _) -> List.nth top_options 1
  | (_,_) -> List.nth top_options 2

let parse_top_II til = 
  List.nth middle_options 1

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
let rec print_row_side func t =
  let room_side =
    match Tiles.get_room t with 
    | Some r ->  func t;
    | None -> List.nth middle_options 0;
  in
  Stdlib.print_string room_side;
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



(* let into_tile t = 
   failwith "Unimplemented"

   let out_of_tile t = 
   failwith "Unimplemented"
*)


(* ------------------------------------------------- *)
(* CODE FOR TESTING *)

let tests = []