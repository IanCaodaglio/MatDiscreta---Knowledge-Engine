# Knowledge Engine — Fórmula 1 2024

Projeto da disciplina **Lógica e Matemática Discreta 2026/1** — Insper.

Construção de uma base de conhecimento em **Prolog** a partir de dados reais da temporada de Fórmula 1 de 2024, com consultas em Lógica de Primeira Ordem.

---

## Dataset

**Fonte:** [Formula 1 World Championship (Kaggle)](https://www.kaggle.com/datasets/rohanrao/formula-1-world-championship-1950-2020)

**Tabela-fonte:** `results.csv` — resultados individuais de cada piloto em cada corrida.

Os arquivos auxiliares `drivers.csv`, `races.csv` e `constructors.csv` são usados apenas no ETL para traduzir IDs numéricos em nomes legíveis. A base de conhecimento final é derivada de uma única tabela.

**Campos selecionados (8):**

| Campo | Tipo | Descrição |
|---|---|---|
| piloto | Qualitativo | Nome do piloto (ex: `max_verstappen`) |
| equipe | Qualitativo | Nome da equipe (ex: `red_bull`) |
| corrida | Qualitativo | Nome do GP (ex: `bahrain_grand_prix`) |
| ano | Quantitativo | Ano da corrida |
| grid | Quantitativo | Posição de largada |
| posicao | Quantitativo | Posição de chegada (`dnf` se não terminou) |
| pontos | Quantitativo | Pontos obtidos na corrida |
| voltas | Quantitativo | Número de voltas completadas |

**Total de predicados gerados: 479** (24 corridas × ~20 pilotos).

---

## Estrutura do Repositório

```
MatDiscreta---Knowledge-Engine/
├── data/
│   ├── results.csv         # Tabela-fonte principal
│   ├── drivers.csv         # Auxiliar: nomes dos pilotos
│   ├── races.csv           # Auxiliar: nomes e datas das corridas
│   └── constructors.csv    # Auxiliar: nomes das equipes
├── etl.py                  # Script Python que gera a base Prolog
├── f1_2024.pl              # Base de conhecimento gerada
├── queries.pl              # Perguntas em Prolog
└── README.md
```

---

## Como Rodar

### 1. Gerar a base de conhecimento

Requisito: Python 3 instalado.

```bash
python etl.py
```

Isso lê os CSVs da pasta `data/` e gera o arquivo `f1_2024.pl` com os 479 predicados.

### 2. Executar as queries

Acesse [https://swish.swi-prolog.org/](https://swish.swi-prolog.org/), crie um novo notebook e:

- Cole o conteúdo de `f1_2024.pl` na área **Program**
- Cole o conteúdo de `queries.pl` também na área **Program**
- Execute as queries abaixo na área **Query**

---

## Perguntas

### Pergunta 1 — Classificação final do campeonato de pilotos
> Qual foi a classificação final do campeonato de pilotos de 2024, ordenada por pontos?

Agrega os pontos de cada piloto em todas as corridas usando `findall` e `sum_list`, e ordena com `setof` + `reverse`.

```prolog
?- classificacao_pilotos(Tabela).
```

**Resultado esperado:**
```
Tabela = [399-max_verstappen, 344-norris, 327-leclerc, 265-piastri, 262-sainz, ...]
```

---

### Pergunta 2 — Melhor recuperação de grid
> Qual piloto mais recuperou posições em uma única corrida (largou mais atrás e chegou mais à frente)?

Compara os campos `grid` e `posicao` de cada resultado, calcula a diferença e filtra o máximo usando negação (`\+`).

```prolog
?- melhor_recuperacao(Piloto, Corrida, Grid, Posicao, Recuperacao).
```

**Resultado esperado:**
```
Piloto = max_verstappen, Corrida = sao_paulo_grand_prix,
Grid = 17, Posicao = 1, Recuperacao = 16
```

---

### Pergunta 3 — Classificação do campeonato de construtores
> Qual equipe somou mais pontos ao longo da temporada de 2024?

Agrega os pontos de todos os pilotos de cada equipe em todas as corridas, e ordena com `setof` + `reverse`.

```prolog
?- classificacao_equipes(Tabela).
```

**Resultado esperado:**
```
Tabela = [609-mclaren, 595-ferrari, 537-red_bull, 433-mercedes, ...]
```