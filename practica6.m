% ==========================================
% Archivo Principal: main.m
% ==========================================
clear; clc; close all;
addpath('libreria'); % Ruta donde guardaste image_gui.m

disp('Abriendo interfaz gráfica...');

% Llamar a la interfaz y recibir los datos calculados/seleccionados
datos_salida = image_gui();

% Verificar si el usuario completó el proceso o cerró la ventana
if ~isempty(datos_salida)
    disp('----------------------------------------');
    [m, n, canales] = size(datos_salida.imagen)
    disp('Datos recibidos exitosamente en el main:');
    fprintf(' - Método elegido: %s\n', datos_salida.metodo);
    fprintf(' - Iteraciones para Cross Validation: %d\n', datos_salida.kcross);
    fprintf(' - K para K-Leave Out: %d\n', datos_salida.kleave);
    fprintf(' - Clases totales: %d\n', datos_salida.n_clases);
    fprintf(' - Representantes por clase: %d\n', datos_salida.n_rep);

    disp(' - Coordenadas de los rectángulos (Clases):');
    disp(datos_salida.rects);

    %disp(' - Puntos aleatorios generados:');
    %disp(datos_salida.puntos_aleatorios);
    disp('----------------------------------------');
else
    disp('El usuario cerró la interfaz sin completar el proceso.');
end

% Extraccion de valores de los pixeles divididos por clase
valores = valor_pixel(datos_salida.puntos_aleatorios, datos_salida.n_clases, datos_salida.imagen);

% Metodos de validacion

% Resutitution: Entrena y prueba con todas

% K-Cross validation (50-50) con 20 iteraciones

% Leave K-out: Deja k datos para probar, los demas para entrenar
