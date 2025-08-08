library(tidyverse)



df %>% filter(Year == input$year, Industry == input$industry, Region == input$region) %>% 
  ggplot(df, aes(x = Industry, y = log10(Revenue), color = Industry)) + 
  geom_boxplot() + 
  guides(x =  guide_axis(angle = 90))

