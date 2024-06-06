# Define a Interface de Usuario ----
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
            "Montante da Complementação-VAAF:",
            value = 24153287047,
            align = "left",
            decimalCharacter = ",",
            digitGroupSeparator = ".",
            decimalPlaces = 0,
            min = 0),
          shinyWidgets::autonumericInput(
            width = "100%",
            "complementacao_vaat",
            "Montante da Complementação-VAAT:",
            value = 18114965285,
            align = "left",
            decimalCharacter = ",",
            digitGroupSeparator = ".",
            decimalPlaces = 0,
            min = 0),
      wellPanel(
        h2("Fatores de ponderação"),
                 sliderInput(
                   "nse",
                   "Fator do nível socioeconômico:",
                   min = 1,
                   max = 4,
                   value = c(1.1),
                   step = .05
                 ),
                 sliderInput(
                   "nf",
                   "Fator da disponibilidade de recursos vinculados:",
                   min = 1,
                   max = 4,
                   value = c(1),
                   step = .05
                 )),
    actionButton("botao", "Simular", 
                     style='font-size:200%;width:100%')),
      column(8,
        h1("Informações Básicas"),
        ### Linha com os infoboxes
          fluidRow(infoBox(
            HTML("VAAT Mínimo <br> Simulado"),
            uiOutput("box_min_vaat"),
            icon = icon("line-chart"),
            color = "orange",
            fill = TRUE
          ),
          infoBox(
            HTML("VAAT Mínimo <br> Atual"),
            8421,
            icon = icon("line-chart"),
            color = "purple",
            fill = TRUE
          ),
          infoBox(
            HTML("VAAT Mínimo <br> Diferença"),
            1,
            icon = icon("line-chart"),
            color = "purple",
            fill = TRUE
          ),
          infoBox(
            HTML("VAAF Mínimo <br> Simulado"),
            uiOutput("box_min_vaaf"),
            icon = icon("line-chart"),
            color = "green",
            fill = TRUE
          ),
          infoBox(
            HTML("VAAF Mínimo <br> Atual"),
            5277,
            icon = icon("line-chart"),
            color = "green",
            fill = TRUE
          ),
          infoBox(
            HTML("VAAF Mínimo <br> Diferença"),
            1,
            icon = icon("line-chart"),
            color = "green",
            fill = TRUE
          ),
          infoBox(
            HTML(paste("Complementação da", br(), "União aos Municípios")),
            uiOutput("box_compl_municipal"),
            icon = icon("line-chart"),
            color = "blue",
            fill = TRUE
          ),
          infoBox(
            HTML(paste("Complementação da", br(), "União aos Estados")),
            uiOutput("box_compl_estadual"),
            icon = icon("line-chart"),
            color = "aqua",
            fill = TRUE
          ),
          infoBox(
            HTML(paste("Percentual dos entes", br(), "que recebem complementação")),
            uiOutput("percentual_complemento"),
            icon = icon("line-chart"),
            color = "aqua",
            fill = TRUE
          )),
        br(),
        h1('Tabela Resumo'),
        shinycssloaders::withSpinner(DT::dataTableOutput("tabela_resumo")),
        br(),
        h1("Síntese da Diferença por UF"),
        br(),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_diff_uf")),
        br(),
        h1("Síntese da Complementação da União – 2024"),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_complementacao_modalidade")),
        br(),
        h1("Síntese da Complementação da União – 2024"),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_complementacao_destino")),
        br()
      ))),
    tabPanel('Pesos', value = 'pesos',
             column(6,
                    # Pesos por etapa e modalidade
                    wellPanel(
                      h2("Fator por Tipo e Modalidade-VAAF"),
                      uiOutput("pesos_vaaf")
                    )),
             column(6,
                    # Pesos por etapa e modalidade
                    wellPanel(
                      h2("Fator por Tipo e Modalidade-VAAT"),
                      uiOutput("pesos_vaat")
                    ))),
    tabPanel('Análise regional',
             fluidRow(
               column(4,
                      wellPanel(
                      selectInput("estado_analise", "Escola uma região:",
                                  list(Norte = c("AM", "PA", "AC", 'RR', "RO", 'AP', 'TO'),
                                       Nordeste = c("CE", 'PE', 'PI', 'SE', 'AL', 'RN', 'BA', 'MA', 'PB'),
                                       Sudeste = c("SP", "RJ", "ES", 'MG'),
                                       Sul = c('RS', "PR", 'SC'),
                                       `Centro-Oeste` = c('DF', 'GO', 'MS', 'MT'))
                      ))),
               column(8,
                      fluidRow(infoBox(
                        "VAAT Máximo",
                        uiOutput("box_max_vaat_regional"),
                        icon = icon("line-chart"),
                        color = "orange",
                        fill = TRUE
                      ),
                      infoBox(
                        "VAAT Mínimo",
                        uiOutput("box_min_vaat_regional"),
                        icon = icon("line-chart"),
                        color = "purple",
                        fill = TRUE
                      ),
                      infoBox(
                        HTML("VAAF Mínimo"),
                        uiOutput("box_min_vaaf_regional"),
                        icon = icon("line-chart"),
                        color = "green",
                        fill = TRUE
                      )),
                      fluidRow(
                        infoBox(
                          HTML(paste("Complementação da", br(), "União aos Municípios")),
                          uiOutput("box_compl_municipal_regional"),
                          icon = icon("line-chart"),
                          color = "blue",
                          fill = TRUE
                        ),
                        infoBox(
                          HTML(paste("Complementação da", br(), "União aos Estados")),
                          uiOutput("box_compl_estadual_regional"),
                          icon = icon("line-chart"),
                          color = "aqua",
                          fill = TRUE
                        ),
                        infoBox(
                          HTML(paste("Percentual de", br(), "Entes que recebem complementação")),
                          uiOutput("percentual_complemento_regional"),
                          icon = icon("line-chart"),
                          color = "olive",
                          fill = TRUE
                        )),
                      h1('Tabela Resumo'),
                      shinycssloaders::withSpinner(DT::dataTableOutput("tabela_resumo_regional"))))),
    tabPanel("Documentação", 
             column(2),
             column(8,
                    withMathJax(
                      shiny::includeMarkdown("documentacao.md")
                    ))),
    tabPanel("Tabela - Simulação",
             column(2,
                    
                    downloadButton('dicionario', "Dicionário de dados", style='font-size:150%;heigth:200%;width:100%;color:white')),
             column(8,
                    ### Planilha com resultados da simulação ----
                    h1("Planilha com os resultados"),
                    shinycssloaders::withSpinner(DT::dataTableOutput("simulacao_dt"))
                    ))),
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
