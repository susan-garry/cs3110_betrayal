(** Room information that gets placed into a tile. Whereas tiles represent the
    physical aspect of a spot, rooms contain the qualitative info, such as
    descriptions and effects.

    This module defines the data structure for rooms. It handles loading that
    data from JSON files and querying that data.

    @author: Primary author Isabel Sein, is389
*)

(** The abstract type of values representing rooms *)
type t

(** The type of room names *)
type room_id = string

(** The type of effect sets *)
type eff_lst = Yojson.Basic.t list

(** [from_json j] is the room that [j] represents.
    Requires: [j] is a valid JSON room representation. *)
val from_json : Yojson.Basic.t -> t

(** [room_id r] is the name of room [r]. *)
val room_id : t -> room_id

(** [room_desc r] is the description of room [r]. *)
val room_desc : t -> string

(** [init_effects r] is the list of effects that occur when room [r] is first
    entered. *)
val init_effects : t -> eff_lst

(** [rep_effects r] is the list of effects that occur each time room [r] is
    entered. *)
val rep_effects : t -> eff_lst

(* ----------------------------------- *)

(** [tests] is a list of OUnit test cases for all functions in Tiles. *)
val tests : OUnit2.test list