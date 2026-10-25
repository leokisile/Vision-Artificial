function graficar_comparativa_accuracy(metodos, accuracies)
    % metodos: Cell array con los nombres de los metodos de validacion
    % accuracies: Vector con los porcentajes de accuracy correspondientes, ej: [85.5, 92.0, 88.3]

    figure('Name', 'Comparativa de Accuracy por Metodo', 'Position', [200, 200, 600, 450]);

    % Crear la grafica de barras
    b = bar(accuracies, 'FaceColor', [0.2, 0.6, 0.8]);

    % Personalizar ejes y etiquetas
    set(gca, 'XTickLabel', metodos, 'FontSize', 11);
    ylabel('Accuracy (%)', 'FontSize', 12, 'FontWeight', 'bold');
    xlabel('Métodos de Validacion', 'FontSize', 12, 'FontWeight', 'bold');
    title('Comparativa de Rendimiento (Accuracy)', 'FontSize', 13, 'FontWeight', 'bold');

    % Limitar el eje Y de 0 a 100
    ylim([0, 105]);
    grid on;

    % Agregar el valor exacto del accuracy en la parte superior de cada barra
    for i = 1:length(accuracies)
        text(i, accuracies(i) + 2, sprintf('%.2f%%', accuracies(i)), ...
             'HorizontalAlignment', 'center', ...
             'VerticalAlignment', 'bottom', ...
             'FontSize', 10, 'FontWeight', 'bold');
    end

    disp('¡Grafica comparativa generada exitosamente!');
end
