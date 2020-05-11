(** @author: Primary author: Daphne Rios, dr434
             Secondary author: Susan Garry, shg64
*)

open Tiles

(** Type [player_stats] is the abstract representation of a player's physical and mental conditions. *)
type player_stats

(** Type [player_condition] is the abstract representation of a player's playing status: whether they have won or lost the game or are still playing. *)
type player_condition = 
  | Winner of (string -> string)
  | Loser of (string -> string)
  | Playing

(**The abstract type for values representing a player *)
type t


(**[empty] returns a bare-bones player with all attributes set to 4*)
val empty : t

(**[get_name p] returns the name of [p]*)
val get_name : t -> string

(**[set_name n p] returns a player identical to [p] but whose name is [n]*)
val set_name : string -> t -> t

(**[player_location p] returns the tile where [player] is currently located*)
val get_loc : t -> Tiles.t

(**[get_condition p] returns the player_condition of [p]*)
val get_condition : t -> player_condition

(**[move p t] returns a player identical to [p] but located in [t]*)
val move : Tiles.t -> t -> t

(**[get_stat_sanity p] returns the [player_stats] field [sanity] of [p]*)
val get_stat_sanity : t -> int

(**[get_stat_insight p] returns the [player_stats] field [insight] of [p]*)
val get_stat_insight : t -> int

(**[get_stat_strength p] returns the [player_stats] field [strength] of [p]*)
val get_stat_strength : t -> int

(**[get_stat_hunger p] returns the [player_stats] field [hunger] of [p]*)
val get_stat_hunger : t -> int

(**[get_stat_sanity p] returns returns a player identical to [p] but whose [player_stats] field [sanity] is [n]*)
val set_stat_sanity : int -> t -> t

(**[get_stat_insight p] returns returns a player identical to [p] but whose [player_stats] field [insight] is [n]*)
val set_stat_insight : int -> t -> t

(**[get_stat_strength p] returns returns a player identical to [p] but whose [player_stats] field [strength] is [n]*)
val set_stat_strength : int -> t -> t

(**[get_stat_hunger p] returns returns a player identical to [p] but whose [player_stats] field [hunger] is [n]*)
val set_stat_hunger : int -> t -> t

(** [print_player p] returns unit; printing out the name, location, and stats of player [p]. *)
val print_player : t -> unit

(**[tests] returns the list of test cases for the Player module *)
val tests : OUnit2.test list
