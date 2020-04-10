(** *)

type card_type

type card_effects

type card

type card_stacks

exception UnknownCard of card


(** [card_shuffle lst] is a set-like list of cards out of their original order. *)
