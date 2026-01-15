############################################################################### #
# Aim ----
#| produce visuals
# NOTES:
#| git cheat: git status, git add -A, git commit -m "", git push, git pull, git restore
#| list of things to do...
############################################################################### #

# Load packages ----
# select packages
pkgs <- c("dplyr", "tidyr", "zoo", "writexl", "ggplot2", "lubridate")
# install packages
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))

# load data
<<<<<<< HEAD
BelgiumExport_nation <- read.csv("Belgium_export-nation.csv", sep=";") %>% mutate(week=week(date), year=year(date))

# create folder if not existing
ifelse(!dir.exists("plot"), dir.create("plot"), "Folder exists already")

#define colors
line_colors=c(
  "value_pmmv"="#C93E22",
  "value_pmmv_avg14d_past"="#CF9184"
)

# graph at national level
graph_nation <- BelgiumExport_nation %>% filter(value_pmmv>0) %>% 
  ggplot() +
  geom_point(aes(x = week, y=value_pmmv, group=1, color="value_pmmv"), size=2)+
  geom_line(aes(x = week ,y=value_pmmv_avg14d_past, group=1, color="value_pmmv_avg14d_past"), size=2, alpha=0.5)+
  theme(axis.text.x=element_text(angle=90))+
  labs(title = "Viral ratio over time in Belgium",
       x = "Calendar week",
       y = "Viral ratio") +
  facet_wrap(~year, scales="free_x") +
  theme_bw()+
  scale_color_manual(values=line_colors)+
  labs(color="Value")

 print(graph_nation)

# save graph
ggsave(graph_nation, filename = "graph-viral_ratio-nation.png", path = "plot")


# display msg
cat("- Success : visuals saved \n")

#add a test line for pushing
=======
  ==========


