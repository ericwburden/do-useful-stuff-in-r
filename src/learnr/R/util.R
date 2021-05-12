#' Create a link to a vocabulary definition
#' 
#' Prepares a styled hyperlink that can be used to trigger a definition modal.
#' The modal code will need to be included in an {r context="server"} code
#' chunk, in an `observeEvent(input$name, {})` call. Note, the label for the
#' link will be the hyphenated form of 'name', ex. 
#' `'a link name' -> 'a-link-name'`.
#'
#' @param name The label to display for the link
#'
#' @return a shiny::actionLink
#' @examples def_link("monad")
def_link <- function(name) {
  hyphenated <- gsub(' ', '-', name)
  style = paste(
    "font-weight: bold;",
    "display: inline-block;",
    "padding: 0px 4px;"
  )
  shiny::actionLink(hyphenated, name, style = style, class = "bg-info text-white")
}


#' Insert an image
#'
#' @param filename Name of the file in the 'images' folder
#' @param alt Alt text for the image
#' @param caption Optional caption for the image
#' @param max_width Optional max width (defaults to 800px)
#'
#' @return a <figure> element
insert_figure <- function(filename, alt, caption, max_width = "800px") {
  # caption <- gsub("`([^`]*)`", "<code>\\1</code>", caption)
  el <- shiny::tags$figure(
    style = "padding: 20px 0;",
    shiny::tags$img(
      src = paste("images", filename, sep = "/"),
      alt = alt,
      style = paste0("width:100%; min-width:350px; max-width:", max_width, ";")
    ),
    if (!missing(caption)) { shiny::tags$figcaption(caption) }
  )
  cat(format(el))
}
