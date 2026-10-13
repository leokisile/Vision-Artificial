clc
clear all
close all
warning off all

addpath("libreria");

imagen=imread('imagenes\metrobus.png');
continuar = true;

% Canal rojo
roja = imagen;
roja(:,:,2)=0;
roja(:,:,3)=0;


%canal azul
azul = imagen;
azul(:,:,1)=0;
azul(:,:,2)=0;


% Conversion a grises y seleccionamos 3 canales
img_gris = rgb2gray(imagen);
img_gris_rgb = cat(3, img_gris, img_gris, img_gris);

% Definiicon del color de la letra
color_verde = [0, 255, 0];

% Modificar canales
r_canal = img_gris_rgb(:,:,1);
g_canal = img_gris_rgb(:,:,2);
b_canal = img_gris_rgb(:,:,3);

% Donde la mascara sea 1, se queda en verde
matriz_letra_binaria = matriz_letra('S');
mascara = escalar_mascara(imagen, matriz_letra_binaria);

r_canal(mascara == 1) = color_verde(1);
g_canal(mascara == 1) = color_verde(2);
b_canal(mascara == 1) = color_verde(3);

% Unimos los canales
resultado_final = cat(3, r_canal, g_canal, b_canal);

matriz = [azul imagen; roja resultado_final];

% Visualizaci¢n
figure;
subplot(2, 2, 1);
imshow(azul); title('Canal azul');
subplot(2, 2, 2);
imshow(imagen); title('Imagen a color');
subplot(2, 2, 3);
imshow(roja); title('Canal rojo');
subplot(2, 2, 4);
imshow(resultado_final); title('Gris con letra verde');

figure(2);
imshow(matriz);


