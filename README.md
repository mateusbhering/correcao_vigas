Rotina AutoLISP para padronização de objetos em projetos estruturais de vigas no AutoCAD. Desenvolvida para adequar elementos gerados por softwares de detalhamento (como o CAD/TQS) ao padrão de entrega do escritório.

Funcionalidades

Deleta layers desnecessários — remove automaticamente os layers ELE_REF_REF_NOME e ELE_COT_TEXTOS_ESTRIBOS
Move cotas de armadura — desloca elementos do layer ELE_COT_COT_ARM 10 unidades para baixo
Corrige altura de texto em cotas — normaliza a altura de dimensões no layer ELE_COT_COMPRIMENTO_PROJETADO de 10.0 para 0.01
Padroniza textos (TEXT e MTEXT):

Aplica o estilo de fonte ROMANS (romans.shx)
Define fator de largura em 0.95
Ajusta alturas de texto: 13.333 → 12.5 e 16.667 → 18.0
Formata strings de armadura removendo parênteses e padronizando separadores




Requisitos

AutoCAD com suporte a AutoLISP e Visual LISP (ActiveX)
Arquivo de fonte romans.shx disponível no caminho de suporte do AutoCAD


Como usar

Carregue o arquivo no AutoCAD via APPLOAD ou arrastando o .lsp para a área de trabalho
No prompt de comando, digite:

   MAQVIGAS

Selecione os objetos que deseja processar e pressione Enter
A rotina será aplicada e exibirá a mensagem de confirmação no prompt


Transformações de texto
A rotina aplica as seguintes substituições nas strings de texto:
DeParaDescriçãox(xRemove parêntese após x)  Remove parêntese de fechamento seguido de espaço( ou )(vazio)Remove parênteses restanteseNNCorrige prefixo de bitolac= c=Adiciona espaço antes do espaçamento de estribo

Estrutura do arquivo
maqvigas.lsp
└── c:MAQVIGAS        ; comando principal
