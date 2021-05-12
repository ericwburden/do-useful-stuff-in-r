# Rebuild the docker image

# Knit all the learnr tutorials. If they're not pre-knitted, changes won't be
# reflected in the containerized app

require(rprojroot)
tutorials <- list.files(
  rprojroot::is_rstudio_project$find_file("src/learnr/tutorial"),
  pattern = "index\\.Rmd",
  recursive = T,
  full.names = T
)
lapply(tutorials, rmarkdown::render)
