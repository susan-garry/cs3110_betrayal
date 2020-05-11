(* Takes a string of user input and converts it into a format that can be easily 
   used by other modules *)


(** The type [direction] represents the direction a player wants to proceed in. *)
type direction = 
  | Right | Left | Up | Down

(** The type [commmand] represents a player's course of action that is decomposed into a verb and possibly a direction. *)
type command = 
  | Go of direction
  | Map
  | Stats 
  | Quit

(** [choice] represents a player's response to a choice effect *)
type choice = Yes | No

(** Raised when an empty command is parsed. *)
exception Empty

(** Raised when a malformed command is encountered. *)
exception Malformed


(** [remove_blanks lst] removes any empty strings in string list [lst]. *)
val remove_blanks : string list -> string list

(** [parse str] parses a player's input into a [command], as follows. 
    The first word (i.e., consecutive sequence of non-space characters) of [str] 
    will indicate the verb & direction the player will move/perform.

    Requires: [str] contains only alphanumeric (A-Z, a-z, 0-9) and space 
    characters (only ASCII character code 32; not tabs or newlines, etc.).

    Raises: [Empty] if [str] is the empty string or contains only spaces. 

    Raises: [Malformed] if the command is malformed. A command
    is {i malformed} if the verb is neither "quit" nor a common direction like 
    "south" or "up", or if the verb is "quit" and there is a non-empty string 
    list. *)
val parse : string -> command

(** [eff_parse str] parses a player's input into a [choice].

    Requires: [str] contains only alphanumeric (A-Z, a-z, 0-9) and space 
    characters (only ASCII character code 32; not tabs or newlines, etc.).

    Raises: [Empty] if [str] is the empty string or contains only spaces. 

    Raises: [Malformed] if the choice is malformed. A choice is {i malformed} if
    the input is neither "yes" nor "no" (nor capitalized variants). *)
val eff_parse : string -> choice

val tests : OUnit2.test list