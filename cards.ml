type card_type = Item | Omen | Event

type card_effects = {top_description: string; special_description: string list option; bottom_description: string option}

type card = {c_type: card_type; name: string; description: string; effects: card_effects}

type card_stack = {items: card list list; omens: card list; events: card list}

exception UnknownCard of card
