function letra = pintar_letra(img, r, g, b)
    % corte_horizontal: Divide la imagen en 3 franjas horizontales, cada una con un solo canal del RGB
    %   img: Matriz de la imagen a aplicar el corte
    %   r,g,b: Enteros para los canales de color a pintar la letra

    [m, n, canales]=size(img);
    letra = zeros(m, n, 3, 'uint8');
    letra(:, 1:round(n/2), 1) = 255;
    letra(:, round(n/2)+1:end, 3) = 255;

    verde = img(:,:,2);
    mascara_letra = (verde != 255);

    r_canal = letra(:,:,1);
    g_canal = letra(:,:,2);
    b_canal = letra(:,:,3);

    r_canal(mascara_letra) = r;
    g_canal(mascara_letra) = g;
    b_canal(mascara_letra) = b;

    letra(:,:,1) = r_canal;
    letra(:,:,2) = g_canal;
    letra(:,:,3) = b_canal;
end
