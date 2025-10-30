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

# filter data
df_plot <- df %>%
  filter(labProtocolID == "SC_COV_4.1") %>%
  filter(measure == "SARS-CoV-2 E gene") %>%
  filter(date > "2024-09-01" & date < "2025-09-01") %>%
  filter(siteName %in% c("Aalst", "Oostende"))

# define y-axis limits and breaks (adjust to match Murals)
y_min <- 0
y_max <- max(df_plot$value, na.rm = TRUE) * 1.1  # 10% buffer
y_breaks <- seq(0, y_max, by = 10)  # adjust to match Murals

# define x-axis breaks (monthly)
x_breaks <- seq(as.Date("2024-09-01"), as.Date("2025-09-01"), by = "1 month")
x_labels <- format(x_breaks, "%b %Y")

# graph
plot <- ggplot(df_plot, aes(x = date, y = value, group = siteName, color = siteName)) +
  geom_point(na.rm = TRUE) +
  geom_line(na.rm = TRUE) +
  scale_y_continuous(limits = c(y_min, y_max),
                     breaks = y_breaks,
                     labels = comma_format(accuracy = 1),
                     expand = expansion(mult = c(0, 0))) +
  scale_x_date(breaks = x_breaks,
               labels = x_labels,
               expand = expansion(add = c(0, 0))) +
  theme_minimal(base_size = 14) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid.minor = element_blank(),
        plot.margin = margin(10,10,10,10)) +
  labs(x = NULL, y = "SARS-CoV-2 Value", color = "Site Name")


plot

# save
ggsave(file="./plot/graph_oostende_aalst.png",
       plot, width = 21, height = 12, dpi = 200)
