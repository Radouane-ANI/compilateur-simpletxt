type document = macro list * element list
and macro = string * fragment list

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
  | Cle of string
  | Color of fragment * fragment list
  | StartItalic
  | EndItalic
  | StartBold
  | EndBold
  | Link of fragment list * fragment

  exception Duplicate_macro of string

  let build_macro_table macros =
    let table = Hashtbl.create 10 in
    List.iter
      (fun (key, frags) ->
        if Hashtbl.mem table key then
          raise (Duplicate_macro key)
        else
          Hashtbl.add table key frags)
      macros;
    table
  

exception Undefined_macro of string
    
let rec string_of_fragment table = function
  | Word w -> w
  | Cle c -> (
      match Hashtbl.find_opt table c with
      | Some frags -> string_of_fragments table frags
      | None -> raise (Undefined_macro c)) 
  | StartItalic -> "<em>"
  | EndItalic -> "</em>"
  | StartBold -> "<strong>"
  | EndBold -> "</strong>"
  | Link (words, url) ->
      "<a href=\""
      ^ string_of_fragment table url
      ^ "\">"
      ^ String.concat " " (List.map (string_of_fragment table) words)
      ^ "</a>"
  | Color (code, words) ->
      "<span style=\"color:#"
      ^ string_of_fragment table code
      ^ "\">"
      ^ String.concat " " (List.map (string_of_fragment table) words)
      ^ "</span>"

and string_of_fragments table frags =
  List.map (string_of_fragment table) frags |> String.concat " "

let rec string_of_element table = function
  | HEADER1 frags -> "<h1>" ^ string_of_fragments table frags ^ "</h1>"
  | HEADER2 frags -> "<h2>" ^ string_of_fragments table frags ^ "</h2>"
  | Paragraph frags -> "<p>" ^ string_of_fragments table frags ^ "</p>"
  | List items ->
      "<ul>"
      ^ String.concat "\n" (List.map (string_of_item table) items)
      ^ "</ul>"

and string_of_item table = function
  | CONTENUE c -> string_of_element table c
  | SOUSITEM (e, items) ->
      "<li>" ^ string_of_element table e ^ "</li><ul>"
      ^ String.concat "\n" (List.map (string_of_item table) items)
      ^ "</ul>"
  | ITEM i -> "<li>" ^ string_of_element table i ^ "</li>"

let string_of_document (macros, elements) =
  let table = build_macro_table macros in
  List.map (string_of_element table) elements |> String.concat "\n\n"

  let write_document_to_file doc =
    try
      let oc = open_out "outpout.html" in
      let html = string_of_document doc in
      output_string oc html;
      close_out oc
    with
    | Undefined_macro c ->
        prerr_endline ("Erreur : macro non définie \"" ^ c ^ "\"");
        exit 1
  
