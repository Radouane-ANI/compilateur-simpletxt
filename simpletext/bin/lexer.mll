{
open Parser
}

rule token = parse
  | "# "             { HEADER1 }
  | "## "            { HEADER2 }

  (* | "\\emph{"        { EMPH_OPEN }
  | "\\textbf{"      { BOLD_OPEN }  *)
  | "{"              { OPEN_BRACE }
  | "}"              { CLOSE_BRACE }
  | "***"             { BOLD_ITALIC }
  | "**"             { BOLD_MARK }
  | "*"              { ITALIC_MARK }

  | "["              { LBRACKET }
  | "]"              { RBRACKET }
  | "("              { LPAREN }
  | ")"              { RPAREN }

  | "\\item" [' ' '\t']+ { ITEM }

  | '\n' ([' ' '\t']* '\n')+ { Lexing.new_line lexbuf;
                              Lexing.new_line lexbuf;
                              PARAGRAPH_BREAK }

  | [' ' '\t' ]+ { token lexbuf }
  | ['\n']+ { Lexing.new_line lexbuf; token lexbuf }

  | [^ '*' '#' '\\' '[' ']' '(' ')' ' ' '\n' '\t']+ as txt
                     { TEXT(txt) }

  | eof              { EOF }
