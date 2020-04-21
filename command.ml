

type command = 
  | Right | East
  | Left | West
  | Up | North
  | Down | South
  | Go of string list
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
  failwith "Unimplemented"