library(shiny)
library(rCharts)
library(data.table)
library(UsingR)

shinyUI(
  #specify a layout for page with a sidebar
  pageWithSidebar(
    
    #instantiate a header panel with an overall title
    headerPanel( p("MLB Team Stats Explorer") ),
  
    #instanditate the sidebard to control team data to be plotted
    sidebarPanel(width=3, uiOutput("teamControls") ),
 
    #in the main panel, allow the user to select the relevant statistics and plot the outcome
    mainPanel(
      #the first column will include a selector for data to be plotted
      column(3,
        wellPanel(
          radioButtons(
            "statsToBeExplored", "Stat To Explore (chose 1):",
            c("Attendance" = "attendance", "Runs Scored" = "scored", 
               "Runs Allowed" = "allowed", "Wins" = "wins") 
          ) #end of radioButtons
        ) #end of wellpanel      
      ), #end of column
      #the second column will inlcude the plots along with a legend for the team colors
      column(9,
        wellPanel( 
          plotOutput('teamStatByYear'),
          plotOutput('teamLegend')
        ) #end of wellPanel 
      ) #end of column
    ) #end of mainPanel

  ) #end of pageWithSidebar
  
) #end of shinyUI