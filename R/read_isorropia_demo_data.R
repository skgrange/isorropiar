#' Function to read/load the demo data that is supplied with the ISORROPIA II
#' code package. 
#' 
#' @author ISORROPIA's developers. 
#' 
#' @return Tibble. 
#' 
#' @export
read_isorropia_demo_data <- function() {
  
  tibble::tribble(
    ~Na, ~SO4, ~NH3, ~NO3, ~Cl, ~Ca, ~K, ~Mg, ~RH,  ~TEMP,
    0,   1,    2,    2,    0,   1,   0,  0,   0.75, 280,  
    0,   2,    2,    2,    0,   0,   0,  0,   0.75, 280,  
    0,   3,    2,    2,    0,   0,   0,  0,   0.75, 280,  
    0,   4,    2,    2,    0,   0,   0,  0,   0.75, 280,  
    0,   5,    2,    2,    0,   0,   0,  0,   0.75, 280,  
    0,   6,    2,    2,    0,   0,   0,  0,   0.75, 280,  
    0,   7,    2,    2,    0,   0,   0,  0,   0.75, 280,  
    0,   8,    2,    2,    0,   0,   0,  0,   0.75, 280,  
    0,   9,    2,    2,    0,   0,   0,  0,   0.75, 280,  
    0,   10,   2,    2,    0,   0,   0,  0,   0.75, 280,  
    0,   11,   2,    2,    0,   0,   0,  0,   0.75, 280,  
    0,   12,   2,    2,    0,   0,   0,  0,   0.75, 280,  
    0,   13,   2,    2,    0,   0,   0,  0,   0.75, 280,  
    0,   14,   2,    2,    0,   0,   0,  0,   0.75, 280,  
    0,   15,   2,    2,    0,   0,   0,  0,   0.75, 280
  )
  
}
