**Introdução:**

Objetivo do projeto é ler 3 arquivos csv, fazer tratamento necessário e criar um
relatório consumindo os dados inseridos.

**Dados origens:**

-   price_quote.csv

-   bill_of_materials.csv

-   comp_boss.csv

**Análise:**

A solução adotada foi trabalhar o dado no conceito de data lake com 3 camadas:

| **Raw Zone**                                                                               | **Trusted Zone**                                                                                                                                                                                                  | **Refined Zone**                                                                                                                                                                                                                                                                |
|--------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| A tecnologia usada foi armazenar os arquivos .csv com dados brutos no Google Clould Store. | A tecnologia usada foi ler os arquivos csv do Google Cloud Store via Data Prep. Realizando a padronização dos dados e aplicando unpivot. Então os dados foram gravados em tabelas da camada trusted do Big Query. | Para a camada refined, foram criadas view materializadas utilizando o modelagem dimensonal snowflake, aplicando regras de agregação e preenchimento dos dados ausentes nas dimensões que estavam na fato. O Data Studio acessa os dados desta camada para criação do dashboard. |

**Modelo Conceitual Refined Zone:**

![](media/59dfc646ea941ad92a1045d9a748ea36.png)

2\. Diagrama ou Modelo dos dados (principalmente da trusted e refined) explicando
para essa última os motivos de separar component_id de material

3\. Uma explicação sobre a qualidade dos dados e o que foi feito na refined a fim
de mitigar e evidenciar o problema.

**Arquitetura da solução:**

**A arquitetura proposta contém 4 produtos do GCP:**

![](media/ec21dbb90126782497f6cfc1aa9313fb.png)

1.  Arquivos origens são carregados no Cloud Storage no bucket raw zone

2.  No Cloud Dataprep é feito ETL onde são aplicados os tratamentos necessários
    e os dados são gravados no bucket trusted zone

3.  Processo é executado via 3 Flows do DataPrep, que são atualizados a cada 20
    minutos.

4.  No BigQuery foi criado o modelo dimensional e gravado no bucket refined zone

5.  No Data Studio foram criados os relatórios lendo os dados da camada refined
    do Bigquery.

**1 - Clould Storage:**

**![](media/0e3be8d84f0cef9e2dd14e91300ca665.png)**

>   **Bucket:**

## dasa-raw-zone

>   ![](media/bb634bb77f125ec3dbe6bb05af715870.png)

## dasa-trusted-zone

>   ![](media/283a25bd6895fa101cad6ab2e4160dd3.png)

## 

**2 - Cloud Dataprep:**

![](media/7eac97ed818279451b5c8450e2d58f8a.png)

-   **flow-material-bill**

![](media/82f4b3878da04b6d08152e337b07890b.png)

**Tratamentos:**

-   Faz unpivot transformando as colunas de componentes e quantidades em linhas;

-   Conversão dos data types;

-   Limpa os valores N/A;

-   Agrupamento por tube_assembly_id, component_id e sumarização da quantidade
    (quantity), para eliminar duplicidade.

![](media/771ff9702ee5698db791c7d76e26d897.png)

-   **flow-price-quote**

![](media/9064721caeb94c6cdc33fec85c50bf77.png)

**Tratamentos:**

-   Conversão de data types

-   **flow-component**

**![](media/06584d53aad6d21b2e39ac843528241b.png)**

**Tratamentos:**

-   Conversão de data types

-   Remoção de possíveis registros duplicados

-   Tratamento dos valores 9999 e NA para nulo

![](media/751e962565961df4d9efa00808cae619.png)

**3 - Bigquery**

**![](media/f65a7acac4335b59c5ac3be2566a604b.png)**

**4 - Data Studio:**

**![](media/367cba296ca9d72f6a55049773de54a9.png)**

**![](media/4be0c82c99f14242fbd5d184bbb633b3.png)**

**![](media/6f885c21544d2d23e9779b2b24ad2d2d.png)**

![](media/acd40ba0922b104134fa28baf64670d7.png)

**Ao analisar o dashboard podemos concluir que:**

-   O ano com maior número de ordens foi 2013.

-   No consolidado o mês com maior número de ordens foi Maio.

-   A forma de cotação Bracket pricing corresponde a 87% das cotações.

-   Apenas 36% da meta foi atingida no consolidado dos anos.

**Possíveis melhorias:**

-   Acrescentar o Google Cloud Composer para orquestração do fluxo do pipeline.

-   Criar um processo de validação e aviso dos possíveis dados ausentes dos
    cadastros aos data owner dos dados.
