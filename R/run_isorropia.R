#' Function to run the ISORROPIA II model and return the model's input and 
#' output in a friendly format. 
#' 
#' @author Stuart K. Grange
#' 
#' @param df Input data frame/tibble that is to be modelled with ISORROPIA II.
#' 
#' @param directory_isorropia Directory where ISORROPIA II's programme is 
#' located. 
#' 
#' @param verbose Should the function give messages? 
#' 
#' @return Nested tibble with a single row. 
#' 
#' @examples 
#' 
#' \dontrun{
#' 
#' # Run the ISORROPIA II model 
#' run_isorropia(
#'  data_pm_observations,
#'  directory_isorropia = "~/isorropia/source",
#'  verbose = TRUE
#' )
#' 
#' }
#' 
#' @export
run_isorropia <- function(df, directory_isorropia, verbose = FALSE) {
  
  # TODO: check inputs
  
  # Get system date
  date_system <- lubridate::now()
  date_system_unix <- as.integer(date_system)
  
  # Store date if it exists
  if ("date" %in% names(df)) {
    dates <- df$date
    df <- select(df, -date)
  } else {
    dates <- lubridate::NA_POSIXct_
  }
  
  # Store working directory
  directory_current <- getwd()
  
  # Enter source directory
  setwd(directory_isorropia)
  
  # The files to be used
  file_input <- stringr::str_c(date_system_unix, "_isorropia_run.txt")
  file_output <- fs::path_ext_set(file_input, "dat")
  
  # Write preamble to control file
  write(isorropia_input_preamble(), file_input)
  
  # Write the input data to input control file
  write.table(df, file_input, append = TRUE, col.names = FALSE, row.names = FALSE)
  
  # Build command string
  cmd <- stringr::str_c("echo ", file_input, " | ./isorropia")
  
  # A message to user
  if (verbose) {
    message(date_message(), "Running ISORROPIA II: `", cmd, "`...")
  }
  
  # Run/call the isorropia model
  x <- system(cmd, ignore.stderr = FALSE, ignore.stdout = FALSE, intern = TRUE)
  
  # Read input file
  df_input_nest <- read_isorropia_input_file(file_input)
  
  # Add date if it exists too
  df_input_nest$input[[1]] <- df_input_nest$input[[1]] %>% 
    mutate(date = !!dates) %>% 
    relocate(date)
  
  # Add extras
  df_input_nest <- df_input_nest %>% 
    mutate(date_model_run = date_system) %>% 
    relocate(date_model_run)
  
  # Read results
  df_output <- read_isorropia_output_file(file_output)
  
  # Trash files
  fs::file_delete(c(file_input, file_output))
  
  # Back to original working directory
  setwd(directory_current)
  
  # Build nested tibble return
  df_nest <- df_input_nest %>% 
    dplyr::bind_cols(tibble(output = list(df_output))) %>% 
    rowwise(date_model_run) %>% 
    mutate(combined = list(combine_isorropia_inputs_and_outputs(input, output)))
  
  return(df_nest)
  
}


isorropia_input_preamble <- function () {
  
  # An eight line header with some options followed by eight numbers formatted
  # with a Fortran delimiter
  
  "Input units (0=umol/m3, 1=ug/m3)
1

Problem type (0=forward, 1=reverse); Phase state (0=solid+liquid, 1=metastable)
0, 0

NH4-SO4-NO3 system case
Na      SO4     NH3    NO3     Cl    Ca    K     Mg    RH      TEMP"
  
}


combine_isorropia_inputs_and_outputs <- function(df_input, df_output) {
  
  df_input <- df_input %>% 
    mutate(source = "input") %>% 
    tibble::rowid_to_column() %>% 
    tidyr::pivot_longer(-c(rowid, date, source), names_to = "variable")
  
  # Get dates for joining to output
  df_dates <- df_input %>% 
    distinct(rowid,
             date)
  
  df_output <- df_output %>% 
    mutate(source = "output") %>% 
    tibble::rowid_to_column() %>% 
    left_join(df_dates, by = "rowid") %>% 
    select(-CASE) %>% 
    tidyr::pivot_longer(-c(rowid, date, source), names_to = "variable")
  
  # Bind the sets
  df <- df_input %>% 
    bind_rows(df_output) %>% 
    arrange(source,
            variable,
            rowid)
  
  return(df)
  
}
