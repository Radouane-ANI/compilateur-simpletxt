{
open Parser
}

rule token = parse
  | "# "             { HEADER1 }
  | "## "            { HEADER2 }

  (* | "\\emph{"        { EMPH_OPEN }
  | "\\textbf{"      { BOLD_OPEN }  *)
  | "***"             { BOLD_ITALIC }
  | "**"             { BOLD_MARK }
  | "*"              { ITALIC_MARK }

  | "\\color"         { COLOR }
  | "{"               { LBRACE }
  | "}"               { RBRACE }

  | "["              { LBRACKET }
  | "]"              { RBRACKET }
  | "("              { LPAREN }
  | ")"              { RPAREN }
  | "\\begindocument" { BEGINDOCUMENT } 
  | "\\enddocument"   { ENDDOCUMENT }
  | "\\define"        { DEFINE }
  | "\\item" [' ' '\t']+ { ITEM }
  | "\\"[ 'a'-'z' 'A'-'Z' ]+ as nom { NOM(nom) }
  | '\n' ([' ' '\t']* '\n')+ { Lexing.new_line lexbuf;
                              Lexing.new_line lexbuf;
                              PARAGRAPH_BREAK }

  | [' ' '\t' ]+ { token lexbuf }
  | ['\n']+ { Lexing.new_line lexbuf; token lexbuf }

  | [^ '*' '#' '\\' '[' ']' '(' ')' '{' '}' ' ' '\n' '\t']+ as txt
                     { TEXT(txt) }

  | eof              { EOF }
