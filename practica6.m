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
    disp('Datos recibidos exitosamente en el main:');
    fprintf(' - Método elegido: %s\n', datos_salida.metodo);
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
