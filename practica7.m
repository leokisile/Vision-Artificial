clear; clc; close all;
addpath('libreria');
pkg load image

disp('Abriendo interfaz gráfica...');

% Llamar a la nueva interfaz renombrada
datos_salida = interfazP7();

if ~isempty(datos_salida)
    disp('----------------------------------------');
    disp('Datos recibidos exitosamente en el main:');
    fprintf(' - Modelo de color elegido: %s\n', datos_salida.modelo_color);
    fprintf(' - Clases totales: %d\n', datos_salida.n_clases);
    fprintf(' - Pesos (X1, X2, X3): [%f, %f, %f]\n', datos_salida.pesos);
    fprintf(' - Sesgo (X0): %f\n', datos_salida.sesgo);
    fprintf(' - Tasa de aprendizaje (Gamma): %f\n', datos_salida.gamma);
    disp(' - Coordenadas de los rectángulos (Clases):');
    disp(datos_salida.rects);
    disp('----------------------------------------');
else
    disp('El usuario cerró la interfaz sin completar el proceso.');
end
