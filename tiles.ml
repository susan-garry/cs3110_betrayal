type coord = int*int

exception EmptyTile

type t = unit

type exit = Discovered of t | Undiscovered of t option | Nonexistent of t option

let new_tile t e =
  failwith "Unimplemented"

let get_n t =
  failwith "Unimplemented"

let set_n t e =
  failwith "Unimplemented"

let get_e t =
  failwith "Unimplemented"

let set_e t e =
  failwith "Unimplemented"

let get_s t =
  failwith "Unimplemented"

let set_s t e =
  failwith "Unimplemented"

let get_w t =
  failwith "Unimplemented"

let set_w t e =
  failwith "Unimplemented"

let get_coords t =
  failwith "Unimplemented"

let get_room t =
  failwith "Unimplemented"

let fill_tile t r =
  failwith "Unimplemented"
