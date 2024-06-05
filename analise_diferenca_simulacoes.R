analise_diferenca_simulacoes = function(cenario_atual, cenario_base){

  names(cenario_atual) = ifelse(names(cenario_atual) == 'ibge', 'ibge', paste0(names(cenario_atual), '_atual'))
  
  df = merge(cenario_atual, cenario_base, all.x = TRUE)
  
  tabela_resumo = data.frame(
    Variável = c("Maior aumento nos recursos (em percentual)", "Maior redução nos recursos (em percentual)", "Mudança mediana nos recursos (em percentual)", "Mudança média nos recursos  (em percentual)", "Maior aumento nos recursos", "Maior redução nos recursos", "Mudança mediana nos recursos", "Mudança média nos recursos" , "Mudança no VAAF mínimo", "Mudança no VAAT mínimo"),
    Valores = c(
      scales::percent(max((df$recursos_fundeb_atual - df$recursos_fundeb) / df$recursos_fundeb
), big.mark = '.', decimal.mark = ',', accuracy = 0.01),
      scales::percent(min((df$recursos_fundeb_atual - df$recursos_fundeb) / df$recursos_fundeb
), big.mark = '.', decimal.mark = ',', accuracy = 0.01),
      scales::percent(median((df$recursos_fundeb_atual - df$recursos_fundeb) / df$recursos_fundeb), big.mark = '.', decimal.mark = ',', accuracy = 0.01),
      scales::percent(mean((df$recursos_fundeb_atual - df$recursos_fundeb) / df$recursos_fundeb), big.mark = '.', decimal.mark = ',', accuracy = 0.01),
      scales::number(max(df$recursos_fundeb_atual - df$recursos_fundeb), big.mark = '.', decimal.mark = ',', accuracy = 0.01),
      scales::number(min(df$recursos_fundeb_atual - df$recursos_fundeb), big.mark = '.', decimal.mark = ',', accuracy = 0.01),
      scales::number(median(df$recursos_fundeb_atual - df$recursos_fundeb), big.mark = '.', decimal.mark = ',', accuracy = 0.01),
        scales::number(mean(df$recursos_fundeb_atual - df$recursos_fundeb), big.mark = '.', decimal.mark = ',', accuracy = 0.01),
        scales::number(min(df$vaaf_final_atual) - min(df$vaaf_final), big.mark = '.', decimal.mark = ',', accuracy = 0.01),
        scales::number(min(df[!df$inabilitados_vaat_atual, ]$vaat_final_atual) - min(df[!df$inabilitados_vaat, ]$vaat_final), big.mark = '.', decimal.mark = ',', accuracy = 0.01)
      ))
  
  return(tabela_resumo)
}


