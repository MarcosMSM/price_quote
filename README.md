## Introdução:




Objetivo do projeto é ler 3 arquivos csv, fazer tratamento necessário e criar um
relatório consumindo os dados inseridos.

**Dados origens:**

-   price_quote.csv

-   bill_of_materials.csv

-   comp_boss.csv

### Análise:

A solução adotada foi trabalhar o dado no conceito de data lake com 3 camadas:


**Raw Zone**
```
Os arquivos csv, em seu estado bruto, foram armazenados no bucket
dasa-raw-zone do Google Cloud Storage.
```

**Trusted Zone**
```
Posteriormente foi construído um pipeline com Google DataPrep, a fim de
padronizar, limpar e aplicar unpivot nos dados.

O output do pipeline entrega dados em 2 saídas: tabelas do BigQuery e no
bucket dasa-trusted-zone do Google Cloud Storage, em formato compactado.

No BigQuery é possível consultar a última versão dos dados (com excelente
desempenho), enquanto no bucket há o histórico completo, com um custo mais
acessível. Nesse cenário, uma aplicação de ML poderia consumir dados
```


**Refined Zone**
```
Para fornecer dados na zona dasa-refined-zone, foram criadas views
materializadas no BigQuery.

Adicionalmente, um modelo dimensional snowflake **garante que todos os
cadastros existentes nesse dataset estejam devidamente disponíveis nas
dimensões** de *component* e *material,*  o que permitirá agregar os dados
das fatos com um simples join, **sem a necessidade de aplicar agregações
como MAX**.

O Data Studio acessa os dados desta camada para criação do dashboard.
```

**Modelo Conceitual Refined Zone:**

### Modelo Conceitual Refined Zone:

![image](https://user-images.githubusercontent.com/20050770/117577400-050ed680-b0c0-11eb-9e54-6e775c2b377a.png)



### Arquitetura:

**A arquitetura proposta é contém 4 produtos do GCP:** 

![image](https://user-images.githubusercontent.com/20050770/117577321-b3fee280-b0bf-11eb-80e1-a4b5fd5255eb.png)


1.  Arquivos origens são carregados no Cloud Storage no bucket raw zone

2.  No Cloud Dataprep é feito ETL onde são aplicados os tratamentos necessários
    e os dados são gravados no bucket trusted zone

3.  Processo é executado via 3 Flows do DataPrep, que são atualizados a cada 20
    minutos.

4.  No BigQuery foi criado o modelo dimensional e gravado no bucket refined zone

5.  No Data Studio foram criados os relatórios lendo os dados da camada refined
    do Bigquery.
    
### 1 - Clould Storage:

![image](https://user-images.githubusercontent.com/20050770/117577625-eeb54a80-b0c0-11eb-89ed-dbdd1792a98d.png)

>   **Bucket:**

-   **dasa-raw-zone**

![image](https://user-images.githubusercontent.com/20050770/117577674-21f7d980-b0c1-11eb-8139-c184d388824c.png)

-   **dasa-trusted-zone**

![image](https://user-images.githubusercontent.com/20050770/117577685-2de39b80-b0c1-11eb-8122-95e27a3c8e14.png)


### 2 - Cloud Dataprep:

![image](https://user-images.githubusercontent.com/20050770/117577724-4fdd1e00-b0c1-11eb-9154-ccfb4a1a93f8.png)

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


### 3 - Bigquery

![image](https://user-images.githubusercontent.com/20050770/117561518-d536e300-b06d-11eb-80b5-df8064857057.png)


### 4 - Data Studio:

![image](https://user-images.githubusercontent.com/20050770/117577099-cc223200-b0be-11eb-929a-e1fae622a86b.png)
![image](https://user-images.githubusercontent.com/20050770/117577171-0be91980-b0bf-11eb-8cd5-6fb65030ad4c.png)
![image](https://user-images.githubusercontent.com/20050770/117577239-608c9480-b0bf-11eb-858d-4b7f2c248f54.png)

**Ao analisar o dashboard podemos concluir que:**

-   O ano com maior número de ordens foi 2013.

-   No consolidado o mês com maior número de ordens foi Maio.

-   A forma de cotação Bracket pricing corresponde a 87% das cotações.

-   Apenas 36% da meta foi atingida no consolidado dos anos.

### Possíveis melhorias:

-   Acrescentar o Google Cloud Composer para orquestração do fluxo do pipeline.

-   Criar um processo de validação e aviso, aos data owner dos dados, sobre os possíveis dados ausentes nos cadastros.

