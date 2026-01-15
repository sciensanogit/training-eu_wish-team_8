############################################################################### #
# Aim ----
#| generating wastewater reports
# Requires: 
# NOTES:
#| git cheat: git status, git add -A, git commit -m "", git push, git pull, git restore
#|
############################################################################### #

# Load packages ----
# select packages
pkgs <- c("dplyr", "ggplot2")
# install packages
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))


# Mission 1.1 ----
## Source member 1 script ----
source("01_data_prep_session3.R")

## Source member 2 script ----
source("02_visuals_session3.R")

## Source member 3 script
source("03_tbl.R")

##Source member 4 script
source("04_quarto.R")