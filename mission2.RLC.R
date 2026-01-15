


##### Adapt 03_tbl.R code 

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

