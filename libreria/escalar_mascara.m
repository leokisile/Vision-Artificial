function escalada_final = escalar_mascara(imagen, mascara)
    % ESCALAR_MASCARA : regresa la mascara escalada y centrada segun una imagen/matriz
    %                  imagen: imagen principal
    %                  mascara: mascara binaria a escalar

    escalada = imagen;
    escalada(:, :, :) = 0;
    [m, n, c] = size(escalada); %filas, columnas, canal
    ancho_imagen = round(n/2); % engorda
    desplazamiento = round((n - ancho_imagen) / 2); % enpareja
    alto_imagen = m;

    copia_mascara = mascara;
    copia_mascara(:, :, :) = 0;
    [m_mascara, n_mascara, c_mascara] = size(copia_mascara);
    ancho_mascara = n_mascara;
    alto_mascara = m_mascara;

    ancho_unidad = round(ancho_imagen/ancho_mascara);
    alto_unidad = round(alto_imagen/alto_mascara);



    for i = 1 : m_mascara
      for j = 1 : n_mascara
        inicio_fila = ((i - 1) * alto_unidad) + 1;
        fin_fila = i * alto_unidad;

        inicio_columna = ((j - 1) * ancho_unidad) + 1;
        fin_columna = j * ancho_unidad;


        if i == m_mascara
            fin_fila = alto_imagen;
        end
        if j == n_mascara
            fin_columna = ancho_imagen;
        end


        if mascara(i, j) == 1
            inicio_absoluto_columna = inicio_columna + desplazamiento;
            fin_absoluto_columna = fin_columna + desplazamiento;

            escalada(inicio_fila:fin_fila, inicio_absoluto_columna:fin_absoluto_columna, :) = 1;
        end

      end
    end
    escalada_final = logical(escalada(:,:,1));


end
