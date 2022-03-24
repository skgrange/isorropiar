# **isorropiar**

**isorropiar** is an R package to interact with the aerosol thermodynamical equilibrium [ISORROPIA II](https://www.epfl.ch/labs/lapi/software/isorropia/) model. 

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

My directory is called `source`, and this is what is used throughout the documentation, but this can change depend on your preferences. 

## Running the model

Running ISORROPIA II only requires two things:

  1. A data table formatted in the correct way
  2. The compiled ISORROPIA II programme and knowledge where the programme is on your file system
  
Demo data that only changes sulfate concentrations is included in the package. Therefore, modelling these data can be achieved with code below:  

```
# Load the package
library(isorropiar)

# Load demo data
data_demo <- read_isorropia_demo_data()

# Run the ISORROPIA II model with demo data
run_isorropia(
  data_demo,
  directory_isorropia = "~/isorropia/source",
  verbose = TRUE
)
```
