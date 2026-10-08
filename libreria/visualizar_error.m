function error_vis = visualizar_error(error)
    % visualizar_error: Suma 128 unidades a cualquier valor menor a 0
    %   error: Matriz de error

    tipo_original = class(error);
    error_vis = double(error);

    % 1. Crear una máscara lógica para identificar posiciones menores a 0
    mascara_negativos = error_vis < 0;

    % 2. Sumar 128 únicamente a los elementos que cumplen la condición
    error_vis(mascara_negativos) = error_vis(mascara_negativos) + 128;

    % 3. Castear de vuelta al tipo de dato original (ej. uint8)
    error_vis = cast(error_vis, tipo_original);
end
