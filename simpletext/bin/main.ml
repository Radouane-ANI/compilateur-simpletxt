let print_position lexbuf =
  let pos = lexbuf.Lexing.lex_curr_p in
  Printf.eprintf "Erreur à la ligne %d, colonne %d\n" pos.Lexing.pos_lnum
    (pos.Lexing.pos_cnum - pos.Lexing.pos_bol + 1)

let () =
  let chan = open_in "bin/test_input.txt" in
  let lexbuf = Lexing.from_channel chan in
  try
    let doc = Parser.main Lexer.token lexbuf in
    print_endline "Parsing OK!";
    Ast.write_document_to_file doc
  with Parser.Error ->
    print_position lexbuf;
    let lexeme = Lexing.lexeme lexbuf in
    Printf.eprintf "Lexème: '%s'\n" lexeme;
    prerr_endline "Erreur de parsing.";
    close_in chan
