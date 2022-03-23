#' Function to squash R check's global variable notes. 
#' 
if (getRversion() >= "2.15.1") {
  
  # What variables are causing issues?
  variables <- c(
    ".", "rowid", "CASE", "variable", "date_model_rum", "input", "output",
    "date_model_run"
  )
  
  # Squash the note
  utils::globalVariables(variables)
  
}

