function guardar_resultados_txt(metodo, matriz_confusion, accuracy, n_clases)
    % Definir la ruta de la carpeta 'matrices'
    ruta_carpeta = 'matrices';

    % Verificar si la carpeta 'matrices' existe, si no, crearla
    if ~exist(ruta_carpeta, 'dir')
        mkdir(ruta_carpeta);
    end

    % Ruta completa del archivo .txt
    nombre_archivo = fullfile(ruta_carpeta, 'resultados_clasificacion.txt');

    % Abrir archivo en modo de edicion ('a')
    fid = fopen(nombre_archivo, 'a');

    if fid == -1
        error('No se pudo abrir el archivo de texto en la carpeta matrices.');
    end

    fprintf(fid, '========================================\n');
    fprintf(fid, 'Método Evaluado: %s\n', metodo);
    fprintf(fid, 'Fecha y Hora: %s\n', datestr(now));
    fprintf(fid, 'Accuracy (Precisión Global): %.2f%%\n', accuracy);
    fprintf(fid, 'Matriz de Confusión (Filas: Real, Columnas: Predicha):\n');

    % Imprimir cabecera de columnas (c1, c2, c3, ...)
    fprintf(fid, '\t');
    for j = 1:n_clases
        fprintf(fid, 'c%d\t', j);
    end
    fprintf(fid, '\n');

    % Imprimir filas con su etiqueta c1, c2, ... y los valores de la matriz
    for i = 1:n_clases
        fprintf(fid, 'c%d\t', i); % Etiqueta de la fila
        for j = 1:n_clases
            fprintf(fid, '%d\t', matriz_confusion(i, j));
        end
        fprintf(fid, '\n');
    end

    fprintf(fid, '========================================\n\n');

    fclose(fid);
    disp(['Resultados almacenados exitosamente en: ', nombre_archivo]);
end
