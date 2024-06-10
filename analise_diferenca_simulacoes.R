# Analisa as diferenças entre o cenario base e o cenario atual para a tabela resumo
analise_diferenca_simulacoes = function(simulacao_comparada){
    
    tabela_resumo = data.frame(
    Variável = c("Maior aumento nos recursos (em percentual)", "Maior redução nos recursos (em percentual)", "Mudança mediana nos recursos (em percentual)", "Mudança média nos recursos  (em percentual)", "Maior aumento nos recursos", "Maior redução nos recursos", "Mudança mediana nos recursos", "Mudança média nos recursos" , "Mudança no VAAF mínimo", "Mudança no VAAT mínimo"),
    Valores = c(
      scales::percent(
        max((simulacao_comparada$recursos_fundeb_simulacao - simulacao_comparada$recursos_fundeb_atual) / simulacao_comparada$recursos_fundeb_atual
        ),
        big.mark = '.',
        decimal.mark = ',',
        accuracy = 0.01
      ),
      scales::percent(
        min((simulacao_comparada$recursos_fundeb_simulacao - simulacao_comparada$recursos_fundeb_atual) / simulacao_comparada$recursos_fundeb_atual
        ),
        big.mark = '.',
        decimal.mark = ',',
        accuracy = 0.01
      ),
      scales::percent(
        median((simulacao_comparada$recursos_fundeb_simulacao - simulacao_comparada$recursos_fundeb_atual) / simulacao_comparada$recursos_fundeb_atual
        ),
        big.mark = '.',
        decimal.mark = ',',
        accuracy = 0.01
      ),
      scales::percent(
        mean((simulacao_comparada$recursos_fundeb_simulacao - simulacao_comparada$recursos_fundeb_atual) / simulacao_comparada$recursos_fundeb_atual
        ),
        big.mark = '.',
        decimal.mark = ',',
        accuracy = 0.01
      ),
      scales::number(
        max(simulacao_comparada$recursos_fundeb_simulacao - simulacao_comparada$recursos_fundeb_atual),
        big.mark = '.',
        decimal.mark = ',',
        accuracy = 0.01
      ),
      scales::number(
        min(simulacao_comparada$recursos_fundeb_simulacao - simulacao_comparada$recursos_fundeb_atual),
        big.mark = '.',
        decimal.mark = ',',
        accuracy = 0.01
      ),
      scales::number(
        median(simulacao_comparada$recursos_fundeb_simulacao - simulacao_comparada$recursos_fundeb_atual),
        big.mark = '.',
        decimal.mark = ',',
        accuracy = 0.01
      ),
      scales::number(
        mean(simulacao_comparada$recursos_fundeb_simulacao - simulacao_comparada$recursos_fundeb_atual),
        big.mark = '.',
        decimal.mark = ',',
        accuracy = 0.01
      ),
      scales::number(
        min(simulacao_comparada$vaaf_final_simulacao) - min(simulacao_comparada$vaaf_final_atual),
        big.mark = '.',
        decimal.mark = ',',
        accuracy = 0.01
      ),
      scales::number(
        min(simulacao_comparada[simulacao_comparada$inabilitados_vaat_simulacao == 'Falso', ]$vaat_final_simulacao) - min(simulacao_comparada[simulacao_comparada$inabilitados_vaat_atual  == 'Falso', ]$vaat_final_atual),
        big.mark = '.',
        decimal.mark = ',',
        accuracy = 0.01
      )
    ))
  
  return(tabela_resumo)
}

