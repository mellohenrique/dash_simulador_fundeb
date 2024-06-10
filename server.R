# Inicio do Server ----
server = function(input, output, session) {
  ## Carrega funcoes ----
  source('r/utils.r', encoding = 'UTF-8')
  source('r/analise_diferenca_simulacoes.R', encoding = 'UTF-8')
  source('r/analise_infobox.R', encoding = 'UTF-8')
  source('r/analise_vencedores_perdedores.R', encoding = 'UTF-8')
  source('r/texto_entrada.R', encoding = 'UTF-8')
  
  ## Cria sliders para UI ----
  ### VAAF ----
  output$pesos_vaaf = renderUI({
    lapply(1:length(pesos$etapa), function(i) {
      sliderInput(
        label = paste(i, '-', pesos$nome[[i]]),
        inputId = paste0("pesos_vaaf_", i),
        min = 0.8,
        max = 3.5,
        value = c(pesos$peso_vaaf[[i]])
      )
    })
  })
  
  ### VAAT ----
  output$pesos_vaat = renderUI({
    lapply(1:length(pesos$etapa), function(i) {
      sliderInput(
        label = paste(i, '-', pesos$nome[[i]]),
        inputId = paste0("pesos_vaat_", i),
        min = 0.8,
        max = 3.5,
        step = .1,
        value = c(pesos$peso_vaat[[i]])
      )
    })
  })
  
  ## Cria tabela de peso usada no servidor ----analise_diferenca_simulacoes
  pesos_app = reactive({
    
  ### Estabelece reatividade ----
    req(input$pesos_vaat_30)
    
  ### Cria data.frame com os pesos ----
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
  
  ### Retorna pesos no ambiente reactive----
  pesos
    
  })
  
## Simula fundeb com parametros dados pelo usuario ----
### Considera simulacao ja realizada para primeira simulacao ----
  simulacao = reactive({
    if (input$botao == 0) {
      cenario_atual
    } else { 
      simulacao_realizada()}})
  
### Realiza-se simulacao quando botao ativado  ----
  simulacao_realizada = eventReactive(input$botao, {
    
### Considera valor zero caso nao NA ou NULL no valor de complementacao vaaf ----
    complementacao_vaaf = if (is.null(input$complementacao_vaaf) | is.na(input$complementacao_vaaf)) {
      0
    } else {
      input$complementacao_vaaf
    }
### Considera valor zero caso nao NA ou NULL no valor de complementacao vaat ---- 
    complementacao_vaat = if (is.null(input$complementacao_vaat) | is.na(input$complementacao_vaat)) {
      0
    } else {
      input$complementacao_vaat
    }
    
## Simulacao ----
    simulacao = simulador.fundeb::simula_fundeb(
      dados_matriculas = matriculas,
      dados_complementar = complementar,
      dados_peso = pesos_app(),
      complementacao_vaaf = 24153287047,
      complementacao_vaat = 18114965285,
      complementacao_vaar = 0,
      max_nse = input$nse,
      min_nse = 1,
      max_nf = input$nf,
      min_nf = 1
    )

### Retorna resultado da simulacao----
    simulacao[, c('matriculas_vaaf', 'matriculas_vaat',  'recursos_vaaf', 'recursos_vaat',  'recursos_vaaf_final', 'vaaf_final', 'vaat_pre', 'recursos_vaat_final', 'vaat_final', 'complemento_vaaf', 'complemento_vaat', 'complemento_uniao', 'recursos_fundeb')] = lapply(simulacao[, c('matriculas_vaaf', 'matriculas_vaat',  'recursos_vaaf', 'recursos_vaat',  'recursos_vaaf_final', 'vaaf_final', 'vaat_pre', 'recursos_vaat_final', 'vaat_final', 'complemento_vaaf', 'complemento_vaat', 'complemento_uniao', 'recursos_fundeb')], round, 2)
    

    simulacao = simulacao[, c('ibge', 'uf', 'nome', 'matriculas_vaaf', 'matriculas_vaat', "inabilitados_vaat", 'nse', 'nf', 'recursos_vaaf', 'recursos_vaat',  'recursos_vaaf_final', 'vaaf_final', 'vaat_pre', 'recursos_vaat_final', 'vaat_final', 'complemento_vaaf', 'complemento_vaat', 'complemento_uniao', 'recursos_fundeb')]
    
    simulacao$inabilitados_vaat = ifelse(simulacao$inabilitados_vaat, 'Verdadeiro', "Falso")
    
    simulacao
    
    })
  
## Filtro regional
  simulacao_analise_regional = reactive({
    simulacao_regional = simulacao()[simulacao()$uf %in% input$estado_analise,]
    
    simulacao_regional
  })
  
## Filtro regional
simulacao_comparada = reactive({
  simulacao_comparada = une_simulacao_cenario_atual(simulacao(), cenario_atual)
    
    simulacao_comparada
  })
  
## Filtro regional
simulacao_comparada_regional = reactive({
  simulacao_comparada_regional = une_simulacao_cenario_atual(simulacao_analise_regional(), cenario_atual)
    
    simulacao_comparada_regional
  })
## Valores para Infoboxes ----
### Nacional ----
#### Calculo ----
infobox_nacional = reactive({analise_infobox(simulacao_comparada())})
#### Definição de valores ----
output$nacional_vaaf = reactive({infobox_nacional()$vaaf_minimo})
output$nacional_vaat = reactive({infobox_nacional()$vaat_minimo})
output$nacional_dif_vaaf = reactive({infobox_nacional()$dif_vaaf})
output$nacional_dif_vaat = reactive({infobox_nacional()$dif_vaat})
output$nacional_compl_est = reactive({infobox_nacional()$compl_est})
output$nacional_compl_mun = reactive({infobox_nacional()$compl_mun})
output$nacional_perc_compl = reactive({infobox_nacional()$perc_compl})
### Regional ----
#### Calculo ----
infobox_regional = reactive({analise_infobox(simulacao_comparada())})
#### Definição de valores ----
output$regional_vaaf = reactive({infobox_regional()$vaaf_minimo})
output$regional_vaat = reactive({infobox_regional()$vaat_minimo})
output$regional_dif_vaaf = reactive({infobox_regional()$dif_vaaf})
output$regional_dif_vaat = reactive({infobox_regional()$dif_vaat})
output$regional_compl_est = reactive({infobox_regional()$compl_est})
output$regional_compl_mun = reactive({infobox_regional()$compl_mun})
output$regional_perc_compl = reactive({infobox_regional()$perc_compl})

## Simulação UFS ----
  simulacao_ufs = reactive({
    simulacao_filtro = simulacao()[simulacao()$inabilitados_vaat == 'Falso' | simulacao()$uf == 'DF',]
    
    simulacao_ufs = stats::aggregate(
      list(VAAF = simulacao_filtro$vaaf_final,
           VAAT = simulacao_filtro$vaat_final),
      by = list(uf = simulacao_filtro$uf),
      FUN=mean)
    
    
    simulacao_ufs$tipo = 'Simulação'
    
    simulacao_ufs
  })
  
  ## Gráfico com complementação da união por UF e tipo de complementação ----
  output$graf_vaaf_ufs = plotly::renderPlotly({
    ### Calculo do complementacao por unidade da federação ----
    simulacao_ufs = simulacao_ufs()
    
    simulacao_ufs$uf = factor(simulacao_ufs$uf, simulacao_ufs$uf[order(simulacao_ufs$VAAF)])
    
    simulacao_ufs = rbind(simulacao_ufs, cenario_ufs_atual)
    
    ### Plotly ----    
    fig = plot_ly(
      simulacao_ufs,
      x = ~uf,
      y = ~VAAF,
      color = ~tipo,
      type = "bar",
      meta = ~tipo,
      hovertemplate = "UF: %{label}<br>%{meta[0]}: %{y:,.0f} reais<extra></extra>"
    )
    
    fig =  layout(fig, separators = ',.', xaxis = list(title = "", tickangle = 0), yaxis = list(title = "Montante", tickformat = ',.f', ticksuffix= " milhões"), title = "<b>Complementação da União por UF e Modalidade<b>")
    ### Retorna figura  
    fig 
  })
  
  
  ## Gráfico com complementação da união por UF e tipo de complementação ----
  output$graf_vaat_ufs = plotly::renderPlotly({
    ### Calculo do complementacao por unidade da federação ----
    simulacao_ufs = simulacao_ufs()
    
    simulacao_ufs$uf = factor(simulacao_ufs$uf, simulacao_ufs$uf[order(simulacao_ufs$VAAT)])
    
    simulacao_ufs = rbind(simulacao_ufs, cenario_ufs_atual)
    
    ### Plotly ----    
    fig = plot_ly(
      simulacao_ufs,
      x = ~uf,
      y = ~VAAT,
      color = ~tipo,
      type = "bar",
      meta = ~tipo,
      hovertemplate = "UF: %{label}<br>%{meta[0]}: %{y:,.0f} reais<extra></extra>"
    )
    
    fig =  layout(fig, separators = ',.', xaxis = list(title = "", tickangle = 0), yaxis = list(title = "Montante", tickformat = ',.f', ticksuffix= " milhões"), title = "<b>Complementação da União por UF e Modalidade<b>")
    ### Retorna figura  
    fig 
  })
  
## Gráfico com complementação da união por UF e tipo de complementação ----
  output$graf_complementacao_modalidade = plotly::renderPlotly({
### Calculo do complementacao por unidade da federação ----
    
    complementacao_uf = stats::aggregate(
      list(complemento_vaaf = simulacao()$complemento_vaaf,
           complemento_vaat = simulacao()$complemento_vaat),
           by = list(uf = simulacao()$uf),
      FUN=sum)
    
    complementacao_uf = complementacao_uf[order((complementacao_uf$complemento_vaaf + complementacao_uf$complemento_vaat) * -1),]
    complementacao_uf$uf = factor(complementacao_uf$uf, levels = complementacao_uf$uf, ordered = TRUE)
    
    complementacao_uf = reshape(complementacao_uf, direction = "long", varying = 2:3, times = names(complementacao_uf)[2:3], timevar = "tipo", v.names = "complemento")
    
    complementacao_uf = complementacao_uf[,c('uf', 'tipo', 'complemento')]
    complementacao_uf$tipo = ifelse(complementacao_uf$tipo == 'complemento_vaaf', "Complementação-VAAF", 'Complementação-VAAT')
### Plotly ----    
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
### Retorna figura  
    fig 
  })
  
  ## Gráfico com complementação da união por UF e destino da complementação ----
  output$graf_complementacao_destino = plotly::renderPlotly({
    ### Calculo do complementacao por unidade da federação ----
    
    complementacao_uf = stats::aggregate(
      list(complemento = simulacao()$complemento_vaaf + simulacao()$complemento_vaat),
      by = list(uf = simulacao()$uf,
                tipo = ifelse(simulacao()$ibge < 100, 'Estado', 'Município')),
      FUN=sum)
    
    complementacao_ordem = stats::aggregate(
      list(complemento = -complementacao_uf$complemento),
      by = list(uf = complementacao_uf$uf),
      FUN=sum)
    
    complementacao_uf$uf = factor(complementacao_uf$uf, levels = complementacao_ordem[order(complementacao_ordem$complemento),]$uf, ordered = TRUE)
    
    ### Plotly ----    
    fig = plot_ly(
      complementacao_uf,
      x = ~uf,
      y = ~complemento/1000000,
      name = ~tipo,
      meta = ~tipo,
      type = "bar",
      hovertemplate = "UF: %{label}<br>%{meta[0]}: %{y:,.0f} milhões<extra></extra>"
    )
    fig =  layout(fig, separators = ',.', barmode = "stack", xaxis = list(title = "", tickangle = 0), yaxis = list(title = "Montante", tickformat = ',.f', ticksuffix= " milhões"), title = "<b>Complementação da União por UF e Categoria Administrativa<b>")
    ### Retorna figura  
    fig 
  })
  
## Grafico diferença ----
  output$graf_diff_uf = renderPlotly({
    
    simulacao_agregada = stats::aggregate(
      list(complemento_atual = simulacao()$complemento_uniao),
      by = list(uf = simulacao()$uf),
      FUN=sum)
    
    comparacao = merge(simulacao_agregada, cenario_atual_agregada, by = 'uf')
    
    comparacao$diff = comparacao$complemento_atual - comparacao$complemento_uniao
    
    comparacao = comparacao[order(comparacao$diff * -1),]
    comparacao$uf = factor(comparacao$uf, levels = comparacao$uf, ordered = TRUE)
    
    fig = plot_ly(
      comparacao,
      x = ~uf,
      y = ~round(diff/1000000),
      type = "bar",
      hovertemplate = "UF: %{label}<br>Diferença: %{y:,.0f} milhões<extra></extra>"
    )
    
    fig =  layout(fig, separators = ',.', barmode = "stack", xaxis = list(title = "", tickangle = 0), yaxis = list(title = "Montante", tickformat = ',.f', ticksuffix= " milhões"), title = '<b>Diferença Complementação da União por UF<b> - Cenário atual x Cenário base')
    
    fig 
    
    
  })
  
  ## Grafico diferença ----
  tabela_resumo = reactive({
    tabela_resumo = analise_diferenca_simulacoes(simulacao_comparada())
    
    tabela_resumo
  })
  
  ## Grafico diferença ----
  tabela_resumo_regional = reactive({
    tabela_resumo_regional = analise_diferenca_simulacoes(simulacao_comparada_regional())
    
    tabela_resumo_regional
  })  
  
  
## Define tabela final a ser enviada para o usuário ----
  tabela_final = reactive({
    if (input$botao == 0) {
      names(cenario_atual) = c('ibge', 'uf', 'nome', paste0(names(cenario_atual)[4:19], '_atual'))
      tabela = cenario_atual
    } else {
      tabela = simulacao_comparada()
    }
    tabela
    
  })
  
## Tabela DT ----
  output$simulacao_dt = DT::renderDT(
    tabela_final(),
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
      buttons = list('csv', 'excel')
    )
  )
 
  ## Tabela DT ----
  output$tabela_resumo = DT::renderDT(
    tabela_resumo(),
    server = FALSE,
    filter = 'top',
    class = 'cell-border stripe',
    extensions = 'Buttons',
    #### Opções adicionais
    options = list(
      autoWidth = FALSE,
      paging = FALSE,
      searching = FALSE,
      fixedColumns = TRUE,
      ordering = TRUE,
      scrollX = TRUE,
      dom = 'Bftsp',
      buttons = list('csv', 'excel')
    )
  ) 

  ## Tabela DT ----
  output$tabela_resumo_regional = DT::renderDT(
    tabela_resumo_regional(),
    server = FALSE,
    filter = 'top',
    class = 'cell-border stripe',
    extensions = 'Buttons',
    #### Opções adicionais
    options = list(
      autoWidth = FALSE,
      paging = FALSE,
      searching = FALSE,
      fixedColumns = TRUE,
      ordering = TRUE,
      scrollX = FALSE,
      dom = 'Bftsp',
      buttons = list('csv', 'excel')
    )
  ) 
  
  # Dicionário ----
  
  output$dicionario <- downloadHandler(
    filename = 'dicionario.xlsx',
    content = function(file) {
      #temp <- file.path(tempdir(), "report.Rmd")
      file.copy(file.path(getwd(),'dicionario.xlsx'), file, overwrite = TRUE)
    })
  
  # Carrega dados de pesos previamente ----
  outputOptions(output, "pesos_vaat", suspendWhenHidden = FALSE)
  outputOptions(output, "pesos_vaaf", suspendWhenHidden = FALSE)
  
  
  shinyalert::shinyalert(text = texto_entrada)
}
