# language: pt
Funcionalidade: Pagamento de Encomenda via MB Way
  Como cliente da loja online em Portugal
  Quero efetuar o pagamento da minha encomenda através de MB Way
  Para que o pagamento seja processado de forma rápida, segura e sem cartão de crédito

  Contexto:
    Dado que o cliente possui itens válidos no carrinho no valor total de 45.00 EUR
    E o cliente está autenticado e na etapa de "Pagamento" no checkout

  @smoke @happy_path
  Cenário: Pagamento aprovado com sucesso dentro do prazo limite
    Quando o cliente seleciona o método de pagamento "MB Way"
    E insere o número de telemóvel "912345678"
    E clica no botão "Confirmar Pagamento"
    Então o sistema deve enviar a solicitação para o gateway MB Way
    E a interface deve exibir a mensagem "Aguardando confirmação no seu telemóvel (4 minutos restantes)"
    Quando o cliente autoriza a notificação na aplicação MB Way
    Então o sistema deve receber a notificação de confirmação (Webhook Callback)
    E a encomenda deve ser atualizada para o estado "PAGO"
    E o cliente deve ser redirecionado para a página de confirmação de encomenda

  @negativo @timeout
  Cenário: Pagamento cancelado por expiração de tempo limite (Timeout de 4 minutos)
    Quando o cliente seleciona o método de pagamento "MB Way"
    E insere o número de telemóvel "912345678"
    E clica no botão "Confirmar Pagamento"
    Mas o cliente não autoriza a transação dentro da janela de 4 minutos
    Então o gateway deve retornar o estado "EXPIRED"
    E a encomenda deve ser atualizada para o estado "CANCELADO_TIMEOUT"
    E a interface deve exibir o alerta "Tempo limite para confirmação expirado. Os seus artigos continuam no carrinho."

  @negativo @validacao_formulario
  Esquema do Cenário: Validação de formato de número de telemóvel inválido
    Quando o cliente seleciona o método de pagamento "MB Way"
    E insere o número de telemóvel "<numero_invalido>"
    E clica no botão "Confirmar Pagamento"
    Então o sistema deve bloquear o envio da requisição
    E exibir a mensagem de erro "<mensagem_erro>"

    Exemplos:
      | numero_invalido | mensagem_erro                                                    |
      | 123456          | O número de telemóvel deve conter exatamente 9 dígitos           |
      | 212345678       | O número deve começar por 91, 92, 93 ou 96 (operadoras móveis)  |
      | 912abc789       | O número de telemóvel deve conter apenas algarismos              |
      |                 | O preenchimento do número de telemóvel é obrigatório             |

  @negativo @recusa_utilizador
  Cenário: Pagamento rejeitado manualmente pelo utilizador na app
    Quando o cliente seleciona o método de pagamento "MB Way"
    E insere o número de telemóvel "912345678"
    E clica no botão "Confirmar Pagamento"
    E o cliente rejeita a cobrança na aplicação MB Way
    Então o sistema deve receber o status "REJECTED"
    E a encomenda deve ser atualizada para o estado "CANCELADO_RECUSADO"
    E a interface deve permitir escolher outro método de pagamento imediatamente
