

dashboardPage(skin = 'blue',
  dashboardHeader(title='Company Research App', titleWidth = 300),
  
  dashboardSidebar(
    sidebarMenu( id = 'tabs',
      menuItem("About this App and it's Data", tabName= 'Welcome', icon = icon('map')),
      
      menuItem("Financial Plots", tabName = "Financials", icon = icon("map")),
         
      menuItem('ESG Rating and Profit Margin', tabName = 'ESG_ProfitMargin', icon = icon('map')),
      
      menuItem(HTML("Resource Consumption<br>and Emissions"), tabName = "Emissions", icon = icon("map")),
      
      menuItem('Individual Company Research', tabName = 'Company_Research', icon = icon('map'))
      )
  ),

          
    
  dashboardBody(
    tabItems(
      tabItem(tabName = 'Welcome',
                       fluidRow(
                         box(
                           title = "About this App and its Data",
                           width = 12,
                           h5("This dataset shows simulated data regarding the financial and ESG (Environmental, Social, and Governance) performance of 1,000 global companies across 9 industries and 7 regions from 2015 to 2025."),
                           p("Revenue: Annual revenue in millions USD"),
                           p("ProfitMargin: Net profit margin as percentage of revenue"),
                           p("MarketCap: Market capitalization in millions USD"),
                           p("GrowthRate: Year-over-year revenue growth rate (%) (starting with 2015)"),
                           p("ESG_Overall: Aggregate ESG sustainability score 0-100"),
                           p("ESG_Environmental: Environmental sustainability score 0-100"),
                           p("ESG_Social: Social responsibility score 0-100"),
                           p("ESG_Governance: Corporate governance quality score 0-100"),
                           p("CarbonEmissions: Annual carbon emissions in tons CO₂ "),
                           p("WaterUsage: Annual water usage in cubic meters"),
                           p("EnergyConsumption: Annual energy consumption in megawatt-hours (MWh)")
                         )
                         
        
      )),
      tabItem(tabName = 'Financials', fluidRow(
                                      box(title ="Financial Plots", width = 12,
                                          fluidRow( column(
                                        width = 4,
                                          selectizeInput(inputId = "region",                                              
                                                          label = "Select Region",
                                                         choices=unique(df$Region))
                                        ),
                                          column(width = 4,
                                          selectizeInput(inputId= 'year',
                                                         label = 'Year',
                                                         choices = unique(df$Year),
                                                         selected = 2025)
                                          ),
                                          column(width = 4,
                                          selectizeInput(inputId = 'y',
                                                         label = 'Y-Axis',
                                                         choices = c('Revenue', 'ProfitMargin',
                                                                     'MarketCap', 'GrowthRate'))
                                          )
                                        ),
                                        fluidRow(
                                          plotOutput('comparison_plots', height = '600px'))
                                        
              )
            )
           ),
    
      tabItem(tabName='ESG_ProfitMargin',
            fluidRow(
              box(title = 'ESG(Environmental) Rating and Profit Margin', width = 12, 
                  selectizeInput(inputId = "region1", 
                                    label = "Select Region",
                                   choices=unique(industry_AVG_year$Region)),
                  
                  fluidRow(
                    column(
                      width = 9,
                      checkboxGroupInput(
                        inputId = "industries", 
                        label = "Select Industries", 
                        choices = unique(industry_AVG_year$Industry), 
                        selected = unique(industry_AVG_year$Industry),
                        inline=TRUE
                      )
                    ),
                    column(
                      width = 3,
                      br(),  # adds vertical space to align the button nicely with checkboxes
                      actionButton("deselect_all", "Deselect All")
                    )
                  ),
                  
                  plotlyOutput('esg', height = '450px'),  plotlyOutput('profit', height = '450px'))

     )
    ),
    
    tabItem(tabName='Emissions',
            fluidRow(
              box(title = HTML("Company Resource Score:<br>Energy Consumption and Emissions Data"), width = 12, 
                  h5('This resource score combines scaled values of carbon emissions, water usage, and energy consumption 
                  to create a single environmental impact metric. A higher resource score indicates better resource efficiency, 
                  in the form of less resource consumption and lower carbon emissions.'),
                  
                  selectizeInput(inputId = "region2", 
                                             label = "Select Region",
                                          choices=unique(df_clean_ranked$Region)),
                  
                  selectizeInput("industries1", label = 'Select Industries', 
                                 choices = unique(df_clean_ranked$Industry), 
                                 selected = unique(df_clean_ranked$Industry)),
                  
                  
                  plotlyOutput('emissions')),
              
              titlePanel("Company Data"),
              mainPanel(width = 12,
                        DT::dataTableOutput("mytable")
    )
   )
  ),
  
  tabItem(tabName = 'Company_Research', 
          fluidRow(
               box(title ="Company Research", width = 12, 
                   selectizeInput(inputId = "region3", 
                                  label = "Select Region",
                                  choices=unique(df$Region),
                                  multiple = FALSE),
                   
                   selectizeInput(inputId = "industry1", 
                                  label = "Select Indsutry",
                                  choices=unique(df$Industry),
                                  multiple= FALSE),
                   
                   selectizeInput(inputId = 'choose_company',
                                  label = 'Select a Company',
                                  choices = NULL,
                                  multiple = FALSE),
                   
                   selectizeInput(inputId= "y1", 
                                  label = 'Select Plot Information', 
                                  choices = c('Revenue', 'ProfitMargin', 'MarketCap', 'GrowthRate',
                                              "ESG_Overall",  "ESG_Environmental", "ESG_Social",
                                              "ESG_Governance",    "CarbonEmissions",  
                                              "WaterUsage", "EnergyConsumption"),
                                  multiple = FALSE),
                   
                   plotOutput('company_research'))
    
       )
      )
    )
  )
)