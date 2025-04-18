%{
open Ast  
%}

%token HEADER1
%token HEADER2
%token ITEM
// %token EMPH_OPEN
// %token BOLD_OPEN OPEN_ITEM
%token OPEN_BRACE
%token CLOSE_BRACE
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
%nonassoc TEXT LBRACKET ITALIC_MARK BOLD_MARK

%start main
%type <Ast.document> main  
%type <Ast.element> element
%type <Ast.fragment list> texte
%type <Ast.element list> corps
%type <string list> liste_mots
%type <Ast.fragment> element_de_texte

%%

main:
  document EOF { $1 }

document:
  corps { $1 }

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
  ITEM OPEN_BRACE paragraphe item_complexe CLOSE_BRACE { SOUSITEM($3, $4) }
| ITEM paragraphe               { ITEM($2) }

item_complexe:
  item_content item_complexe { $1 :: $2 }
|                            { [] }

item_content:
  paragraphe PARAGRAPH_BREAK { CONTENUE($1) }
| ITEM paragraphe            { ITEM($2) }

element_de_texte:
  TEXT                                { Word($1) }
| ITALIC_MARK liste_mots ITALIC_MARK { Italic($2) }
| BOLD_MARK liste_mots BOLD_MARK     { Bold($2) }
| LBRACKET liste_mots RBRACKET LPAREN TEXT RPAREN { Link($2, $5) }


texte:
  element_de_texte texte { $1 :: $2 }
|           %prec LOWPRI { [] }

liste_mots:
  TEXT liste_mots { $1 :: $2 }
|                 { [] }





%%
