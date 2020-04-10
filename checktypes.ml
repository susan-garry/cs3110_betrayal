module type CardsSig = sig
  type card_type
  type card_effects
  type card
  type card_stacks
  exception UnknownCard of card
end

module CardsCheck : CardsSig = Cards

module type RoomsSig = sig
  type floor 
  type tile
end

module RoomsCheck : RoomsSig = Rooms

module type AuthorSig = sig
  val hours_worked : int
end

(** [Unbound module Author] error *)
(** module AuthorCheck : AuthorSig = Author *)