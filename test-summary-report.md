# 📊 Relatório de Fechamento de Testes (Test Summary Report)

**Projeto:** E-commerce Sauce Demo
**Data da Execução:** Setembro de 2026
**Responsável (QA):** Márcio Bruno Santos
**Ambiente:** Google Chrome v116 (Windows) / Produção (saucedemo.com)

---

## 1. Resumo Executivo
Os testes manuais funcionais foram concluídos na plataforma Sauce Demo com foco nas jornadas críticas do usuário: **Login** e **Checkout**. 
O objetivo foi garantir a estabilidade das operações que impactam diretamente a receita do negócio.

No geral, a plataforma apresenta boa estabilidade no fluxo principal (Caminho Feliz), mas foram encontrados **defeitos críticos em fluxos de exceção e no motor de cálculo**, o que representa um alto risco financeiro para a empresa.

---

## 2. Métricas de Execução (Cobertura)

| Métrica | Quantidade |
| :--- | :---: |
| 📝 **Total de Casos de Teste Planejados** | 10 |
| ✅ **Testes Aprovados (Passed)** | 7 |
| ❌ **Testes Falhados (Failed)** | 3 |
| ⏸️ **Testes Bloqueados (Blocked)** | 0 |
| 🎯 **Taxa de Sucesso (Pass Rate)** | **70%** |

---

## 3. Resumo de Defeitos (Bugs)

Foram reportados **2 bugs** durante este ciclo de testes.

| ID do Bug | Título / Descrição | Severidade | Status | Link para o Report |
| :--- | :--- | :---: | :---: | :--- |
| **BUG-001** | Soma incorreta do valor "Total" na página de Checkout | **🔴 Crítica** | Aberto | [Ver Report](./bug-reports/bug-checkout-total.md) |
| **BUG-002** | Lentidão extrema / Timeout (Erro 500) ao logar como `glitch_user` | **🟠 Alta** | Aberto | [Ver Report](./bug-reports/bug-login-500.md) |

---

## 4. Análise de Risco e Qualidade

*   **Risco Funcional (Checkout):** A falha no cálculo do valor total (BUG-001) é um problema severo de arquitetura. O sistema cobra um valor superior à soma dos itens, o que gera problemas legais (lesão ao consumidor) e quebra de confiança.
*   **Risco de Performance (Login):** O tempo de resposta para usuários específicos está acima de 5 segundos, afetando negativamente a experiência do usuário (UX).

---

## 5. Recomendação Final (Go / No-Go)

🛑 **NO-GO (Não Recomendado para Produção).**

**Justificativa:** 
Apesar da taxa de aprovação ser de 70%, o impacto do **BUG-001 (Erro de cálculo matemático no Checkout)** fere a regra de negócio principal de qualquer e-commerce. A liberação para produção (Deploy) deve ser **bloqueada** até que a equipe de desenvolvimento corrija a falha no módulo de pagamentos. 

Recomenda-se um novo ciclo de **Testes de Regressão** no módulo de Checkout logo após a correção.
