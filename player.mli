
type player_id
type player_stats

type t

exception LastPlayer

(**[empty] returns a bare-bones player with minimum attributes*)
val empty : t

(**[move p t] returns a player identical to [p] but located in [t]*)
val move : Tiles.t -> t -> t

(**[get_name p] returns the name of [p]*)
val get_name : t -> string

(**[set_id n p] returns a player identical to [p] but whose name is [n]*)
val set_name : string -> t -> t

(**[player_location p] returns the tile where [player] is currently located*)
val get_loc : t -> Tiles.t

(** [player_lose p count] is true if one of the player's stats is less than or equal to [count]. 
    Otherwise, false *)
val player_lose : t -> int -> bool

(** [player_win p count] is true if one of the player's stats is greater than or euqal to [count]. 
    Otherwise, false. *)
val player_win : t -> int -> bool

(** [print_player p] returns unit; printing out the name, location, and stats of player [p]. *)
val print_player : t -> unit

(**[tests] returns the list of test cases for the Player module *)
val tests : OUnit2.test list
