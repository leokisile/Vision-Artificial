function clase_predicha = evaluar_punto(punto, centroides, datos_referencia, metodo)
    switch metodo
        case 'Euclidiana'
            distancias = calcular_distancias(punto, centroides);
            [~, clase_predicha] = min(distancias);
        case 'Mahalanobis'
            distancias = calcular_mahalanobis(punto, centroides, datos_referencia);
            [~, clase_predicha] = min(distancias);
        case 'Max prob'
            probs = maxima_probabilidad(punto, centroides, datos_referencia);
            probs_norm = normalizar(probs);
            [~, clase_predicha] = max(probs_norm);
    end
end
