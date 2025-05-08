%{
open Ast  
%}

%token HEADER1
%token HEADER2
%token ITEM
%token COLOR
%token LBRACE
%token RBRACE
// %token EMPH_OPEN
// %token BOLD_OPEN OPEN_ITEM
%token BEGINDOCUMENT
%token ENDDOCUMENT
%token DEFINE
%token <string> NOM
%token BOLD_ITALIC
%token BOLD_MARK
%token ITALIC_MARK
%token LBRACKET
%token RBRACKET
%token LPAREN
%token RPAREN
%token PARAGRAPH_BREAK
%token EOF
%token <string> TEXT 

%nonassoc LOWPRI
%nonassoc TEXT LBRACKET ITALIC_MARK BOLD_MARK BOLD_ITALIC COLOR NOM

%start main
%type <Ast.document> main  
%type <Ast.element> element
%type <Ast.fragment list> texte
%type <Ast.macro list> en_tete
%type <Ast.macro> macro
%type <Ast.element list> corps
%type <Ast.fragment> element_de_texte

%%

main:
  document EOF { $1 }

en_tete:
  macro en_tete { $1 :: $2 }
| BEGINDOCUMENT { [] }

macro:
  DEFINE LBRACE identifiant RBRACE LBRACE texte RBRACE { ($3,$6) }

identifiant:
  NOM { $1 }

document:
  en_tete corps ENDDOCUMENT { ($1, $2) }

corps:
  element PARAGRAPH_BREAK  corps { $1 :: $3 }
| element               { [$1] }

element:
   HEADER1 texte { HEADER1($2) }
 | HEADER2 texte { HEADER2($2) }
 | paragraphe_item        { $1 }

paragraphe_item:
  suite_items  { List($1) } 
| paragraphe   { $1 }

paragraphe:
  texte        { Paragraph($1) }
  
suite_items:
  item suite_items { $1 :: $2 }
| item             { [$1] }

item:
  ITEM LBRACE paragraphe item_complexe RBRACE { SOUSITEM($3, $4) }
| ITEM paragraphe               { ITEM($2) }

item_complexe:
  item_content item_complexe { $1 :: $2 }
|                            { [] }

item_content:
  paragraphe PARAGRAPH_BREAK { CONTENUE($1) }
| item            { $1 }

element_de_texte:
  txt                                 { $1 }
| COLOR LBRACE txt RBRACE LBRACE texte RBRACE { Color($3, $6) }
| LBRACKET texte RBRACKET LPAREN txt RPAREN { Link($2, $5) }

txt:
  TEXT                                { Word($1) }
| NOM                                 { Cle($1) }

texte:
  element_de_texte texte { $1 :: $2 }
| ITALIC_MARK texte2 texte  { StartItalic :: $2 @ $3 }
| BOLD_MARK texte3 texte      { StartBold :: $2 @ $3 }
| BOLD_ITALIC texte4 texte      { [StartBold;StartItalic] @ $2 @ $3 }
|           %prec LOWPRI { [] }
texte2:
  element_de_texte texte2 { $1 :: $2 }
| ITALIC_MARK                         { [EndItalic] }
|  BOLD_MARK texte4                       { [StartBold] @ $2 }

texte3:
  element_de_texte texte3 { $1 :: $2 }
|  BOLD_MARK                        { [EndBold] }
| ITALIC_MARK texte4                       { [StartItalic] @ $2 }

texte4:
  element_de_texte texte4 { $1 :: $2 }
|                   %prec LOWPRI       { [] }
| BOLD_ITALIC                        { [EndBold;EndItalic] }
| ITALIC_MARK texte3                    { [EndItalic] @ $2 }
|  BOLD_MARK texte2                       { [EndBold] @ $2 }

%%
