# Define a Interface de Usuario ----
ui = tagList(
## Estilo ----
  includeCSS("estilo.css"),
  shinyWidgets::useShinydashboard(),
  tags$head(HTML("<title>Simulador Fundeb (Em desenvolvimento)</title>")),
### Define Tema ---
  navbarPage(
    theme = shinytheme("flatly"),
### Barra Superior ----
    title = div(img(src = 'logo.png', style = "margin-top: -20px; margin-left: -20px; padding-right:-0px; padding-bottom:10px", height = 70)),
    selected = "Simulação",
## Aba de Simulação ----
    tabPanel(
      title = "Simulação",
      fluidRow(
        column(4,
### Complementacao da  ----
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
### Fatores de ponderação ----
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
### Infoboxes ----
      column(8,
        h1("Informações Básicas"),
          fluidRow(infoBox(
            HTML("VAAT Mínimo <br> Simulado"),
            uiOutput("nacional_vaat"),
            icon = icon("line-chart"),
            color = "orange",
            fill = TRUE
          ),
          infoBox(
            HTML("VAAT Mínimo <br> Atual"),
            scales::number(8420.96, big.mark = '.', decimal.mark = ','),
            icon = icon("line-chart"),
            color = "purple",
            fill = TRUE
          ),
          infoBox(
            HTML("VAAT Mínimo <br> Diferença"),
            uiOutput('nacional_dif_vaat'),
            icon = icon("line-chart"),
            color = "purple",
            fill = TRUE
          ),
          infoBox(
            HTML("VAAF Mínimo <br> Simulado"),
            uiOutput("nacional_vaaf"),
            icon = icon("line-chart"),
            color = "green",
            fill = TRUE
          ),
          infoBox(
            HTML("VAAF Mínimo <br> Atual"),
            scales::number(5361.43, big.mark = '.', decimal.mark = ','),
            icon = icon("line-chart"),
            color = "green",
            fill = TRUE
          ),
          infoBox(
            HTML("VAAF Mínimo <br> Diferença"),
            uiOutput('nacional_dif_vaaf'),
            icon = icon("line-chart"),
            color = "green",
            fill = TRUE
          ),
          infoBox(
            HTML(paste("Complementação da", br(), "União aos Municípios")),
            uiOutput("nacional_compl_mun"),
            icon = icon("line-chart"),
            color = "blue",
            fill = TRUE
          ),
          infoBox(
            HTML(paste("Complementação da", br(), "União aos Estados")),
            uiOutput("nacional_compl_est"),
            icon = icon("line-chart"),
            color = "aqua",
            fill = TRUE
          ),
          infoBox(
            HTML(paste("Percentual dos entes", br(), "que recebem complementação")),
            uiOutput("nacional_perc_compl"),
            icon = icon("line-chart"),
            color = "aqua",
            fill = TRUE
          )),
        br(),
        h1('Valor Aluno ano na Simulação e no Cenário Atual'),
        br(),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_vaaf_ufs")),
        br(),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_vaat_ufs")),
        br(),
        h1('Tabela Resumo'),
        br(),
        h2('Comparação na Simulação e no Cenário Atual'),
        h3('Entes que tem resultado positivo e negativo de recursos VAAF entre a simulação e o cenário atual'),
        shinycssloaders::withSpinner(DT::dataTableOutput("tabela_vencedores_vaaf")),
        br(),
        h3('Entes que tem resultado positivo e negativo de recursos VAAT entre a simulação e o cenário atual'),
        shinycssloaders::withSpinner(DT::dataTableOutput("tabela_vencedores_vaat")),
        br(),
        h3('Medidas resumo'),
        shinycssloaders::withSpinner(DT::dataTableOutput("tabela_resumo")),
        br(),
        HTML('<ul><li>A Tabela apresenta uma série de medidas de comparação entre a simulação e o cenário base.</li></ul>'),
        h1("Síntese da Diferença por UF"),
        br(),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_diff_uf")),
        HTML('<ul><li>O Gráfico faz um comparação entre o montante de recursos do Fundeb de cada rede estadual, comprando a simulação com o cenário base.</li></ul>'),
        br(),
        h1("Síntese da Complementação da União – 2024"),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_complementacao_modalidade")),
        HTML('<ul><li>O Gráfico apresenta a quantidade de recursos que cada rede estadual recebe de complementação da União pelo Fundeb no cenário simulado, divindo entre o montante que vai para as redes educacionais municipais e o quanto vai para a a rede estadual.</li></ul>'),
        br(),
        h1("Síntese da Complementação da União – 2024"),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_complementacao_destino")),
        HTML('<ul><li>O Gráfico apresenta a quantidade de recursos que cada rede estadual recebe de complementação da União pelo Fundeb no cenário simulado, divindo entre o montante recebido pela modalidade VAAF e o montante recebido pela modalidade VAAT.</li></ul>'),
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
    ## Análise regional ----
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
 ### Infobox regional ----
               column(8,
                      h1("Informações Básicas"),
                      fluidRow(infoBox(
                        HTML("VAAT Mínimo <br> Simulado"),
                        uiOutput("regional_vaat"),
                        icon = icon("line-chart"),
                        color = "orange",
                        fill = TRUE
                      ),
                      infoBox(
                        HTML("VAAT Mínimo <br> Atual"),
                        scales::number(8420.96, big.mark = '.', decimal.mark = ','),
                        icon = icon("line-chart"),
                        color = "purple",
                        fill = TRUE
                      ),
                      infoBox(
                        HTML("VAAT Mínimo <br> Diferença"),
                        uiOutput('regional_dif_vaat'),
                        icon = icon("line-chart"),
                        color = "purple",
                        fill = TRUE
                      ),
                      infoBox(
                        HTML("VAAF Mínimo <br> Simulado"),
                        uiOutput("regional_vaaf"),
                        icon = icon("line-chart"),
                        color = "green",
                        fill = TRUE
                      ),
                      infoBox(
                        HTML("VAAF Mínimo <br> Atual"),
                        scales::number(5361.43, big.mark = '.', decimal.mark = ','),
                        icon = icon("line-chart"),
                        color = "green",
                        fill = TRUE
                      ),
                      infoBox(
                        HTML("VAAF Mínimo <br> Diferença"),
                        uiOutput('regional_dif_vaaf'),
                        icon = icon("line-chart"),
                        color = "green",
                        fill = TRUE
                      ),
                      infoBox(
                        HTML(paste("Complementação da", br(), "União aos Municípios")),
                        uiOutput("regional_compl_mun"),
                        icon = icon("line-chart"),
                        color = "blue",
                        fill = TRUE
                      ),
                      infoBox(
                        HTML(paste("Complementação da", br(), "União aos Estados")),
                        uiOutput("regional_compl_est"),
                        icon = icon("line-chart"),
                        color = "aqua",
                        fill = TRUE
                      ),
                      infoBox(
                        HTML(paste("Percentual dos entes", br(), "que recebem complementação")),
                        uiOutput("regional_perc_compl"),
                        icon = icon("line-chart"),
                        color = "aqua",
                        fill = TRUE
                      )),
                      h1('Tabela Resumo'),
                      shinycssloaders::withSpinner(DT::dataTableOutput("tabela_resumo_regional")),
                      br()))),
    tabPanel("Documentação", 
             column(2),
             column(8,
                    withMathJax(
                      shiny::includeMarkdown("documentacao.md")
                    ))),
    tabPanel("Planilha de Resultados",
             column(2,
                    ### Botão de download do dicionário de dados ----
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
