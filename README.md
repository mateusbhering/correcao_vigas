# correcao_vigas

Rotina AutoLISP para padronizacao de objetos em projetos estruturais de vigas no AutoCAD. Desenvolvida em ambiente profissional para adequar elementos gerados por softwares de detalhamento (CAD/TQS) ao padrao de entrega do escritorio, eliminando etapas manuais repetitivas no fluxo de producao de pranchas estruturais.

## Impacto

Reduziu em 50% o tempo de padronizacao de pranchas de vigas, automatizando correcoes que antes eram feitas manualmente objeto a objeto.

## Funcionalidades

- **Deleta layers desnecessarios** — remove automaticamente `ELE_REF_REF_NOME` e `ELE_COT_TEXTOS_ESTRIBOS`
- **Move e processa cotas de armadura** — elementos do layer `ELE_COT_COT_ARM` sao deslocados 10 unidades para baixo; cotas (DIMENSION) tem seu valor arredondado para o multiplo de 5 mais proximo e o texto descido 10 unidades adicionais
- **Corrige altura de texto em cotas** — normaliza dimensoes no layer `ELE_COT_COMPRIMENTO_PROJETADO` de `10.0` para `0.01`
- **Padroniza textos (TEXT e MTEXT)**
  - Aplica estilo de fonte `ROMANS` (`romans.shx`)
  - Define fator de largura em `0.95`
  - Ajusta alturas: `13.333 → 12.5` e `16.667 → 18.0`
  - Formata strings de armadura removendo parenteses e padronizando separadores
  - Normaliza texto `"Ver esperas no detalhamento de pilares ou vista de muros"` para `"Ver esperas no detalhamento de pilares"`, com altura `12.5` e cor cyan (indice 4)

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
| `"...ou vista de muros"` | `"Ver esperas no detalhamento de pilares"` | Normaliza texto de esperas, cor cyan, altura 12.5 |

## Arredondamento de cotas (`ELE_COT_COT_ARM`)

Cotas do layer `ELE_COT_COT_ARM` passam pelas seguintes correcoes:

1. Todo o elemento e movido 10 unidades para baixo
2. Para entidades `DIMENSION`: o valor exibido e arredondado para o multiplo de 5 mais proximo (ex: `14 → 15`, `19 → 20`, `94 → 95`)
3. O texto da cota e deslocado 10 unidades adicionais para baixo em relacao a linha de cota

## Estrutura

```
correcao_vigas/
└── maqvigas.lsp       ; comando principal (c:MAQVIGAS)
```
