library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(dplyr)

df =  read.csv('./company_esg_financial_dataset.csv')

industry_AVG_year = df |> group_by(Industry, Year, Region) |>
  summarise(AvgRevenue= round(mean(Revenue),2) , 
            AvgProfitMargin = round(mean(ProfitMargin),2),
            AvgMarketCap  = round(mean(MarketCap),2),
            AvgGrowthRate = round(mean(GrowthRate, na.rm = TRUE),2),
            AvgESG_Overall = round(mean(ESG_Overall),1),
            AvgESG_Environmental = round(mean(ESG_Environmental),1),
            AvgESG_Social  = round(mean(ESG_Social),1),
            AvgESG_Governance  = round(mean(ESG_Governance),1),
            AvgCarbonEmissions = round(mean(CarbonEmissions),2),
            AvgWaterUsage  = round(mean(WaterUsage),2),
            AvgEnergyConsumption = round(mean(EnergyConsumption),2))

df_clean_ranked = df |>
  mutate(
    scaled_Carbon = as.numeric(scale(CarbonEmissions)),
    scaled_Water = as.numeric(scale(WaterUsage)),
    scaled_Energy = as.numeric(scale(EnergyConsumption))
  ) |>
  filter(
    CarbonEmissions < quantile(CarbonEmissions, 0.99, na.rm = TRUE) &
      WaterUsage < quantile(WaterUsage, 0.99, na.rm = TRUE) &
      EnergyConsumption < quantile(EnergyConsumption, 0.99, na.rm = TRUE))  |>
  mutate(
    resource_score = -1 * rowMeans(across(c(scaled_Carbon, scaled_Water, scaled_Energy)))
  )
