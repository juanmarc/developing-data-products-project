library(shiny)
library(dplyr)
library(ggplot2)
library(data.table)
library(rCharts)
library(reshape2)
library(markdown)
library(UsingR)

#prepare the data
#rename the franchises to be more descriptive
#add a color for each team for plotting and for the legend
MLBattend$color <- "black"
MLBattend$color[MLBattend$franchise == "ANA"] <- "red"
MLBattend$franchise <- gsub("ANA","Angels",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "CAL"] <- "red"
MLBattend$franchise <- gsub("CAL","Angels",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "ARI"] <- "darkred"
MLBattend$franchise <- gsub("ARI","Diamond Backs",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "ATL"] <- "red1"
MLBattend$franchise <- gsub("ATL","Braves",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "BAL"] <- "darkorange"
MLBattend$franchise <- gsub("BAL","Orioles",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "BOS"] <- "red2"
MLBattend$franchise <- gsub("BOS","Red Sox",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "CHIA"] <- "slategray4"
MLBattend$franchise <- gsub("CHIA","White Sox",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "CHIN"] <- "blue4"
MLBattend$franchise <- gsub("CHIN","Cubs",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "CIN"] <- "red2"
MLBattend$franchise <- gsub("CIN","Reds",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "CLE"] <- "darkblue"
MLBattend$franchise <- gsub("CLE","Indians",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "COL"] <- "blueviolet"
MLBattend$franchise <- gsub("COL","Rockies",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "DET"] <- "midnightblue"
MLBattend$franchise <- gsub("DET","Tigers",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "FL"] <- "darkturquoise"
MLBattend$franchise <- gsub("FL","Marlins",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "HOU"] <- "red3"
MLBattend$franchise <- gsub("HOU","Astros",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "KC"] <- "royalblue4"
MLBattend$franchise <- gsub("KC","Royals",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "MILA"] <- "navyblue"
MLBattend$franchise <- gsub("MILA","Brewers",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "MILN"] <- "navyblue"
MLBattend$franchise <- gsub("MILN","Brewers",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "LA"] <- "dodgerblue"
MLBattend$franchise <- gsub("LA","Dodgers",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "MIN"] <- "midnightblue"
MLBattend$franchise <- gsub("MIN","Twins",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "MON"] <- "mediumblue"
MLBattend$franchise <- gsub("MON","Expos",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "NYA"] <- "navy"
MLBattend$franchise <- gsub("NYA","Yankees",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "NYN"] <- "blue2"
MLBattend$franchise <- gsub("NYN","Mets",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "OAK"] <- "springgreen4"
MLBattend$franchise <- gsub("OAK","A's",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "PHI"] <- "indianred4"
MLBattend$franchise <- gsub("PHI","Phillies",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "PIT"] <- "black"
MLBattend$franchise <- gsub("PIT","Pirates",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "SD"] <- "navyblue"
MLBattend$franchise <- gsub("SD","Padres",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "SEA"] <- "darkslategray"
MLBattend$franchise <- gsub("SEA","Mariners",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "SF"] <- "darkorange3"
MLBattend$franchise <- gsub("SF","Giants",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "STL"] <- "red1"
MLBattend$franchise <- gsub("STL","Cardinals",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "TB"] <- "turquoise4"
MLBattend$franchise <- gsub("TB","Rays",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "TEX"] <- "firebrick"
MLBattend$franchise <- gsub("TEX","Rangers",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "WAS"] <- "firebrick4"
MLBattend$franchise <- gsub("WAS","Rangers",MLBattend$franchise, fixed=TRUE)
MLBattend$color[MLBattend$franchise == "TOR"] <- "blue3"
MLBattend$franchise <- gsub("TOR","Blue Jays",MLBattend$franchise, fixed=TRUE)

#sort the team list to be in alphabetical order
teamList <- sort(unique(MLBattend$franchise))

#adjust the year range from 69 - 00 to be from 1969 - 2000
MLBattend$year <- 1900 + MLBattend$year
MLBattend$year[MLBattend$year == 1900] <- 2000
MLBattend$attendance <- MLBattend$attendance/100000

#create MLB and League averages by Year for a reference plot
MLByears <- sort(unique(MLBattend$year))
MLBfranchise <- "MLB"
MLBleague <- "NA"
MLBdivision <- "NA"
MLBavgAttend <- mean(MLBattend$attendance[MLBattend$year==MLByears[1]])
MLBavgScored <- mean(MLBattend$runs.scored[MLBattend$year==MLByears[1]])
MLBavgAllowed <- mean(MLBattend$runs.allowed[MLBattend$year==MLByears[1]])
MLBavgWins <- mean(MLBattend$wins[MLBattend$year==MLByears[1]])
MLBavgLosses <- mean(MLBattend$losses[MLBattend$year==MLByears[1]])
MLBavgBehind <- mean(MLBattend$games.behind[MLBattend$year==MLByears[1]])
for(i in 2:length(MLByears))
{
  MLBfranchise <- c(MLBfranchise,"MLB")
  MLBleague <- c(MLBleague,"NA")
  MLBdivision <- c(MLBdivision,"NA")
  MLBavgAttend <- c(MLBavgAttend,mean(MLBattend$attendance[MLBattend$year==MLByears[i]]))
  MLBavgScored <- c(MLBavgScored,mean(MLBattend$runs.scored[MLBattend$year==MLByears[i]]))
  MLBavgAllowed <- c(MLBavgAllowed,mean(MLBattend$runs.allowed[MLBattend$year==MLByears[i]]))
  MLBavgWins <- c(MLBavgWins,mean(MLBattend$wins[MLBattend$year==MLByears[i]]))
  MLBavgLosses <- c(MLBavgLosses,mean(MLBattend$losses[MLBattend$year==MLByears[i]]))
  MLBavgBehind <- c(MLBavgBehind,mean(MLBattend$games.behind[MLBattend$year==MLByears[i]]))
}
MLBavg <- data.frame(franchise = MLBfranchise, league = MLBleague, division = MLBdivision,
                     year = MLByears, attendance = MLBavgAttend, 
                     runs.scored = MLBavgScored, runs.allowed = MLBavgAllowed,
                     wins = MLBavgWins, losses = MLBavgLosses,
                     games.behind = MLBavgBehind)

shinyServer(function(input, output,session) 
{

  #create team list checkbox
  output$teamControls <- renderUI({
    checkboxGroupInput('teams', 'Teams (choose 1 or more)', teamList, selected=teamList[1])
  }) #end of output$teamControls

  #plot stat according to user selection
  #lines will be plotted in different colors for each team
  output$teamStatByYear <- renderPlot({
    #attendance
    if(input$statsToBeExplored == "attendance")
      {
      #first plot the MLB average for reference
      plot(MLBavg$year,MLBavg$attendance,col='gray', type='l', lwd=3, lty=2,
           xlim=c(1969,2000),ylim=c(0,50), main="Attendance by Year",
           ylab="attendance (100K)", xlab="year")
      #plot data for the user selected team(s)
      for(i in 1:length(input$teams))
      {
        lines(MLBattend$year[MLBattend$franchise == input$teams[i]],
              MLBattend$attendance[MLBattend$franchise == input$teams[i]],
              col=MLBattend$color[MLBattend$franchise == input$teams[i]], lwd=4)
      }#for(i in 1:length(input$teams))
    } #if(input$statsToBeExplored == "attendance")
    
    #runs scored
    if(input$statsToBeExplored == "scored")
    {
      #first plot the MLB average for reference
      plot(MLBavg$year,MLBavg$runs.scored,col='gray', type='l', lwd=3, lty=2, 
           xlim=c(1969,2000), ylim=c(300,1100), main="Runs Scored by Year", 
           ylab="runs scored", xlab="year")
      for(i in 1:length(input$teams))
      {
        lines(MLBattend$year[MLBattend$franchise == input$teams[i]],
              MLBattend$runs.scored[MLBattend$franchise == input$teams[i]],
              col=MLBattend$color[MLBattend$franchise == input$teams[i]], lwd=4)
      } #for(i in 1:length(input$teams))
    } #if(input$statsToBeExplored == "scored")
    
    #runs allowed
    if(input$statsToBeExplored == "allowed")
    {
      #first plot the MLB average for reference
      plot(MLBavg$year,MLBavg$runs.allowed,col='gray', type='l', lwd=3, lty=2, 
           xlim=c(1969,2000), ylim=c(300,1100), main="Runs Allowed by Year", 
           ylab="runs allowed", xlab="year")
      for(i in 1:length(input$teams))
      {
        lines(MLBattend$year[MLBattend$franchise == input$teams[i]],
              MLBattend$runs.allowed[MLBattend$franchise == input$teams[i]],
                col=MLBattend$color[MLBattend$franchise == input$teams[i]], lwd=4)
      } #for(i in 1:length(input$teams))
    } #if(input$statsToBeExplored == "allowed")
    
    #wins
    if(input$statsToBeExplored == "wins")
    {
      #first plot the MLB average for reference
      plot(MLBavg$year,MLBavg$wins,col='gray', type='l', lwd=3, lty=2, 
           xlim=c(1969,2000),ylim=c(30,120), main="Wins by Year", 
           ylab="wins", xlab="year")
      for(i in 1:length(input$teams))
      {
        lines(MLBattend$year[MLBattend$franchise == input$teams[i]],
              MLBattend$wins[MLBattend$franchise == input$teams[i]],
              col=MLBattend$color[MLBattend$franchise == input$teams[i]], lwd=4)
        } #for(i in 2:length(input$teams))
    } #if(input$statsToBeExplored == "wins")
  }) #end of output$teamStatByYear
  
  
  #add legend for colored lines
  output$teamLegend <- renderPlot({
    #first plot a box with all white lines so it's hidden
    #this provides a plotting window to overlay text
    plot(c(0,100),c(0,100), type='l',col='white',xlab=' ',ylab=' ', bg='white', 
         col.axis='white', col.lab='white', col.main='white', fg='white')
    #add legend for the MLB average line centered at the top
    lines(c(15,35),c(100,100),lwd=3,col='gray',lty=2)
    text(35.5,100,"MLB Average (1969 - 2000)", pos=4)
    
    #add legend for included teams
    row <- -1
    for(i in 1:length(input$teams))
    {
      #determine row and column positions
      column <- (i-1) %% 3
        
      if (column == 0){
        row <- row + 1
      } #if (column == 0)
      
      #add the legend entry
      lines(c(2+35*column,11+35*column),c(85-9*row,85-9*row),lwd=4,
            col=MLBattend$color[MLBattend$franchise == input$teams[i]])
      text(11.5+35*column,85-9*row,input$teams[i], pos=4)
    } #for(i in 1:length(input$teams)
  }) #end of output$teamLegend

}) #end of shinyServer