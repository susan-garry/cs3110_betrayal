(** The tiles that make up the game board. Tiles represent the physical board
    locations, whereas rooms are the randomized qualities of these locations.

    This module defines the data structure for tiles. It handles updating and
    querying that data, as well as adding new tiles to the board.

    @author: Primary author Isabel Selin, is389
*)

(** The abstract type of values representing tiles.*)
type t

(** The type of exit qualifiers. *)
type exit_qual = Discovered | Undiscovered | Nonexistent

(** The type of tile exits. *)
type exit = exit_qual * (t option)

(** The type of tile coordinates. *)
type coord = int*int

(** Raised if character does not correspond to a direction. *)
exception InvalidDirection of char

(** [empty] is an empty tile to provide the origin.
    Warning: does not make a second empty tile once the exits to the first tile
            have been changed*)
val empty : t

(** [new_tile t dir] is a new tile linked to the exit of tile [t] in 
    the cardinal direction indicaded by [dir].
    Requires: [dir] is 'N', 'E', 'S' or 'W' (or lowercase counterparts);
            [t] does not currently connect to a tile in direction [dir].
    Raises: [InvalidDirection dir] if [dir] does not satisfy the requirement. *)
val new_tile : t -> char -> t

(** [get_n t] is the north exit of tile [t]. *)
val get_n : t -> exit

(** [set_n t qual] is tile [t] with its north exit set to type [qual]. *)
val set_n : t -> exit_qual -> unit

(** [get_e t] is the east exit of tile [t]. *)
val get_e : t -> exit

(** [set_e t qual] is tile [t] with its east exit set to type [qual]. *)
val set_e : t -> exit_qual -> unit

(** [get_s t] is the south exit of tile [t]. *)
val get_s : t -> exit

(** [set_s t qual] is tile [t] with its south exit set to type [qual]. *)
val set_s : t -> exit_qual -> unit

(** [get_w t] is the west exit of tile [t]. *)
val get_w : t -> exit

(** [set_w t qual] is tile [t] with its west exit set to type [qual]. *)
val set_w : t -> exit_qual -> unit

(** [get_coords t] is the coordinate pair of tile [t]. *)
val get_coords : t -> coord

(** [get_room t] is the room option contained in tile [t].*)
val get_room : t -> Rooms.t option

(** [fill_tile t r] is tile [t] with its room set to [r]. Randomly chooses exits
    to be assigned as nonexistent. Updates exits of tiles surrounding [t]. *)
val fill_tile : t -> Rooms.t -> t

(** [fill_start t r] is tile [t] with its room set to [r] and all exits open.
    Updates exits of tiles surrounding [t].*)
val fill_start : t -> Rooms.t -> t

(** [close t] sets the Undiscovered exits of tile [t] to Nonexistent *)
val close: t -> unit

(* ----------------------------------- *)

(** [tests] is a list of OUnit test cases for all functions in Tiles. *)
val tests : OUnit2.test list