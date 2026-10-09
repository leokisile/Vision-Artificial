function CortVer = corte_vertical(imagen, cortes, corte, r, g, b)
    % CORTE_VERTICAL : Divide una imagen dada en la cantidad de cortes deseados
    %   imagen: imagen recibida .
    %   cortes: numero de cortes iguales deseados.
    %   corte: corte a extraer desde 1 hasta cortes
    %   r,g,b: bandera de que canal recuperar
    copia = imagen;
    copia(:, :, :)= 0;
    corte = corte -1;
    [n, m, canal]=size(copia);
    pix_por_corte = round(m/cortes);
    inicio = corte * pix_por_corte;
    fin = inicio + pix_por_corte -1;

    if pix_por_corte < 10
      CortVer = copia;
      return
    end
    if corte == 0
      inicio=1;
    end
    if corte == cortes -1
      fin=m;
    end

    if canal == 3
      if r ~= 0
        copia(:, inicio:fin, 1) = imagen(:, inicio:fin, 1);
      end
      if g ~= 0
        copia(:, inicio:fin, 2) = imagen(:, inicio:fin, 2);
      end
      if b ~= 0
        copia(:, inicio:fin, 3) = imagen(:, inicio:fin, 3);
      end
    else
      copia(:, inicio:fin, :) = imagen(:, inicio:fin, :);

    end
    CortVer = copia;


end
