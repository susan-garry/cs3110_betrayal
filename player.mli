open Tiles

type player_stats
type player_condition = Winner | Loser |Playing

type t


(**[empty] returns a bare-bones player with all attributes set to 4*)
val empty : t

(**[get_name p] returns the name of [p]*)
val get_name : t -> string

(**[set_name n p] returns a player identical to [p] but whose name is [n]*)
val set_name : string -> t -> t

(**[player_location p] returns the tile where [player] is currently located*)
val get_loc : t -> Tiles.t

(** *)
val get_condition : t -> player_condition

(** *)
val set_condition : t -> player_condition -> t

(**[move p t] returns a player identical to [p] but located in [t]*)
val move : Tiles.t -> t -> t

(** *)
val get_stat_sanity : t -> int

(** *)
val get_stat_insight : t -> int

(** *)
val get_stat_strength : t -> int

(** *)
val get_stat_hunger : t -> int

(** *)
val set_stat_sanity : int -> t -> t

(** *)
val set_stat_insight : int -> t -> t

(** *)
val set_stat_strength : int -> t -> t

(** *)
val set_stat_hunger : int -> t -> t

(** [player_lose p count] is true if one of the player's stats is less than or equal to [count]. 
    Otherwise, false *)
val player_lose : t -> bool

(** [player_win p count] is true if one of the player's stats is greater than or euqal to [count]. 
    Otherwise, false. *)
val player_win : t -> bool

(** [print_player p] returns unit; printing out the name, location, and stats of player [p]. *)
val print_player : t -> unit

(**[tests] returns the list of test cases for the Player module *)
val tests : OUnit2.test list
