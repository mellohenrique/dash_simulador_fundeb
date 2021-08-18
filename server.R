# Carregando pacotes
library(forcats)
library(markdown)
library(shinythemes)

# Inicio do Server
shinyServer(function(input, output) {
  ## Cria sliders com pesos para UI
  output$pesos = renderUI({
    lapply(1:length(peso$etapa), function(i) {
      sliderInput(
        label = peso$etapa_nome[[i]],
        inputId = paste0("etapa_", i),
        min = 0.8,
        max = 3.5,
        value = c(peso$peso_vaaf[[i]])
      )
    })
  })
  
  ## Cria tabela de pesos usada no servidor
  pesos_app = reactive({
    req(input$etapa_30)
    
  pesos = data.frame(
      etapa = peso$etapa,
      peso_vaaf = sapply(1:length(peso$etapa),
                         function(i) {
                           input[[paste0("etapa_", i)]][[1]]
                         }))
  
  pesos$peso_vaat = pesos$peso_vaaf * c(1.5, 1.5, 1.5, 1.5, 1, 1, 1,  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.5, 1.5, 1.5, 1.5, 1, 1, 1, 1, 1)
  
  pesos
    
  })
  
  
  # Simula fundeb com parametros dados pelo usuario
  simulacao = reactive({
    if (input$botao == 0) {
      simulacao_inicial
    } else { 
      simulacao_realizada()}})
  
  simulacao_realizada = eventReactive(input$botao, {
    simulador.fundeb2::simula_fundeb(
      dados_fnde = alunos,
      dados_complementar = complementar,
      peso_etapas = pesos_app(),
      chao_socio = 1,
      teto_socio = input$social,
      chao_fiscal = 1,
      teto_fiscal = input$fiscal,
      complementacao_vaaf = input$complementacao_vaaf,
      complementacao_vaat = input$complementacao_vaat
    )})
  
  ## Valores para Infoboxes
  ### Calcula valor maximo do VAAT para info box
  output$max_vaat = renderUI({
    prettyNum(max(simulacao()$vaat), big.mark = ".", decimal.mark = ",")
  })
  
  ### Calcula minimo VAAT para info box
  output$min_vaat = renderUI({
    prettyNum(min(simulacao()$vaat), big.mark = ".", decimal.mark = ",")
  })
  
  ## Gráfico com complementação da federação por UF
  output$complementacao_federal = plotly::renderPlotly({
    ### Calculo do complementacao por unidade da federação
    complementacao_uf = melt(simulacao()[, .(
      complementacao_vaaf = sum(fundo_vaaf - fundeb),
      complementacao_vaat = sum(fundo_vaat - fundo_vaaf_extra)
    ), by = uf][, `:=`(complementacao_vaaf = ifelse(complementacao_vaaf < 1, 0 , complementacao_vaaf), complementacao_vaat = ifelse(complementacao_vaat < 1, 0 , complementacao_vaat))], id.vars = "uf")
    ### Geração do gráfico em plotly
    plotly::ggplotly(ggplot(complementacao_uf, aes(x = fct_reorder(uf, value), y = value, fill = variable)) +
                       geom_col() +
                       coord_flip() +
                       labs(x = "UF", y = "complementacao Federal") +
                       scale_y_continuous(labels = scales::number_format(big.mark = ".", decimal.mark = ",")) +
                       scale_fill_viridis_d(end = 0.8, begin = .2))
  })
  
  ### Tabela DT
  output$simulacao_dt = DT::renderDT(
    simulacao(),
    server = FALSE,
    filter = 'top',
    class = 'cell-border stripe',
    extensions = 'Buttons',
    options = list(
      autoWidth = TRUE,
      paging = TRUE,
      searching = TRUE,
      fixedColumns = TRUE,
      ordering = TRUE,
      scrollX = TRUE,
      dom = 'Bftsp',
      buttons = c('copy', 'csv', 'excel')
    )
  )
})
