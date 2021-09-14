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
          value = 16000000000,
          min = 0,
        ),
        numericInput(
          "complementacao_vaat",
          "Montante da Complementação VAAT:",
          value = 3000000000,
          min = 0
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
          )
        ),
        ### Gráfico com complementação de recursos por unidade da federação
        h1("Avaliação VAAT"),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_dispersao")),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_dispersao_ente")),
        h1("Avaliação da complementação"),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_complementacao_federal")),
        h1("Avaliação do VAA"),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_decil_saeb")),
        HTML("<ul><li>O gráfico acima divide os entes federados em dez décis de acordo com o indicador socioeconômico como calculado pelo SAEB 2019;<li>O primeiro décil contém os entes com os 10% piores indicadores, o segundo décil os entes entre o 11% e 20% piores indicadores e assim sucessivamente</li></li><li>Considerou-se Valor Aluno Ano (VAA) não considerando as ponderações por aluno, por estas modificarem tanto o numerador como o denominador do cálculo em questão</li></ul>"),
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
