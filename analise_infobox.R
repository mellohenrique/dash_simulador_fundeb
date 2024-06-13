# Gera medidas resumo para serem usadas no infobox

analise_infobox = function(simulacao_comparada){
  
  vaaf_minimo_simulacao = min(simulacao_comparada$vaaf_final_simulacao)
  vaat_minimo_simulacao = min(simulacao_comparada[simulacao_comparada$inabilitados_vaat_simulacao == 'Falso',]$vaat_final_simulacao)
  vaaf_minimo_atual = min(simulacao_comparada$vaaf_final_atual)
  vaat_minimo_atual = min(simulacao_comparada[simulacao_comparada$inabilitados_vaat_atual == 'Falso',]$vaat_final_atual)
  dif_vaaf_minimo = (vaaf_minimo_simulacao - vaaf_minimo_atual)/vaaf_minimo_atual
  dif_vaat_minimo = (vaat_minimo_simulacao - vaat_minimo_atual)/vaat_minimo_atual
  complementacao_municipios = sum(simulacao_comparada[simulacao_comparada$ibge > 100,]$complemento_uniao_simulacao)
  complementacao_estado = sum(simulacao_comparada[simulacao_comparada$ibge < 100,]$complemento_uniao_simulacao)
  entes_complementados = mean(simulacao_comparada$complemento_uniao_simulacao > 0)
  
  #### Calcula valor maximo do VAAT para info box ----
  lista_valores_infobox = list(
    vaaf_minimo =  prettyNum(vaaf_minimo_simulacao, big.mark = ".", decimal.mark = ",", digits = 2),
    vaat_minimo =  prettyNum(vaat_minimo_simulacao, big.mark = ".", decimal.mark = ",", digits = 2),
    dif_vaaf =  scales::percent(dif_vaaf_minimo, big.mark = ".", decimal.mark = ",", accuracy = .01),
    dif_vaat =  scales::percent(dif_vaat_minimo, big.mark = ".", decimal.mark = ",", accuracy = .01),
    compl_est = prettyNum(complementacao_estado, big.mark = ".", decimal.mark = ",", digits = 4),
    compl_mun = prettyNum(complementacao_municipios, big.mark = ".", decimal.mark = ",", digits = 4),
    perc_compl = scales::percent(entes_complementados, big.mark = ".", decimal.mark = ",", accuracy = .01)
  )
  
  
  
  return(lista_valores_infobox)
}
