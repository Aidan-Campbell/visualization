library(tidyverse); library(dplyr);library(ggpubr); library(viridis)
#Load the data
df.COVIDdeaths.age <- data.frame(read.csv("./public_data/covid_deathsMA_age.csv"))
#Cleaning and converting to long format
df_long <- df.COVIDdeaths.age %>%
  select(date, age_group, 
         deaths_boost_vac_rate_7ma, 
         deaths_full_vac_rate_7ma,
         deaths_not_full_vac_rate_7ma) %>%
  pivot_longer(
    cols = starts_with("deaths_"),
    names_to = "vaccination_status",
    values_to = "death_rate"
  ) %>%
  mutate(
    vaccination_status = case_when( #Creating variable for vaccination status
      vaccination_status == "deaths_boost_vac_rate_7ma" ~ "Boosted",
      vaccination_status == "deaths_full_vac_rate_7ma" ~ "Fully Vaccinated",
      vaccination_status == "deaths_not_full_vac_rate_7ma" ~ "Not Fully Vaccinated",
      TRUE ~ vaccination_status
    ),
    age_group = factor(age_group, 
                       levels = c("0-4yrs", "5-11yrs", "12-17yrs", 
                                  "18-39yrs", "40-59yrs", "60+", "ALL"))
  )
#This cleans the data up a little more
df_long <- df_long %>%
  mutate(
    date = as.Date(sub("T.*", "", date)),
    #Kept only adult ranges as I was originally interested in comparing across these groups
    age_group = factor(age_group,
                       levels = c("18-39yrs", "40-59yrs", "60+"))
  ) %>%
  filter(
    age_group %in% c("18-39yrs", "40-59yrs", "60+")
  )

#Create plot looking only at 7-day Moving Averages of death rates for ages 60+
df_long %>%
  filter(age_group == "60+") %>%
  ggplot(aes(x = date, y = death_rate)) +
  geom_line(linewidth = 1, aes(color = vaccination_status)) +
  facet_wrap( #For comparison across vaccine status, stacked them vertically
    ~ vaccination_status, 
    nrow = 3,
    strip.position = "right"
  ) +
  #Fixed Y-axis across each comparison group
  coord_cartesian(ylim = c(0, 20)) +
  #Setting interval spacing for tick marks
  scale_x_date(
    date_breaks = "3 months",
    date_labels = "%b %Y"
  ) +
  labs(
    title = "COVID-19 Death Rates for Seniors (60+)",
    x = "Date",
    y = "Death Rate (per 100k)"
  ) +
  theme_minimal() +
  #Cleaning up the appearance (no redundant legend, spaces between graphs)
  theme(
    legend.position = "none",
    strip.text = element_text(face = "bold", size = 10),
    panel.spacing = unit(1, "lines"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  ) +
  #Adding virdis coloring just to test it out
  scale_color_viridis(discrete = TRUE, begin = 0.1, direction = 1, option = "turbo")




#Copied this graph to replicate for other age groups
df_long %>%
  filter(age_group == "18-39yrs") %>%
  ggplot(aes(x = date, y = death_rate)) +
  geom_line(linewidth = 1, aes(color = vaccination_status)) +
  facet_wrap( #For comparison across vaccine status, stacked them vertically
    ~ vaccination_status, 
    nrow = 3,
    strip.position = "right"
  ) +
  #Fixed Y-axis across each comparison group
  coord_cartesian(ylim = c(0, 0.25)) + #Note: the Y-limit has been reduced to 0.25 here 
  #Setting colors for comparison groups
  scale_color_manual(values = c(
    "Boosted" = "#1f77b4",
    "Fully Vaccinated" = "#ff7f0e",
    "Not Fully Vaccinated" = "#d62728"
  )) +
  #Setting interval spacing for tick marks
  scale_x_date(
    date_breaks = "3 months",
    date_labels = "%b %Y"
  ) +
  labs(
    title = "COVID-19 Death Rates for Seniors (Ages 18-39)",
    x = "Date",
    y = "Death Rate (per 100k)"
  ) +
  theme_minimal() +
  #Cleaning up the appearance (no redundant legend, spaces between graphs)
  theme(
    legend.position = "none",
    strip.text = element_text(face = "bold", size = 10),
    panel.spacing = unit(1, "lines"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

df_long %>%
  filter(age_group == "40-59yrs") %>%
  ggplot(aes(x = date, y = death_rate)) +
  geom_line(linewidth = 1, aes(color = vaccination_status)) +
  facet_wrap( #For comparison across vaccine status, stacked them vertically
    ~ vaccination_status, 
    nrow = 3,
    strip.position = "right"
  ) +
  #Fixed Y-axis across each comparison group
  coord_cartesian(ylim = c(0, 0.5)) + #Note: Y-limit reduced to 0.5 here
  #Setting colors for comparison groups
  scale_color_manual(values = c(
    "Boosted" = "#1f77b4",
    "Fully Vaccinated" = "#ff7f0e",
    "Not Fully Vaccinated" = "#d62728"
  )) +
  #Setting interval spacing for tick marks
  scale_x_date(
    date_breaks = "3 months",
    date_labels = "%b %Y"
  ) +
  labs(
    title = "COVID-19 Death Rates for Seniors (Ages 40-59)",
    x = "Date",
    y = "Death Rate (per 100k)"
  ) +
  theme_minimal() +
  #Cleaning up the appearance (no redundant legend, spaces between graphs)
  theme(
    legend.position = "none",
    strip.text = element_text(face = "bold", size = 10),
    panel.spacing = unit(1, "lines"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )
