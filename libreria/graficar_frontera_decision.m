function graficar_frontera_decision(pesos, sesgo, modelo_color, img_actualizada)
    % 1. Convertir imagen a double y al modelo de color seleccionado
    img_double = im2double(img_actualizada);

    switch upper(modelo_color)
        case 'RGB'
            img_model = img_double;
        case 'HSV'
            img_model = rgb2hsv(img_double);
        case 'HSI'
            img_model = rgb2hsi_local(img_double);
        otherwise
            img_model = img_double;
    end

    [H, W, ~] = size(img_model);

    % 2. Aplanar la imagen a una matriz de (H*W) x 3 para un cálculo matricial rápido
    pixels_flat = reshape(img_model, [], 3);

    % 3. Multiplicación de matrices: (W1*x1 + W2*x2 + W3*x3) + W0 (Sesgo)
    scores = pixels_flat * pesos(:) + sesgo;

    % 4. Generar la matriz de clasificación (Falso = Clase 1, Verdadero = Clase 2)
    clase_map = reshape(scores >= 0, H, W);

    % 5. Crear una nueva ventana independiente comparativa
    figure('Name', ['Mapa de Segmentación - Modelo ' modelo_color], ...
           'Position', [200, 200, 900, 450]);

    % Subplot 1: Imagen Original
    subplot(1, 2, 1);
    imshow(img_actualizada);
    title('Imagen Original', 'FontSize', 11, 'FontWeight', 'bold');

    % Subplot 2: Mapa de Clasificación Binaria
    subplot(1, 2, 2);
    imagesc(clase_map);
    % Asignar un mapa de colores personalizado (Ej: Azul para Clase 1, Rojo/Naranja para Clase 2)
    colormap(gca, [0.15 0.45 0.75; 0.85 0.35 0.20]);
    cb = colorbar('Ticks', [0.25, 0.75], 'TickLabels', {'Clase 1 (<0)', 'Clase 2 (>=0)'});

    % Corrección compatible con Octave para cambiar el tamaño de fuente de la barra de color
    set(cb, 'FontSize', 10);

    title(sprintf('Segmentación por Clasificador (%s)', modelo_color), 'FontSize', 11, 'FontWeight', 'bold');
    axis image;
end
