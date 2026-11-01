function dibujar_puntos_clase(ax, puntos, indice_clase)
    % Paleta de colores y símbolos (marcadores) disponibles para rotar
    colores = ['r', 'g', 'b', 'c', 'm', 'y', 'k'];
    simbolos = {'o', 's', '^', 'd', 'v', 'p', '*'}; % Círculo, Cuadrado, Triángulo, Diamante, etc.

    color_actual = colores(mod(indice_clase - 1, length(colores)) + 1);
    simbolo_actual = simbolos{mod(indice_clase - 1, length(simbolos)) + 1};

    hold(ax, 'on');
    plot(ax, puntos(:, 1), puntos(:, 2), simbolo_actual, ...
         'Color', color_actual, ...
         'MarkerFaceColor', color_actual, ...
         'MarkerSize', 5, ...
         'LineStyle', 'none');
    hold(ax, 'off');
end
