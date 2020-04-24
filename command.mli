(* Takes a string of user input and converts it into a format that can be easily used by other modules *)


(** The type [direction] represents a player direction that is decomposed
    into a verb and possibly a string list. *)
type direction = 
  | Right | Left | Up | Down

type command = 
  |Go of direction | Quit

(** Raised when an empty direction is parsed. *)
exception Empty

(** Raised when a malformed direction is encountered. *)
exception Malformed


(** [parse str] parses a player's input into a [direction], as follows. 
    The first word (i.e., consecutive sequence of non-space characters) of [str] becomes the verb/direction the player will move. The rest of the words, if any, become a string list.

    Requires: [str] contains only alphanumeric (A-Z, a-z, 0-9) and space 
    characters (only ASCII character code 32; not tabs or newlines, etc.).

    Raises: [Empty] if [str] is the empty string or contains only spaces. 

    Raises: [Malformed] if the command is malformed. A direction
    is {i malformed} if the verb is neither "quit" nor a common direction like "south" or "up",
    or if the verb is "quit" or a direction and there is a non-empty string list. *)
val parse : string -> command

val tests : OUnit2.test list