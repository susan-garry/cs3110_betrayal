open Tiles

type t

(**[move p t] returns a player identical to [p] but located in [t]*)
val move : Tiles.t -> t -> t

(**[location p] returns the tile where [player] is currently located*)
val location : t -> Tiles.t

(**[get_] *)
