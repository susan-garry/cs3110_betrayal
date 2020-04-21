(* Takes a string of user input and converts it into a format that can be easily used by other modules *)


(** The type [command] represents a player command that is decomposed
    into a verb and possibly a string list. *)
type command = 
  | Right | East
  | Left | West
  | Up | North
  | Down | South
  | Go of string list
  | Quit

(** Raised when an empty command is parsed. *)
exception Empty

(** Raised when a malformed command is encountered. *)
exception Malformed


(** [parse str] parses a player's input into a [command], as follows. 
    The first word (i.e., consecutive sequence of non-space characters) of [str] becomes the verb. The rest of the words, if any, become a string list.

    Requires: [str] contains only alphanumeric (A-Z, a-z, 0-9) and space 
    characters (only ASCII character code 32; not tabs or newlines, etc.).

    Raises: [Empty] if [str] is the empty string or contains only spaces. 

    Raises: [Malformed] if the command is malformed. A command
    is {i malformed} if the verb is neither "quit" nor "go" nor a common direction like "south" or "up",
    or if the verb is "quit" or a direction and there is a non-empty string list,
    or if the verb is "go" and there is an empty string list.*)
val parse : string -> command