type card_type = ITEM | OMEN | EVENT

type card_effects = {top_description: string; special_description: string list option; bottom_description: string option}

type card = {c_type: card_type; name: string; description: string; effects: card_effects}

type card_stacks = {items: card list; omens: card list; events: card list}

exception UnknownCard of card


(** Create some kind of function to shuffle the cards in a list *)
let card_shuffle lst = 
  print_endline "card_shuffle function isn't ready yet";
