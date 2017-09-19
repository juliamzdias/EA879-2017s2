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
%token <strval> STRING DIV MULT OBRACKET CBRACKET
%token <ival> VAR IGUAL EOL ASPA
%token <fval> NUM
%left SOMA
%type <fval> FATOR

%%

PROGRAMA:
  PROGRAMA EXPRESSAO EOL
  |
  ;

EXPRESSAO:
    STRING IGUAL STRING {
      printf("Copiando %s para %s\n", $3, $1);
      imagem I = abrir_imagem($3);
      printf("Li imagem %d por %d\n", I.width, I.height);
      salvar_imagem($1, &I);
      liberar_imagem(&I);
    }
    | STRING IGUAL STRING FATOR {
      printf("Modificando brilho de %s\n", $3);
      imagem I = abrir_imagem($3);
      printf("Adicionando %s para %s\n", $3, $1);
      I = brilho_imagem(&I, $4);
      printf("Li imagem %d por %d\n", I.width, I.height);
      salvar_imagem($1, &I);
      liberar_imagem(&I);
    }
    | OBRACKET STRING CBRACKET {
      imagem I = abrir_imagem($2);
      float max = max_imagem(&I);
      printf("O valor máximo de %s é %.2f\n", $2, max);
      liberar_imagem(&I);
    }
    ;

FATOR:
    MULT NUM {
      $$ = $2;
    }
    | DIV NUM {
      $$ = 1/$2;
    }
    ;




%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
  FreeImage_Initialise(0);
  yyparse();
  return 0;

}
