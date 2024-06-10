# Aplicativo Simulador Fundeb

## Introdução

O Fundo de Manutenção e Desenvolvimento da Educação Básica e de Valorização dos Profissionais da Educação (Fundeb) é o principal mecanismo de financiamento da educação básica no Brasil, fundamentado no Art. 212-A da Constituição Federal e regulamentado pela Lei nº 14.113, de 25 de dezembro de 2020.

Este simulador de fatores de ponderação do Fundeb é uma ferramenta especialmente desenvolvida para auxiliar na estimativa e distribuição dos recursos dos fundos, permitindo que os usuários definam parâmetros e visualizem os potenciais impactos dessas definições. Sua interface amigável e completa visa subsidiar as decisões da União, dos Estados e dos municípios quanto às diferenças e ponderações das etapas, modalidades, durações de jornada e tipos de estabelecimento de ensino.

## Descrição do Simulador

O Simulador de Fatores de Ponderação é um aplicativo desenvolvido para estimar o funcionamento do Fundeb de acordo com diferentes parâmetros definidos pelo usuário. 

Utilizando dados de matrículas fornecidos pelo Instituto Nacional de Estudos e Pesquisas Educacionais Anísio Teixeira (Inep), dados de recursos calculados pelo Fundo Nacional de Desenvolvimento da Educação (FNDE) e as ponderações definidas pela Comissão Intergovernamental de Financiamento para a Educação Básica de Qualidade (CIF), o simulador calcula o montante distribuído para cada ente nacional e a complementação da União em infinitos cenários simulados pelos usuários. 

A ferramenta é composta por dois projetos principais:

*	O pacote em R criado para realizar as simulações, disponível: [simulador.fundeb](https://github.com/mellohenrique/simulador.fundeb).
*	O aplicativo em Shiny, cujo código pode ser obtido no link: [dash_simulador_fundeb](https://github.com/mellohenrique/dash_simulador_fundeb).

O simulador abrange as complementações-VAAF e VAAT, não incluindo a complementação-VAAR.

Ressalta-se que os resultados apresentados são simulações e não representam os valores reais que determinados entes federativos deverão receber. Diversos fatores não estão sendo controlados, como a arrecadação e o número de matrículas, o que pode afetar significativamente os valores finais. Portanto, os resultados devem ser utilizados apenas como referência para possíveis cenários, com vistas a subsidiar eventuais revisões nos fatores de ponderação do Fundeb.

##	Explicação sobre o Fundeb e suas Partes

###	Complementação-VAAF

A complementação-VAAF (Valor Aluno Ano Fundeb) equaliza os fundos estaduais considerando o valor aluno/ano. O fundo estadual com menor valor aluno/ano é complementado até atingir o valor do segundo fundo estadual com menor valor aluno/ano. Esse processo é repetido sucessivamente até esgotar os recursos disponíveis para a complementação. Caso não seja possível igualar todos os fundos, os recursos são distribuídos de maneira a maximizar o valor aluno/ano possível.

###	Complementação-VAAT

A complementação-VAAT (Valor Aluno Ano Total) equaliza os fundos dos entes federativos (Estados e municípios) em âmbito nacional, levando em consideração o valor aluno/ano total, o qual, por sua vez, considera outros recursos vinculados à educação para além das receitas integrantes do Fundeb, a exemplo das arrecadações próprias dos municípios, das transferências federais da contribuição do salário educação e dos programas federais de distribuição universal. O processo de complementação é similar ao da VAAF, mas focado nos entes federativos propriamente ditos e seus respectivos valores aluno/ano.

###	Complementação-VAAR

A complementação-VAAR (Valor Aluno Ano Resultado) destina-se a entes que apresentaram melhorias em indicadores de atendimento e de aprendizagem com redução das desigualdades, conforme aferido pelo Inep, com o objetivo de incentivar a melhoria da qualidade e da equidade na educação básica. Por não responder às diferenças e ponderações que balizam a distribuição das parcelas-VAAF e VAAT, a complementação-VAAR não se encontra abrangida por este simulador.

##  Fontes e Dados Utilizados

* Os dados de alunos foram retirados da [portaria interministerial número 1, de 23/02/2024](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/matriculas-da-educacao-basica/copy_of_2024-com-base-na-portaria-interministerial-no-6-de-28-12-2023);
* Os valores de receitas do Fundeb foram obtidos no portal do [FNDE](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/2024-1);
* Os pesos utilizados foram extraídos da [Resolução MEC nº 04, de 30 de outubro de 2023](https://www.gov.br/mec/pt-br/acesso-a-informacao/participacao-social/conselhos-e-orgaos-colegiados/comissao-intergovernamental-fundeb/Resoluo4_30102023.pdf).
* O fator relativo ao Indicador de Nível Socioeconômico (NSE) ampara-se na [Nota Técnica nº 16/2023/CGEE/DIRED/Inep](https://download.inep.gov.br/areas_de_atuacao/fundeb/nota_tecnica_16_2023.pdf)  e os dados estão disponíveis no portal do Inep;
* O fator de disponibilidade de recursos vinculados à educação (DRec) baseia-se na [Nota Técnica nº 2312/2023/MF](https://www.gov.br/mec/pt-br/acesso-a-informacao/participacao-social/conselhos-e-orgaos-colegiados/comissao-intergovernamental-fundeb/Nota_Tecnica_2312_2023_MF.pdf)  e os dados estão disponíveis no portal do FNDE .

## Créditos

Este simulador foi desenvolvido mediante o Termo nº XX, de DIA de MÊS de 2024, entre o Instituto Nacional de Estudos e Pesquisas Educacionais Anísio Teixeira (Inep) e o Todos pela Educação.

## Formulação matemática da equalização

A equalização é realizada dentro da simulação da seguinte forma: seja $X$ um conjunto de fundos ordenado $X = (x_1, x_2, ..., x_k)$ sendo $k$ o número de entes do fundo, tendo cada fundo um vetor com três valores: $x_i = (a_i, m_i, v_i)$; sendo $x_i$ o fundo do ente $i$, $a_i$ o número de alunos do ente $i$ e $v_i$ o valor por aluno do fundo, ou seja, $m_i/a_i$. Seja $X$ ordenado de forma crescente pelo valor por alunom ou seja, $a_i < a_j; \forall i,j; i<j$. Calcula-se um vetor $N = (n_1, n_2, ..., n_{k-1})$, com $n_i = \sum_1^i a_t * v_{i+1}$, ou seja, o número total de alunos de todos os fundos com menor valor por aluno que o fundo considerado multiplicado pelo valor de aluno do fundo logo em sequência que recebe mais por aluno. Isso nós dá um vetor $N = (n_1, n_2, ..., n_k)$ com o $n_i$ sendo o montante necessário para realizar uma equalização dos $i$ fundos mais pobres com o valor por aluno do fundo $i+1$.

Dado o montante $u$ passado pela União para equalizar os fundos, observa-se $u > n_i, \forall i$ ou $u \leq n_i$, para algum $i \in (1, 2, ..., k - 1)$. Considere-se então o menor $i$ para o qual $u \leq n_i$, tomam-se os fundos $x_1, ..., x_i$ e um novo montante $M = u + \sum_1^im_t$. O novos fundos então serão, portanto:

$x_i = (a_i, m_i = \frac{a_i * M}{\sum_1^ia_t}, v_i = \frac{M}{\sum_1^ia_t})$

Os fundos $x_1, ..., x_i$ equalizados são unidos aos fundos $x_{i+1}, ..., x_k$ não equalizados. Caso $u > n_i, \forall i$ todos os fundo participam dessa equalização

