function predicha = predecir_img(vacia)
    % predecir_img: Predice el contenido de una imagen segun una matriz con una fila y una columna
    %   vacia: Matriz de la imagen "vaciada"

    tipo_original = class(vacia);
    vacia = double(vacia);

    m = size(vacia, 1); % Filas
    n = size(vacia, 2); % Columnas

    % Matriz para la prediccion
    predicha = zeros(size(vacia));
    predicha(1, :, :) = vacia(1, :, :);
    predicha(:, 1, :) = vacia(:, 1, :);

    % MAtriz logica para rastrear a los elementos conocidos
    conocidos = false(m, n);
    conocidos(1, :) = true;
    conocidos(:, 1) = true;

    for y=2:m
      for x=2:n
        % Limites de la vecindad 8
        y_min = max(1, y - 1);
        y_max = min(m, y + 1);
        x_min = max(1, x - 1);
        x_max = min(n, x + 1);

        mascara_vecinos = conocidos(y_min:y_max, x_min:x_max);
        num_conocidos = sum(mascara_vecinos(:));

        if num_conocidos > 0
          ventana = predicha(y_min:y_max, x_min:x_max, :);
          ventana_filtrada = ventana .* mascara_vecinos; % Al multiplicar por false, no considera elementos desconocidos, el '.' expande a n canales

          suma_canales = sum(sum(ventana_filtrada, 1), 2);
          promedio = suma_canales / num_conocidos;
          predicha(y, x, :) = promedio;
        endif
        conocidos(y, x) = true;

      endfor

    endfor

    predicha = cast(predicha, tipo_original);
end
