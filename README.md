# Achieving higher standards in species distribution modeling by leveraging the diversity of available software: tutorials

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.14000836.svg)](https://doi.org/10.5281/zenodo.14000836)

There are many tools for species distribution modeling in R, so many in fact that sorting through them and deciding which to use for what can be an overwhelming exercise. This repository provides .Rmd files for the three vignettes (i.e., tutorials) and associated data as supplemental information to  [Kass et al. (2024)](https://www.doi.org/10.1111/ecog.07346) that highlight how pluralistic use of R package tools can enhance analyses. The .pdf files for the vignettes are also available on [Figshare](www.doi.org/10.6084/m9.figshare.27312903). All vignettes present full SDM analyses from data collection and processing to model building and predictions, and two of them provide walkthroughs for shiny applications. This repository also provides code and data to reproduce Figures 2 and S1 from the manuscript. This first release (1.0.0) is planned to be updated over time to adapt to new package versions.

## Project leaders

Jamie M. Kass, Adam B. Smith, and Dan L. Warren led the authorship of the vignettes. Sergio Vignali implemented full reproducibility of the analysis and led formatting and syntax standardization, customized plotting, bug fixing, and general management of the Github repository during development. Other vignette authors are acknowledged in the front matter of each vignette.

## Repository structure

There are four main folders in this project:

* **data** stores the data used for analyses and one table for Figure S1
* **output** will store the data outputs of analyses once they are run
* **scripts** includes code to reproduce manuscript figures and citations for R packages
* **vignettes** has the RMarkdown files for the vignettes

> [!IMPORTANT]
> 1. We use `R` 4.3.3 (not possible with `R` >= 4.4.0 because at the current time `rgdal` cannot be compiled in Windows).
> 2. It can take a rather long time to install all the necessary dependencies.
> 3. These vignettes function properly with the exact versions of the packages included in the `renv` lockfile. There is no guarantee that they will work with other versions.
> 4. The package `rJava` requires `Java JDK` to be installed. Check the package [website](https://www.rforge.net/rJava/docs/index.html) for more information. Running `R CMD javareconf` in the terminal can help for Mac OS and Linux.
> 5. Windows users need to download and install [Rtools43](https://cran.r-project.org/bin/windows/Rtools/rtools43/rtools.html) in order to compile and install packages from source.


## Data used in vignettes

All the data used in the vignettes are downloaded within the code, with one exception: the `occCiteData` object containing moose occurrences in the climate change vignette. Acquiring the `occCiteData` object requires signing into GBIF, so these data are provided with the vignettes. In the invasive species vignette, users can choose to download the IUCN Red List expert range map shapefile ([available for download here with sign-in](https://www.iucnredlist.org/species/70204120/70204139)) to inform the native range, but as this data has sharing restrictions, the vignette includes a workaround using political boundaries.

## Code formatting

Since the vignettes use several R packages for SDMs, to avoid confusion, all functions are explicitly specified using the `package_name::function()` format. For example:

```r
geodata::sp_occurrence(genus = "Homo",
                       species = "habilis")
```

This syntax avoids a conflict if another package has a function with the same name. In a few cases, we directly imported the package with `library()` to simplify the code, e.g., `library(ggplot2)`.

Many functions used in the vignettes are verbose and print useful and informative messages. These messages have been silenced to produce a more concise output, but they will be displayed if you run the code interactively.

When executing the code interactively, each chunk should be executed in full by clicking the `Run Current Chunk` button and not by running one command at a time, especially for chunks that include plotting functions.

## Spatial data

Some of these packages use `terra` objects, while others still use `raster` objects, though this package is soon to be deprecated. We will update vignettes when packages make the switch to `terra`. We named environmental rasters with the notation `envs_terra` and `envs_raster` to reduce confusion and specify which format is needed by each package.

## Install packages

The project uses `renv` to track package versions and create a project library. To recreate the same project library used to compile the vignettes of [Kass et al. 2024](www.doi.org/10.1111/ecog.07346), run the following command:

```r
renv::restore()
```

This command takes some time to run but it will isolate the packages used in this project from those that you have already installed in your system/user library, avoiding possible conflicts.

## Dockerfile

To avoid having to install all the required packages on your computer, we provide a `Dockerfile` to build an image containing all the software necessary to run the code in the vignettes. In order to build the image and reproduce the analyses, clone the repository and follow the steps below:

1. First, download the Docker app and run it. Then create a Docker image (this step may take several minutes): open the Terminal, go to the repository folder and run:

    ```
    docker build -t sdm-tutorials-image .
    ```

2. Launch a container: run the following command from the Terminal (replace `yourpassword` with a password of your choice):

    * Linux and macOS

      ```
      docker run --rm -it -p 8787:8787 -e PASSWORD=yourpassword -v $(pwd):/home/rstudio/sdm-pkg-plurality-tutorials sdm-tutorials-image
      ```

    * Windows (Command Prompt)

      ```
      docker run --rm -it -p 8787:8787 -e PASSWORD=yourpassword -v %cd%:/home/rstudio/sdm-pkg-plurality-tutorials sdm-tutorials-image
      ```

    This mounts your local folder in the container and saves the output of the analyses on your computer.

3. Start RStudio server: in your web browser, go to `localhost:8787`. You will have to enter a username and password. The username is `rstudio` while the password is the one you used in step 2.

Now everything is set up. You can open the RMarkdown files in the `vignettes` folder and run the steps interactively, or alternatively knit the .pdf file to reproduce the same output in [Figshare](www.doi.org/10.6084/m9.figshare.27312903). To stop the container, go to the Terminal window running the process and press <kbd>Ctrl</kbd> + <kbd>C</kbd>.

## Troubleshooting

### PROJ on Mac OS

If you installed PROJ with Homebrew on Mac OS, you may get the error `Cannot find proj.db`. One possible fix is to create a `.Renviron` file and specify where the `proj.db` lives. This way, RStudio will know its location whenever you open this project. However, if you build the Docker image, which is based on Linux, and mount the local folder in the container, the `.Renviron` file would also interfere with the container settings. For this reason, we suggest to specify the environment variable for the `proj.db` dynamically within the `.Rprofile` file by first checking the OS running the R session. To implement this approach, follow the steps below:

1. Make sure that `Homebrew` has an updated `PROJ` install. From the Terminal run the following commands:

    ```
    brew update
    ```

    ```
    brew upgrade proj
    ```

    Or, if for some reason `PROJ` was not installed already, use this first:

    ```
    brew install proj
    ```

2. From RStudio run the following `R` command:

    ```r
    usethis::edit_r_profile(scope = "project")
    ```

    This command opens the already existing `.Rprofile` file.

3. Uncomment the code from line 5 to 8 and replace `9.4.0` with your version of `PROJ`.

4. Save the file, restart `R` and confirm that the directory is set with:

    ```r
    Sys.getenv("PROJ_LIB")
    ```

### gfortran on Mac OS

If you are using Mac OS and get `warning: search path '/opt/gfortran/lib' not found`, you may need to install `gfortran` separately, even if you had installed it with Homebrew. You can find it here, at the very top of the [R for macOS webpage](https://cran.r-project.org/bin/macosx/tools/).
