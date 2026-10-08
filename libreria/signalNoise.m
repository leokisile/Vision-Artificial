function SN = signalNoise(img, img_reconstruida)
    % signalNoise: Calcula la relación señal a ruido (SNR) en decibeles (dB)
    %   img: Imagen original (uint8 o double)
    %   img_reconstruida: Imagen reconstruida final en el dominio de la imagen

    % Convertir ambas imágenes a double para evitar desbordamiento y permitir decimales
    img_double = double(img);
    rec_double = double(img_reconstruida);

    % 1. Sumatoria de la energía de la señal original (img^2)
    energia_senal = sum(img_double(:).^2);

    % 2. Sumatoria de la energía del error/ruido ((img - img_reconstruida)^2)
    diferencia = img_double - rec_double;
    energia_ruido = sum(diferencia(:).^2);

    % 3. Cálculo de la SNR en decibeles (dB)
    if energia_ruido == 0
        SN = Inf; % Si la reconstrucción es idéntica/sin error, la SNR es infinita
    else
        SN = 10 * log10(energia_senal / energia_ruido);
    end

    fprintf('Relación Señal/Ruido (SNR): %.2f dB\n', SN);
end
