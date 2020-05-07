(** @author: Primary author, Susan Garry shg64
             Additional contributor: Isabel Selin, is389 
*)

(**The abstract type for values representing a game state *)
type t

(**The abstract type representing winning and losing conditions *)
type outcome = Win of string | Lose of string

exception EmptyTile
exception FullGame
exception NoDoor
exception OutOfBounds

(**[from_json json] takes a json file and creates the initial game state. The
   play order is initialized with an "empty" player.*)
val from_json : Yojson.Basic.t -> t

(**[get_first_tile t] returns the upper left corner tile in [t] *)
val first_tile : t -> Tiles.t

(**[room_id st] returns the name of the room occupied by the player who is 
   currently in play. 
   Raises EmptyTile if that tile is empty. *)
val room_id : t -> string

(**[get_room_descr st] returns the description of the room occupied by the
   player who is currently in play. 
   Raises EmptyTile if that tile is empty. *)
val room_desc : t -> string

(**[player_name st] returns the name of the player who is currently in play *)
val player_name : t -> string

(**[player_id st] returns the id of the player who is currently in play *)
val player_desc : t -> string

(**[add_player name st] adds a player with name [name] in the same room as the 
   current player to the end of the play order of [st] and makes them the 
   current player.
   Requires that the current player in [st] is the last player in the play order
   and there are not already 9 players in the play order.
   Raises FullGame if there are already 9 player in the play order. *)
val add_player : string -> t -> t

(**[set_player p i st] returns a state in which the player located at position
   i in the play order (including nonexistent players) of [st] is [p] but is
   otherwise identical to [st]. *)
val set_player : Player.t -> int -> t -> t

(**[get_players st] returns an array of all of the players in [st], in their
   player order *)
val get_players : t -> Player.t option array

(**[set_players p st] returns a state where all of the players and play order
   is given by [p] but is otherwise identical to [st]*)
val set_players : Player.t option array -> t -> t

(**[get_current_index st] returns the integer index of the location of the
   player who is currently in play in [st] *)
val get_current_index : t -> int

(**[set_current_index i st] returns a state where the index of the player who
   is currently in play is set to [i] if [0 <= i <= 8] but is otherwise 
   identical to [st].
   Raises OutOfBounds if [i < 0] or [i > 8] *)
val set_current_index : int -> t -> t

(**[get_locs st] returns an association list of tile coordinates and 
   player lists, 
   where a tile coordinate maps to a list of the players contained within it if there is at least one player inside of that room; 
   Otherwise it has no binding in the association list. *)
val get_locs : t -> (Tiles.coord * int list) list

(**[get_status st] returns a list of win/lose conditions that occurred during
   the last turn, with lose conditions appearing before the win conditions.*)
val get_status : t -> outcome list

(**[move_player d st] returns a state identical to [st] but with the player
   currently in play located in the tile in direction [d] relative to its 
   current location and the next player in the play order in play *)
val move_player : Command.direction -> t -> t

(** [print_current_player p] returns unit; printing out the name, location, and stats of the player [p] who is currently in play. *)
val print_current_player : t -> unit


(**[teleport tile] returns a player with the same attributes as [p] but located
   in [tile], regardless of whether or not [tile] is adjacent to the tile that
   the player is currently located in*)
(* val teleport : exit -> Player.t -> Player.t *)

(**[tests] returns a list of OUnit2 tests for the functions in state*)
val tests : OUnit2.test list