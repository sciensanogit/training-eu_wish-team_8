############################################################################### #
# Aim ----
#| produce tables
# NOTES:
#| git cheat: git status, git add -A, git commit -m "", git push, git pull, git restore
#| list of things to do...
############################################################################### #

# Load packages ----
# select packages
pkgs <- c("dplyr", "ggplot2", "flextable", "quarto")
# install packages
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))


#load data - before data prep is done
#df_nation <- read.table(file = "./Belgium_export-nation.csv", sep = ";", dec = ".", header = T)

# load data - after data prep is done
df_nation <- read.table(file = "./data_folder/Belgium_export-nation.csv", sep = ";", dec = ".", header = T)


#Make table
table_nation <- df_nation%>%
  mutate(date = as.Date(date, format="%Y-%m-%d")) %>%
  mutate(is_monday = if_else(wday(date) == 2, TRUE, FALSE)) %>%
  select(date, value_pmmv) %>%
  arrange(desc(date)) %>% 
  slice(1:10) %>%
  flextable() %>%
  fontsize(part = "body",size = 10) %>%
  fontsize(part = "header",size = 10) %>%
  set_header_labels(date = "Date", value_pmmv = "viral ratio of SARS-CoV-2 / PMMV") %>%
  bold(part = "header") %>%
  set_table_properties(layout = "autofit") %>%
  autofit() %>% theme_vanilla()
#  bg(part = "body", j = date, i = which(is_monday), bg = "orange")

#View table
table_nation


# display msg
#cat("- Success : tables saved \n")
