# Inicio do Server ----
shinyServer(function(input, output) {
  ## Cria sliders com pesos para UI ----
  output$pesos_vaaf = renderUI({
    lapply(1:length(pesos$etapa), function(i) {
      sliderInput(
        label = pesos$etapa[[i]],
        inputId = paste0("pesos_vaaf_", i),
        min = 0.8,
        max = 3.5,
        value = c(pesos$peso_vaaf[[i]])
      )
    })
  })
  
  output$pesos_vaat = renderUI({
    lapply(1:length(pesos$etapa), function(i) {
      sliderInput(
        label = pesos$etapa[[i]],
        inputId = paste0("pesos_vaat_", i),
        min = 0.8,
        max = 3.5,
        value = c(pesos$peso_vaat[[i]])
      )
    })
  })
  
  ## Cria tabela de peso usada no servidor ----
  pesos_app = reactive({
    req(input$pesos_vaat_30)
    
  pesos = data.frame(
      etapa = pesos$etapa,
      peso_vaaf = sapply(1:length(pesos$etapa),
                         function(i) {
                           input[[paste0("pesos_vaaf_", i)]][[1]]
                         }),
      peso_vaat = sapply(1:length(pesos$etapa),
                         function(i) {
                           input[[paste0("pesos_vaat_", i)]][[1]]
                         }))
  
  ### Retorna pesos no ambiente reactive
  pesos
    
  })
  
  ## Simula fundeb com parametros dados pelo usuario ----
  ### Considera simulacao ja realizada para primeira simulacao ----
  simulacao = reactive({
    if (input$botao == 0) {
      simulacao_inicial
    } else { 
      simulacao_realizada()}})
  
  ### Realiza-se simulacao quando botao ativado
  simulacao_realizada = eventReactive(input$botao, {
    
    #### Considera valor zero caso nao NA ou NULL no valor de complementacao vaaf ----
    complementacao_vaaf = if (is.null(input$complementacao_vaaf) | is.na(input$complementacao_vaaf)) {
      0
    } else {
      input$complementacao_vaaf
    }
    #### Considera valor zero caso nao NA ou NULL no valor de complementacao vaat ---- 
    complementacao_vaat = if (is.null(input$complementacao_vaat) | is.na(input$complementacao_vaat)) {
      0
    } else {
      input$complementacao_vaat
    }
    
    #### Simulacao ----
    simulacao = simulador.fundeb::simula_fundeb(
      dados_alunos = alunos,
      dados_complementar = complementos,
      dados_peso = pesos_app(),
      complementacao_vaaf = complementacao_vaaf * 1000000,
      complementacao_vaat = complementacao_vaat * 1000000,
      complementacao_vaar = 0
    )

    #### Retorna resultado da simulacao----
    simulacao
    })
  
  ## Valores para Infoboxes ----
  ### Calcula valor maximo do VAAT para info box
  output$box_max_vaat = renderUI({
    prettyNum(max(simulacao()$vaat_final), big.mark = ".", decimal.mark = ",", digits = 4)
  })
  
  ### Calcula minimo VAAF para info box ----
  output$box_min_vaaf = renderUI({
    prettyNum(min(simulacao()$vaaf_final), big.mark = ".", decimal.mark = ",", digits = 4)
  })
  
  ### Calcula minimo VAAT para info box ----
  output$box_min_vaat = renderUI({
    prettyNum(min(simulacao()$vaat_final), big.mark = ".", decimal.mark = ",", digits = 4)
  })
  
  ### Calcula total VAAT da complementação municipal ----
  output$box_compl_municipal = renderUI({
    prettyNum(sum(simulacao()[simulacao()$ibge > 100,]$complemento_uniao), big.mark = ".", decimal.mark = ",", digits = 4)
  })
  
  ### Calcula total VAAT da complementação estadual ----
  output$box_compl_estadual = renderUI({
    prettyNum(sum(simulacao()[simulacao()$ibge < 100,]$complemento_uniao), big.mark = ".", decimal.mark = ",", digits = 4)
  })
  
  ## Gráfico com complementação da federação por UF ----
  output$graf_complementacao_federal = plotly::renderPlotly({
    ### Calculo do complementacao por unidade da federação ----
    simulacao = simulacao()
    
    complementacao_uf = stats::aggregate(
      list(complemento_vaaf = simulacao$complemento_vaaf,
           complemento_vaat = simulacao$complemento_vaat),
           by = list(uf = simulacao$uf),
      FUN=sum)
    
    complementacao_uf = complementacao_uf[order((complementacao_uf$complemento_vaaf + complementacao_uf$complemento_vaat) * -1),]
    complementacao_uf$uf = factor(complementacao_uf$uf, levels = complementacao_uf$uf, ordered = TRUE)
    
    complementacao_uf = reshape(complementacao_uf, direction = "long", varying = 2:3, times = names(complementacao_uf)[2:3], timevar = "tipo", v.names = "complemento")
    
    complementacao_uf = complementacao_uf[,c('uf', 'tipo', 'complemento')]
    
    fig = plot_ly(
      complementacao_uf,
      x = ~uf,
      y = ~complemento/1000000,
      name = ~tipo,
      type = "bar",
      meta = ~tipo,
      hovertemplate = "UF: %{label}<br>%{meta[0]}: %{y:,.0f} milhões<extra></extra>"
    )
    
    fig =  layout(fig, separators = ',.', barmode = "stack", xaxis = list(title = "", tickangle = 0), yaxis = list(title = "Montante", tickformat = ',.f', ticksuffix= " milhões"), title = "<b>Complementação da União por UF e Modalidade<b>")
    
    fig 
  })
  
  
  ### Grafico dispersao
  output$graf_diff_uf = renderPlotly({
    simulacao_atual = simulacao()
    
    complementacao_atual = stats::aggregate(
      list(complemento_atual = simulacao_atual$complemento_uniao),
           by = list(uf = simulacao_atual$uf),
           FUN=sum)
      
      comparacao = merge(complementacao_atual, simulacao_inicial_agregada, by = 'uf')
      
      comparacao$diff = comparacao$complemento_atual - comparacao$complemento_uniao
      
      comparacao = comparacao[order(comparacao$diff * -1),]
      comparacao$uf = factor(comparacao$uf, levels = comparacao$uf, ordered = TRUE)
      
      fig = plot_ly(
        comparacao,
        x = ~uf,
        y = ~diff/1000000,
        type = "bar",
        hovertemplate = "UF: %{label}<br>%{meta[0]}: %{y:,.0f} milhões<extra></extra>"
      )
      
      fig =  layout(fig, separators = ',.', barmode = "stack", xaxis = list(title = "", tickangle = 0), yaxis = list(title = "Montante", tickformat = ',.f', ticksuffix= " milhões"), title = '<b>Diferença Complementação da União por UF<b> - Cenário atual x Cenário base')
      
      fig 
  })
  
  ## Cria tabela de peso usada no servidor ----
  mapa_fundeb = reactive({
    
    simulacao_atual = simulacao()
    
    complementacao_atual = stats::aggregate(
      list(complemento_atual = simulacao_atual$complemento_uniao),
      by = list(uf = simulacao_atual$uf),
      FUN=sum)
    
    mapa_estadual = merge(mapa, complementacao_atual)
    
    mapa_estadual
  })
  
  
  ### Mapa Complemento ----
  output$mapa_complemento = renderPlotly({
    mapa_fundeb = mapa_fundeb()
    
    fig = ggplot(mapa_fundeb[,c('complemento_atual', 'geometry')], aes(fill = complemento_atual, geometry = geometry)) +
      geom_sf() +
      scale_fill_viridis_c()

    fig = ggplotly(fig)
    
    fig 
  })
  
  ## Tabela DT ----
  output$simulacao_dt = DT::renderDT(
    simulacao(),
    server = FALSE,
    filter = 'top',
    class = 'cell-border stripe',
    extensions = 'Buttons',
    #### Opções adicionais
    options = list(
      autoWidth = TRUE,
      paging = TRUE,
      searching = TRUE,
      fixedColumns = TRUE,
      ordering = TRUE,
      scrollX = TRUE,
      dom = 'Bftsp',
      buttons = c('csv', 'excel')
    )
  )
  
  
  
  outputOptions(output, "pesos_vaat", suspendWhenHidden = FALSE)
  outputOptions(output, "pesos_vaaf", suspendWhenHidden = FALSE)
})
