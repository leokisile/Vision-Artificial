function [pixels_raw, pixels_modelo] = extraer_pixeles(img_rgb, img_model, rects_data, n_clases, target_n)
    % Si no se especifica la cantidad de píxeles, por defecto extrae 500
    if nargin < 5
        target_n = 500;
    end

    pixels_raw = cell(n_clases, 1);
    pixels_modelo = cell(n_clases, 1);
    [img_h, img_w, ~] = size(img_rgb);

    for i = 1:n_clases
        rect = rects_data{i}; % [x_min, y_min, width, height]
        x_min = rect(1);
        y_min = rect(2);
        w = rect(3);
        h = rect(4);

        % Definir límites seguros dentro de la imagen
        x_start = max(1, round(x_min));
        x_end   = min(img_w, round(x_min + w));
        y_start = max(1, round(y_min));
        y_end   = min(img_h, round(y_min + h));

        % Recorte por indexación directa
        crop_rgb   = img_rgb(y_start:y_end, x_start:x_end, :);
        crop_model = img_model(y_start:y_end, x_start:x_end, :);

        % Reformatear matrices de tamaño HxWx3 a N x 3 píxeles
        pixels_rgb_flat = reshape(crop_rgb, [], 3);
        pixels_mod_flat = reshape(crop_model, [], 3);

        num_pixels = size(pixels_mod_flat, 1);

        if num_pixels >= target_n
            % Seleccionar aleatoriamente sin reemplazo
            idx = randperm(num_pixels, target_n);
            pixels_raw{i} = pixels_rgb_flat(idx, :);
            pixels_modelo{i} = pixels_mod_flat(idx, :);
        else
            warning('Clase %d tiene menos de %d píxeles (%d encontrados). Se usarán todos.', i, target_n, num_pixels);
            pixels_raw{i} = pixels_rgb_flat;
            pixels_modelo{i} = pixels_mod_flat;
        end
    end
end
