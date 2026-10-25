function maxProb = maxima_probabilidad(vector, valores, clases)
    % MAXIMA_PROBABILIDAD: Calcula la probabilidad usando distribución normal multivariada 3D

    n_clases = length(clases);
    maxProb = zeros(1, n_clases);

    % Obtener distancias de Mahalanobis
    mahalanobis = calcular_mahalanobis(vector, valores, clases);

    vector = reshape(vector, 1, []);
    dim = length(vector); % 3 para RGB

    for i = 1:n_clases
        c_actual = clases{i};
        [n_muestras, ~] = size(c_actual);

        mu = mean(c_actual, 1);
        c_centrado = c_actual - repmat(mu, n_muestras, 1);
        sigma = (c_centrado' * c_centrado) / n_muestras + eye(dim) * 1e-5;

        exponente = -0.5 * (mahalanobis(1, i) ^ 2);
        denominador = ((2 * pi) ^ (dim / 2)) * sqrt(abs(det(sigma)));

        if denominador == 0
            denominador = 1e-10;
        end

        maxProb(1, i) = exp(exponente) / denominador;
    end
end
