(* hello_tiny.ml *)

(* --------- 1) Descriptive types ---------------------------------------- *)

(* Why an input is invalid *)
type bad_reason =
  | Not_single_char          (* more than one character *)
  | Not_a_letter             (* not a letter (digit, symbol, …) *)

(* How the raw input is classified *)
type classified_input =
  | Quit                     (* empty input: just Enter *)
  | One_letter of char       (* exactly one valid letter *)
  | Bad of bad_reason        (* any other invalid case *)

(* What our program logic wants to express *)
type outcome =
  | Bye
  | Letter_pair of char * char   (* (lowercase, uppercase) *)
  | Error_msg of string


(* --------- 2) Tiny helper functions (pure, single-purpose) -------------- *)

let is_ascii_letter (c : char) : bool =
  ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z')

let to_lower (c : char) : char =
  Char.lowercase_ascii c

let to_upper (c : char) : char =
  Char.uppercase_ascii c

let is_single_char (s : string) : bool =
  String.length s = 1

let classify (s : string) : classified_input =
  if s = "" then Quit
  else if not (is_single_char s) then Bad Not_single_char
  else
    let c = s.[0] in
    if is_ascii_letter c then One_letter c
    else Bad Not_a_letter

let decide (ci : classified_input) : outcome =
  match ci with
  | Quit -> Bye
  | One_letter c -> Letter_pair (to_lower c, to_upper c)
  | Bad Not_single_char ->
      Error_msg "Please enter EXACTLY ONE character (a single letter)."
  | Bad Not_a_letter ->
      Error_msg "Please enter a letter (not a number/symbol)."


(* --------- 3) Thin IO loop --------------------------------------------- *)

let rec loop () : unit =
  print_endline "Enter a letter (or press Enter to quit):";
  let line = read_line () in
  let result = decide (classify line) in
  match result with
  | Bye ->
      print_endline "Goodbye!"
  | Letter_pair (lo, up) ->
      Printf.printf "Lower: %c, Upper: %c\n\n" lo up;
      loop ()
  | Error_msg msg ->
      Printf.printf "[Error] %s\n\n" msg;
      loop ()


(* --------- 4) Entry point ---------------------------------------------- *)

let () = loop ()
