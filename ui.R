# Define a Interface de Usuario
ui = tagList(
  includeCSS("estilo.css"),
  tags$head(HTML("<title>Simulador Fundeb</title>")),
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
        column(12,
        ### Complementacao da União
        h2("Complementação da União")),
        column(5,
               shinyWidgets::autonumericInput(width = "100%",
          "complementacao_vaaf",
          "Montante da Complementação VAAF (em milhões):",
          value = 20529,
          align = "left",
          decimalCharacter = ",",
          digitGroupSeparator = ".",
          decimalPlaces = 0,
          min = 0,
        )),
        column(5,
               shinyWidgets::autonumericInput(width = "100%",
          "complementacao_vaat",
          "Montante da Complementação VAAT (em milhões):",
          value = 10264,
          align = "left",
          decimalCharacter = ",",
          digitGroupSeparator = ".",
          decimalPlaces = 0,
          min = 0
        )),
        column(2, 
        actionButton("botao", "Simular", width = "100%",
                     style='font-size:200%'))),
        fluidRow(
        ### Parametros fiscais e sociais
        column(4,
               wellPanel(
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
        ))),
      ## Tabela com resultados
      column(8,
        h1("Informações Básicas"),
        ### Linha com os infoboxes
          bslib::value_box(
            "VAAT Máximo",
            uiOutput("box_max_vaat"),
            icon = icon("line-chart"),
            color = "orange",
            fill = TRUE
          ),
          bslib::value_box(
            "VAAT Mínimo",
            uiOutput("box_min_vaat"),
            icon = icon("line-chart"),
            color = "purple",
            fill = TRUE
          ),
          bslib::value_box(
            HTML(paste("VAAF Mínimo", br(), "Quintil inferior")),
            uiOutput("box_min_vaaf"),
            icon = icon("line-chart"),
            color = "green",
            fill = TRUE
          ),
          bslib::value_box(
            HTML(paste("Complementação da", br(), "União aos Municípios")),
            uiOutput("box_compl_municipal"),
            icon = icon("line-chart"),
            color = "blue",
            fill = TRUE
          ),
          bslib::value_box(
            HTML(paste("Complementação da", br(), "ao Estados")),
            uiOutput("box_compl_estadual"),
            icon = icon("line-chart"),
            color = "aqua",
            fill = TRUE
          )),
        column(8,
        br(),
        h1("Síntese da Diferença por UF"),
        br(),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_diff_uf")),
        HTML("<ul><li>O gráfico acima divide os entes federados em dez décis de acordo com o indicador socioeconômico como calculado pelo SAEB 2019;<li>O primeiro décil contém os entes com os 10% piores indicadores, o segundo décil os entes entre o 11% e 20% piores indicadores e assim sucessivamente</li></li</ul>"),
        br(),
        h1("Síntese da Complementação da União – 2022"),
        shinycssloaders::withSpinner(plotly::plotlyOutput("graf_complementacao_federal")),
        br(),
        h1("Tabela com os resultados"),
        ### Tabela com resultados da simulação
        shinycssloaders::withSpinner(DT::dataTableOutput("simulacao_dt"))
        
      ))
      
    ),
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
  ),
  tags$footer(HTML("
                    <!-- Footer -->
                           <footer class='page-footer font-large indigo'>
                           <br>
                           <!-- Copyright -->
                           <div class='footer-copyright text-center py-3'>© 2022 Copyright:
                           <a href='https://todospelaeducacao.org.br/'> Todos pela Educação</a>
                           </div>
                           <!-- Copyright -->
                           <br>

                           </footer>
                           <!-- Footer -->"))
)
