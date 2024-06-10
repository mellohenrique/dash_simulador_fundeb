# Gera medidas de comparação para tabela de comparação de ganhadores e perdedores com a mudança da simulação

analise_vencedores_perdedores = function(simulacao_comparada){
  
  df = dplyr::mutate(simulacao_comparada, 
                     Região = stringr::str_extract(ibge, '^.'),
                     Região = dplyr::case_when(Região == 1 ~ 'Norte', Região == 2 ~ 'Nordeste', Região == 3 ~ 'Sudeste', Região == 4 ~ 'Sul', Região == 5 ~ "Centro-Oeste"),
                     dif_vaaf = (recursos_vaaf_final_simulacao - recursos_vaaf_final_atual)/recursos_vaaf_final_atual,
                     dif_vaat = (recursos_vaat_final_simulacao - recursos_vaat_final_atual)/recursos_vaat_final_atual,
                     `Resultado VAAF` = ifelse(dif_vaaf >= 0, 'Positivo', "Negativo"),
                     `Resultado VAAT` = ifelse(dif_vaat >= 0, 'Positivo', "Negativo"))
  
  
  tabela_vaaf = dplyr::group_by(df, `Resultado VAAF`, Região) |>
    dplyr::summarise(Entes = n(),
                     `Média` = scales::percent(mean(dif_vaaf), accuracy = .01, decimal.mark = ',', big.mark = '.'),
                     `Máximo` = scales::percent(max(abs(dif_vaaf)), accuracy = .01, decimal.mark = ',', big.mark = '.'),
                     `Mínimo` = scales::percent(min(abs(dif_vaaf)), accuracy = .01, decimal.mark = ',', big.mark = '.'))
  
  tabela_vaat = dplyr::group_by(df, `Resultado VAAT`, Região) |>
    dplyr::summarise(Entes = n(),
                     `Média` = scales::percent(mean(dif_vaat), accuracy = .01, decimal.mark = ',', big.mark = '.'),
                     `Máximo` = scales::percent(max(abs(dif_vaat)), accuracy = .01, decimal.mark = ',', big.mark = '.'),
                     `Mínimo` = scales::percent(min(abs(dif_vaat)), accuracy = .01, decimal.mark = ',', big.mark = '.'))
  
  lista_resultado = list(tabela_vaaf = tabela_vaaf,
       tabela_vaat = tabela_vaat)
  
  return(lista_resultado)
}
