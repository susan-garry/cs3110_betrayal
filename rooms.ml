(** for rooms *)
type floor = BASEMENT | GROUND | UPPER

type tile = {floors:floor list; name:string; description:string option; symbols:string list option; doors:int}
(** for type [tile], change symbols into card_type list option *)

