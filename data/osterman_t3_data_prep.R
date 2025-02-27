###############################################################################################
#####
#####  Data preparation script 
#####
#####   The aim of this script is to prepare the replication dataset from Österman (2020)
#####   for use in workshops by students.
#####   
#####   Original dataset: Österman, Marcus, 2020, "Replication Data for: Can we trust education for 
#####   fostering trust? Quasi-experimental evidence on the effect of education and tracking on 
#####   social trust", https://doi.org/10.7910/DVN/RCSCDA, Harvard Dataverse, V1; 
#####   Replication_data_ESS1-9_20201113.tab [fileName], UNF:6:JFCYBnvMggBGvWPpZovzFQ== [fileUNF]
#####
#####   The original dataset is publicly available from the Harvard Dataverse at the link above. 
#####   The dataset can first be downloaded to a local folder and then read into R, or read into R 
#####   directly from the web using the {dataverse} package (https://cran.r-project.org/web/packages/dataverse)
#####   
#####  Prepared by: Dr. Chris Moreh                           
#####
#####  Date: October 2024                                   
#####
###############################################################################################

## Packages
library("dataverse")
library("tidyverse")
library("easystats")
library("sjlabelled")

## To import the data in its original Stata (.dta) format using the {dataverse} package, we do: ----

osterman <- dataverse::get_dataframe_by_name(
  filename = "Replication_data_ESS1-9_20201113.tab",
  dataset = "10.7910/DVN/RCSCDA",
  server = "dataverse.harvard.edu",
  original = TRUE,
  .f = haven::read_dta)

## If first downloaded to a local folder called "raw" in the working directory, we do: ----

osterman <- datawizard::data_read("raw/Replication_data_ESS1-9_20201113.dta")


## Select the variables that will be used for modelling ----

model_vars <- c("trustindex3", "reform1_7", "reform_id_num", "female", "agea", "fbrneur", "mbrneur", "fnotbrneur", "mnotbrneur", "blgetmg_d", "yrbrn", "essround")

## Filter cases to restrict the data to the one used in the original analysis, keep selected variables and label all the variables ----

osterman_t3 <- osterman  |> 
  datawizard::data_filter(agea >= 25 &
                         agea <=80 &
                         brncntr == 1 &
                         reform_years<=7 & 
                         reform_years>=-7
                         ) |> 
  datawizard::data_select(c("cntry", "dweight", "ppltrst", "pplfair", "pplhlp", "eduyrs25", "paredu_a_high", model_vars)) |> 
  tidyr::drop_na(any_of(model_vars)) |> 
  sjlabelled::val_labels(female = c("Male" = 0, "Female" = 1),
                         blgetmg_d = c("No" = 0, "Yes" = 1),
                         fbrneur = c("No" = 0, "Yes" = 1),
                         mbrneur = c("No" = 0, "Yes" = 1),
                         fnotbrneur = c("No" = 0, "Yes" = 1),
                         mnotbrneur = c("No" = 0, "Yes" = 1),
                         paredu_a_high = c("No" = 0, "Yes" = 1),
  ) |> 
  sjlabelled::var_labels(trustindex3 = "Social trust scale",
                         reform1_7 = "General reform indicator",
                         reform_id_num = "Reform ID number",
                         female = "Sex",
                         fnotbrneur = "Foreign-born father, outside Europe",
                         mnotbrneur = "Foreign-born mother, outside Europe",
                         blgetmg_d = "Belongs to ethnic minority",
                         eduyrs25 = "Years of full-time education",
                         paredu_a_high = "High parental education"
  )

## Create a new variable to code birth-year-cohorts by country (i.e. recreate the `cntry_cohort` variable from the original dataset) ----

osterman_t3 <- osterman_t3 |> 
  data_unite(new_column = "cntry_cohort", select = c("cntry", "yrbrn"), append = TRUE)


## Export the dataset to file ----
osterman_t3 |> data_write("osterman_t3.dta")


