#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(forcats)
library(markdown)

# Define UI for application that draws a histogram
shinyUI(
    navbarPage(
      theme = shinytheme("flatly"),
      shinyWidgets::useShinydashboard(),
        title = "Simulador Fundeb",
        tabPanel(
            title = "Simulação",
            sidebarPanel(
              h2("Aporte da União"),
              numericInput("complementacao_vaaf", "Montante da Complementação VAAF:", value = 16000000000),
              numericInput("complementacao_vaat", "Montante da Complementação VAAT:", value = 3000000000),
              h2("Fator por parâmetro social e fiscal"),
              sliderInput("social", "Parâmetros Social:", 
                          min = .7, max = 2, value = c(1, 1.3)),
              sliderInput("fiscal", "Parâmetros Fiscal:", 
                          min = .7, max = 2, value = c(1, 1.3)),
              h2("Fator por tipo e modalidade"),
              uiOutput("pesos")
            ),
            mainPanel(
              width = 8,
              fluidRow(
                shinydashboard::infoBox(
                "Máximo VAAT", uiOutput("max_vaat"), icon = icon("line-chart"), color = "green",
                fill = TRUE
              ),
              shinydashboard::infoBox(
                "Mínimo VAAT", uiOutput("min_vaat"), icon = icon("line-chart"), color = "green",
                fill = TRUE
              ),
              shinydashboard::infoBox(
                "Mínimo VAAF", uiOutput("min_vaaf"), icon = icon("line-chart"), color = "green",
                fill = TRUE
              )),
              plotly::plotlyOutput("aporte_federal"),
              DT::dataTableOutput("simulacao_dt")
              
            )
            
                 ),
        tabPanel("Documentação",
                 column(8,
                        withMathJax(shiny::includeMarkdown("documentacao.md"))))))
