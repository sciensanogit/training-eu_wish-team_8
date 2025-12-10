############################################################################### #
# Aim ----
#| produce visuals
# NOTES:
#| git cheat: git status, git add -A, git commit -m "", git push, git pull, git restore
#| list of things to do...
############################################################################### #

# Load packages ----
# select packages
pkgs <- c("dplyr", "tidyr", "zoo", "writexl", "ggplot2")
# install packages
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))

# load data
BelgiumExport_nation <- read.csv("Belgium_export-nation.csv", sep=";")

# create folder if not existing
ifelse(!dir.exists("plot"), dir.create("plot"), "Folder exists already")

# graph at national level
graph_nation <- BelgiumExport_nation %>%
  ggplot(aes(x = date, y = value)) +
  geom_point(color = "blue", na.rm = T) +
  labs(title = "Mean normalized concentration over time in Belgium",
       x = "Date",
       y = "Mean normalized concentration") +

  print(graph_nation)

# save graph
ggsave(graph_nation, filename = "graph-viral_ratio-nation.png", path = "plot")


# display msg
cat("- Success : visuals saved \n")

#add a test line for pushing
