function horizontal = corte_horizontal(img)
    % corte_horizontal: Divide la imagen en 3 franjas horizontales, cada una con un solo canal del RGB
    %   img: Matriz de la imagen a aplicar el corte

    [m, n, canales]=size(img);
    horizontal = img;
    corteh = round(m/3);

    % Rojo
    horizontal(1:corteh,:,1);
    horizontal(1:corteh,:,2)=0;
    horizontal(1:corteh,:,3)=0;

    % Verde
    horizontal(corteh+1:2*corteh,:,1)=0;
    horizontal(corteh+1:2*corteh,:,2);
    horizontal(corteh+1:2*corteh,:,3)=0;

    % Azul
    horizontal(2*corteh+1:m,:,1)=0;
    horizontal(2*corteh+1:m,:,2)=0;
    horizontal(2*corteh+1:m,:,3);
end
