function hsi = rgb2hsi_local(rgb)
    % Conversión estándar de RGB a HSI (valores normalizados [0, 1])
    r = rgb(:,:,1);
    g = rgb(:,:,2);
    b = rgb(:,:,3);

    numerator = 0.5 * ((r - g) + (r - b));

    % Fórmula estándar del denominador con protección contra negativos
    den_sq = (r - g).^2 + (r - b).*(g - b);
    den_sq = max(0, den_sq); % Evita valores negativos que generan números complejos
    denominator = sqrt(den_sq);

    % Proteger el argumento de acos para que esté estrictamente entre -1 y 1
    ratio = numerator ./ (denominator + eps);
    ratio = min(1, max(-1, ratio));
    theta = acos(ratio);

    h = theta;
    h(b > g) = 2*pi - h(b > g);
    h = h / (2*pi);

    min_rgb = min(min(r, g), b);
    s = 1 - 3 .* min_rgb ./ (r + g + b + eps);

    i = (r + g + b) / 3;

    hsi = cat(3, h, s, i);
end
