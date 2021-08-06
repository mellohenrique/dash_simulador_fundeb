library(forcats)

shinyServer(function(input, output) {
  output$pesos = renderUI({
    lapply(1:length(peso$etapa), function(i) {
      sliderInput(
        label = peso$etapa_nome[[i]],
        inputId = paste0("etapa_", i),
        min = 0.8,
        max = 2,
        value = peso$peso_alt[[i]]
      )
    })
  })
  
  pesos_app = reactive({
    req(input$etapa_30)
    
    data.frame(etapa = peso$etapa,
               peso = sapply(1:length(peso$etapa),
                             function(i) {
                               input[[paste0("etapa_", i)]]
                             }))
  })
  
  simulacao = reactive(
    simulador.fundeb2::simula_fundeb(
      dados_fnde = alunos,
      dados_complementar = complementar,
      peso_etapas = pesos_app(),
      chao_socio = input$social[[1]],
      teto_socio = input$social[[2]],
      chao_fiscal = input$fiscal[[1]],
      teto_fiscal = input$fiscal[[2]],
      aporte_vaaf = input$complementacao_vaaf,
      aporte_vaat = input$complementacao_vaat
      
    )
  )
  
  output$max_vaat = renderUI({
    prettyNum(max(simulacao()$vaat), big.mark = ".", decimal.mark = ",")
  })
  
  output$min_vaat = renderUI({
    prettyNum(min(simulacao()$vaat), big.mark = ".", decimal.mark = ",")
  })
  
  output$min_vaaf = renderUI({
    prettyNum(max(simulacao()$vaaf), big.mark = ".", decimal.mark = ",")
  })
  
  output$aporte_federal = plotly::renderPlotly({
    aporte_uf = melt(simulacao()[, .(
      aporte_vaaf = sum(fundo_vaaf - fundeb),
      aporte_vaat = sum(fundo_vaat - fundo_vaaf_extra)
    ), by = uf][, `:=`(aporte_vaaf = ifelse(aporte_vaaf < 1, 0 , aporte_vaaf), aporte_vaat = ifelse(aporte_vaat < 1, 0 , aporte_vaat))], id.vars = "uf")
    
    plotly::ggplotly(ggplot(aporte_uf, aes(x = fct_reorder(uf, value), y = value, fill = variable)) +
                       geom_col() +
                       coord_flip() +
                       labs(x = "UF", y = "Aporte Federal") +
                       scale_y_continuous(labels = scales::number_format(big.mark = ".", decimal.mark = ",")) +
                       scale_fill_viridis_d(end = 0.8, begin = .2))
  })
  

  
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
