analise_diferenca_simulacoes = function(cenario_atual, cenario_base){

  names(cenario_atual) = ifelse(names(cenario_atual) == 'ibge', 'ibge', paste0(names(cenario_atual), '_atual'))
  
  df = merge(cenario_atual, cenario_base, all.x = TRUE)
  
  tabela_resumo = data.frame(
    Variável = c("Mudança máxima nos recursos (em percentual)", "Mudança mediana nos recursos (em percentual)", "Mudança média nos recursos  (em percentual)","Mudança máxima nos recursos", "Mudança mediana nos recursos", "Mudança média nos recursos" , "Mudança no VAAF mínimo", "Mudança no VAAT mínimo"),
    Valores = c(max((df$recursos_fundeb_atual - df$recursos_fundeb) / df$recursos_fundeb),
                median((df$recursos_fundeb_atual - df$recursos_fundeb) / df$recursos_fundeb),
                mean((df$recursos_fundeb_atual - df$recursos_fundeb) / df$recursos_fundeb),
                max(df$recursos_fundeb_atual - df$recursos_fundeb),
                median(df$recursos_fundeb_atual - df$recursos_fundeb),
                mean(df$recursos_fundeb_atual - df$recursos_fundeb),
                min(df$vaaf_final_atual) - min(df$vaaf_final),
                min(df[!df$inabilitados_vaat_atual,]$vaat_final_atual) - min(df[!df$inabilitados_vaat,]$vaat_final)))
  
  return(tabela_resumo)
}


