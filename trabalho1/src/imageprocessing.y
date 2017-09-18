%{
#include <stdio.h>
#include "imageprocessing.h"
#include <FreeImage.h>

void yyerror(char *c);
int yylex(void);

%}
%union {
  char    strval[50];
  int     ival;
  float   fval;
}
%token <strval> STRING OP
%token <ival> VAR IGUAL EOL ASPA
%left SOMA

%%

PROGRAMA:
        PROGRAMA EXPRESSAO EOL
        |
        ;

EXPRESSAO:
    | STRING IGUAL STRING {
        printf("Copiando %s para %s\n", $3, $1);
        imagem I = abrir_imagem($3);
        printf("Li imagem %d por %d\n", I.width, I.height);
        salvar_imagem($1, &I);
        liberar_imagem(&I);
                          }

    | STRING IGUAL STRING FATOR {
      // printf("Copiando %s para %s\n", $3, $1);
      imagem I = abrir_imagem($3);
      brilho_imagem(&I, $4);
      // printf("Li imagem %d por %d\n", I.width, I.height);
      salvar_imagem($1, &I);
      liberar_imagem(&I);
      }
      ;

FATOR:
    MULT NUM {
      return $2;
    }
    DIV NUM {
      return 1/$2;
    }

NUM:
  INT {
    return (float)
  }




%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
  FreeImage_Initialise(0);
  yyparse();
  return 0;

}
