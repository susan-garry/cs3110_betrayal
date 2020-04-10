type card_type = Item | Omen | Event
type card_effect = {e_description: string; e_effects: string list option}
type card = {c_type: card_type; name: string; description: string; effects: card_effect}
type card_stack = {items: card list list; omens: card list; events: card list}

exception UnknownCardEffect of card_effect
exception UnknownCard of card
