# Inicio do Server ----
shinyServer(function(input, output) {
  ## Cria sliders com pesos para UI ----
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
  
  ## Cria tabela de pesos usada no servidor ----
  pesos_app = reactive({
    req(input$etapa_30)
    
  pesos = data.frame(
      etapa = peso$etapa,
      peso_vaaf = sapply(1:length(peso$etapa),
                         function(i) {
                           input[[paste0("etapa_", i)]][[1]]
                         }))
  
  ### Altera os pesos vaat para considerar creche como 50% maior na etapa vaat
  pesos$peso_vaat = pesos$peso_vaaf * c(1.5, 1.5, 1.5, 1.5, 1, 1, 1,  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.5, 1.5, 1.5, 1.5, 1, 1, 1, 1, 1)
  
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
    simulacao = simulador.fundeb2::simula_fundeb(
      dados_alunos = alunos,
      dados_complementar = complementar,
      peso_etapas = pesos_app(),
      chao_socio = 1,
      teto_socio = input$social,
      chao_fiscal = 1,
      teto_fiscal = input$fiscal,
      complementacao_vaaf = complementacao_vaaf * 1000000,
      complementacao_vaat = complementacao_vaat * 1000000,
      produto_dt = TRUE
    )
    
    #### Altera nomes para padrao externo ----
    setnames(simulacao,
             names(simulacao),
             c("UF", "Ibge", "Alunos", "Alunos ponderados VAAF", "Alunos ponderados VAAT", "Município", "Fator Social", "Fator Fiscal", "Montante do Fundeb", "Montante Extra", "Fundo estadual etapa VAAF", "Equalizado VAAF", "VAAF", "Montante VAAF", "Montante Base", "Montante VAAF extra", "VAAF extra", "Montante VAAT", "Equalizado VAAT", "VAAT"))

    #### Altera ordem para padrao externo ----    
    setcolorder(simulacao, c("UF", "Ibge", "Alunos", "VAAT", "Alunos ponderados VAAF", "Alunos ponderados VAAT", "Município", "Fator Social", "Fator Fiscal", "Montante do Fundeb", "Montante Extra", "Fundo estadual etapa VAAF", "Equalizado VAAF", "VAAF", "Montante VAAF", "Montante Base", "Montante VAAF extra", "VAAF extra", "Montante VAAT", "Equalizado VAAT"))
    
    #### Retorna resultado da simulacao----
    simulacao
    })
  
  ## Valores para Infoboxes ----
  ### Calcula valor maximo do VAAT para info box
  output$box_max_vaat = renderUI({
    prettyNum(max(simulacao()$VAAT), big.mark = ".", decimal.mark = ",", digits = 0)
  })
  
  ### Calcula minimo VAAT para info box ----
  output$box_media_vaat = renderUI({
    prettyNum(mean(simulacao()$VAAT), big.mark = ".", decimal.mark = ",", digits = 0)
  })
  
  ### Calcula minimo VAAT para info box ----
  output$box_min_vaat = renderUI({
    prettyNum(min(simulacao()$VAAT), big.mark = ".", decimal.mark = ",", digits = 0)
  })
  
  ### Calcula media VAAT do quintil SAEB para info box ----
  output$box_mean_vaat_quintil = renderUI({
    prettyNum(mean(simulacao()[Ibge %in% codigos_ibge,]$VAAT), big.mark = ".", decimal.mark = ",", digits = 0)
  })
  
  ### Calcula total VAAT da complementação municipal ----
  output$box_compl_municipal = renderUI({
    prettyNum(sum(simulacao()[Ibge > 100,]$`Montante VAAT`) - sum(simulacao()[Ibge > 100,]$`Montante VAAF extra`) + 
                sum(simulacao()[Ibge > 100,]$`Montante VAAF`) - sum(simulacao()[Ibge > 100,]$`Montante Base`), big.mark = ".", decimal.mark = ",", digits = 0)
  })
  
  ### Calcula total VAAT da complementação estadual ----
  output$box_compl_estadual = renderUI({
    prettyNum(sum(simulacao()[Ibge < 100,]$`Montante VAAT`) - sum(simulacao()[Ibge < 100,]$`Montante VAAF extra`) +
      sum(simulacao()[Ibge < 100,]$`Montante VAAF`) - sum(simulacao()[Ibge < 100,]$`Montante Base`), big.mark = ".", decimal.mark = ",", digits = 0, format = "f")
  })
  
  ## Gráfico com complementação da federação por UF ----
  output$graf_complementacao_federal = plotly::renderPlotly({
    ### Calculo do complementacao por unidade da federação ----
    complementacao_uf = melt(simulacao()[, .(
      `Complementação VAAF` = sum(`Montante VAAF` - `Montante do Fundeb`),
      `Complementação VAAT` = sum(`Montante VAAT` - `Montante VAAF extra`)
    ), by = UF][,UF := fct_reorder(UF, - `Complementação VAAF` - `Complementação VAAT`)][, `:=`(`Complementação VAAF` = ifelse(`Complementação VAAF` < 1, 0 , `Complementação VAAF`), `Complementação VAAT` = ifelse(`Complementação VAAT` < 1, 0 , `Complementação VAAT`))], id.vars = "UF")
    
    fig = plot_ly(
      complementacao_uf,
      x = ~UF,
      y = ~value/1000000,
      name = ~variable,
      type = "bar",
      meta = ~variable,
      hovertemplate = "UF: %{label}<br>%{meta[0]}: %{y:,.0f} milhões<extra></extra>"
    )
    
    fig =  layout(fig, separators = ',.', barmode = "stack", xaxis = list(title = "", tickangle = 0), yaxis = list(title = "Montante", tickformat = ',.f', ticksuffix= " milhões"), title = "<b>Complementação da União por UF e Modalidade<b>")
    
    fig 
  })
  
  ## Gráfico da dispersão do VAAT por ente ----
  output$graf_dispersao_ente = plotly::renderPlotly({
    
    simulacao_ordenada = setorder(simulacao(), VAAT)
    simulacao_ordenada = simulacao_ordenada[, ordem := 1:5595]
    
    fig = plot_ly(simulacao_ordenada,
                  x = ~ordem,
                  y = ~VAAT,
                  text = ~Município,
                  hovertemplate = "Nome do ente: %{text}<br>VAAT: %{y}<extra></extra>",
                  type = "scatter")
    
    fig = layout(fig, separators = ',.', barmode = "stack", xaxis = list(title = "Número de entes (ordenado, ascendente)"), yaxis = list(title = "VAAT", tickformat = ',.0f', range = list(0, 1.1*max(simulacao_ordenada$VAAT))), title = "<b>VAAT por Ente Federado  – 2021<b>")
    
    fig
  }) 
  
  ### Gráfico decil ----
  output$graf_decil_saeb = plotly::renderPlotly({
    ### Calculo do complementacao por unidade da federação ----
    
    simulacao_decil = simulacao()[complementar, indicador_social := fator_social, on = c("Ibge" = "ibge")]
    
    simulacao_decil[, decil := cut(indicador_social, quantile(indicador_social, probs = 0:10/10),
                         labels = c("1º Decil", "2º Decil", "3º Decil", "4º Decil", "5º Decil", "6º Decil", "7º Decil", "8º Decil", "9º Decil", "10º Decil"), include.lowest = TRUE, ordered_result	
                         = TRUE)]
    
    
    simulacao_decil = simulacao_decil[,.(VAAT = mean(VAAT)), by = decil]
    
    fig = plot_ly(simulacao_decil,
                  x = ~decil,
                  y = ~VAAT,
                  hovertemplate = "%{x}<br>VAAT médio: %{y}<extra></extra>")
    
    fig = layout(fig, separators = ',.', xaxis = list(title = "Decis de renda"), yaxis = list(title = "VAAT Médio (em reais)", tickformat = ',.0f'), title = "<b>VAAT Médio por Decil do indicador socioeconômico SAEB – 2019<b>")
    
    fig
    
  }) 
  
  
  ### Grafico dispersao
  output$graf_dispersao = renderPlotly({
    dados = simulacao()[,.(
      minimo_vaat = min(VAAT),
      maximo_vaat = max(VAAT),
      media_vaat = mean(VAAT)),
      by = "UF"][,uf:= fct_reorder(UF, -media_vaat)]
    
    fig = plot_ly(dados, y = ~maximo_vaat, x = ~uf, name = "Máximo VAAT", type = 'scatter', meta = "VAAT Máximo da UF",
                   mode = "markers", marker = list(color = "blue"),
                   hovertemplate = "%{meta}: %{y:,.0f}<extra></extra>")
    
    fig = add_trace(fig, y = ~media_vaat, x = ~uf, name = "Média VAAT",type = 'scatter', meta = "VAAT Médio da UF",
                     mode = "markers", marker = list(color = "green"))
    
    fig = add_trace(fig, y = ~minimo_vaat, x = ~uf, name = "Mínimo VAAT",type = 'scatter', meta = "VAAT Mínimo da UF",
                     mode = "markers", marker = list(color = "orange"))
    
    layout(fig,
           title = "<b>Dispersão do Valor VAAT por UF<b>",
           xaxis = list(title = "", tickangle = 0),
           yaxis = list(title = "VAAT (em reais)", tickformat = ',.0f'),
           separators = ',.',
           hovermode = "x unified")
  })
  
  ### Tabela DT ----
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
      buttons = c('copy', 'csv', 'excel')
    )
  )
})
