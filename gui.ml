type player_icon = {icon: string}

exception PlayerNumbers

(** [top_options]/[middle_options]/[bottom_options] is a string list of possible ways a wall of a tile/room can be represented using ASCII representation. *)
let top_options = ["       "; " _____ "; " _   _ "]
let middle_options = ["       "; "|     |"; "|      "; "      |"]
let bottom_options = ["       "; "|_____|"; "|_   _|"]


(** [corner_tile st] is the first tile players are on in the game state. *)
let corner_tile st =
  State.first_tile st

(** *)
let players_in_room (til: Tiles.coord) (lst : (Tiles.coord * int list) list) = 
  begin match List.assoc_opt til lst with 
    | None -> []
    | Some v -> v
  end

(**  *)
let parse_top til p_lst =
  match Tiles.get_n til with 
  | (Nonexistent, _) -> List.nth top_options 1
  | (_,_) -> List.nth top_options 2

let parse_top_II til p_lst = 
  let players = players_in_room (Tiles.get_coords til) p_lst in 
  let room_wall = 
    match players with 
    | [] -> List.nth middle_options 1
    | h1::h2::h3::t -> "|" ^ string_of_int h1 ^ " " ^ string_of_int h2 ^ " " ^ string_of_int h3 ^ "|"
    | h1::h2::[] -> "| " ^ string_of_int h1 ^ " " ^ string_of_int h2 ^ " |"
    | h::[] -> "|  "^ string_of_int h ^ "  |"
  in room_wall

let parse_middle til p_lst =
  let players = players_in_room (Tiles.get_coords til) p_lst in
  let room_wall =
    match Tiles.get_w til, Tiles.get_e til with 
    | (Nonexistent, _), (Nonexistent, _) -> List.nth middle_options 1
    | (Nonexistent,_), (_,_) -> List.nth middle_options 2
    | (_, _), (Nonexistent, _) -> List.nth middle_options 3
    | (_, _), (_,_) -> List.nth middle_options 0 in 
  if (List.length players > 3) then 
    match (players |> List.tl |> List.tl |> List.tl) with 
    | [] -> room_wall
    | h1::h2::h3::t -> String.sub room_wall 0 1 ^ string_of_int h1 ^ " " ^ string_of_int h2 ^ " " ^ string_of_int h3 ^ String.sub room_wall 6 1
    | h1::h2::[] -> String.sub room_wall 0 2 ^ string_of_int h1 ^ " " ^ string_of_int h2 ^ String.sub room_wall 6 2
    | h::[] -> String.sub room_wall 0 3 ^ string_of_int h ^ String.sub room_wall 6 3
  else room_wall

let parse_bottom til p_lst =
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

(** [print_row_side] is unit; parses a side of a tile for a row of tiles. *)
let rec print_row_side func t (p : (Tiles.coord * int list) list) =
  let room_side =
    begin match Tiles.get_room t with 
      | Some r ->  func t p;
      | None -> List.nth middle_options 0;
    end
  in Stdlib.print_string room_side;
  match Tiles.get_e t with
  | (_, Some til) -> print_row_side func til p
  | (_, None) -> () 

(** [print_row_side] is unit; parses all sides of a tile for a row of tiles. *)
let print_row t p_lst =
  print_row_side parse_top t p_lst;
  print_newline ();
  print_row_side parse_top_II t p_lst; 
  print_newline ();
  print_row_side parse_middle t p_lst;
  print_newline ();
  print_row_side parse_bottom t p_lst;
  print_newline ();
  ()

let print_board st =
  let rec print_board_helper t st =
    let  p_lst =  State.get_locs st in
    print_row t p_lst;
    match Tiles.get_s t with 
    | (_, Some til) -> print_board_helper til st
    | (_, None) -> ()
  in print_board_helper (corner_tile st) st

