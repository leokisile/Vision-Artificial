addpath("libreria");

img = imread('imagenes\metrobus.png');

repetir = 's';
while repetir == 's'
  n = input("Elige la compresion de bits (1-7): ");

  % --- PROCESO ---
  vaciada = vaciar_img(img);

  predicha = predecir_img(vaciada);

  error = double(img) - double(predicha);
  error_vis = visualizar_error(error);

  maximo = squeeze(max(max(error, [], 1), [], 2))'; % Vector 1xc
  minimo = squeeze(min(min(error, [], 1), [], 2))'; % Vector 1xc
  combinaciones = 2^n;

  rangos = calcular_rangosError(maximo, minimo, combinaciones);
  MEQ = matriz_ErrorCuantificada(error, rangos);
  MEQ_1 = inversa_MEQ(MEQ, rangos, minimo);

  reconstruida = MEQ_1 + double(predicha);
  img_reconstruida = uint8(max(0, min(255, reconstruida)));

  SN = signalNoise(img, img_reconstruida);


  % --- GRAFICAR ---
  % Creamos una ventana de figuras
  figure(1)

  % Imagen Original
  subplot(3, 2, 1);
  imshow(img);
  title("Original");

  % Vaciada
  subplot(3, 2, 2);
  imshow(vaciada);
  title("Imagen a predecir");

  % Predicha
  subplot(3, 2, 3);
  imshow(predicha);
  title("Imagen predicha");

  % Error
  subplot(3, 2, 4);
  imshow(error_vis);
  title("Error encontrado");

  % Imagen recuperada
  subplot(3, 2, 5);
  imshow(img_reconstruida);
  title(sprintf('Imagen reconstruida con %d bits', n));

  % Termino
  repetir = input("Quiere comprimir otra vez (s/n)?: ", "s");
  if repetir == 'n'
    disp("Nos vemos en 8 dias")
  endif
endwhile
