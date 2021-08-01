# Pacotes
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(simulador.fundeb2)

# App
shinyApp(
    ui = dashboardPage(
        header = dashboardHeader(),
        sidebar = dashboardSidebar(),
        body = dashboardBody()
    ),
    server = function(input, output) { }
)
