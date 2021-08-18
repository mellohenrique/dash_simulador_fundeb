# Define a Interface de Usuario
shinyUI(
  ## Define UI como pagina de navegacao
  navbarPage(
    ### Define Tema
    theme = shinytheme("flatly"),
    selected = "Simulação",
    shinyWidgets::useShinydashboard(),
    ### Barra 1
    title = "Simulador Fundeb",
    tabPanel(
      title = "Simulação",
      sidebarPanel(
        ### Complementacao da União
        actionButton("botao", "Simular"),
        h2("Complementação da União"),
        numericInput(
          "complementacao_vaaf",
          "Montante da Complementação VAAF:",
          value = 16000000000
        ),
        numericInput(
          "complementacao_vaat",
          "Montante da Complementação VAAT:",
          value = 3000000000
        ),
        ### Parametros fiscais e sociais
        h2("Fator por parâmetro social e fiscal"),
        sliderInput(
          "social",
          "Parâmetros Social:",
          min = 1,
          max = 2,
          value = c(1.3)
        ),
        sliderInput(
          "fiscal",
          "Parâmetros Fiscal:",
          min = 1,
          max = 2,
          value = c(1.3)
        ),
        # Pesos por etapa e modalidade
        h2("Fator por tipo e modalidade"),
        uiOutput("pesos")
      ),
      ## Tabela com resultados
      mainPanel(
        width = 8,
        ### Linha com os infoboxes
        fluidRow(
          shinydashboard::infoBox(
            "Máximo VAAT",
            uiOutput("max_vaat"),
            icon = icon("line-chart"),
            color = "green",
            fill = TRUE
          ),
            shinydashboard::infoBox(
            "Mínimo VAAT",
            uiOutput("min_vaat"),
            icon = icon("line-chart"),
            color = "green",
            fill = TRUE
          )
        ),
        ### Gráfico com complementação de recursos por unidade da federação
        shinycssloaders::withSpinner(plotly::plotlyOutput("complementacao_federal")),
        ### Tabela com resultados da simulação
        shinycssloaders::withSpinner(DT::dataTableOutput("simulacao_dt"))
        
      )
      
    ),
    tabPanel("Documentação",
             column(8,
                    withMathJax(
                      shiny::includeMarkdown("documentacao.md")
                    )))
  )
)
