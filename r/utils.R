une_simulacao_cenario_atual = function(simulacao, cenario_base){
  dplyr::left_join(simulacao, cenario_base, by = c('ibge', 'nome', 'uf'), suffix = c('_simulacao', '_atual'))
  }
