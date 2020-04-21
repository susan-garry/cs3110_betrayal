open Yojson.Basic.Util

type room_id = string
type eff_lst = int list

type t = {id: room_id; desc: string; effects: eff_lst}

let from_json json =
  let j_assoc = json |> to_assoc in
  {id = j_assoc |> List.assoc "id" |> to_string;
   desc = j_assoc |> List.assoc "description" |> to_string;
   effects = j_assoc |> List.assoc "effects" |> to_list 
             |> List.mapi (fun j_int -> to_int)}

let room_id r = r.id

let room_desc r = r.desc

let room_effects r = r.effects