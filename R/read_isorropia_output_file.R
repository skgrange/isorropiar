#' Functions to read input and output data files used by the ISORROPIA II model. 
#' 
#' @param file File name of an ISORROPIA II input or output data file. 
#' 
#' @param unnest For \code{read_isorropia_input_file}, should the return be 
#' unnested? 
#' 
#' @author Stuart K. Grange
#' 
#' @return Tibble. 
#' 
#' @export
read_isorropia_output_file <- function(file) {
  
  # File needs to be read as text first to remove the white space at the 
  # beginning and end of the lines
  file %>% 
    readr::read_lines(progress = FALSE) %>% 
    stringr::str_squish() %>% 
    stringr::str_c(collapse = "\n") %>% 
    readr::read_delim(na = "Infinity", show_col_types = FALSE, progress = FALSE) %>% 
    data.frame() %>% 
    as_tibble()
  
}


#' @rdname read_isorropia_output_file
#' 
#' @export
read_isorropia_input_file <- function(file, unnest = FALSE) {
  
  # Read entire file as text
  text <- readr::read_lines(file, progress = FALSE)
  
  # Isolate the input data table
  index_start_table <- stringr::str_which(text, "system case")[1] + 1L
  index_end_table <- stringr::str_which(text, "\\*\\*\\*")[1] - 1L
  index_end_table <- if_else(is.na(index_end_table), length(text), index_end_table)
  
  # Read input table
  df <- text[index_start_table:index_end_table] %>% 
    stringr::str_c(collape = "\n") %>% 
    readr::read_table(show_col_types = FALSE, progress = FALSE) %>% 
    data.frame() %>% 
    as_tibble()
  
  # Get programme messages
  text_messages <- text[(index_end_table + 1L):length(text)]
  
  # Get index of error messages
  index_error_messages <- stringr::str_which(text_messages, "ERROR MESSAGES") + 1L
  
  if (length(index_error_messages) != 0L) {
    
    # Extract the unique error messages as character vector with length of one
    text_error_messages <- text_messages[index_error_messages] %>% 
      stringr::str_squish() %>% 
      unique() %>% 
      .[. != ""] %>% 
      stringr::str_c(collapse = ";")
    
  } else {
    
    # Include the elements, but set to missing
    text_messages <- NA_character_
    text_error_messages <- NA_character_
    
  }
  
  # Build nested tibble return
  df_nest <- tibble(
    input = list(df),
    messages = list(text_messages),
    error_messages = text_error_messages
  )
  
  # Just return a table if desired, a bad name here
  if (unnest) {
    df_nest <- df_nest$input[[1]]
  }
  
  return(df_nest)
  
}
