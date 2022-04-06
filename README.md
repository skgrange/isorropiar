# **isorropiar**

**isorropiar** is an R package to interact with the aerosol thermodynamical equilibrium [ISORROPIA II](https://www.epfl.ch/labs/lapi/software/isorropia/) model. ISORROPIA II is used for modelling aerosol-gas systems. A common application is to use ISORROPIA II to explore the partitioning of total reduced nitrogen (NH<sub>x</sub>) into the gas (ammonia; NH<sub>3</sub>) and aerosol (ammonium; NH<sub>4</sub><sup>+</sup>) phases. The main reference for ISORROPIA II is an [*Atmospheric Chemistry and Physics* article](https://doi.org/10.5194/acp-7-4639-2007).

# Installation

The development version of the **isorropiar** package can be easily installed with the [**remotes**](https://github.com/r-lib/remotes) package: 

```
# Install isorropiar
remotes::install_packages("skgrange/isorropiar")
```

# Setting-up ISORROPIA II

## Downloading the ISORROPIA II programme

The ISORROPIA II programme itself is not provided in the **isorropiar** R package and needs to be downloaded from official websites for licencing reasons. The ISORROPIA II source code can be requested for use on Unix systems or a Windows executable can downloaded from [here](https://www.epfl.ch/labs/lapi/software/isorropia/) or [here](https://nenes.eas.gatech.edu/ISORROPIA/index_old.html). If the source code is downloaded, the Fortran code will require compilation for your particular system before using. 

## ISORROPIA II programme structure

### Source code

On my Ubuntu (Unix) system, the ISORROPIA II programme directory structure looks like this: 

<!-- # tree --charset ascii source/ --> 
```
source/
|-- DEMO.dat
|-- DEMO.INP
|-- DEMO.txt
|-- isocom.for
|-- ISOFWD.FOR
|-- isorev.for
|-- isorropia
|-- isrpia.cnf
|-- isrpia.inc
|-- main.for
`-- main.inc
```

My directory where the ISORROPIA II programme is located is called `source`, but this can change depend on your preferences and the executable programme is called `isorropia`.

### Windows executable

On Windows systems, the only file that is required is called `isrpia2.exe`. I have kept the same directory name (`ISO2_1Bin`) that is downloaded and will look like this:  

<!-- # tree --charset ascii ISO2_1Bin/ -->
```
ISO2_1Bin/
|-- DEMO.INP
|-- isrpia2.exe
`-- ISRPIA.CNF
```

## Running the model

Running ISORROPIA II only requires two things:

  1. A data table formatted in the correct way
  2. The compiled ISORROPIA II programme (`isorropia`) or the Windows `isrpia2.exe` file and knowledge where either of these programmes is on your file system

### An example with demo data

Demo data that only varies sulfate concentrations are included in **isorropia** and these data can be loaded with the `read_isorropia_demo_data` function. 

#### Using the complied source

If the complied ISORROPIA II source is available, modelling can be done like this: 

``` r
# Load the packages
library(dplyr)
library(isorropiar)

# Load demo data
data_demo <- read_isorropia_demo_data()

# Run the ISORROPIA II model with demo data
data_isorropia <- run_isorropia(
  data_demo,
  directory_isorropia = "source/",
  verbose = TRUE
)
#> 2022-04-06 17:27:00.574 CEST: Running ISORROPIA II: `echo 1649258820_isorropia_run.txt | ./isorropia`...

# Print the result
data_isorropia
#> # A tibble: 1 × 8
#> # Rowwise:  date_model_run
#>   date_model_run      version        n_input input              messages      error_messages     output   combined
#>   <dttm>              <chr>            <int> <list>             <list>        <chr>              <list>   <list>  
#> 1 2022-04-06 17:27:00 2.1 (07/19/09)      15 <tibble [15 × 10]> <chr [1,311]> NO ERRORS DETECTED <tibble> <tibble>
```

#### Using the Windows executable

If the Windows executable is to be used, only the `directory_isorropia` argument needs to be changed: 

``` r
# Load the packages
library(dplyr)
library(isorropiar)

# Load demo data
data_demo <- read_isorropia_demo_data()

# Run the ISORROPIA II model with demo data
data_isorropia <- run_isorropia(
  data_demo,
  directory_isorropia = "C:/isorropia/ISO2_1Bin",
  verbose = TRUE
)
```

#### Using the generated outputs

The `data_isorropia` object is a nested tibble object that contains the input passed to ISORROPIA II and the outputs produced by ISORROPIA II. These units can be extracted from the nested structure and can be used within the R analysis ecosystem. For example, to extract ISORROPIA II's output, the `summarise` function can do this rather easily: 

``` r
# Extract the model's output
data_isorropia %>% 
  summarise(output,
            .groups = "drop")
#> # A tibble: 15 × 50
#>    date_model_run      NATOT SO4TOT NH4TOT NO3TOT CLTOT CATOT  KTOT MGTOT    RH  TEMP   GNH3     GHCL    GHNO3    CNACL
#>    <dttm>              <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl>    <dbl>    <dbl>    <dbl>
#>  1 2022-04-06 17:27:00     0      1      2      2     0     1     0     0  0.75   280 1.96   3.65e-13 6.3 e-13 5.85e-13
#>  2 2022-04-06 17:27:00     0      2      2      2     0     0     0     0  0.75   280 0.868  0        3.75e- 1 0       
#>  3 2022-04-06 17:27:00     0      3      2      2     0     0     0     0  0.75   280 0.545  0        4.61e- 1 0       
#>  4 2022-04-06 17:27:00     0      4      2      2     0     0     0     0  0.75   280 0.264  0        7.00e- 1 0       
#>  5 2022-04-06 17:27:00     0      5      2      2     0     0     0     0  0.75   280 0.0785 0        1.26e+ 0 0       
#>  6 2022-04-06 17:27:00     0      6      2      2     0     0     0     0  0.75   280 0      0        1.86e+ 0 0       
#>  7 2022-04-06 17:27:00     0      7      2      2     0     0     0     0  0.75   280 0      0        1.97e+ 0 0       
#>  8 2022-04-06 17:27:00     0      8      2      2     0     0     0     0  0.75   280 0      0        1.98e+ 0 0       
#>  9 2022-04-06 17:27:00     0      9      2      2     0     0     0     0  0.75   280 0      0        1.99e+ 0 0       
#> 10 2022-04-06 17:27:00     0     10      2      2     0     0     0     0  0.75   280 0      0        1.99e+ 0 0       
#> 11 2022-04-06 17:27:00     0     11      2      2     0     0     0     0  0.75   280 0      0        1.99e+ 0 0       
#> 12 2022-04-06 17:27:00     0     12      2      2     0     0     0     0  0.75   280 0      0        1.99e+ 0 0       
#> 13 2022-04-06 17:27:00     0     13      2      2     0     0     0     0  0.75   280 0      0        2.00e+ 0 0       
#> 14 2022-04-06 17:27:00     0     14      2      2     0     0     0     0  0.75   280 0      0        2.00e+ 0 0       
#> 15 2022-04-06 17:27:00     0     15      2      2     0     0     0     0  0.75   280 0      0        2.00e+ 0 0       
#> # … with 35 more variables: CNANO3 <dbl>, CNA2SO4 <dbl>, CNAHSO4 <dbl>, CNH4CL <dbl>, CNH4NO3 <dbl>, CNH42S4 <dbl>,
#> #   CNH4HS4 <dbl>, CLC <dbl>, CCASO4 <dbl>, CCANO32 <dbl>, CCACL2 <dbl>, CK2SO4 <dbl>, CKHSO4 <dbl>, CKNO3 <dbl>,
#> #   CKCL <dbl>, CMGSO4 <dbl>, CMGNO32 <dbl>, CMGCL2 <dbl>, HLIQ <dbl>, NALIQ <dbl>, NH4LIQ <dbl>, CLLIQ <dbl>,
#> #   SO4LIQ <dbl>, HSO4LIQ <dbl>, NO3LIQ <dbl>, CaLIQ <dbl>, KLIQ <dbl>, MgLIQ <dbl>, NH4AER <dbl>, CLAER <dbl>,
#> #   NO3AER <dbl>, WATER <dbl>, LMASS <dbl>, SMASS <dbl>, CASE <chr>
```
