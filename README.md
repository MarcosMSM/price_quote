## Introdução:




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

![image](https://user-images.githubusercontent.com/20050770/117561468-8a1cd000-b06d-11eb-85cf-ebea65c61041.png)


**Arquitetura:**

**A arquitetura proposta é contém 4 produtos do GCP:** *Cloud Storage, Cloud
Dataprep, Big Query e Data Studio*

![image](https://user-images.githubusercontent.com/20050770/117561471-93a63800-b06d-11eb-9ba6-e19201616fa4.png)


1.  Arquivos origens são carregados no Cloud Storage no bucket raw zone

2.  No Cloud Dataprep é feito ETL onde são aplicados os tratamentos necessários
    e os dados são gravados no bucket trusted zone

3.  No BigQuery foi criado o modelo dimensional e gravado no bucket refined zone

4.  No Data Studio foram criados os relatórios lendo bucket Refined.

5.  Processo é executado via 3 Data Flows que estão schedulados a cada 20min

**Cloud Data prep:**

![image](https://user-images.githubusercontent.com/20050770/117561480-9b65dc80-b06d-11eb-888b-16055b692907.png)


-   **flow-material-bill**

![image](https://user-images.githubusercontent.com/20050770/117561487-a587db00-b06d-11eb-893b-4ada469207e5.png)


**Tratamentos:**

-   Faz unpivot transformando as colunas de componentes e quantidades em linhas;

-   Conversão dos data types;

-   Limpa os valores N/A;

-   Agrupamento por tube_assembly_id, component_id e sumarização da quantidade
    (quantity), para eliminar duplicidade.

![image](https://user-images.githubusercontent.com/20050770/117561492-af114300-b06d-11eb-9e3b-89c26660b2ec.png)


-   *flow-price-quote*

![image](https://user-images.githubusercontent.com/20050770/117561497-b7697e00-b06d-11eb-861f-e29654278bd2.png)


**Tratamentos:**

-   Conversão de data types

-   *flow-component*

![image](https://user-images.githubusercontent.com/20050770/117561505-c05a4f80-b06d-11eb-933a-5fb2075640fb.png)


**Tratamentos:**

-   Conversão de data types

-   Remoção de possíveis registros duplicados

-   Tratamento dos valores 9999 e NA para nulo

![image](https://user-images.githubusercontent.com/20050770/117561510-cbad7b00-b06d-11eb-836a-dade27b118a1.png)


**Bigquery**

![image](https://user-images.githubusercontent.com/20050770/117561518-d536e300-b06d-11eb-80b5-df8064857057.png)


**Data Studio:**

![image](https://user-images.githubusercontent.com/20050770/117561520-dff17800-b06d-11eb-983e-365f87c95426.png)
![image](https://user-images.githubusercontent.com/20050770/117561524-e4b62c00-b06d-11eb-9d1e-84060fd0fe2e.png)
![image](https://user-images.githubusercontent.com/20050770/117561526-e97ae000-b06d-11eb-9c74-371454aaca61.png)
![image](https://user-images.githubusercontent.com/20050770/117561531-f0095780-b06d-11eb-80be-14b850844c06.png)

