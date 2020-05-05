(* Takes a string of user input and converts it into a format that can be easily used by other modules *)


(** The type [direction] represents a player direction that is decomposed
    into a verb and possibly a string list. *)
type direction = 
  | Right | Left | Up | Down

type command = 
  | Go of direction
  | Map
  | Stats 
  | Quit

(** Raised when an empty command is parsed. *)
exception Empty

(** Raised when a malformed command is encountered. *)
exception Malformed


(** [parse str] parses a player's input into a [command], as follows. 
    The first word (i.e., consecutive sequence of non-space characters) of [str] will indicate the verb & direction the player will move/perform.

    Requires: [str] contains only alphanumeric (A-Z, a-z, 0-9) and space 
    characters (only ASCII character code 32; not tabs or newlines, etc.).

    Raises: [Empty] if [str] is the empty string or contains only spaces. 

    Raises: [Malformed] if the command is malformed. A command
    is {i malformed} if the verb is neither "quit" nor a common direction like "south" or "up",
    or if the verb is "quit" and there is a non-empty string list. *)
val parse : string -> command

val tests : OUnit2.test list