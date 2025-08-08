

server <- function(input, output, session) {
  
  
  output$comparison_plots = renderPlot({
    
    df |> 
      filter(Year == input$year, Region == input$region, !is.na(.data[[input$y]])) |>
      mutate(y_value = if (input$y %in% c('Revenue', 'MarketCap')) log10(.data[[input$y]]) else .data[[input$y]] ) |>
      ggplot(aes(x = reorder(Industry, y_value), y = y_value, fill = Industry)) + 
      geom_boxplot() + 
      ylab(input$y) +
      xlab('Industry') +
      ggtitle(paste('Yearly', input$y)) +
      theme_minimal(base_size = 16)
      
  })
  
  
  
  
  output$profit = renderPlotly({
    req(input$region1, input$industries)
    
   profit_plots = industry_AVG_year |> filter(Region == input$region1, Industry %in% input$industries)|> 
      ggplot(aes(x = Year, y = AvgProfitMargin, color = Industry, group = Industry,
                 text = paste(Industry, ":", AvgProfitMargin))) +
      geom_line()+ 
     geom_point() + 
     ylab('Average Market Cap') + 
     scale_x_continuous(breaks = unique(industry_AVG_year$Year))
  
   
  ggplotly(profit_plots, tooltip = 'text')
  
})
  
  
   output$esg = renderPlotly({
     req(input$region1, input$industries)
     
    esg_plots =  industry_AVG_year |> filter(Region == input$region1, Industry %in% input$industries)|> 
       ggplot(aes(x = Year, y = AvgESG_Environmental, color = Industry, group = Industry,
                  text = paste(Industry, ":", AvgESG_Environmental))) +
       geom_line()+ 
       geom_point() + 
       ylab('Average Environmental Score') + 
       scale_x_continuous(breaks = unique(industry_AVG_year$Year))
    
     ggplotly(esg_plots, tooltip =  'text')
    
  })
  
   
   
   
   output$emissions = renderPlotly({
     
     plots = df_clean_ranked |> 
        filter(Region == input$region2, Industry %in% input$industries1) |>
       group_by(CompanyName) |>
        summarise( avg_score= mean(resource_score),
                   CarbonEmissions = mean(CarbonEmissions),
                   WaterUsage = mean(WaterUsage),
                   EnergyConsumption = mean(EnergyConsumption))|> 
        slice_min(order_by = avg_score, n = 20) |>
       
     ggplot(aes(x=reorder(CompanyName, -avg_score), y= avg_score, fill = CompanyName,
                text = paste("Carbon Emissions in tons of CO2:", round(CarbonEmissions, 1), "<br>",
                             "Water Usage in Cubic Meters:", round(WaterUsage,1), "<br>",
                             "Energy Consumption in MWh:", round(EnergyConsumption, 1)))) +
       geom_col()+
        xlab('Company Name') +
        ylab('Resource Score')+
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) + scale_fill_hue()
     
     ggplotly(plots, tooltip = "text")
     
   })
  
   
  observeEvent(input$deselect_all, {
    updateCheckboxGroupInput(session, "industries", selected = character(0))
  })
 
  
  
  
    output$mytable <- DT::renderDataTable(df_clean_ranked,
                                          options = list(scrollX = TRUE),
                                          rownames = FALSE)
    
      
      
    observeEvent(list(input$region3, input$industry1), {
        req(input$region3, input$industry1)
        filtered_companies = df |> 
          filter(Region == input$region3, Industry == input$industry1) |>
          pull(CompanyName) |> unique()
          
          
      updateSelectizeInput(
        session,
        inputId = "choose_company",
        choices = filtered_companies,
        server = TRUE)
    })
    
    
    output$company_research = renderPlot({
      req(df, input$industry1, input$region3, input$choose_company, input$y1)
      df %>%
        filter(Industry == input$industry1, 
               Region == input$region3, 
               CompanyName == input$choose_company,
               !is.na(.data[[input$y1]])) %>%
        
        mutate(y_value = if (input$y1 %in% c('Revenue', 'MarketCap'))
          log10(.data[[input$y1]]) else .data[[input$y1]] ) %>%
        
        ggplot(aes(x = Year, y = y_value, group= CompanyName)) + 
        geom_line() + geom_point()+
        ylab(input$y1) +
        scale_x_continuous(breaks = unique(df$Year))+
        ggtitle(paste("Year Over Year", input$y1, "for", input$choose_company)) 
      
      
    })
  
}