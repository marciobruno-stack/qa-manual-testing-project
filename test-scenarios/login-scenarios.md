# Cenários de Teste – Login

## Cenário 1: Login bem-sucedido
**Dado** que o usuário está na página de login
**Quando** insere credenciais válidas
**Então** deve ser autenticado e redirecionado ao dashboard

## Cenário 2: Login com senha incorreta
**Dado** que o usuário está na página de login
**Quando** insere senha inválida
**Então** deve ver mensagem de erro
