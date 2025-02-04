###############################################################################################
#####
#####  Data preparation script for SOC2069 
#####  
#####   SOC2069 is an introductory quantitative methods module (course) for 2nd-year sociology 
#####   students at Newcastle University (United Kingdom)
#####
#####   The aim of this script is to prepare original raw data from the EUROMODULE survey (1999-2002)
#####   for use in workshops by students. More on EUROMODULE:
#####       - Delhey et al. (2002), https://link.springer.com/chapter/10.1007/0-306-47513-8_8
#####       - Data source: https://search.gesis.org/research_data/ZA4063
#####
#####   The script provides a complete data management pipeline from the raw data files that are
#####   freely available (upon registration) from GESIS – Leibniz Institute for the Social Sciences
#####
#####   
#####  Prepared by: Dr. Chris Moreh                           
#####
#####  Date: October 2024                                   
#####
###############################################################################################


## Install and load packages ##################################################################

if (!require("pacman")) install.packages("pacman")

pacman::p_load(
  tidyverse, easystats, sjlabelled, sjmisc, archive, fs, DT
)

## Data management

## Download the data file in SPSS format: 
## https://search.gesis.org/research_data/ZA4063

## Name of the downloaded SPSS dataset
datafile <- "ZA4063.sav"

## Find the path to the raw file anywhere on a Windows system
datafile_path <- fs::dir_ls(path = "\\",                          
                            glob = paste0("*", datafile), 
                            recurse = TRUE, 
                            fail = FALSE)

## Import the SPSS file to R
euromodule <- data_read(datafile_path)

## Checks
dim(euromodule)  ## [1] 14730   366


## Select variables
euromodule_small <- euromodule |> 
  select(
    # A: Demographic characteristics (control variables)
      COUNTRY, YEAR, V7, V8, V33, 
    # B: Personality theory
      V55A, V55D, V55E,  
    # C: Success and well-being theory
      V23, V28, V40, V56, V57, V31A:V31E, V21A:V21U, V24, V24_PPP, V26, V27, V22, V36, V46,
    # D: Voluntary organisation theory
      V12A:V12J, 
    # E: Social network theory
      V13, V14, V15, V55B,
    # F: Community theory
      V11_A:V11_TR, V50, V49, V51A:V51D,
    # G: Societal conditions theory
      V17A:V17J, V52, V61, V58A:V58M
    )

## Save the dataset

euromodule_small |> 
  data_write("Data/workshop_data/delhey&newton2003.sav")



