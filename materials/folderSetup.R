

## ----------------------- Create folders and metadata files ------------


for (j in c("notes", "slides", "worksheets", "handouts", "info")){
  dir.create(j)
  sapply(paste0("materials/", j, "/_metadata.yml"), file.create)
  sapply(paste0("materials/", j, "/index.qmd"), file.create)
}


## ----------------------- Edit metadata --------------------------------

notes_meta <- 
  "
format:
  html: default
#  pdf: default
bibliography: ../../hss8005.bib
page-layout: full
toc-location: left"

worksheets_meta <-
  "bibliography: ../../hss8005.bib
page-layout: full
toc-location: left
abstract-title: Description

code-link: true
code-line-numbers: true
# code-tools: true
# code-block-border-left: $ncl-blue
# code-block-bg: lightgray
# license: CC BY-NC"

handouts_meta <-
  "format:
  html: default
#  pdf: default
bibliography: ../../hss8005.bib
page-layout: full
toc-location: left
abstract-title: Description
code-link: true
code-line-numbers: true
# code-tools: true
# code-block-border-left: $ncl-blue
# code-block-bg: lightgray
# license: CC BY-NC"

info_meta <-
  "bibliography: ../../hss8005.bib
page-layout: full
toc-location: left
abstract-title: Description

code-link: true
code-line-numbers: true
# code-tools: true
# code-block-border-left: $ncl-blue
# code-block-bg: lightgray
# license: CC BY-NC"


slides_meta <-
  "bibliography: ../../hss8005.bib
page-layout: full
toc-location: left
abstract-title: Description

code-link: true
code-line-numbers: true
# code-tools: true
# code-block-border-left: $ncl-blue
# code-block-bg: lightgray
# license: CC BY-NC"

listings <-
"---
title: \"\"
toc-location: body
listing:
  type: table
  sort: \"filename\"
  fields: [title, abstract, reading-time]
  field-display-names:
    abstract: \"Description\"
  sort-ui: false
  filter-ui: false
---"

for (j in c("notes", "slides", "worksheets", "handouts", "info")){
  writeLines(listings, paste0("materials/", j, "/index.qmd"))
}


writeLines(handouts_meta, "materials/handouts/_metadata.yml")
writeLines(info_meta, "materials/info/_metadata.yml")
writeLines(notes_meta, "materials/notes/_metadata.yml")
writeLines(slides_meta, "materials/slides/_metadata.yml")
writeLines(worksheets_meta, "materials/worksheets/_metadata.yml")


## ----------------------- Listings -------------------------------------

listings <-
  "---
title: \"\"
listing:
  type: table
sort: \"filename\"
fields: [title, abstract, reading-time]
field-display-names:
  abstract: \"Description\"
sort-ui: false
filter-ui: false
---"

for (j in c("notes", "slides", "worksheets", "handouts", "info")){
  writeLines(listings, paste0("materials/", j, "/index.qmd"))
}


## ----------------------- Create template files ------------------------

dir.create("materials/templates")

sapply(paste0("materials/templates/", c("notes_template", "slides_template", "worksheets_template", "handouts_template"), ".qmd"), file.create)




## ---------------------- Template YAML ---------------------------------






## -------------- Create files -----------------------------------------



for (j in 1:8) {
  file.copy(from = "materials/templates/slides_template.qmd", to = paste0("materials/slides/draft-slides_w0", j, ".qmd"), overwrite = TRUE)
  readLines(paste0("materials/slides/draft-slides_w0", j, ".qmd")) |> 
  stringr::str_replace_all(
    pattern = "REPLACE", 
    replace = paste0(j)) |> 
  writeLines(con = paste0("materials/slides/draft-slides_w0", j, ".qmd"))
}






## -------------- Teaching dates 2023 ----------------------------------

# Start date
week1 <- lubridate::as_date("02-02-2023", format = '%d-%m-%Y')

# Semester dates
dates <- c(week1 - 3, week1 + 7*0:7, week1 + 7*7 + 1)

# Add list of dates as a variable to "_variables.yml"
write_lines(c("date:", paste0("  w", c("Intro", 1:8, "Conclusion"), ": ", "\"", print(as.character(dates)), "\"")), 
            append = TRUE, file = "_variables.yml")


## -------------- Slide links -------------------------------------------

write_lines("slides:", append = TRUE, file = "_variables.yml")

for (j in 1:8) {
write_lines(paste0("  w", j, ": ", "\"", "https://cgmoreh.github.io/webslides/HSS8005/w", j, "\""), 
            append = TRUE, file = "_variables.yml")
}




