############################################################################### #
# Aim ----
#| load data and produce first graph
# NOTES:
#| list of things to do
#|
############################################################################### #

# Load packages ----
# select packages
pkgs <- c("dplyr", "ggplot2")
# install packages
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))

# load data ----
# Belgian data are available here https://www.geo.be/catalog/details/9eec5acf-a2df-11ed-9952-186571a04de2?l=en
#| Metadata
#| siteName is the name of the treatment plant
#| collDTStart is the date of sampling
#| labName is the name of the lab analysing the sample
#| labProtocolID is the protocol used to analyse the dample
#| flowRate is the flow rate measured at the inlet of the treatment plant during sampling
#| popServ is the population covered by the treatment plant
#| measure is the target measured
#| value is the result

# sars-cov-2 data
df_sc <- read.csv("https://data.geo.be/ws/sciensano/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=2.0.0&TYPENAMES=sciensano:wastewatertreatmentplantscovid&outputFormat=csv")

# pmmv data
df_pmmv <- read.csv("https://data.geo.be/ws/sciensano/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=2.0.0&TYPENAMES=sciensano:wastewatertreatmentplantspmmv&outputFormat=csv")

# join both
df <- df_sc %>%
  rbind(df_pmmv)

# clean data
df <- df %>%
  select(siteName, collDTStart, labName, labProtocolID, flowRate, popServ, measure, value)

# format date
df$date <- as.POSIXct(df$collDTStart, format = "%Y-%m-%dT%H:%M:%S")
df$date <- format(df$date, "%Y-%m-%d")

# compute viral ratio
# unique(df$measure) ...

# graph
plot <- df %>%
  filter(labProtocolID == "SC_COV_4.1") %>%
  filter(measure == "SARS-CoV-2 E gene") %>%
  filter(date > "2024-09-01" & date < "2025-09-01") %>%
  filter(siteName %in% c("Aalst", "Oostende")) %>%
  ggplot(aes(x = date, y = value, group = siteName, color = siteName)) +
  geom_point(na.rm = T) +
  geom_line(na.rm = T)

plot

# save
ggsave(file="./plot/graph_oostende_aalst.png",
       plot, width = 21, height = 12, dpi = 200)

read.csv()



##### Adapt 03_tbl.R code Open RStudio and go to the Environment pane, then select "Import Dataset" > "From Text (readr)...". 
#####Browse to your CSV file, adjust settings like header row or delimiters in the preview window, and click "Import" to load it as a data frame

#####- save a table showing last ten dates of the national viral ratio with the last date being the date_reporting defined in 01_data_prep.R
source("01_data_prep.R")
# Gets last 10 rows, with final row as latest date_reporting
last10 <- tail(df, 10)  
print(last10)
write.csv(last10[, c("date", "value")], 
          "last10_national_viral_ratio.csv", row.names = FALSE)


#library(knitr)
#kable(last10[, c("date", "value")], 
#      caption = "Last 10 National Viral Ratios") %>%
#  save_kable("viral_ratio_table.html")


###### display only sampling days which are Mondays
library(dplyr)
mondays <- Belgium_export_nation %>% 
  mutate(datetime = as.POSIXct(date)) %>%
  filter(weekdays(datetime) == "Monday")
View(mondays)


## display understandable headers, nice units, nice digits
library(knitr)
install.packages("kableExtra")
                 
library(kableExtra)
table <- kable(mondays[, c("date", "value")], 
               col.names = c("Date", "Viral Ratio (log10 CPM)"),
               digits = 3, caption = "Monday Sampling Results") %>%
  kable_styling(bootstrap_options = c("striped", "hover")) %>%
  add_header_above(c(" " = 1, "National Average" = 1))
  


write.csv(mondays, "data.csv", row.names = FALSE)  # Raw export

