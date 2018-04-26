# Teste NewWay
App iOS de teste para a vaga de *Desenvolvedor iOS Pleno*,  na empresa NewWay.

O app apresenta uma listagem com os repositórios Swift mais populares do GitHub, ordenados pela quantidade de estrelas.

Preview:

![Preview (retrato)](https://i.imgur.com/mZSz0CG.png)
![Preview (paisagem)](https://i.imgur.com/q9uzPnz.png)

## Características
 - Dispositivos: iPhone, iPad;
 - iOS: 10.0.0+;
 - Orientações: retrato e paisagem;
 - Dependências/pods:
	 - Alamofire ~> 4.7;
	 - AlamofireNetworkActivityIndicator ~> 2.2;
	 - SDWebImage ~> 4.0;
	 - EVReflection ~> 5.5;
	 - EVReflection/Alamofire ~> 5.5;
	 - MBProgressHUD ~> 1.1.

## Composição principal
### Data Transfer Objects
O grupo *DTO* contém os DTOs do projeto, i.e., mapeamento dos objetos JSON envolvidos nas requisições para Swift. 

São eles:

 - `BaseDTO`: visa encapsular alguns detalhes comuns a todos os DTOs;
 - `QueryableEntity`: protocolo para DTOs de objetos que podem ser consultados (repositórios, no caso);
 - `Response`: representa a resposta de uma requisição ao serviço. Contém os campos mais básicos;
 - `ResponseError`: representa um erro do serviço (pode ser retornado na resposta, ou criado mais tarde);
 - `ErrorCode`: enum com os "códigos" de erro que podem ocorrer durante o consumo de um dos serviços;
 - `Repository`: DTO referente a um repositório retornado pelo serviço;
 - `RepositoriesQueryResponse`: representa a resposta de uma requisição ao serviço de consulta de repositórios. Idealmente, seria genérico, todavia testes iniciais mostraram que a desserialização não funciona com tipos genéricos (problema interno do *EVReflection*, provavelmente);
 - `RepositoryOwner`: dono de um dos repositórios.

### Service Clients
O grupo *ServiceClients* contém tipos relativos ao consumo dos serviços utilizados pelo app, visando abstraí-los.

Inclui:

 - `ServiceClient`: protocolo definindo métodos para consumir os serviços;
 - `Cancellable`: protocolo para envelopar requisições HTTP feitas por implementações de `ServiceClient` e abstrair o cancelamento delas;
 - `AlamofireServiceClient`: implementação de `ServiceClient` onde os serviços são consumidos utilizando a lib *Alamofire*;
 - `ServiceClientFactory`: simple factory para fornecer instâncias de `ServiceClient` a quem precisar. No caso, é retornada instância de `AlamofireServiceClient`; como essa classe é *stateless*, retorna sempre a mesma instância.

### Controller
O grupo *Controller* contém o único controller do app, `ProjectsController`, responsável por controlar a consulta, acesso e carregamentos adicionais de repositórios. 

Idealmente, `ProjectsController`seria genérico, permitindo consulta de qualquer `QueryableEntity`, todavia, o escopo limitado do app e as limitações de generics do Swift desencorajam o empreendimento do esforço necessário para tanto.

### View Controller e View
O grupo *ViewController* contém o único (table) view controller do app, `PopularProjectsTableViewController`, que exibe a lista de repositórios do GitHub. O `title` desse view controller é definido via código, a fim de facilitar o esforço de localização, pois o app (por requisito) usa StoryBoard.

O código da célula exibida na listagem, `ProjectTableViewCell`, está no grupo *View*, enquanto seu layout visual está definido como protótipo no StoryBoard *Main*. 

`ProjectTableViewCell` não é projetada para ser usada sem o protótipo visual (migrar para XIB, caso necessário).

### TODO

 - Testes.

-- Luiz Soares dos Santos Baglie
luizssb.biz *at* gmail *dot* com 