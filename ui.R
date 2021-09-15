# Define a Interface de Usuario
shinyUI(
  ## Define UI como pagina de navegacao
  navbarPage(
    ### Define Tema
    theme = shinytheme("flatly"),
    tags$head(tags$style(HTML('.info-box-text {text-transform: capitalize;} '))),
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
          "Montante da Complementação VAAF (em milhões):",
          value = 16000,
          min = 0,
        ),
        numericInput(
          "complementacao_vaat",
          "Montante da Complementação VAAT (em milhões):",
          value = 3000,
          min = 0
        ),
        ### Parametros fiscais e sociais
        h2("Fator por parâmetro social e fiscal"),
        sliderInput(
          "social",
          "Parâmetros Social:",
          min = 1,
          max = 2,
          value = c(1)
        ),
        sliderInput(
          "fiscal",
          "Parâmetros Fiscal:",
          min = 1,
          max = 2,
          value = c(1)
        ),
        # Pesos por etapa e modalidade
        h2("Fator por Tipo e Modalidade"),
        uiOutput("pesos")
      ),
      ## Tabela com resultados
      mainPanel(
        width = 8,
        h1("Informações Básicas"),
        ### Linha com os infoboxes
        fluidRow(
          shinydashboard::infoBox(
            "VAAT Máximo",
            uiOutput("box_max_vaat"),
            icon = icon("line-chart"),
            color = "green",
            fill = TRUE
          ),
          shinydashboard::infoBox(
            "VAAT Médio",
            uiOutput("box_media_vaat"),
            icon = icon("line-chart"),
            color = "green",
            fill = TRUE
          ),
            shinydashboard::infoBox(
            "VAAT Mínimo",
            uiOutput("box_min_vaat"),
            icon = icon("line-chart"),
            color = "green",
            fill = TRUE
          ),
          shinydashboard::infoBox(
            HTML(paste("VAAT Médio", br(), "Quintil inferior")),
            uiOutput("box_mean_vaat_quintil"),
            icon = icon("line-chart"),
            color = "green",
            fill = TRUE
          ),
          shinydashboard::infoBox(
            HTML(paste("Complementação", br(), "municipal")),
            uiOutput("box_compl_municipal"),
            icon = icon("line-chart"),
            color = "green",
            fill = TRUE
          ),
          shinydashboard::infoBox(
            HTML(paste("Complementação", br(), "estadual")),
            uiOutput("box_compl_estadual"),
            icon = icon("line-chart"),
            color = "green",
            fill = TRUE
          ),
        ),
        ### Gráfico com complementação de recursos por unidade da federação
        h1("Avaliação VAAT"),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_dispersao")),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_dispersao_ente")),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_decil_saeb")),
        HTML("<ul><li>O gráfico acima divide os entes federados em dez décis de acordo com o indicador socioeconômico como calculado pelo SAEB 2019;<li>O primeiro décil contém os entes com os 10% piores indicadores, o segundo décil os entes entre o 11% e 20% piores indicadores e assim sucessivamente</li></li</ul>"),
        h1("Avaliação da complementação"),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_complementacao_federal")),
        h1("Tabela com os resultados"),
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
