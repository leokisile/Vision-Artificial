clc
clear all
close all
warning off all

addpath("libreria");

imagen=imread('C:\LOCAL\Superior\5to\Vision\Codigos en clase\test.png'); %ubicacion imagen
%imagen=imread('C:\LOCAL\TRABAJOS ANGEL\SUPERIOR\5\vision artificial\Codigos en clase\test.png');
continuar = true;

while continuar
    disp(' ');
    disp('    QUE DESEA HACER?   ');
    disp('1. Cuadro multicolor');
    disp('2. Cortar vertical');
    disp('3. Cortar horizontal');
    disp('4. Letra con fondo');
    disp('5. Salir');

    opcion = input('ingresar (1-5): ');

    switch opcion
        case 1
            disp('Tipo de cuadro----------');
            disp('1. Basico (Subplot)');
            disp('2. Pro (1 sola img)');
            tipo_cuadro = input('ingresar (1 o 2): ');

            if tipo_cuadro == 1

                roja = imagen;
                roja(:,:,2) = 0;
                roja(:,:,3) = 0;

                verde = imagen;
                verde(:,:,1) = 0;
                verde(:,:,3) = 0;

                azul = imagen;
                azul(:,:,1) = 0;
                azul(:,:,2) = 0;

                figure('1');

                subplot(2,2,1);
                imshow(imagen);
                title('Original');

                subplot(2,2,2);
                imshow(roja);
                title('Roja');

                subplot(2,2,3);
                imshow(verde);
                title('Verde');

                subplot(2,2,4);
                imshow(azul);
                title('Azul');

            elseif tipo_cuadro == 2

                v1 = corte_vertical(imagen, 2, 1, 1, 1, 1); %original
                v2 = corte_vertical(imagen, 2, 2, 1, 0, 0); % rojo
                mitad_sup = corte_horizontal(v1 + v2, 2, 1, 1, 1, 1);

                v3 = corte_vertical(imagen, 2, 1, 0, 1, 0); % verde
                v4 = corte_vertical(imagen, 2, 2, 0, 0, 1); % azul
                mitad_inf = corte_horizontal(v3 + v4, 2, 2, 2, 1, 1);

                resultado = mitad_sup + mitad_inf;

                figure(2);
                imshow(resultado);
                title('Cuadro Multicolor Pro');

            else
                disp('no valido');
            end

        case 2
            disp('Corte Vertical -------------');
            cortes = input('En cuantas partes dividira la imagen? ');
            resultado_acomulado = imagen;
            resultado_acomulado(:,:,:)=0;

            for corte=1 : 1 :cortes
              color = input('Elige el color del siguiente pedazo (r, g, b): ', 's');

              r = 0; g = 0; b = 0;
              if color == 'r'
                  r = 1;
              elseif color == 'g'
                  g = 1;
              elseif color == 'b'
                  b = 1;
              end

              resultado = corte_vertical(imagen, cortes, corte, r, g, b);
              resultado_acomulado = resultado_acomulado + resultado;
            end

            figure(3);
            imshow(resultado_acomulado);
            title('Corte verticarl');

        case 3
            disp('Corte Horizontal -------------');
            cortes = input('En cuantas partes dividira la imagen? ');
            resultado_acomulado = imagen;
            resultado_acomulado(:,:,:)=0;

            for corte=1 : 1 :cortes
              color = input('Elige el color del siguiente pedazo (r, g, b): ', 's');

              r = 0; g = 0; b = 0;
              if color == 'r'
                  r = 1;
              elseif color == 'g'
                  g = 1;
              elseif color == 'b'
                  b = 1;
              end

              resultado = corte_horizontal(imagen, cortes, corte, r, g, b);
              resultado_acomulado = resultado_acomulado + resultado;
            end

            figure(4);
            imshow(resultado_acomulado);
            title('Corte horizontal');

        case 4
            disp('Letra con fondo dividido ---------');
            letra_elegida = input('Ingrese el caracter deseado: ', 's');

            disp('Izquierda');
            color = input('Elige el color (r, g, b): ', 's');

              r = 0; g = 0; b = 0;
              if color == 'r'
                  r = 1;
              elseif color == 'g'
                  g = 1;
              elseif color == 'b'
                  b = 1;
              end
            mitad_izq = corte_vertical(imagen, 2, 1, r, g, b);

            disp('Derecha');
            color = input('Elige el color (r, g, b): ', 's');

              r = 0; g = 0; b = 0;
              if color == 'r'
                  r = 1;
              elseif color == 'g'
                  g = 1;
              elseif color == 'b'
                  b = 1;
              end
            mitad_der = corte_vertical(imagen, 2, 2, r, g, b);

            fondo = mitad_izq + mitad_der;
            imagen_letra = imagen;

            disp('Letra');
            color = input('Elige el color (r, g, b): ', 's');

              if color == 'r'
                  imagen_letra(:,:,2) = 0;
                  imagen_letra(:,:,3) = 0;
              elseif color == 'g'
                  imagen_letra(:,:,1) = 0;
                  imagen_letra(:,:,3) = 0;
              elseif color == 'b'
                  imagen_letra(:,:,1) = 0;
                  imagen_letra(:,:,2) = 0;
              end

            matriz_letra_binaria = matriz_letra(letra_elegida);
            mascara = escalar_mascara(imagen, matriz_letra_binaria);

            fondo_r = fondo(:,:,1);
            fondo_g = fondo(:,:,2);
            fondo_b = fondo(:,:,3);

            fondo_r(mascara == 1) = 0;
            fondo_g(mascara == 1) = 0;
            fondo_b(mascara == 1) = 0;

            fondo(:,:,1) = fondo_r;
            fondo(:,:,2) = fondo_g;
            fondo(:,:,3) = fondo_b;

            letra_r = imagen_letra(:,:,1);
            letra_g = imagen_letra(:,:,2);
            letra_b = imagen_letra(:,:,3);

            letra_r(mascara == 0) = 0;
            letra_g(mascara == 0) = 0;
            letra_b(mascara == 0) = 0;
            imagen_letra(:,:,1) = letra_r;
            imagen_letra(:,:,2) = letra_g;
            imagen_letra(:,:,3) = letra_b;

            resultado_final = fondo + imagen_letra;

            figure(5);
            imshow(resultado_final);
            title(['Imagen con letra: ', letra_elegida]);

        case 5
            disp('Saliendo del programa...');
            continuar = false;

        otherwise
            disp('Opcion no valida. Intenta de nuevo.');
    end
end
