# Aplicativo Simulador Fundeb

O aplicativo simulador do Fundo de Manutenção e Desenvolvimento da Educação Básica e de Valorização dos Profissionais da Educação (FUNDEB) é um aplicativo utilizado para estimar o funcionamento deste fundo de acordo com diferentes parâmetros definidos pelo usuário. O aplicativo utiliza dados disponibilizados pelo Fundo Nacional de Desenvolvimento da Educação (FNDE) para calcular o montante de distribuido para cade ente nacional e como é feita a complementação da União. Dois projetos são utilizados para a criação deste aplicativo:

* O próprio aplicativo em _Shiny_ cujo código pode ser obtido no link do [simulador_fundeb](https://github.com/mellohenrique/dash-simulador-fundeb);
* O pacote em R criado para fazer as simulações [simulador.fundeb2](https://github.com/mellohenrique/simulador.fundeb2).

# Fonte

* Os dados de alunos foram retirados da [portaria interministerial número 3, de 24/05/2021](https://www.fnde.gov.br/index.php/financiamento/fundeb/consultas/item/14177-2021-com-base-na-portaria-interministerial-n%C2%BA-3,-de-24-05-2021);
* Os valores de receitas do fundeb e receitas extra foram retirados do portal do [FNDE](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/consultas), especificamente do seguinte [PDF](https://www.gov.br/fnde/pt-br/acesso-a-informacao/acoes-e-programas/financiamento/fundeb/vaat/vaat-2021-receita-stn-2019.pdf).

# Equalização

A equalização dos fundos é realizada em duas etapas subsequentes:

1. Etapa VAAT em que são equalizados os fundos estaduais por valor aluno ano;
2. Etapa VAAF em que são equalizados os fundos dos entes por valor aluno ano.

As duas equalizaçõesa são realizadas de forma semelhante, com o fundo com o menor aluno ano recebendo verbas até ter o mesmo valor que o fundo com o segundo menor valor aluno ano, então os dois fundos com menor aluno ano recebem um montante até ficarem com o mesmo valor que o terceiro fundo com o menor aluno ano. Esse processo é repetido até todo o montante destinado a equalização se esgotar.

A equalização é realizada dentro da simulação da seguinte forma, seja $X$ um conjunto de fundos ordenado $X = (x_1, x_2, ..., x_k)$ sendo $k$ o número de entes do fundo, cada fundo um vetor com três valores, $x_i = (a_i, m_i, v_i)$, sendo $x_i$ o fundo do ente $i$, $a_i$ o número de alunos do ente $i$ e $v_i$ o valor por aluno do fundo, ou seja, $m_i/a_i$. Seja $X$ ordenado de forma crescente pelo valor por alunom ou seja, $a_i < a_j; \forall i,j; i<j$. Calcula-se um vetor $N = (n_1, n_2, ..., n_{k-1})$, com $n_i = \sum_1^i a_t * v_{i+1}$, ou seja, o número total de alunos de todos os fundos com menor valor por aluno que o fundo considerado multiplicado pelo valor de aluno do fundo logo em sequência que recebe mais por aluno. Isso nós dá um vetor $N = (n_1, n_2, ..., n_k)$ com o $n_i$ sendo o montante necessário para realizar uma equalização dos $i$ fundos mais pobres com o valor por aluno do fundo $i+1$.

Dado o montante $u$ passado pela União para equalizar os fundos, obseva-se $u > n_i, \forall i$ ou $u \leq n_i$, para algum $i \in (1, 2, ..., k - 1)$. Considere-se então o menor $i$ para o qual $u \leq n_i$, então toma-se os fundos $x_1, ..., x_i$, e um novo montante $M = u + \sum_1^im_t$. O novos fundos então serão:

$x_i = (a_i, m_i = \frac{a_i * M}{\sum_1^ia_t}, v_i = \frac{M}{\sum_1^ia_t})$

Os fundos $x_1, ..., x_i$ equalizados são unidos aos fundos $x_{i+1}, ..., x_k$ não equalizados. Caso $u > n_i, \forall i$ todos os fundo participam dessa equalização

