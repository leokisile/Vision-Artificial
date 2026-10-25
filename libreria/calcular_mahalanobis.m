function mahalanobis = calcular_mahalanobis(vector, valores, clases)
    % CALCULAR_MAHALANOBIS: Calcula la distancia de Mahalanobis para vectores RGB (3D)

    n_clases = length(clases);
    mahalanobis = zeros(1, n_clases);

    % Asegurar que el vector evaluado sea una fila (1x3)
    vector = reshape(vector, 1, []);
    dim = length(vector); % 3 para RGB

    for i = 1:n_clases
        c_actual = clases{i}; % Matriz de tamaño [m_muestras x 3]
        [n_muestras, ~] = size(c_actual);

        % Calcular el centroide directamente de las muestras de la clase (1 x 3)
        mu = mean(c_actual, 1);

        % Centrar los datos: cada muestra menos su media
        c_centrado = c_actual - repmat(mu, n_muestras, 1);

        % Matriz de covarianza de [dim x dim] (3x3)
        sigma = (c_centrado' * c_centrado) / n_muestras + eye(dim) * 1e-5;

        % Vector diferencia (1 x 3)
        dif = vector - mu;

        % Distancia de Mahalanobis
        mahalanobis(1, i) = sqrt(dif * inv(sigma) * dif');
    end
end
