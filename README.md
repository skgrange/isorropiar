# **isorropiar**

**isorropiar** is an R package to interact with the aerosol thermodynamical equilibrium [ISORROPIA II](https://www.epfl.ch/labs/lapi/software/isorropia/) model. ISORROPIA II is used for modelling aerosol (or particulate matter; PM)-gas systems. A common application is to use ISORROPIA II to explore the partitioning of total reduced nitrogen (NH<sub>x</sub>) into the gas (ammonia; NH<sub>3</sub>) and aerosol (ammonium; NH<sub>4</sub><sup>+</sup>) phases. The main reference for ISORROPIA II is an [*Atmospheric Chemistry and Physics* article](https://doi.org/10.5194/acp-7-4639-2007).

# Installation

The development version of the **isorropiar** package can be easily installed with the [**remotes**](https://github.com/r-lib/remotes) package: 

```
# Install isorropiar
remotes::install_packages("skgrange/isorropiar")
```

# Setting-up

## ISORROPIA II programme structure

The ISORROPIA II code base must be requested from [here](https://www.epfl.ch/labs/lapi/software/isorropia/). After receiving the package, it will require compilation for use on your system. After compilation the directory's contents should look like this: 

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

My directory where the ISORROPIA II programme is located is called `source`, and this is what is used throughout the documentation, but this can change depend on your preferences. 

## Running the model

Running ISORROPIA II only requires two things:

  1. A data table formatted in the correct way
  2. The compiled ISORROPIA II programme and knowledge where the programme is on your file system

Demo data that only varies sulfate concentrations are included in the R package. Therefore, modelling these data can be achieved with the code below:

```
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
#> 2022-03-25 09:09:13.848 CET: Running ISORROPIA II: `echo 1648195753_isorropia_run.txt | ./isorropia`...

# Print the result
data_isorropia
#> # A tibble: 1 × 8
#> # Rowwise:  date_model_run
#>   date_model_run      version        n_input input              messages      error_messages     output   combined
#>   <dttm>              <chr>            <int> <list>             <list>        <chr>              <list>   <list>  
#> 1 2022-03-25 09:09:13 2.1 (07/19/09)      15 <tibble [15 × 10]> <chr [1,311]> NO ERRORS DETECTED <tibble> <tibble>
```

The `data_isorropia` object is a nested tibble object that contains the input passed to ISORROPIA II and the outputs produced by ISORROPIA II. These units are extracted from the nested structure and can be used within the R analysis ecosystem. 

```
# Extract the model's output
data_isorropia %>% 
  summarise(output,
            .groups = "drop")
```

