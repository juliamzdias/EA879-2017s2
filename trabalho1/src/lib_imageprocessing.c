
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#include "imageprocessing.h"

#include <FreeImage.h>

/*
imagem abrir_imagem(char *nome_do_arquivo);
void salvar_imagem(char *nome_do_arquivo);
void liberar_imagem(imagem *i);
 */

float max_imagem(imagem* I) {
  float max = 0, max_aux;
  int idx;
  for (int i=0; i< I->width; i++) {
    for (int j=0; j < I->height; j++) {
        idx = i + (j * I->width);
        max_aux = sqrt(pow(I->r[idx], 2) + pow(I->g[idx], 2) + pow(I->b[idx], 2));
        if(max_aux > max) max = max_aux;
    }
  }
  return max;
}

imagem brilho_imagem(imagem* I, float fator) {
   imagem J;

   J.r = malloc(sizeof(float) * I->width * I->height);
   J.g = malloc(sizeof(float) * I->width * I->height);
   J.b = malloc(sizeof(float) * I->width * I->height);

   J.height = I->height;
   J.width = I->width;

   for (int i=0; i< I->width; i++) {
     for (int j=0; j < I->height; j++) {
      int idx;

      idx = i + (j * I->width);

      J.r[idx] = fator * I->r[idx];
      if(J.r[idx] > 255) J.r[idx] = 255;
      J.g[idx] = fator * I->g[idx];
      if(J.g[idx] > 255) J.g[idx] = 255;
      J.b[idx] = fator * I->b[idx];
      if(J.b[idx] > 255) J.b[idx] = 255;
    }
   }
  return J;

}

imagem abrir_imagem(char *nome_do_arquivo) {
  FIBITMAP *bitmapIn;
  int x, y;
  RGBQUAD color;
  imagem I;

  bitmapIn = FreeImage_Load(FIF_JPEG, nome_do_arquivo, 0);

  if (bitmapIn == 0) {
    printf("Erro! Nao achei arquivo - %s\n", nome_do_arquivo);
  } else {
    printf("Arquivo lido corretamente!\n");
   }

  x = FreeImage_GetWidth(bitmapIn);
  y = FreeImage_GetHeight(bitmapIn);

  I.width = x;
  I.height = y;
  I.r = malloc(sizeof(float) * x * y);
  I.g = malloc(sizeof(float) * x * y);
  I.b = malloc(sizeof(float) * x * y);

   for (int i=0; i<x; i++) {
     for (int j=0; j <y; j++) {
      int idx;
      FreeImage_GetPixelColor(bitmapIn, i, j, &color);

      idx = i + (j*x);

      I.r[idx] = color.rgbRed;
      I.g[idx] = color.rgbGreen;
      I.b[idx] = color.rgbBlue;
    }
   }
  return I;

}

void liberar_imagem(imagem *I) {
  free(I->r);
  free(I->g);
  free(I->b);
}

void salvar_imagem(char *nome_do_arquivo, imagem *I) {
  FIBITMAP *bitmapOut;
  RGBQUAD color;

  printf("Salvando imagem %d por %d...\n", I->width, I->height);
  bitmapOut = FreeImage_Allocate(I->width, I->height, 24, 0, 0, 0);

   for (int i=0; i<I->width; i++) {
     for (int j=0; j<I->height; j++) {
      int idx;

      idx = i + (j*I->width);
      color.rgbRed = I->r[idx];
      color.rgbGreen = I->g[idx];
      color.rgbBlue = I->b[idx];

      FreeImage_SetPixelColor(bitmapOut, i, j, &color);
    }
  }

  FreeImage_Save(FIF_JPEG, bitmapOut, nome_do_arquivo, JPEG_DEFAULT);
}
