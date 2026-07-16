# Casos de Teste – Checkout

| ID | Caso de Teste | Passos | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| CT-005 | Checkout com sucesso | 1. Adicionar item ao carrinho <br> 2. Clicar no ícone do carrinho <br> 3. Clicar em "Checkout" <br> 4. Preencher "First Name", "Last Name" e "Zip/Postal Code" <br> 5. Clicar em "Continue" <br> 6. Clicar em "Finish" | Página exibindo a mensagem "Thank you for your order!" |
| CT-006 | Checkout com dados em branco | 1. Ir para o carrinho e clicar em "Checkout" <br> 2. Deixar os campos em branco <br> 3. Clicar em "Continue" | Mensagem de erro "Error: First Name is required" |
| CT-007 | Checkout apenas com o primeiro nome | 1. Preencher apenas "First Name" no checkout <br> 2. Clicar em "Continue" | Mensagem de erro "Error: Last Name is required" |
| CT-008 | Cálculo correto do valor total | 1. Adicionar dois itens ao carrinho <br> 2. Prosseguir até a página de revisão (Overview) <br> 3. Verificar a soma do Item Total com a Tax | O "Total" deve ser exatamente a soma dos itens + Taxa |
