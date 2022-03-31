#' Function to load a table with information about the variables used in the 
#' ISORROPIA II model. 
#' 
#' \code{isorropia_variables_helper} is helpful for joining and decoding the 
#' model's variables. 
#' 
#' @author Stuart K. Grange
#' 
#' @return Tibble.
#' 
#' @export
isorropia_variables_helper <- function() {
  
  tibble::tribble(
    ~variable_isorropia, ~variable_isorropia_long,                                               ~variable,                              ~unit,         ~notes,                         
    "NATOT",             "Total sodium (gas+aerosol) expressed as equivalent Na",                "sodium_total",                         "ug.m-3.air",  NA_character_,                  
    "SO4TOT",            "Total sulfate (gas+aerosol) expressed as equivalent H2SO4",            "sulfate_total",                        "ug.m-3.air",  NA_character_,                  
    "NH4TOT",            "Total ammonium (gas+aerosol) expressed as equivalent NH3",             "ammonium_total",                       "ug.m-3.air",  NA_character_,                  
    "NO3TOT",            "Total nitrate (gas+aerosol) expressed as equivalent HNO3",             "nitrate_total",                        "ug.m-3.air",  NA_character_,                  
    "CLTOT",             "Total chloride (gas+aerosol) expressed as equivalent HCl",             "chloride_total",                       "ug.m-3.air",  NA_character_,                  
    "CATOT",             "Total calcium (gas+aerosol)",                                          "calcium_total",                        "ug.m-3.air",  "not included in documentation",
    "KTOT",              "Total potassium (gas+aerosol)",                                        "potassium_total",                      "ug.m-3.air",  "not included in documentation",
    "MGTOT",             "Total magnesium (gas+aerosol)",                                        "magnesium_total",                      "ug.m-3.air",  "not included in documentation",
    "RH",                "Ambient relative humidity",                                            "rh",                                   "0-1 scale", NA_character_,                  
    "TEMP",              "Ambient temperature",                                                  "air_temp",                             "K",           NA_character_,                  
    "GNH3",              "Gas phase NH3",                                                        "ammonia_gas",                          "ug.m-3.air",  NA_character_,                  
    "GHCL",              "Gas phase HCl",                                                        "hydrogen_chloride_gas",                "ug.m-3.air",  NA_character_,                  
    "GHNO3",             "Gas phase HNO3",                                                       "nitric_acid_gas",                      "ug.m-3.air",  NA_character_,                  
    "CNACL",             "Solid phase NaCl",                                                     "sodium_chloride_solid",                "ug.m-3.air",  NA_character_,                  
    "CNANO3",            "Solid phase NaNO3",                                                    "sodium_nitrate_solid",                 "ug.m-3.air",  NA_character_,                  
    "CNA2SO4",           "Solid phase Na2SO4",                                                   "sodium_sulfate_solid",                 "ug.m-3.air",  NA_character_,                  
    "CNAHSO4",           "Solid phase NaHSO4",                                                   "sodium_bisulfate_solid",               "ug.m-3.air",  NA_character_,                  
    "CNH4CL",            "Solid phase NH4Cl",                                                    "ammonium_chloride_solid",              "ug.m-3.air",  NA_character_,                  
    "CNH4NO3",           "Solid phase NH4NO3",                                                   "ammonium_nitrate_solid",               "ug.m-3.air",  NA_character_,                  
    "CNH42S4",           "Solid phase (NH4)2SO4",                                                "ammonium_sulfate_solid",               "ug.m-3.air",  NA_character_,                  
    "CNH4HS4",           "Solid phase NH4HSO4",                                                  "ammonium_bisulfate_solid",             "ug.m-3.air",  NA_character_,                  
    "CLC",               "Solid phase (NH4)3H(SO4)2",                                            "triammonium_hydrogen_disulfate_solid", "ug.m-3.air",  NA_character_,                  
    "CCASO4",            "Solid phase CaSO4",                                                    "calcium_sulfate_solid",                "ug.m-3.air",  NA_character_,                  
    "CCANO32",           "Solid phase Ca(NO3)2",                                                 "calcium_nitrate_solid",                "ug.m-3.air",  NA_character_,                  
    "CCACL2",            "Solid phase CaCl2",                                                    "calcium_chloride_solid",               "ug.m-3.air",  NA_character_,                  
    "CK2SO4",            "Solid phase K2SO4",                                                    "potassium_sulfate_solid",              "ug.m-3.air",  NA_character_,                  
    "CKHSO4",            "Solid phase KHSO4",                                                    "potassium_bisulfate_solid",            "ug.m-3.air",  NA_character_,                  
    "CKNO3",             "Solid phase KNO3",                                                     "potassium_nitrate_solid",              "ug.m-3.air",  NA_character_,                  
    "CKCL",              "Solid phase KCl",                                                      "potassium_chloride_solid",             "ug.m-3.air",  NA_character_,                  
    "CMGSO4",            "Solid phase MgSO4",                                                    "magnesium_sulfate_solid",              "ug.m-3.air",  NA_character_,                  
    "CMGNO32",           "Solid phase Mg(NO3)2",                                                 "magnesium_nitrate_solid",              "ug.m-3.air",  NA_character_,                  
    "CMGCL2",            "Solid phase MgCl2",                                                    "magnesium_chloride_solid",             "ug.m-3.air",  NA_character_,                  
    "HLIQ",              "Aqueous phase H+",                                                     "hydron_aqueous",                       "ug.m-3.air",  NA_character_,                  
    "NALIQ",             "Aqueous phase Na+",                                                    "sodium_aqueous",                       "ug.m-3.air",  NA_character_,                  
    "NH4LIQ",            "Aqueous phase NH4+",                                                   "ammonium_aqueous",                     "ug.m-3.air",  NA_character_,                  
    "CLLIQ",             "Aqueous phase Cl-",                                                    "chloride_aqueous",                     "ug.m-3.air",  NA_character_,                  
    "SO4LIQ",            "Aqueous phase SO4-2",                                                  "sulfate_aqueous",                      "ug.m-3.air",  NA_character_,                  
    "HSO4LIQ",           "Aqueous phase HSO4-",                                                  "hydrogen_sulfate_aqueous",             "ug.m-3.air",  NA_character_,                  
    "NO3LIQ",            "Aqueous phase NO3-",                                                   "nitrate_aqueous",                      "ug.m-3.air",  NA_character_,                  
    "CaLIQ",             "Aqueous phase Ca2+",                                                   "calcium_ion_aqueous",                  "ug.m-3.air",  NA_character_,                  
    "KLIQ",              "Aqueous phase K+",                                                     "potassium_ion_aqueous",                "ug.m-3.air",  NA_character_,                  
    "MgLIQ",             "Aqueous phase Mg2+",                                                   "magnesium_ion_aqueous",                "ug.m-3.air",  NA_character_,                  
    "NH4AER",            "Total aerosol ammonium (solid + aqueous) expressed as equivalent NH3", "ammonium_aerosol_total",               "ug.m-3.air",  NA_character_,                  
    "CLAER",             "Total aerosol chloride (solid + aqueous) expressed as equivalent HCl", "chloride_aerosol_total",               "ug.m-3.air",  NA_character_,                  
    "NO3AER",            "Total aerosol nitrate (solid + aqueous) expressed as equivalent HNO3", "nitrate_aerosol_total",                "ug.m-3.air",  NA_character_,                  
    "WATER",             "Aerosol water content",                                                "aerosol_water_content",                "ug.m-3.air",  NA_character_,                  
    "LMASS",             "Aerosol aqueous phase mass (water+dissolved salts)",                   "aqueous_phase_mass",                   "ug.m-3.air",  NA_character_,                  
    "SMASS",             "Aerosol solid phase mass",                                             "solid_phase_mass",                     "ug.m-3.air",  NA_character_,                  
    "CASE",              "ISORROPIA subcase",                                                    "isorropia_subcase",                    NA_character_, "a character vector"
  )
  
}
