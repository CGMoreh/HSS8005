### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###  
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###  
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###  
### ----------------------------------------------------------------------- ###  
###               Preparing the data file `trust_inequality`                ### 
###  data source: World Values Survey; European Values Study; World Bank    ### 
###                  purpose: data for teaching                             ### 
###                  script author: Dr Chris Moreh                          ### 
###                       date: January 2025                                ### 
### ----------------------------------------------------------------------- ###  
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###  
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###  

##### Packages #####

if (!require("pacman")) install.packages("pacman")

pacman::p_load(
  tidyverse, ggrepel, easystats, sjlabelled, archive, fs
)

##### Joint EVS/WVS 2017-2022 #####

# Version 5 of the Joint EVS/WVS 2017-2022 dataset was downloaded in SPSS format from the EVS website (https://search.gesis.org/research_data/ZA7505).
# The code below assumes that the zipped file containing the raw dataset was saved locally to folder path `data/raw/wvs_evs`.

## Find the raw data file in the system
fs::dir_ls("data/raw/wvs_evs")

## Save the data file name as a string value
datafile <- "data/raw/wvs_evs/ZA7505_v5-0-0.sav.zip"

## Create readable connection to the compressed file
d <- archive::archive_read(datafile)

# Import dataset
j_wvs_evs <- sjlabelled::read_spss(d)

## Select only `trust` and country name variables, make some changes
j_wvs_evs_small <- j_wvs_evs |> 
  select(cntry, cntry_AN, A165) |> 
  rename(trust = A165,
         country_code = cntry_AN) |> 
  mutate(country = as_numeric(cntry) |> 
           as_label(),
         country = case_match(country, 
                              "Great Britain" ~ "United Kingdom",
                              "Northern Ireland" ~ "United Kingdom",
                              .default = country),  
         trust_d = sjmisc::rec(trust, 
                               rec = "2=0; 1=1; else=NA")) |> 
  mutate(trust_pct = round(mean(trust_d, na.rm = T) * 100, 2), 
         .by = country) # instead of `group_by` (https://dplyr.tidyverse.org/reference/dplyr_by.html)

## Quick checks
nrow(j_wvs_evs_small)           # should be 156658
nrow(distinct(j_wvs_evs_small)) # should be 263

## Collapse variables to country-averaged
j_wvs_evs_small_avg <- j_wvs_evs_small |> 
  select(-c(trust, trust_d, cntry)) |> 
  distinct(country, .keep_all = TRUE)

## Quick checks
nrow(distinct(j_wvs_evs_small_avg))              # should be 91

identical(nrow(j_wvs_evs_small_avg),             # should be TRUE
          nrow(distinct(j_wvs_evs_small_avg))
          )

##### World Bank data

# Data with various country-level indicators were downloaded from https://data.worldbank.org/indicator

## Find the raw data file in the system
fs::dir_ls("data/raw/wb")

## Import Excel sheet with the data and make some changes
WB <- readxl::read_xlsx("data/raw/wb/P_Data_Extract_From_World_Development_Indicators.xlsx", sheet = 1) |> 
  select(3, 5:10) |> 
  rename(country = 1,
         GDP_pc = 2,
         pop_n = 3,
         urban_pop_pct = 4,
         income_top20 = 5,
         income_bottom20 = 6,
         inequality_s80s20 = 7) |>
  mutate(across(-c(country), as.numeric),
         country = case_match(country, 
                              "Russian Federation" ~ "Russia", 
                              "Slovak Republic" ~ "Slovakia", 
                              "Egypt, Arab Rep." ~ "Egypt",
                              "Hong Kong SAR, China" ~ "Hong Kong SAR",
                              "Iran, Islamic Rep." ~ "Iran",
                              "Kyrgyz Republic" ~ "Kyrgyzstan",
                              "Macao SAR, China" ~ "Macau SAR",
                              "Korea, Rep." ~ "South Korea",
                              "Turkiye" ~ "Turkey",
                              .default = country))

## Another spreadsheet was downloaded from the World Bank, which codes their country classifications (world regions, income group, etc.)
WB_CLASS <- readxl::read_xlsx("data/raw/wb/CLASS.xlsx", sheet = 1, n_max = 220) |> 
  select(1, 3, 4) |> 
  rename(country = "Economy",
         region = "Region",
         income_gr = "Income group") |> 
  mutate(country = case_match(country, 
                              "Russian Federation" ~ "Russia", 
                              "Slovak Republic" ~ "Slovakia", 
                              "Egypt, Arab Rep." ~ "Egypt",
                              "Hong Kong SAR, China" ~ "Hong Kong SAR",
                              "Iran, Islamic Rep." ~ "Iran",
                              "Kyrgyz Republic" ~ "Kyrgyzstan",
                              "Macao SAR, China" ~ "Macau SAR",
                              "Korea, Rep." ~ "South Korea",
                              "Türkiye" ~ "Turkey",
                              .default = country))


## Match and merge the datasets

all_data <- list(j_wvs_evs_small_avg, 
                 WB, WB_CLASS)

joint_merged <- datawizard::data_merge(all_data, join = "left", by = "country")

## Final data management, labelling the variables for export types that support it

joint_merged  <- joint_merged |> 
  sjlabelled::var_labels(country = "Country name",
                         trust_pct = "% people who agree that “most people can be trusted”",
                         GDP_pc = "GDP per capita, PPP (constant 2017 international $)",
                         pop_n = "Population size",
                         urban_pop_pct = "% of population living in urban areas",
                         income_top20 = "Share of population in the top 20% of the income distribution",
                         income_bottom20 = "Share of population in the bottom 20% of the income distribution",
                         inequality_s80s20 = "Ratio of the average income of the 20% richest to the 20% poorest",
                         region = "Geographical region (World Bank classification)",
                         income_gr = "Income group (World Bank classification)",
                         ) 

## Save as RDS
saveRDS(joint_merged, "data/trust_inequality.rds", compress = "bzip2")
## Save as DTA
data_write(joint_merged, "data/trust_inequality.dta")
## Save as CSV
data_write(joint_merged, "data/trust_inequality.csv")

