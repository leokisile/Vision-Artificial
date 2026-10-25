function valores = valor_pixel(coordenadas, n_clases, imagen)
    % valor_pixel: Calcula el valor RGB de los pixeles de la imagen divididos por clase
    %   coordenadas: Cell array con los puntos [x,y] de cada clase {i}
    %   n_clases: Numero total de clases
    %   imagen: Imagen de la cual extraer los valores
    pkg load image
    valores = cell(n_clases, 1);

    for i = 1:n_clases
        % Extraer todas las coordenadas X y todas las coordenadas Y de la clase i
        x_coords = coordenadas{i}(:, 1);
        y_coords = coordenadas{i}(:, 2);

        % Obtener los valores de píxel
        valorLocal = impixel(imagen, x_coords, y_coords);
        valores{i} = valorLocal;
    end
end
