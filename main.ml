(** @author: Primary author, Daphne Rios dr434
             Additional contributor: Susan Garry, shg64
*)

open Yojson.Basic

let start_screen = ANSITerminal.(print_string [blue]"\n\nWelcome to Betrayal of CU on the Hill! \n")

(** [more_players n state] adds a player at index [n] in the play order of
    [state].
    Precondition: 0 <= n <= 5*)
let more_players n state = 
  print_string "What is Player "; print_int (n+1); print_endline "'s name?";
  print_string "> ";
  let temp = read_line () |> String.trim |> String.escaped 
             |> String.split_on_char ' ' |> Command.remove_blanks 
             |> String.concat " "
  in 
  State.add_player temp state

(**[preface n state] prompts the player if they want to add another player to
   the game. If [n = 6] the game starts; otherwise it takes a string input
   [input] and adds a player with the name [input] to the play order at index
   [n]*)
let rec preface (n : int) (state : State.t) : State.t = 
  if (n = 6) then (print_endline "You cannot add more than 6 players"; state)
  else
    (print_endline "Are there any more players you would like to add?";
     print_string "> ";
     match read_line () with 
     | "no" -> state
     | "yes" -> more_players (n) state |> preface (n+1)
     | _ -> print_endline "What? I didn't understand that."; preface n state)

(** [parse_input ()] is [i] only if i is a well-formed command. 
    Otherwise, it will prompt the user again for input. *)
let rec parse_input () =
  match Command.parse (read_line ()) with
  | exception Command.Empty -> 
    print_endline "Where would you like to go?"; 
    print_string "> ";
    parse_input ()
  | exception _ -> 
    print_endline "I don't understand that."; 
    print_string "> ";
    parse_input ()
  | c -> c

(** [parse_move d state] is a new state [st] only if State.move_player in direction [d] in state [state] is a valid move. 
    Otherwise, the state remains unchanged. *)
let parse_move d state =
  try State.move_player d state with 
  | State.NoDoor -> 
    print_endline "You can't go that way! Go elsewhere.";
    state
  | State.EmptyTile -> 
    print_endline "Something went wrong, it's empty!";
    state
(*| _ -> 
  print_endline "Something went wrong! Oh no!!! ";
  print_newline ();
  state *)

let rec check_status_helper lst state = 
  match lst with 
  | [] -> state
  | h::t -> 
    begin match h with 
      | State.Win s -> print_string s; exit 0
      | State.Loss s -> print_string s; check_status_helper t state
    end

let check_status state = 
  state |> check_status_helper (State.get_status state)

(** [play st] resumes play from the game state in [state]. *)
let rec play state =
  print_newline ();
  print_string "It is "; print_string (State.player_desc state); 
  print_endline "'s turn.";
  print_endline (State.room_desc state);
  print_string "> ";
  match parse_input () with
  | Quit -> exit 0
  | Map -> Gui.print_board state; play state
  | Stats -> State.print_current_player state; play state;
    (** call [print_player p] for the current player in play *)
  | Go d -> state |> parse_move d |> check_status |> play

(** [main ()] prompts for the game to play, then starts it. *)
let main () =
  start_screen;
  let pre_state = "spooky_game.json" |> Yojson.Basic.from_file |> State.from_json
  in
  print_endline "What is Player 1's name?";
  print_string "> ";
  read_line () |> String.trim |> String.escaped 
  |> String.split_on_char ' ' |> Command.remove_blanks |> String.concat " " 
  |> pre_state |> preface 1 |> State.set_current_index 0 |> play

(* Execute the game engine. *)
let () = main ()