type document = element list

and item =
  | CONTENUE of element
  | SOUSITEM of element * item list
  | ITEM of element

and element =
  | HEADER1 of fragment list
  | HEADER2 of fragment list
  | Paragraph of fragment list
  | List of item list

and fragment =
  | Word of string
  | Italic of fragment list
  | Bold of fragment list
  | Link of fragment list * string

let rec string_of_fragment = function
  | Word w -> w
  | Italic words ->
      "<em>" ^ String.concat " " (List.map string_of_fragment words) ^ "</em>"
  | Bold words ->
      "<strong>"
      ^ String.concat " " (List.map string_of_fragment words)
      ^ "</strong>"
  | Link (words, url) ->
      "<a href=\"" ^ url ^ "\" >"
      ^ String.concat " " (List.map string_of_fragment words)
      ^ "</a>"

let string_of_fragments frags =
  List.map string_of_fragment frags |> String.concat " "

let rec string_of_element = function
  | HEADER1 frags -> "<h1>" ^ string_of_fragments frags ^ "</h1>"
  | HEADER2 frags -> "<h2>" ^ string_of_fragments frags ^ "</h2>"
  | Paragraph frags -> "<p>" ^ string_of_fragments frags ^ "</p>"
  | List items ->
      "<ul>" ^ String.concat "\n" (List.map string_of_item items) ^ "</ul>"

and string_of_item = function
  | CONTENUE c -> string_of_element c
  | SOUSITEM (e, items) ->
      "<li>" ^ string_of_element e ^ "</li> <ul>"
      ^ String.concat "\n" (List.map string_of_item items)
      ^ "</ul>"
  | ITEM i -> "<li>" ^ string_of_element i ^ "</li>"

let string_of_document doc =
  List.map string_of_element doc |> String.concat "\n\n"

let write_document_to_file doc =
  let oc = open_out "outpout.html" in
  let html = string_of_document doc in
  output_string oc html;
  close_out oc
