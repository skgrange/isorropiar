#' Function to select the variables that are required for the ISORROPIA II 
#' model. 
#' 
#' @param df Data frame or tibble containing the required variables. 
#' 
#' @param drop Should the ISORROPIA II variables be dropped rather than kept? 
#' 
#' @author Stuart K. Grange
#' 
#' @return Data frame or tibble
#' 
#' @seealso \code{\link{read_isorropia_demo_data}}
#' 
#' @export
select_isorropia_variables <- function(df, drop = FALSE) {
  
  # Check that a data frame has been passed
  stopifnot("data.frame" %in% class(df))
  
  if (!drop) {
    # Select the variables in the order that is required
    df <- select(df, !!variables_isorropia)
  } else {
    # Drop the variables
    df <- select(df, !!-variables_isorropia)
  }
  
  return(df)
  
}


#' @rdname select_isorropia_variables
#' 
#' @export
variables_isorropia <- c(
  "Na", "SO4", "NH3", "NO3", "Cl", "Ca", "K", "Mg", "RH", "TEMP"
)
