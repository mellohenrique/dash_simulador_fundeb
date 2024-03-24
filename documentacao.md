# Aplicativo Simulador Fundeb

O aplicativo Simulador Fundeb é um aplicativo utilizado para estimar o funcionamento do Fundo de Manutenção da Educação Básica e de Valorização dos Profissionais de Educação  de acordo com diferentes parâmetros a serem definidos pelo usuário. A ferramenta utiliza dados do Fundo Nacional de Desenvolvimento da Educação (FNDE) para calcular o montante distribuído para cada ente nacional e a complementação da União. Dois projetos são utilizados para a criação deste aplicativo:

* O próprio aplicativo em _Shiny_ cujo código pode ser obtido no link do [dash_simulador_fundeb](https://github.com/mellohenrique/dash_simulador_fundeb);
* O pacote em R criado para fazer as simulações [simulador.fundeb](https://github.com/mellohenrique/simulador.fundeb).

## Fonte

* Os dados de alunos foram retirados da [portaria interministerial número 7, de 29/12/2023](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/matriculas-da-educacao-basica/2023-com-base-na-portaria-interministerial-no-7-de-29-12-2023);
* Os valores de receitas do Fundeb  foram retirados do portal do [FNDE](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/2023);
* Os pesos utilizados foram obtidos no portal do Fundeb [link](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/vaat/Fatoresdeponderao.pdf), e na documentação do FNDE, no seguinte [PDF](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/notas-tecnicas/NotaTcnicaConjuntan122022.pdf).
* Indicador de Nível Socioeconômico (nse), disponível no site do [Instituto Nacional de Estudos e Pesquisas Educacionais Anísio Teixeira (INEP)](https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/indicadores-educacionais/nivel-socioeconomico);
* O indicador fiscal será fornecido pelo INEP.

## Equalização

A equalização dos fundos é realizada em duas etapas subsequentes:

1. Etapa VAAF, em que são equalizados os fundos estaduais por valor aluno/ano;
2. Etapa VAAT, em que são equalizados os fundos dos entes por valor aluno/ano;
3. Etapa VAAR, em que são distribuídos recursos para as redes que atingirem metas educacionais.

### Etapa VAAF

A etapa VAAF equaliza os fundos da seguinte maneira: considera-se o fundo estadual com menor aluno/ano e complementam-se os recursos deste até que tenha o mesmo valor aluno/ano do segundo fundo estadual com menor aluno/ano. Em seguida complementam-se estes dois fundos até terem o mesmo valor aluno/ano que o terceiro fundo com menor aluno/ano. Esta operação é repetida até os recursos disponíveis para a complementação terem acabado. Na última etapa, caso não seja possível igualar os fundos com menor aluno/ano até o valor do próximo fundo, complementam-se todos os fundos até que tenham o maior valor aluno ano possível com os recursos disponíveis.

### Etapa VAAT

A etapa VAAT equaliza os fundos dos entes das federações, não os fundos estaduais, fazendo a complementação pelo Valor Aluno Ano Total, que dá mais peso aos alunos da educação infantial e considera outros recursos além do Fundeb. Na complementação VAAT, complementa-se o ente da federação com menor valor até este ter o mesmo valor aluno/ano do segundo ente com menor aluno/ano. Em sequência, complementam-se os recursos destes dois entes que tenham o mesmo valor aluno/ano que o terceiro fundo com menor aluno/ano. Esta operação é contínua, até o fim dos recursos disponíveis para a complementação. Ao fim, caso não seja possível igualar os fundos com menor aluno/ano até o valor do próximo fundo, complementam-se todos os fundos até que tenham o maior valor aluno/ano possível com os recursos disponíveis.

### Etapa VAAR

A complementação VAAR destina-se a entes que tenham melhorado indicadores de aprendizado e antedimento, de acordo com o Inep. O objetivo dessa etapa é beneficiar os entes mais eficientes e promover melhorias na educação brasileira.

## Dados usados nas etapas VAAF e VAAT

* A complementação da Etapa VAAF utiliza os recursos estimados para o ano de 2023;
* A complementação da Etapa VAAT utiliza os recursos realizados do ano de 2021.

## Formulação matemática da equalização

A equalização é realizada dentro da simulação da seguinte forma: seja $X$ um conjunto de fundos ordenado $X = (x_1, x_2, ..., x_k)$ sendo $k$ o número de entes do fundo, tendo cada fundo um vetor com três valores: $x_i = (a_i, m_i, v_i)$; sendo $x_i$ o fundo do ente $i$, $a_i$ o número de alunos do ente $i$ e $v_i$ o valor por aluno do fundo, ou seja, $m_i/a_i$. Seja $X$ ordenado de forma crescente pelo valor por alunom ou seja, $a_i < a_j; \forall i,j; i<j$. Calcula-se um vetor $N = (n_1, n_2, ..., n_{k-1})$, com $n_i = \sum_1^i a_t * v_{i+1}$, ou seja, o número total de alunos de todos os fundos com menor valor por aluno que o fundo considerado multiplicado pelo valor de aluno do fundo logo em sequência que recebe mais por aluno. Isso nós dá um vetor $N = (n_1, n_2, ..., n_k)$ com o $n_i$ sendo o montante necessário para realizar uma equalização dos $i$ fundos mais pobres com o valor por aluno do fundo $i+1$.

Dado o montante $u$ passado pela União para equalizar os fundos, observa-se $u > n_i, \forall i$ ou $u \leq n_i$, para algum $i \in (1, 2, ..., k - 1)$. Considere-se então o menor $i$ para o qual $u \leq n_i$, tomam-se os fundos $x_1, ..., x_i$ e um novo montante $M = u + \sum_1^im_t$. O novos fundos então serão, portanto:

$x_i = (a_i, m_i = \frac{a_i * M}{\sum_1^ia_t}, v_i = \frac{M}{\sum_1^ia_t})$

Os fundos $x_1, ..., x_i$ equalizados são unidos aos fundos $x_{i+1}, ..., x_k$ não equalizados. Caso $u > n_i, \forall i$ todos os fundo participam dessa equalização

