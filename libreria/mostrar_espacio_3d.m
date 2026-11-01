function mostrar_espacio_3d(pesos, sesgo, modelo_color, pixels_modelo)
    w1 = pesos(1);
    w2 = pesos(2);
    w3 = pesos(3);
    w0 = sesgo;

    fig_3d = figure('Name', ['Espacio 3D y Plano de Decisión - Modelo ' modelo_color], ...
                    'Position', [250, 250, 800, 600]);
    ax_3d = axes('Parent', fig_3d);
    hold(ax_3d, 'on');

    % Colores para distinguir las clases en el gráfico 3D
    colores_clases = {'r', 'b', 'g', 'm', 'c'};

    % 1. Graficar los píxeles extraídos de cada clase en el espacio 3D
    n_clases = length(pixels_modelo);
    for i = 1:n_clases
        p = pixels_modelo{i};
        if ~isempty(p)
            color_actual = colores_clases{mod(i-1, length(colores_clases)) + 1};
            scatter3(ax_3d, p(:, 1), p(:, 2), p(:, 3), 18, color_actual, 'filled', ...
                     'DisplayName', ['Clase ' num2str(i)]);
        end
    end

    % 2. Graficar el plano de decisión (W1*x1 + W2*x2 + W3*x3 + W0 = 0)
    % Despejamos X2 si W2 no es cercano a cero
    if abs(w2) > 1e-6
        [X1, X3] = meshgrid(linspace(0, 1, 35), linspace(0, 1, 35));
        X2 = (-w1 * X1 - w3 * X3 - w0) / w2;

        % Opcional: limitar el plano visualmente al cubo [0, 1]
        X2(X2 < 0 | X2 > 1) = NaN;

        surf(ax_3d, X1, X2, X3, 'FaceAlpha', 0.4, 'EdgeColor', 'none', ...
             'FaceColor', 'yellow', 'DisplayName', 'Plano de Decisión');
    end

    % Asignar nombres dinámicos a los ejes según el modelo de color elegido
    switch upper(modelo_color)
        case 'RGB'
            xlabel(ax_3d, 'Rojo (R)'); ylabel(ax_3d, 'Verde (G)'); zlabel(ax_3d, 'Azul (B)');
        case 'HSV'
            xlabel(ax_3d, 'Matiz (H)'); ylabel(ax_3d, 'Saturación (S)'); zlabel(ax_3d, 'Valor (V)');
        case 'HSI'
            xlabel(ax_3d, 'Matiz (H)'); ylabel(ax_3d, 'Saturación (S)'); zlabel(ax_3d, 'Intensidad (I)');
    end

    title(ax_3d, sprintf('Espacio Característico 3D (%s)\nW1=%.2f, W2=%.2f, W3=%.2f, W0=%.2f', ...
          modelo_color, w1, w2, w3, w0), 'Interpreter', 'none');
    legend(ax_3d, 'Location', 'best');
    grid(ax_3d, 'on');
    view(ax_3d, 3); % Vista tridimensional inicial
    hold(ax_3d, 'off');
end
