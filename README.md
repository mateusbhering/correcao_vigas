# correcao_vigas

Rotina AutoLISP para padronizacao de objetos em projetos estruturais de vigas no AutoCAD. Desenvolvida em ambiente profissional para adequar elementos gerados por softwares de detalhamento (CAD/TQS) ao padrao de entrega do escritorio, eliminando etapas manuais repetitivas no fluxo de producao de pranchas estruturais.

## Impacto

Reduziu em 50% o tempo de padronizacao de pranchas de vigas, automatizando correcoes que antes eram feitas manualmente objeto a objeto.

## Funcionalidades

- **Deleta layers desnecessarios** — remove automaticamente `ELE_REF_REF_NOME` e `ELE_COT_TEXTOS_ESTRIBOS`
- **Move cotas de armadura** — desloca elementos do layer `ELE_COT_COT_ARM` 10 unidades para baixo
- **Corrige altura de texto em cotas** — normaliza dimensoes no layer `ELE_COT_COMPRIMENTO_PROJETADO` de `10.0` para `0.01`
- **Padroniza textos (TEXT e MTEXT)**
  - Aplica estilo de fonte `ROMANS` (`romans.shx`)
  - Define fator de largura em `0.95`
  - Ajusta alturas: `13.333 → 12.5` e `16.667 → 18.0`
  - Formata strings de armadura removendo parenteses e padronizando separadores

## Requisitos

- AutoCAD com suporte a AutoLISP e Visual LISP (ActiveX)
- Arquivo de fonte `romans.shx` disponivel no caminho de suporte do AutoCAD

## Como usar

1. Carregue o arquivo no AutoCAD via `APPLOAD` ou arrastando o `.lsp` para a area de trabalho
2. No prompt de comando, execute:
   ```
   MAQVIGAS
   ```
3. Selecione os objetos que deseja processar e pressione `Enter`
4. A rotina sera aplicada e exibira confirmacao no prompt

## Transformacoes de texto

A rotina aplica as seguintes substituicoes nas strings de texto:

| De | Para | Descricao |
|---|---|---|
| `x(` | `x` | Remove parentese apos x |
| `) ` | ` ` | Remove parentese de fechamento seguido de espaco |
| `(` ou `)` | `` | Remove parenteses restantes |
| `eN` | `N` | Corrige prefixo de bitola |
| `c=` | ` c=` | Adiciona espaco antes do espacamento de estribo |

## Estrutura

```
correcao_vigas/
└── maqvigas.lsp       ; comando principal (c:MAQVIGAS)
```
