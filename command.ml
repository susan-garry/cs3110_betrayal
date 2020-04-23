

type direction = 
  | Right | Left | Up | Down
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
      | "right" | "east" -> Right
      | "left" | "west" -> Left
      | "up" | "north" -> Up
      | "down" | "south" -> Down
      | "quit" -> if (t == []) then Quit else raise (Malformed)
      | _ -> raise (Malformed) end