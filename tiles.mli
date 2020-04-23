(** The tiles that make up the game board. Tiles represent the physical board
    locations, whereas rooms are the randomized qualities of these locations.

    This module defines the data structure for tiles. It handles updating and
    querying that data, as well as adding new tiles to the board.
*)

(** The abstract type of values representing tiles.*)
type t

(** The type of tile exits. *)
type exit = Discovered of t | Undiscovered of t option | Nonexistent of t option

(** The type of tile coordinates. *)
type coord = int*int

(** Raised when a room is called from an empty tile. *)
exception EmptyTile

(** Raised if character does not correspond to a direction. *)
exception InvaledDirection of char

(** [empty] is an empty tile.*)
val empty : t

(** [new_tile t dir] is tile [t] with a new tile linked to the exit in the
    cardinal direction indicaded by [dir]. Simply returns [t] if that exit
    already contains a tile.
    Requires: [dir] is 'N', 'E', 'S' or 'W' (or lowercase counterparts). *)
val new_tile : t -> char -> t

(** [get_n t] is the north exit of tile [t]. *)
val get_n : t -> exit

(** [set_n t e] is tile [t] with its north exit set to [e]. *)
val set_n : t -> exit -> t

(** [get_e t] is the east exit of tile [t]. *)
val get_e : t -> exit

(** [set_e t e] is tile [t] with its north exit set to [e]. *)
val set_e : t -> exit -> t

(** [get_s t] is the south exit of tile [t]. *)
val get_s : t -> exit

(** [set_s t e] is tile [t] with its north exit set to [e]. *)
val set_s : t -> exit -> t

(** [get_w t] is the west exit of tile [t]. *)
val get_w : t -> exit

(** [set_w t e] is tile [t] with its north exit set to [e]. *)
val set_w : t -> exit -> t

(** [get_coords t] is the coordinate pair of tile [t]. *)
val get_coords : t -> coord

(** [get_room t] is the room contained in tile [t].
    Raises: [EmptyTile] if [t] does not contain a room. *)
val get_room : t -> Rooms.t

(** [fill_tile t r] is tile [t] with its room set to [r]. *)
(* eventually this will randomize the number of exits and place them *)
val fill_tile : t -> Rooms.t -> t