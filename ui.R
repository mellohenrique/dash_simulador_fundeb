# Define a Interface de Usuario
ui = tagList(
  includeCSS("estilo.css"),
  shinyWidgets::useShinydashboard(),
  tags$head(HTML("<title>Simulador Fundeb (Em desenvolvimento)</title>")),
  ## Define UI como pagina de navegacao
  navbarPage(
    theme = shinytheme("flatly"),
    ### Define Tema
    ### Barra 1
    title = div(img(src = 'logo.png', style = "margin-top: -20px; margin-left: -20px; padding-right:-0px; padding-bottom:10px", height = 70)),
    selected = "Simulação",
    tabPanel(
      title = "Simulação",
      fluidRow(
        column(4,
        ### Complementacao da União
        h2("Complementação da União"),
          shinyWidgets::autonumericInput(
            width = "100%",
            "complementacao_vaaf",
            "Montante da Complementação VAAF (em milhões):",
            value = 22905.22,
            align = "left",
            decimalCharacter = ",",
            digitGroupSeparator = ".",
            decimalPlaces = 0,
            min = 0),
          shinyWidgets::autonumericInput(
            width = "100%",
            "complementacao_vaat",
            "Montante da Complementação VAAT (em milhões):",
            value = 14315.76,
            align = "left",
            decimalCharacter = ",",
            digitGroupSeparator = ".",
            decimalPlaces = 0,
            min = 0),
      wellPanel(
        h2("Fatores de ponderação"),
                 sliderInput(
                   "social",
                   "Fator do nível socioeconômico:",
                   min = 1,
                   max = 2,
                   value = c(1)
                 ),
                 sliderInput(
                   "fiscal",
                   "Fator da disponibilidade de recursos vinculados:",
                   min = 1,
                   max = 2,
                   value = c(1)
                 )),
    actionButton("botao", "Simular", width = "100%",
                     style='font-size:200%')),
      column(8,
        h1("Informações Básicas"),
        ### Linha com os infoboxes
          fluidRow(infoBox(
            "VAAT Máximo",
            uiOutput("box_max_vaat"),
            icon = icon("line-chart"),
            color = "orange",
            fill = TRUE
          ),
          infoBox(
            "VAAT Mínimo",
            uiOutput("box_min_vaat"),
            icon = icon("line-chart"),
            color = "purple",
            fill = TRUE
          ),
          infoBox(
            HTML(paste("VAAF Mínimo", br(), "Quintil inferior")),
            uiOutput("box_min_vaaf"),
            icon = icon("line-chart"),
            color = "green",
            fill = TRUE
          )),
        fluidRow(
          infoBox(
            HTML(paste("Complementação da", br(), "União aos Municípios")),
            uiOutput("box_compl_municipal"),
            icon = icon("line-chart"),
            color = "blue",
            fill = TRUE
          ),
          infoBox(
            HTML(paste("Complementação da", br(), "ao Estados")),
            uiOutput("box_compl_estadual"),
            icon = icon("line-chart"),
            color = "aqua",
            fill = TRUE
          )),
        br(),
        h1("Síntese da Diferença por UF"),
        br(),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_diff_uf")),
        br(),
        h1("Síntese da Complementação da União – 2023"),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_complementacao_modalidade")),
        br(),
        h1("Síntese da Complementação da União – 2023"),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_complementacao_destino")),
        br(),
        h1("Tabela com os resultados"),
        ### Tabela com resultados da simulação
        shinycssloaders::withSpinner(DT::dataTableOutput("simulacao_dt"))
      ))),
    tabPanel('Pesos',
             column(6,
                    # Pesos por etapa e modalidade
                    wellPanel(
                      h2("Fator por Tipo e Modalidade"),
                      uiOutput("pesos_vaaf")
                    )),
             column(6,
                    # Pesos por etapa e modalidade
                    wellPanel(
                      h2("Fator por Tipo e Modalidade"),
                      uiOutput("pesos_vaat")
                    ))),
    tabPanel("Documentação", 
             column(2),
             column(8,
                    withMathJax(
                      shiny::includeMarkdown("documentacao.md")
                    ))),
    tabPanel("Tabela - Simulação",
             column(2),
             column(8,
                    withMathJax(
                      shiny::includeMarkdown("documentacao_tabela_gerada.md")
                    )))),
  tags$footer(HTML("
                    <!-- Footer -->
                           <footer class='page-footer font-large indigo'>
                           <br>
                           <!-- Copyright -->
                           <div class='footer-copyright text-center py-3'>© 2024 Copyright:
                           <a href='https://todospelaeducacao.org.br/'> Todos pela Educação</a>
                           </div>
                           <!-- Copyright -->
                           <br>

                           </footer>
                           <!-- Footer -->"))
)
