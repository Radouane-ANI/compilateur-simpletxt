type document = element list

and element =
  | HEADER1 of fragment list
  | HEADER2 of fragment list
  | Paragraph of fragment list
  | List of element list 
  | Item of fragment list

and fragment =
  | Word of string
  | Italic of string list
  | Bold of string list
  | Link of string list * string
