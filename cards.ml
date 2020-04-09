type card_type = Item | Omen | Event
type card_effect = {e_description: string; e_effects: string option}
type card = {c_type: card_type; name: string; description: string; effects: card_effect}

exception UnknownCardEffect of card_effect
exception UnknownCard of card