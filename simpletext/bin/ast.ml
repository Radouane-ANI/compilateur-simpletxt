type document = element list

and element =
  | HEADER1 of fragment list
  | HEADER2 of fragment list
  | Paragraph of fragment list
  | List of element list
  | Item of element list

and fragment =
  | Word of string
  | Italic of string list
  | Bold of string list
  | Link of string list * string

let string_of_fragment = function
  | Word w -> w
  | Italic words -> "<em>" ^ String.concat " " words ^ "</em>"
  | Bold words -> "<strong>" ^ String.concat " " words ^ "</strong>"
  | Link (words, url) ->
      "<a href=\"" ^ url ^ "\" >" ^ String.concat " " words ^ "</a>"

let string_of_fragments frags =
  List.map string_of_fragment frags |> String.concat " "

let rec string_of_element = function
  | HEADER1 frags -> "<h1>" ^ string_of_fragments frags ^ "</h1>"
  | HEADER2 frags -> "<h2>" ^ string_of_fragments frags ^ "</h2>"
  | Paragraph frags -> "<p>" ^ string_of_fragments frags ^ "</p>"
  | Item elem -> string_of_item elem
  | List items ->
      "<ul>"
      ^ (List.map string_of_element items |> String.concat "\n")
      ^ "</ul>"

and string_of_item item =
  if List.length item == 1 then
    "<li>" ^ string_of_element (List.hd item) ^ "</li>"
  else
    let rec intt i id =
      match i with
      | a :: b ->
          if id = 1 then "<ul>" ^ string_of_element a ^ intt b (id + 1)
          else string_of_element a ^ intt b (id + 1)
      | [] -> "</ul>"
    in

    "<li>" ^ intt item 0 ^ "</li>"

let string_of_document doc =
  List.map string_of_element doc |> String.concat "\n\n"
