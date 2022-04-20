#' Function to run the ISORROPIA II model and return the model's input and 
#' output in a friendly format. 
#' 
#' @author Stuart K. Grange
#' 
#' @param df Input data frame/tibble that is to be modelled with ISORROPIA II.
#' 
#' @param directory_isorropia Directory where ISORROPIA II's programme is 
#' located. The programme can either be the complied source (\code{isorropia}) 
#' or the provided Windows \code{.exe} file (\code{isrpia2.exe}). 
#' 
#' @param verbose Should the function give messages? 
#' 
#' @return Nested tibble with a single row. 
#' 
#' @examples 
#' 
#' \dontrun{
#' 
#' # Load demo data
#' data_demo <- read_isorropia_demo_data()
#' 
#' # Run the ISORROPIA II model with demo data using a complied version of 
#' # isorropia
#' run_isorropia(
#'   data_demo,
#'   directory_isorropia = "~/isorropia/source",
#'   verbose = TRUE
#' )
#' 
#' # Run ISORROPIA II with an executable file on a Windows system
#' run_isorropia(
#'   data_demo,
#'   directory_isorropia = "C:/isorropia/ISO2_1Bin",
#'   verbose = TRUE
#' )
#' 
#' }
#' 
#' @export
run_isorropia <- function(df, directory_isorropia, verbose = FALSE) {
  
  # Get system date
  date_system <- lubridate::now()
  date_system_unix <- as.integer(date_system)
  
  # Check data input
  if (nrow(df) == 0L) {
    stop("Input data contains no observations.", call. = FALSE)
  }
  
  if (!identical(names(df), isorropia_input_names())) {
    stop("Input data have incorrect variables or order.", call. = FALSE)
  }
  
  if (!all(purrr::map_chr(df, class) %in% c("numeric", "integer"))) {
    stop(
      "Input data must be made up of numeric or interger variables.", 
      call. = FALSE
    )
  }
  
  if (anyNA(df)) {
    stop("Input data cannot contain missing (`NA`s) data.", call. = FALSE)
  }
  
  # Expand path
  directory_isorropia <- fs::path_abs(directory_isorropia)
  # Test if it exists
  stopifnot(fs::dir_exists(directory_isorropia))
  
  # Find isorropia programme in directory
  file_list <- list.files(directory_isorropia)
  
  # Get the compiled programme
  file_isorropia <- file_list[file_list == "isorropia"]
  
  # Get the executable file, this will be for Windows systems
  if (length(file_isorropia) == 0L) {
    file_isorropia <- file_list[file_list == "isrpia2.exe"]
  }
  
  # Error if the programme cannot be found
  if (length(file_isorropia) == 0L) {
    stop(
      "The `isorropia` or `isrpia2.exe` programme cannot be found in the directory.", 
      call. = FALSE
    )
  }
  
  # Get number of input observations
  n_input <- nrow(df)
  
  # Get isorropia version
  version <- read_isorropia_version(directory_isorropia)
  
  # Store working directory
  directory_current <- getwd()
  
  # Enter source directory
  setwd(directory_isorropia)
  
  # The files to be used
  file_input <- stringr::str_c(date_system_unix, "_isorropia_run.txt")
  file_output <- fs::path_ext_set(file_input, "dat")
  
  # Write preamble to control file
  write(isorropia_input_preamble(), file_input)
  
  # Write the input data to input control file, using base function here to
  # avoid progress being displayed
  write.table(df, file_input, append = TRUE, col.names = FALSE, row.names = FALSE)
  
  # What type of system? 
  system_type <- .Platform$OS.type
  
  # Build command string and run/call isorropia
  if (system_type != "windows") {
    
    cmd <- stringr::str_c("echo ", file_input, " | ./", file_isorropia)
    if (verbose) message(date_message(), "Running ISORROPIA II: `", cmd, "`...")
    x <- system(cmd, ignore.stderr = FALSE, ignore.stdout = FALSE, intern = TRUE)
    
  } else {
    
    cmd <- stringr::str_c("echo ", file_input, " | ", file_isorropia)
    if (verbose) message(date_message(), "Running ISORROPIA II: `", cmd, "`...")
    x <- shell(cmd, ignore.stderr = FALSE, ignore.stdout = FALSE, intern = TRUE)
    
  }
  
  # Read input file
  df_input_nest <- read_isorropia_input_file(file_input)
  
  # Add extras
  df_input_nest <- df_input_nest %>% 
    mutate(date_model_run = !!date_system,
           system_type = !!system_type,
           isorropia_programme = !!file_isorropia,
           version = !!version,
           n_input = !!n_input) %>% 
    relocate(date_model_run,
             system_type,
             isorropia_programme,
             version,
             n_input)
  
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
  
  # Make input longer
  df_input <- df_input %>% 
    mutate(source = "input") %>% 
    tibble::rowid_to_column() %>% 
    tidyr::pivot_longer(-c(rowid, source), names_to = "variable")
  
  # Make output longer, need to drop case because of different data type
  df_output <- df_output %>% 
    mutate(source = "output") %>% 
    tibble::rowid_to_column() %>% 
    select(-CASE) %>% 
    tidyr::pivot_longer(-c(rowid, source), names_to = "variable")
  
  # Bind the sets
  df <- df_input %>% 
    bind_rows(df_output) %>% 
    arrange(source,
            variable,
            rowid)
  
  return(df)
  
}


isorropia_input_names <- function() {
  c("Na", "SO4", "NH3", "NO3", "Cl", "Ca", "K", "Mg", "RH", "TEMP")
}


read_isorropia_version <- function(directory_isorropia) {
  
  # Build file name
  file <- fs::path(directory_isorropia, "isocom.for")
  
  # Read file and extract version
  if (fs::file_exists(file)) {
    x <-   readr::read_lines(file, progress = FALSE) %>% 
      stringr::str_subset("DATA VERSION") %>% 
      stringr::str_split_fixed("/'|'/", n = 3) %>% 
      .[, 2]
  } else {
    x <- NA_character_
  }
  
  return(x)
  
}
