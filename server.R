# Carregando pacotes ----
library(forcats)
library(markdown)
library(shinythemes)

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
      dados_fnde = alunos,
      dados_complementar = complementar,
      peso_etapas = pesos_app(),
      chao_socio = 1,
      teto_socio = input$social,
      chao_fiscal = 1,
      teto_fiscal = input$fiscal,
      complementacao_vaaf = complementacao_vaaf,
      complementacao_vaat = complementacao_vaat,
      produto_dt = TRUE
    )
    
    #### Altera nomes para padrao externo ----
    setnames(simulacao,
             names(simulacao),
             c("UF", "Ibge", "Alunos", "Alunos ponderados etapa VAAF", "Alunos ponderados VAAT", "Município", "Fator Social", "Fator Fiscal", "Montante do Fundeb", "Montante Extra", "Fundo estadual etapa VAAF", "Equalizado VAAF", "VAAF", "Montante VAAF", "Montante VAAF extra", "VAAF extra", "Montante VAAT", "Equalizado VAAT", "VAAT"))

    #### Altera ordem para padrao externo ----    
    setcolorder(simulacao, c("UF", "Ibge", "Município", "VAAT", "Alunos", "Alunos ponderados etapa VAAF", "Alunos ponderados VAAT", "Fator Social", "Fator Fiscal", "Montante do Fundeb", "Montante Extra", "Fundo estadual etapa VAAF", "Equalizado VAAF", "VAAF", "Montante VAAF", "Montante VAAF extra", "VAAF extra", "Montante VAAT", "Equalizado VAAT"))
    
    #### Retorna resultado da simulacao----
    simulacao
    })
  
  ## Valores para Infoboxes ----
  ### Calcula valor maximo do VAAT para info box
  output$box_max_vaat = renderUI({
    prettyNum(max(simulacao()$VAAT), big.mark = ".", decimal.mark = ",")
  })
  
  ### Calcula minimo VAAT para info box ----
  output$box_media_vaat = renderUI({
    prettyNum(mean(simulacao()$VAAT), big.mark = ".", decimal.mark = ",")
  })
  
  ### Calcula minimo VAAT para info box ----
  output$box_min_vaat = renderUI({
    prettyNum(min(simulacao()$VAAT), big.mark = ".", decimal.mark = ",")
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
      y = ~value,
      name = ~variable,
      type = "bar",
      meta = ~variable,
      hovertemplate = "UF: %{label}<br>%{meta[0]}: %{y}<extra></extra>"
    )
    
    fig =  layout(fig, separators = ',.', barmode = "stack", xaxis = list(title = ""), yaxis = list(title = "Montante", tickformat = ',.2f'), title = "Complementação da União por UF e Modalidade")
    
    fig 
  })
  
  ### Grafico média ----
  output$graf_vaat_medio = renderPlotly({
    vaat_media = simulacao()[, .(VAAT = mean(VAAT)), by = UF][,UF := fct_reorder(UF, VAAT)]
    
    fig = plot_ly(
      vaat_media,
      x = ~UF,
      y = ~VAAT,
      type = "bar",
      hovertemplate = "UF: %{label}<br>VAAT: %{y}<extra></extra>"
    )
    
    
    fig = layout(fig, separators = ',.', title = "VAAT Médio UF")
    
    fig 
  })
  
  ### Grafico dispersao
  output$graf_dispersao = renderPlotly({
    dados = simulacao()[,.(
      minimo_vaat = min(VAAT),
      maximo_vaat = max(VAAT),
      media_vaat = mean(VAAT)),
      by = "UF"][,uf:= fct_reorder(UF, maximo_vaat)]
    
    fig = plot_ly(dados, y = ~maximo_vaat, x = ~uf, name = "Máximo VAAT", type = 'scatter', meta = "VAAT Máximo da UF",
                   mode = "markers", marker = list(color = "blue"),
                   hovertemplate = "%{meta}: %{y:,.2f}<extra></extra>")
    
    fig = add_trace(fig, y = ~media_vaat, x = ~uf, name = "Média VAAT",type = 'scatter', meta = "VAAT Médio da UF",
                     mode = "markers", marker = list(color = "green"))
    
    fig = add_trace(fig, y = ~minimo_vaat, x = ~uf, name = "Mínimo VAAT",type = 'scatter', meta = "VAAT Mínimo da UF",
                     mode = "markers", marker = list(color = "orange"))
    
    layout(fig,
           title = "Dispersão do Valor VAAT por UF",
           xaxis = list(title = ""),
           yaxis = list(title = "Valor em Reais", tickformat = ',.2f'),
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
