**Introdução:**

Objetivo do projeto é ler 3 arquivos csv, fazer tratamento necessário e criar um
relatório consumindo os dados inseridos.

**Dados origens:**

-   price_quote.csv

-   bill_of_materials.csv

-   comp_boss.csv

**Análise:**

A solução adotada foi trabalhar o dado no conceito de data lake com 3 camadas:

**Raw Zone** - Dados brutos iguais a origem csv

**Trusted Zone** - Tabelas tratadas, unpivot, padronização N/A

**Refined Zone** - Views materializadas - Modelo dimensional Snowflake

**Modelo Conceitual:**

![](media/59dfc646ea941ad92a1045d9a748ea36.png)

**Arquitetura:**

**A arquitetura proposta é contém 4 produtos do GCP:** *Cloud Storage, Cloud
Dataprep, Big Query e Data Studio*

![](media/ec21dbb90126782497f6cfc1aa9313fb.png)

1.  Arquivos origens são carregados no Cloud Storage no bucket raw zone

2.  No Cloud Dataprep é feito ETL onde são aplicados os tratamentos necessários
    e os dados são gravados no bucket trusted zone

3.  No BigQuery foi criado o modelo dimensional e gravado no bucket refined zone

4.  No Data Studio foram criados os relatórios lendo bucket Refined.

5.  Processo é executado via 3 Data Flows que estão schedulados a cada 20min

**Cloud Data prep:**

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

-   *flow-price-quote*

![](media/9064721caeb94c6cdc33fec85c50bf77.png)

**Tratamentos:**

-   Conversão de data types

-   *flow-component*

**![](media/06584d53aad6d21b2e39ac843528241b.png)**

**Tratamentos:**

-   Conversão de data types

-   Remoção de possíveis registros duplicados

-   Tratamento dos valores 9999 e NA para nulo

![](media/751e962565961df4d9efa00808cae619.png)

**Bigquery**

**![](media/f65a7acac4335b59c5ac3be2566a604b.png)**

**Data Studio:**

**![](media/367cba296ca9d72f6a55049773de54a9.png)**

**![](media/dc7d2d437d5a8e5c2c0faaa82613c27b.png)**

**![](media/60b44115cf5dff654d441c22f4a08495.png)**

![](media/969984c35f2bba1bc0f9b4205561a8e1.png)
