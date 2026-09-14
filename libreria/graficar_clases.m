function graficar_clases(clases, x_vector)
    % GRAFICAR_CLASES Dibuja un numero arbitrario de clases y un vector de prueba.
    %   clases: Un celdario (cell array) con las matrices, ej: {c1, c2, c3}
    %   x_vector: El vector de coordenadas a graficar en color negro

    figure(1);
    clf; % Limpia la figura actual por si se vuelve a llamar en un bucle
    hold on;
    grid on;
    axis padded

    % Paleta de colores a iterar
    colores = ['r', 'b', 'g', 'm', 'c', 'y'];

    % Bucle para graficar cada clase de forma automatica
    for i = 1:length(clases)
        c_actual = clases{i};
        % Seleccionamos color de forma ciclica si hay mas clases que colores
        c_color = colores(mod(i-1, length(colores)) + 1);

        plot(c_actual(1,:), c_actual(2,:), [c_color 'o'], 'MarkerSize', 10, 'MarkerFaceColor', c_color);
    end

    % Graficamos el vector introducido por el usuario al final
    plot(x_vector(1,:), x_vector(2,:), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');

    % Generamos dinamicamente las etiquetas de la leyenda
    n_clases = length(clases);
    nombres_leyenda = cell(1, n_clases + 1);

    for i = 1:n_clases
        nombres_leyenda{i} = ['Clase ' num2str(i)];
    end
    nombres_leyenda{end} = 'Vector';

    legend(nombres_leyenda, 'Location', 'eastoutside');
    hold off; % Deja de retener los antes graficado
end
