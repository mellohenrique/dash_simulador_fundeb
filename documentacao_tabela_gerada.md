# Tabela Gerada

> As siglas usadas são explicadas na página documentação.

A tabela gerada pela simulação conta com as seguintes colunas:

* ibge: Código IBGE do ente federado;
* uf: Unidade da Federação (Estado) do Ente Federado;
* alunos_vaaf: Números de alunos do ente federado considerando os pesos da etapa VAAF;
* alunos_vaat: Números de alunos do ente federado considerando os pesos da etapa VAAT;
* nome: Nome do ente federado, se é o estado se dá o nome de "GOVERNO do ESTADO";
* recursos_vaaf: Total de recursos do ente considerados para a etapa VAAF (considera-se antes da divisão nos fundos estaduais);
* nf: Nível fiscal do ente federado (variável em construção);
* nse: Nível socioeconômico do ente federado;
* recursos_vaat: Total de recursos do ente considerados para a etapa VAAT;
* peso_vaar: Percentual da complementação VAAR que o ente federado recebe;
* inabilitados_vaat: Variável lógica que diz se o ente federado é habilitado a receber a complementação VAAT;
* recursos_vaaf_final: Total de recursos que o ente recebe (fundos estaduais e complementação da União) durante a etapa VAAF;
* vaaf_final: VAAF após a etapa VAAF (distribuição dos fundos estaduais e complementação da União);
* vaat_pre: VAAT do ente anterior a qualquer complementação, considerando apenas os recursos contabilizados na etapa VAAT;
* recursos_vaat_final: Total de recursos da etapa VAAT do ente após a complementação VAAT, considerando apenas os recursos contabilizados na etapa VAAT, desconsidera-se a VAAF;
* vaat_final: VAAT do ente após a complementação VAAT, considerando apenas os recursos contabilizados na etapa VAAT, desconsidera-se a VAAF;
* recursos_vaar: Complementação que o ente recebe na etapa VAAR;     
* complemento_vaaf: Valor da complementação da União na etapa VAAF para o ente federado;   
* complemento_vaat: Valor da complementação da União na etapa VAAF para o ente federado; 
* complemento_uniao: Valor total da complementação da União para o ente federado; 
* recursos_fundeb: Recursos finais que o ente federado recebe do Fundeb (fundos estaduais mais complementação da União);