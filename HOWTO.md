# Terraform

Todos os arquivos mencionados abaixo se encontram na pasta do terrafrom

Após a criação de sua conta na Azure siga os passos encotnrados na pasta [STATE](/state/README.md)

## Remote backend

O método de autenticação é baseado em RBCA então siga os passos para configuração de acesso 
de uma aplicação com permissões de edição na subscription em questão.
Após a criação dessa aplicação set as variáveis de ambiente (também indicado no arquivo mencionado acima).

Concluído esses dois passos utilize o script mencionado na pasta configure um arquivo de **credentails** para ser utilizado na autenticação ou ainda crie apenas as variáveis de ambiente.


```bash
export ARM_TENANT_ID=6******3
export ARM_SUBSCRIPTION_ID=b******c
export ARM_CLIENT_ID=9******f5
export ARM_CLIENT_SECRET=l******o
```

## Criação dos workspaces
### Dev

`make workspace ENV=dev && make apply`

Para que o comando acima seja aceito configure o valor default das variaváis do terraform no arquivo [variables.tf](/terraform/variables.tf)
- docker_username
- docker_passwd



### Prd
`make workspace ENV=prd && make apply`

# Applicação em docker

Para execussão local dos aplicativos podem ser utizados o arquivo [dockerfile ](/Dockerfile) localizado na pasta raíz para setar o ambiente de dev ou de produção:

## Dev
`docker build -t <image>:dev --target dev . && docker run -it --rm -p 5000:5000 <image>:dev`

## Prd
`docker build -t <image>:prd --target prd . && docker run -it --rm -p 5050:5000 <image>:prd`


# Aplicação

Para a identificação do ambiente foi disponibilizado apenas um endpoint de healthcheck para cada ambiente, assim sendo:

```bash
curl --fail http://localhost:5000/healthDev
curl --fail http://localhost:5000/healthPrd
### Ambiente de dev OK ###
GET /healthDev
Status code: 200
Response: Healthy

GET /healthPrd
Status code: 404
Response: 

curl --fail http://localhost:5050/healthDev
curl --fail http://localhost:5050/healthPrd
### Ambiente de prd OK ###
GET /healthDev
Status code: 404
Response: 

GET /healthPrd
Status code: 200
Response: Healthy

```

# Azure

Foi utlizado o app service por seu rápido setup de deploy e ao mesmo tempo flexibilidade, baixo custo para teste em curto prazo com instancia do tipo B e S1.

Não foi considerado nenhuma politica de Scale out devido a natureza do teste, nem tão pouco 
scale up devido a natureza minima do aplicativo.

A diferença entre os ambientes foi considerado apenas como demonstrativo não tendo qualquer justificativa técnica, uma vez pela natureza da aplicação ser muito pequena e de baixo custo computacional, ambas poderiam estar dispostas em uma mesma versão do app service plan.

O ambiente pode ser verificado nas urls:

### Dev
https://app-nibodevops-niboapi-dev.azurewebsites.net/

```bash
curl --fail https://app-nibodevops-niboapi-dev.azurewebsites.net//healthDev
curl --fail https://app-nibodevops-niboapi-dev.azurewebsites.net//healthPrd
### Ambiente de dev OK ###
GET /healthDev
Status code: 200
Response: Healthy

GET /healthPrd
Status code: 404
Response: 

```

### Prd
https://app-nibodevops-niboapi-prd.azurewebsites.net/

``bash

curl --fail https://app-nibodevops-niboapi-prd.azurewebsites.net//healthDev
curl --fail https://app-nibodevops-niboapi-prd.azurewebsites.net//healthPrd
### Ambiente de prd OK ###
GET /healthDev
Status code: 404
Response: 

GET /healthPrd
Status code: 200
Response: Healthy
```