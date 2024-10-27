# Generate the citations for the packages used in the vignettes
pkgs <- c("base",
          "raster",     # Pkgs to handle spatial data
          "sf",
          "terra",
          "geodata",    # Pkgs to access data
          "occCite",
          "rgbif",
          "rnaturalearth",
          "spocc",
          "biomod2",    # Pkgs for modelling
          "blockCV",
          "bRacatus",
          "dismo",
          "e1071",
          "ecospat",
          "ellipsenm",
          "ENMeval",
          "enmSdmX",
          "ENMTools",
          "flexsdm",
          "fuzzySim",
          "kernlab",
          "maxnet",
          "modEvA",
          "modleR",
          "ntbox",
          "randomForest",
          "sampbias",
          "SDMtune",
          "SSDM",
          "vip",
          "wallace",
          "bdc",        # Pkgs for data cleaning and variable selection
          "CoordinateCleaner",
          "spThin",
          "usdm",
          "brglm2",     # Other pkgs
          "cowplot",
          "dplyr",
          "ggplot2",
          "leaflet",
          "tidyr")
knitr::write_bib(pkgs,
                 file = "vignettes/r-pkgs.bib",
                 tweak = TRUE,
                 width = 80,
                 prefix = "pkg-") |>
  suppressMessages() |>
  suppressWarnings()

readLines("vignettes/r-pkgs.bib") |>
  gsub(pattern = "doi = \\{doi:",
       replacement = "doi = \\{", x = _) |>
  # Fix enmSdmX citation
  gsub(pattern = "Global Ecology & Biogeography",
       replacement = "Global Ecology and Biogeography", x = _) |>
  gsub(pattern = "pages = \\{-13\\},",
       replacement = "pages = \\{342--355\\},", x = _) |>
  # Fix modelR citation
  gsub(pattern = "note = \\{https://model-r.github.io/modleR/index.html\\}",
       replacement = paste0("note = \\{R package version ",
                            packageVersion('modleR'),
                            "\\},\n",
                            "  url = \\{",
                            "https://model-r.github.io/modleR/index.html\\}"),
       x = _) |>
  # Fix sf citation
  gsub(pattern = "note = \\{https://r-spatial.github.io/sf/\\}",
       replacement = paste0("note = \\{R package version ",
                            packageVersion('sf'),
                            "\\},\n",
                            "  url = \\{",
                            "https://r-spatial.github.io/sf/\\}"),
       x = _) |>
  gsub(pattern = "doi = \\{10.1201/9780429459016\\}",
       replacement = paste0("doi = \\{10.1201/9780429459016\\},\n",
                            "  pages = \\{314\\}"),
       x = _) |>
  # Fix vip citation
  gsub(pattern = "note = \\{https://github.com/koalaverse/vip/}",
       replacement = paste0("note = \\{R package version ",
                            packageVersion('vip'),
                            "\\},\n",
                            "  url = \\{",
                            "https://github.com/koalaverse/vip/\\}"),
       x = _) |>
  # Enclose pkg name with curly brackets
  stringi::stri_replace_all_regex(pattern = paste0("\\{", pkgs, ":"),
                                  replacement = paste0("\\{\\{", pkgs, "\\}:"),
                                  vectorize_all = FALSE) |>
  writeLines("vignettes/r-pkgs.bib")

