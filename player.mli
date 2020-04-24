open Tiles

type t

(**[empty] returns a bare-bones player with minimum attributes*)
val empty : t

(**[move p t] returns a player identical to [p] but located in [t]*)
val move : Tiles.t -> t -> t

(**[location p] returns the tile where [player] is currently located*)
val location : t -> Tiles.t

(**[get_next p] returns the next player in the turn lineup*)
val get_next : t -> t
