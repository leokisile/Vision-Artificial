addpath("libreria");

img = imread('imagenes\metrobus.png');
img_letra=imread('imagenes\letraL.jpg');

vertical = corte_vertical(img);
horizontal = corte_horizontal(img);
letra = pintar_letra(img_letra, 0, 255, 0);

% Creamos una ventana de figuras
figure(1)

% Imagen Original
subplot(2, 2, 1);
imshow(img);
title("Original");

% Corte Horizontal
subplot(2, 2, 2);
imshow(horizontal);
title("Cortes Horizontales");

% Corte Vertical
subplot(2, 2, 3);
imshow(vertical);
title("Cortes Verticales");

% Letra Pintada
subplot(2, 2, 4);
imshow(letra);
title("Letra Pintada");
