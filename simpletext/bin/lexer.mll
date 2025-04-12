{
open Parser
}

rule token = parse
  | "# "             { HEADER1 }
  | "## "            { HEADER2 }

  (* | "\\emph{"        { EMPH_OPEN }
  | "\\textbf{"      { BOLD_OPEN }
  | "}"              { CLOSE_BRACE } *)
  | "**"             { BOLD_MARK }
  | "*"              { ITALIC_MARK }

  | "["              { LBRACKET }
  | "]"              { RBRACKET }
  | "("              { LPAREN }
  | ")"              { RPAREN }

  | "\\item" [' ' '\t']+ { ITEM }

  | "\n\n"           {Lexing.new_line lexbuf;Lexing.new_line lexbuf; NEWLINE }

  | [' ' '\t' ]+ { token lexbuf }
  | ['\n']+ { Lexing.new_line lexbuf; token lexbuf }

  | [^ '*' '#' '\\' '[' ']' '(' ')' ' ' '\n' '\t']+ as txt
                     { TEXT(txt) }

  | eof              { EOF }
