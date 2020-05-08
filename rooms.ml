open Yojson.Basic.Util
open OUnit2

type room_id = string
type eff_lst = Yojson.Basic.t list

type t = {id: room_id; desc: string; init_effs: eff_lst; rep_effs: eff_lst}

let from_json json =
  let j_assoc = json |> to_assoc in
  {id = j_assoc |> List.assoc "id" |> to_string;
   desc = j_assoc |> List.assoc "description" |> to_string;
   init_effs = j_assoc |> List.assoc "initial effects" |> to_list;
   rep_effs = j_assoc |> List.assoc "repeated effects" |> to_list;}

let room_id r = r.id

let room_desc r = r.desc

let init_effects r = r.init_effs

let rep_effects r = r.rep_effs

(* ------------------------------------------------- *)
(* CODE FOR TESTING *)

let test_rooms = "test_rooms.json" |> Yojson.Basic.from_file |> member "deck"
                 |> Yojson.Basic.Util.to_list
let room0 = List.hd test_rooms |> from_json
let room1 = List.nth test_rooms 1 |> from_json
let room2 = List.nth test_rooms 2 |> from_json

let tests = [
  "room_id_test" >:: (fun _ -> assert_equal "None" (room_id room0));
  "room_desc_test" >:: (fun _ -> 
      assert_equal "You used none room. It wasn't very effective." 
        (room_desc room0));
]