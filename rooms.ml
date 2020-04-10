(** for rooms *)
type floor = BASEMENT | GROUND | UPPER

type tile = {floors : floor list; name : string; description : string option; symbols : Cards.card_type list option; doors : int}

