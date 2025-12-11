############################################################################### #
# Aim ----
#| load, clean and save data
# NOTES:
#| git cheat: git status, git add -A, git commit -m "", git push, git pull, git restore
#| list of things to do...
############################################################################### #

# Load packages ----
# select packages
pkgs <- c("dplyr", "tidyr", "zoo", "writexl", "ggplot2", "stringr")
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
  select(siteName, collDTStart, labName, labProtocolID, flowRate, popServ, measure, value, quality)

# format date
df$date <- as.Date(df$collDTStart)

# set and subset dates
date_reporting <- as.Date("2025-09-01", format = "%Y-%m-%d")
date_graph_start <- as.Date("2024-09-01", format = "%Y-%m-%d")
date_graph_end <- as.Date("2025-12-01", format = "%Y-%m-%d")

# subset sars and pmmv data based on labProtocolID used betwen date_start and date_end
df_subset<-df %>% 
  filter(
    between(date, date_graph_start, date_graph_end),
    labProtocolID%in%c("SC_COV_4.1", "UA_COV_4.0", "SC_PMMV_2.1", "UA_PMMV_2.0"))
# display existing labProtocolID
unique(df$labProtocolID)
unique(df$measure)

# rename measures
df_renamed<-df_subset %>% mutate(measure=
  if_else(str_detect(
    measure, "SARS"), "SARS", "PMMV"))
# diplay existing measure
# unique(df$measure)

# translate siteName to english
df_trans<-df_renamed %>%  mutate(
  siteName=str_replace(siteName, "Sud", "South"),
  siteName=str_replace(siteName, "Nord", "North")
)

# apply LOQ provided by the lab
df_loq<-df_trans %>% mutate(
  value=case_when(measure=="PMMV"&value<250 ~ NA, TRUE ~ value),
  value=case_when(measure=="SARS"&value<8 ~ NA, TRUE ~ value)
)

# remove outliers
df_out<-df_loq %>% mutate(
  value=case_when(quality=="Quality concerns" ~ NA, TRUE ~ value)
)

# compute mean of replicated analysis of each measure
df_mean<-df_out %>% 
  group_by(
    siteName, date, measure) %>% 
  summarize(summarized_values=mean(value))
# compute viral ratio
df_ratio<-df_mean %>% 
  pivot_wider(
    names_from=measure, values_from = summarized_values) %>% 
  mutate(viral_ratio=SARS/PMMV)
# unique(df$measure) ...

# compute moving average on past 14 days

# natinoal aggregation: compute weighted mean with factor being the population served by each site

# export data ----
# create folder if not existing
dir.create("data")
# export as csv
write.csv(df_ratio, "data/viral_ratio_data_CM.csv")
# export as xls

# export as rds


# display msg
cat("- Success : data prep \n")

