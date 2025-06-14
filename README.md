# Bankits - Gerenciador de Conta Corrente

## Sumário

- [Tecnologias](#tecnologias)
- [Gems](#gems)
- [Configuração](#configuração)
- [Testes](#testes)
- [Funcionalidades](#funcionalidades)
  - [Cadastro de conta](#cadastro-de-conta)
  - [Login](#login)
  - [Visualização de extrato e saldo](#visualização-de-extrato-e-saldo)
  - [Depósito](#depósito)
  - [Saque](#saque)
  - [Transferência](#transferência)
  - [Agendamento gerencial](#visita-gerencial)
  - [Taxa de juros](#taxa-de-juros)
  
## Tecnologias

![Ruby on Rails](https://img.shields.io/badge/Ruby%20on%20Rails-D30001.svg?style=for-the-badge&logo=Ruby-on-Rails&logoColor=white)
![Bootstrap](https://img.shields.io/badge/Bootstrap-7952B3.svg?style=for-the-badge&logo=Bootstrap&logoColor=white)
![SQLITE](https://img.shields.io/badge/SQLite-003B57.svg?style=for-the-badge&logo=SQLite&logoColor=white)

## Gems

- [bootstrap](https://github.com/twbs/bootstrap-rubygem)
- [capybara](https://github.com/teamcapybara/capybara)
- [devise](https://github.com/heartcombo/devise)
- [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails)
- [faker](https://github.com/faker-ruby/faker)
- [rubocop-rails-omakase](https://github.com/rubocop/rubocop-rails)
- [rspec-rails](https://github.com/rspec/rspec-rails)
- [simplecov](https://github.com/simplecov-ruby/simplecov)
- [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
- [sqlite3](https://github.com/sparklemotion/sqlite3-ruby)
- [stimulus-rails](https://github.com/hotwired/stimulus-rails)
- [turbo-rails](https://github.com/hotwired/turbo-rails)



## Configuração

### Para baixar o projeto

```
git clone git@github.com:PedroD98/Bankits.git
cd bankits
```
### Comandos iniciais
Para instalar as depêndencias do projeto e configurar o banco de dados

```
bundle install
rails db:migrate
```

### Seeds🌱
Caso queria popular o banco de dados, execute:

```
rails db:seed
```
Contas para o acesso:
- Usuário regular
  - Número da conta: 12345
  - Senha: 1111
- Usuário Vip
  - Número da conta: 54321
  - Senha: 1111

## Subindo o servidor
Para colocar a aplicação no ar:
```sh
bin/dev
```

## Testes

Para rodar os testes, execute:

```sh
rspec
```
Para gerar o relatório de cobertura de testes, abra o arquivo coverage/index.html no seu navegador após rodar o comando.

<br>
<br>

# Funcionalidades

## Cadastro de conta
É possível cadastrar uma conta acessando a tela inicial e clicando em "Inscrever-se", localizado na navbar. Após enviar o formulário com dados válidos, sua conta estará pronta para ser utilizada.

- Validações:
   - Número da conta: deve conter somente 5 digitos
   - Senha: deve conter somente 4 digitos

***

## Login
Para acessar sua conta, basta preencher o formulário na tela de login com suas credênciais.


***


## Visualização de extrato e saldo

Após realizar o login, o usuário será redirecionado para a tela principal da aplicação. Um dashboard exibirá todas as informações necessárias. Os formulários para depósito, saque e transferência também estarão presentes na tela, assim como uma lista detalhando todas as transações do usuário.

Caso não tenha feito uma transação, o usuário verá uma mensagem comunicando que o extrato está vazio.

Um usuário VIP terá um ícone único na navbar, para facilitar a diferenciação entre tipos de usuários.

***

## Depósito
Inserindo um valor válido e clicando em "Depositar", uma transação será feita para a conta do usuário, e seu saldo será atualizado.
- Validações:
   - O valor inserido no campo não pode ser negativo.

***

## Saque

Inserindo um valor válido e clicando em "Depositar", uma transação será feita para a conta do usuário, e seu saldo será atualizado.
- Validações:
   - O valor inserido no campo não pode ser negativo;
   - Para usuários regulares, não é possível sacar um valor maior do que o saldo atual;
   - Usuários VIP podem sacar além do valor do saldo em conta, mas uma taxa de juros será aplicada a cada minuto até que o saldo seja regularizado.
 
***


## Transferência

Enviar o formulário de transferência com valores válidos gerará 3 transações, são elas:
- Transferência enviada: o valor será debitado da conta do usuário remetente;
- Taxa de transferência: será cobrado uma taxa para a transferência, que também será debitada da conta do remetente:
  - Para usuários regulares, a taxa sempre será de R$ 8,00;
  - Para usuários vip, a taxa será 0,8% em cima do valor da transferência.
- Transferência recebida: o destinatário receberá o valor transferido.

Algumas validações precisam ser seguidas:
- O valor máximo de transferência para usuários regulares é de R$ 1000,00 (sem limites para vip)
- O valor inserido no campo deve ser positivo
- O número da conta inserido no campo deve refletir uma conta existente;
- Não é possível transferir para a própria conta.

***


## Visita gerencial
Apenas usuários VIP conseguiram ver o botão de "Agendamento Gerencial", localizado na navbar. Ao clicar no botão, uma janela modal aparecerá pedindo para que o usuário insira a data para o agendamento da visita.

Ao concluir o processo, um valor de R$ 50,00 será debitado da conta do usuário.

- Validações:
  - Não é possível enviar uma data passada.

***

## Taxa de juros
Quando um usuário VIP está negativado, a cor do saldo fica em vermelho vivo, e uma mensagem de alerta informando sobre a taxa de juros é exibida no topo da página.

A taxa será de 0,1% em cima do valor atual do saldo, e acontecerá a cada minuto até que o usuário regularize seu saldo, seja com trasnferência recebida ou depósito.

