%{
#include <stdlib.h>
#include <string.h>
void yyerror(char *);

#include "y.tab.h"
%}

%%

[a-zA-Z0-9]+\.[a-zA-Z]+  {
              for (int i = 0; i < yyleng; i++ )
                yylval.strval[i] = yytext[i];

              yylval.strval[yyleng] = '\0';
              return IMAGE;
            }

[*/]  {
          yylval.cval = yytext[0];
          return OPERATION;
        }

[0-9]+\.[0-9]+  {
                  yylval.fval = atof(yytext);
                  return FLOAT;
                }

[0-9]+  {
            yylval.ival = atoi(yytext);
            return INT;
          }

[=]   {
       yylval.cval = yytext[0];
       return IGUAL;
     }

\n   {
       return EOL;
     }

[ \t]+ ;

.     {
        printf("**%s**\n", yytext);
        yyerror("Token nao reconhecido!\n");
      }

%%

int  yywrap() {
  return 1;
}
