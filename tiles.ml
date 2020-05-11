open Yojson.Basic.Util
open OUnit2
open Random

type coord = int*int

type exit_qual = Discovered | Undiscovered | Nonexistent

type t = {coord: coord; room: Rooms.t option; n_exit: exit ref; 
          e_exit: exit ref; s_exit: exit ref; w_exit: exit ref}
and exit = exit_qual * (t option)

exception InvalidDirection of char

(** [secret_chance] is the inverse chance of a secret door being created each
    time an exit of a new room is lined up with an existing room. *)
let secret_chance: int = 3
(** [new_chance] is the inverse chance that each unaligned door of a room being 
    discovered is set to Nonexistent. *)
let new_chance: int = 1

let empty = {coord = 0,0; 
             room = None;
             n_exit = ref (Undiscovered, None); 
             e_exit = ref (Undiscovered, None);
             s_exit = ref (Undiscovered, None);
             w_exit = ref (Undiscovered, None)}

let get_n t = !(t.n_exit)
let get_e t = !(t.e_exit)
let get_s t = !(t.s_exit)
let get_w t = !(t.w_exit)
let get_coords t = t.coord
let get_room t = t.room

let set_n t q = t.n_exit := q, snd (get_n t)
let set_e t q = t.e_exit := q, snd (get_e t)
let set_s t q = t.s_exit := q, snd (get_s t)
let set_w t q = t.w_exit := q, snd (get_w t)

(** returns the reference for t's north exit *)
let get_n_ref t = t.n_exit
(** returns the reference for t's east exit *)
let get_e_ref t = t.e_exit
(** returns the reference for t's south exit *)
let get_s_ref t = t.s_exit
(** returns the reference for t's west exit *)
let get_w_ref t = t.w_exit

(** [link_exits_n t1 t_op g1 g2] links [t1] and [t2] through the exits 
    returned by [g1 t1] and [g2 t2] if [t_op] = [Some t2]. If [t_op] = [None],
    nothing happens. *)
let link_exits_n (t1: t) (t_op: t option) (g1:t->exit ref) (g2:t->exit ref) =
  match t_op with
  |None ->()
  |Some t2 -> let ex = g2 t2 in ex := (fst !ex, Some t1); 
    let ex = g1 t1 in 
    if t2.room = None then ex := (fst !ex, Some t2) 
    else ex := (Discovered, Some t2) 

(** [new_tile_helper tn te ts tw] creates a new tile and links it to [tn] on its
    north side, [te] on its east side, [ts] on its south side and [tw] on its 
    west side. *)
let new_tile_helper (tn:t option) (te:t option) (ts:t option) (tw:t option)
    (x:int) (y:int): t =
  let t_new = {coord = x,y; 
               room = None;
               n_exit = ref (Undiscovered, None); 
               e_exit = ref (Undiscovered, None);
               s_exit = ref (Undiscovered, None);
               w_exit = ref (Undiscovered, None)} in
  link_exits_n t_new tn get_n_ref get_s_ref;
  link_exits_n t_new te get_e_ref get_w_ref;
  link_exits_n t_new ts get_s_ref get_n_ref;
  link_exits_n t_new tw get_w_ref get_e_ref;
  t_new

(** [two_from t f1 f2] is the tile two away from [t]  *)
let two_from (t:t) (f1:t -> exit) (f2:t->exit) =
  match snd (f1 t) with
  |None -> None
  |Some t2 -> snd (f2 t2)

(* Doesn't check for tiles directly across the new tile, since rows and columns
   should be created in order. *)
let new_tile (t:t) (dir:char): t =
  match dir with
  |'N' -> if snd (get_n t) != None 
    then failwith "tile already exists" 
    else let ts = Some t in
      let te = two_from t get_e get_n in
      let tw = two_from t get_w get_n in
      let tn = None in new_tile_helper tn te ts tw (fst t.coord) (snd t.coord+1)
  |'E' -> if snd (get_e t) != None 
    then failwith "tile already exists" 
    else let tw = Some t in
      let tn = two_from t get_n get_e in
      let ts = two_from t get_s get_e in
      let te = None in new_tile_helper tn te ts tw (fst t.coord+1) (snd t.coord)
  |'S' -> if snd (get_s t) != None 
    then failwith "tile already exists" 
    else let tn = Some t in
      let te = two_from t get_e get_s in
      let tw = two_from t get_w get_s in
      let ts = None in new_tile_helper tn te ts tw (fst t.coord) (snd t.coord-1)
  |'W' -> if snd (get_w t) != None 
    then failwith "tile already exists" 
    else let te = Some t in
      let tn = two_from t get_n get_w in
      let ts = two_from t get_s get_w in
      let tw = None in new_tile_helper tn te ts tw (fst t.coord-1) (snd t.coord)
  | _ -> raise (InvalidDirection dir)

(** [link_exits_r t1 t_op g1 g2] links [t1] and [t2] through the exits 
    returned by [g1 t1] and [g2 t2] and updates t2's exit to Discovered 
    if [t_op] = [Some t2]. 
    If [t_op] = [None], there is a chance of 1 in [nc] that [fst g1 t] 
    is set to [Nonexistent]. *)
let link_exits_r t1 t_op (g1:t->exit ref) (g2:t->exit ref) nc: unit =
  let new_set () = 
    if nc !=0 && Random.int nc = 1 then 
      (g1 t1) := Nonexistent, t_op 
    else () in
  let update_other t2 = let ex2 = g2 t2 in if fst (!ex2) = Undiscovered 
    then ex2 := Discovered, Some t1 else ex2 := fst !ex2, Some t1 in
  let secret_set () = if Random.int secret_chance = 1 
    then (g1 t1) := Nonexistent, t_op else () in
  match t_op with
  |None -> new_set ()
  |Some t2 -> (if t2.room = None then new_set ()
               else let ex2 = g2 t2 in 
                 if fst !(ex2) = Nonexistent then secret_set ()
                 else g1 t1 := Discovered, t_op);
    update_other t2

(** [fill_helper t r chance] is tile [t] with its room set to [r] and a chance
    of one in [chance] that its new exits are closed. Updates exits of tiles
    surrounding [t]. *)
let fill_helper t r chance=
  Random.self_init ();
  if t.room != None then t else
    let t_new = {t with room= Some r} in
    link_exits_r t_new (snd !(t_new.n_exit)) get_n_ref get_s_ref chance;
    link_exits_r t_new (snd !(t_new.e_exit)) get_e_ref get_w_ref chance;
    link_exits_r t_new (snd !(t_new.s_exit)) get_s_ref get_n_ref chance;
    link_exits_r t_new (snd !(t_new.w_exit)) get_w_ref get_e_ref chance;
    t_new

let fill_tile t r = fill_helper t r new_chance

let fill_start t r = fill_helper t r 0

let close t =
  let update e = if fst !e = Undiscovered then e:= Nonexistent, (snd !e) else ()
  in update t.n_exit; update t.e_exit; update t.s_exit; update t.w_exit

(* ------------------------------------------------- *)
(* CODE FOR TESTING *)

(** [assert_ex_equal ex1 ex2] asserts that exits [ex1] and [ex2] are equal. *)
let assert_ex_equal (ex1: exit) (ex2:exit): unit =
  assert_equal (fst ex1) (fst ex2);
  match (snd ex1, snd ex2) with
  | None, None -> assert_equal true true
  | Some t1, Some t2 -> assert_equal t1.coord t2.coord;
    assert_equal t1.room t2.room;
    assert_equal (t1.n_exit == t2.n_exit) true;
    assert_equal (t1.e_exit == t2.e_exit) true;
    assert_equal (t1.s_exit == t2.s_exit) true;
    assert_equal (t1.w_exit == t2.w_exit) true
  | _ -> failwith "not equal"

(** [make_coords_test name tile expected_output] constructs an OUnit
    test named [name] that asserts the quality of [expected_output]
    with [get_coords tile]. *)
let make_coords_test  
    (name: string)
    (tile: t)
    (expected_output : int * int) : test = 
  name >:: (fun _ -> assert_equal expected_output (get_coords tile))

(** [make_room_test name tile expected_output] constructs an OUnit
    test named [name] that asserts the quality of [expected_output]
    with [get_room tile]. *)
let make_room_test  
    (name: string)
    (tile: t)
    (expected_output : Rooms.t option) : test = 
  name >:: (fun _ -> assert_equal expected_output (get_room tile))

(** [make_exits_test name tile ex_n ex_e ex_s ex_w] constructs four OUnit tests
    named [name] cons-ed with the respective direction char that assert the 
    quality of [ex_n] with [get_n tile], [ex_e] with [get_e tile], [ex_s] with
    [get_s tile] and [ex_w] with [get_w tile]. *)
let make_exits_test  
    (name: string)
    (tile: t)
    (ex_n: exit)
    (ex_e: exit)
    (ex_s: exit)
    (ex_w: exit) : test list = [
  String.concat ", " [name; "N"] >:: (fun _ -> 
      assert_ex_equal ex_n (get_n tile));
  String.concat ", " [name; "E"] >:: (fun _ -> 
      assert_ex_equal ex_e (get_e tile));
  String.concat ", " [name; "S"] >:: (fun _ -> 
      assert_ex_equal ex_s (get_s tile));
  String.concat ", " [name; "W"] >:: (fun _ -> 
      assert_ex_equal ex_w (get_w tile));
]

let s1_t1 = {coord = 0,0; 
             room = None;
             n_exit = ref (Undiscovered, None); 
             e_exit = ref (Undiscovered, None);
             s_exit = ref (Undiscovered, None);
             w_exit = ref (Undiscovered, None)}
let s2_t1 = {coord = 0,0; 
             room = None;
             n_exit = ref (Undiscovered, None); 
             e_exit = ref (Undiscovered, None);
             s_exit = ref (Undiscovered, None);
             w_exit = ref (Undiscovered, None)}
let s2_t2 = new_tile s2_t1 'N'
let s2_t3 = new_tile s2_t2 'E'
let s2_t4 = new_tile s2_t3 'S'
let s2_t5 = new_tile s2_t1 'W'
let s3_t1 = {coord = 0,0; 
             room = None;
             n_exit = ref (Undiscovered, None); 
             e_exit = ref (Undiscovered, None);
             s_exit = ref (Undiscovered, None);
             w_exit = ref (Undiscovered, None)}
let s4_t1 = {coord = 0,0; 
             room = None;
             n_exit = ref (Undiscovered, None); 
             e_exit = ref (Undiscovered, None);
             s_exit = ref (Undiscovered, None);
             w_exit = ref (Undiscovered, None)}


let coords_tests = [
  make_coords_test "Solo tile" s1_t1 (0,0);
  make_coords_test "Multiple tiles, origin" s2_t1 (0,0);
  make_coords_test "Multiple tiles, added N" s2_t2 (0,1);
  make_coords_test "Multiple tiles, added E" s2_t3 (1,1);
  make_coords_test "Multiple tiles, added S" s2_t4 (1,0);
  make_coords_test "Multiple tiles, added W" s2_t5 (-1,0);
]

let room_tests = [
  make_room_test "Solo tile" s1_t1 None;
  make_room_test "Tile with neighbors" s2_t1 None;
]

let set_ex_tests = [
  "Set to Discovered None" >:: (fun _ -> 
      set_n s1_t1 Discovered;
      assert_ex_equal (Discovered, None) (get_n s1_t1));
  "Set to Undiscovered None" >:: (fun _ -> 
      set_n s1_t1 Undiscovered; 
      assert_ex_equal (Undiscovered, None) (get_n s1_t1));
  "Set to Nonexistant None" >:: (fun _ -> 
      set_s s1_t1 Nonexistent; 
      assert_ex_equal (Nonexistent, None) (get_s s1_t1));
]

let test_rooms = "test_rooms.json" |> Yojson.Basic.from_file |> member "deck"
                 |> Yojson.Basic.Util.to_list

let room0 = List.hd test_rooms |> Rooms.from_json

let fill_tile_tests =
  let s3_t1 = 
    fill_tile s3_t1 room0 in
  let st_room = fill_start s4_t1 room0 in
  [
    "Filled tile contains room" >:: (fun _ -> 
        assert_equal (get_room s3_t1) (Some room0));
    "Filled start tile contains room" >:: (fun _ -> 
        assert_equal (get_room st_room) (Some room0));
  ]

let tests = List.flatten [
    coords_tests;
    room_tests;

    make_exits_test "Solo tile" s1_t1 (Undiscovered, None) (Undiscovered, None)
      (Undiscovered, None) (Undiscovered, None);
    make_exits_test "Multiple tiles, origin" s2_t1 (Undiscovered, Some s2_t2) 
      (Undiscovered, Some s2_t4) (Undiscovered, None) 
      (Undiscovered, Some s2_t5);
    make_exits_test "Multiple tiles, added N" s2_t2 (Undiscovered, None) 
      (Undiscovered, Some s2_t3) (Undiscovered, Some s2_t1) 
      (Undiscovered, None);
    make_exits_test "Multiple tiles, added E" s2_t3 (Undiscovered, None) 
      (Undiscovered, None) (Undiscovered, Some s2_t4) 
      (Undiscovered, Some s2_t2);
    make_exits_test "Multiple tiles, added S" s2_t4 (Undiscovered, Some s2_t3) 
      (Undiscovered, None) (Undiscovered, None) (Undiscovered, Some s2_t1);
    make_exits_test "Multiple tiles, added W" s2_t5 (Undiscovered, None) 
      (Undiscovered, Some s2_t1) (Undiscovered, None) (Undiscovered, None);

    set_ex_tests;

    fill_tile_tests;
  ]