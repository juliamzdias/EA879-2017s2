#ifndef IMAGEPROCESSING_H
#define IMAGEPROCESSING_H

typedef struct {
  unsigned int width, height;
  float *r, *g, *b;
} imagem;

float max_imagem(imagem* I);
imagem brilho_imagem(imagem* I, float fator);
imagem abrir_imagem(char *nome_do_arquivo);
void salvar_imagem(char *nome_do_arquivo, imagem *I);
void liberar_imagem(imagem *i);

#endif
