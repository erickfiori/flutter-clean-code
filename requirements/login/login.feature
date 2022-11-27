Feature: Login
    Como um cliente
    I Quero poder acessar minha com e me manter logado
    Para que eu possa ver e responder enquetes de forma rápida

  Scenario: Credenciais Válidas
    Given que o cliente informou credenciais válidas
    When solicitar para fazer login
    Then o sistema deve enviar o usuário para a tela de pesquisas
    And manter o usuário conectado
  
  Scenario: Credenciais Inválidas
    Given que o cliente informou credenciais Inválidas
    When solicitar para fazer login
    Then o sistema deve retornar uam mensagem de erro
  
  
    