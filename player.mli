module type Player = sig
  type t

  type might
  type speed
  type knowledge
  type sanity

  (**[move p t] returns a player identical to [p] but located in [t]*)
  val move : player : Tile.t -> player

  (**[location p] returns the tile where [player] is currently located*)
  val location : player -> Tile.t

  (**[get_] *)
end
