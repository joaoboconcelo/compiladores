## Entrega 1 — Analisador Léxico

O analisador léxico transforma o código-fonte da MPL em uma sequência de
tokens. Cada token possui tipo, lexema, linha e coluna.

### Tabela de Tokens

| Token | Expressão regular / reconhecimento |
|---|---|
| `ID` | `[a-zA-Z_][a-zA-Z0-9_]*` |
| `INTEIRO` | `[0-9]+` |
| `REAL` | `[0-9]+\.[0-9]+` |
| `LOGICO` | `verdadeiro` \| `falso` |
| `TEXTO` | `"(...)"`, permitindo os escapes `\n`, `\t`, `\"` e `\\` |
| `FUNCAO` | `funcao` |
| `RETORNE` | `retorne` |
| `SE` | `se` |
| `SENAO` | `senao` |
| `ENQUANTO` | `enquanto` |
| `ESCREVA` | `escreva` |
| `TIPO_INTEIRO` | `inteiro` |
| `TIPO_REAL` | `real` |
| `TIPO_LOGICO` | `logico` |
| `TIPO_TEXTO` | `texto` |
| `TIPO_VAZIO` | `vazio` |
| `E` | `e` |
| `OU` | `ou` |
| `NAO` | `nao` |
| `MAIS` | `+` |
| `MENOS` | `-` |
| `VEZES` | `*` |
| `DIVIDE` | `/` |
| `RESTO` | `%` |
| `IGUAL` | `==` |
| `DIFERENTE` | `!=` |
| `MENOR` | `<` |
| `MENOR_IGUAL` | `<=` |
| `MAIOR` | `>` |
| `MAIOR_IGUAL` | `>=` |
| `ATRIBUI` | `=` |
| `ABRE_PAR` | `(` |
| `FECHA_PAR` | `)` |
| `ABRE_CHAVE` | `{` |
| `FECHA_CHAVE` | `}` |
| `VIRGULA` | `,` |
| `PONTO_VIRGULA` | `;` |
| `FIM_ARQUIVO` | fim da entrada |

### Comentários

| Tipo | Forma reconhecida |
|---|---|
| Comentário de linha | `//` até o fim da linha |
| Comentário de bloco | `/*` até o primeiro `*/` |

### Observações

- Identificadores são sensíveis a maiúsculas e minúsculas.
- Palavras reservadas são reconhecidas antes de `ID`.
- `<=`, `>=`, `==` e `!=` são reconhecidos antes dos operadores de um caractere.
- Números reais exigem dígitos antes e depois do ponto.
- Textos aceitam apenas os escapes `\n`, `\t`, `\"` e `\\`.
- Espaços, tabulações, quebras de linha e `\r` são ignorados.

## Entrega 2 — Analisador Sintático e Árvore

O analisador sintático transforma a sequência de tokens em uma árvore sintática
abstrata (AST), seguindo a especificação da linguagem e os rótulos definidos em
CONTRATOS.md.

### Gramática implementada (EBNF)

```ebnf
<programa> ::= { <funcao> } EOF

<funcao> ::= FUNCAO <tipo_retorno> ID ABRE_PAR [ <parametros> ] FECHA_PAR <bloco>

<parametros> ::= <parametro> { VIRGULA <parametro> }
<parametro> ::= <tipo> ID

<tipo_retorno> ::= TIPO_INTEIRO
                 | TIPO_REAL
                 | TIPO_LOGICO
                 | TIPO_TEXTO
                 | TIPO_VAZIO

<tipo> ::= TIPO_INTEIRO
         | TIPO_REAL
         | TIPO_LOGICO
         | TIPO_TEXTO

<bloco> ::= ABRE_CHAVE { <comando> } FECHA_CHAVE

<comando> ::= <declaracao>
            | <comando_id>
            | <condicional>
            | <repeticao>
            | <escrita>
            | <retorno>
            | <bloco>

<declaracao> ::= <tipo> ID [ ATRIBUI <expressao> ] PONTO_VIRGULA

<comando_id> ::= ID ATRIBUI <expressao> PONTO_VIRGULA
               | <chamada> PONTO_VIRGULA

<condicional> ::= SE ABRE_PAR <expressao> FECHA_PAR <bloco>
                  [ SENAO <bloco> ]

<repeticao> ::= ENQUANTO ABRE_PAR <expressao> FECHA_PAR <bloco>

<escrita> ::= ESCREVA ABRE_PAR <expressao> FECHA_PAR PONTO_VIRGULA

<retorno> ::= RETORNE [ <expressao> ] PONTO_VIRGULA

<chamada> ::= ID ABRE_PAR [ <argumentos> ] FECHA_PAR
<argumentos> ::= <expressao> { VIRGULA <expressao> }

<expressao> ::= <ou>

<ou> ::= <e> { OU <e> }

<e> ::= <igualdade> { E <igualdade> }

<igualdade> ::= <relacional> { (IGUAL | DIFERENTE) <relacional> }

<relacional> ::= <aditiva> { (MENOR | MENOR_IGUAL | MAIOR | MAIOR_IGUAL) <aditiva> }

<aditiva> ::= <multiplicativa> { (MAIS | MENOS) <multiplicativa> }

<multiplicativa> ::= <unario> { (VEZES | DIVIDE | RESTO) <unario> }

<unario> ::= (NAO | MENOS) <unario> | <primario>

<primario> ::= INTEIRO
             | REAL
             | LOGICO
             | TEXTO
             | ID
             | <chamada>
             | ABRE_PAR <expressao> FECHA_PAR