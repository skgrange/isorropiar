#' Function to squash R check's global variable notes. 
#' 
#' @name zzz
#' 
if (getRversion() >= "2.15.1") {
  
  # What variables are causing issues?
  variables <- c(
    ".", "rowid", "CASE", "variable", "date_model_rum", "input", "output",
    "date_model_run", "Na", "SO4", "NH3", "NO3", "Cl", "Ca", "K", "Mg", "RH",
    "TEMP", "isorropia_programme"
  )
  
  # Squash the note
  utils::globalVariables(variables)
  
}
