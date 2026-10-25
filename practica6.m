clear; clc; close all;
addpath('libreria');
pkg load image

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

ejecutar_proceso_clasificacion(datos_salida);
