function dibujar_cuadrado(ax, rect_coords, indice_clase)
    colores = ['r', 'g', 'b', 'c', 'm', 'y', 'k'];
    color_actual = colores(mod(indice_clase - 1, length(colores)) + 1);

    hold(ax, 'on');
    rectangle(ax, 'Position', rect_coords, 'EdgeColor', color_actual, 'LineWidth', 2);
    hold(ax, 'off');
end
