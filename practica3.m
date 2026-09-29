addpath("libreria");

num = input("Ingresa el numero de clases num = ");
elementos = input("Ingresa el numero de elementos por clase elementos = ");
if num <= 0 || elementos <=0
  disp("Ingrese un numero de clases y elementos por clase mayor a 0")
endif

centros_x = zeros(1, num);
centros_y = zeros(1, num);
disp_x = zeros(1, num);
disp_y = zeros(1, num);
cont = 0;
for k=1:num
  fprintf("Datos para la clase %d\n", k)
  cx = input("Ingresa el centroide en x =");
  cy = input("Ingresa el centroide en y =");
  dx = input("Ingresa la dispersion en x =");
  dy = input("Ingresa la dispersion en y =");
  centros_x(k) = [cx];
  centros_y(k) = [cy];
  disp_x(k) = [dx];
  disp_y(k) = [dy];
end

clases = generar_clases(num, elementos, centros_x, centros_y, disp_x, disp_y);
% Unimos los puntos y sacamos minimos y maximos tanto en x como en y (sumamos y restamos 10 unidades para tolerancia)
todos_puntos = [clases{:}];

min_x = min(todos_puntos(1, :)) - 5;
max_x = max(todos_puntos(1, :)) + 5;

min_y = min(todos_puntos(2, :)) - 5;
max_y = max(todos_puntos(2, :)) + 5;

contador = 0;
repetir = 's';
while repetir == 's'
  % Lectura de los datos
  contador = contador + 1;
  fprintf('Limites en X: [%.2f, %.2f]\n', min_x, max_x);
  fprintf('Limites en Y: [%.2f, %.2f]\n', min_y, max_y);
  if contador > 0
    vx = input("Dame la otra coordenada del vector en x=");
    vy = input("Dame la otra coordenada del vector en y=");
  else
    vx = input("Dame la coordenada del vector en x=");
    vy = input("Dame la coordenada del vector en y=");
  endif

  if vx > max_x || vy > max_y || vx < min_x || vy < min_y
    disp("El vector excede el limite permitido, por lo que no pertenece a ninguna clase")
    repetir = input("Quiere ingresar otro vector(s/n)? ", "s");
    if repetir == 'n'
      disp("Nos vemos en 8 dias")
      break
    endif
    continue
  endif

  x = [vx; vy]

  disp("Nuestro menu del dia de hoy:")
  disp("1) Distancia minima")
  disp("2) Distancia mahalanobis")
  disp("3) Máxima Probabilidad")
  opc = input("Ingrese ua opcion: (1/2/3)");

  % Funcion para graficar dinamicamente n clases
  graficar_clases(clases, x);

  % Calculo de los centroides
  centroides = calcular_centroides(clases);
  %disp(centroides(:,4)) % Impresion de un centroide

  if opc == 1

    % Calculo de las distnacias con respecto a los centroides
    distancias = calcular_distancias(x, centroides)

    % Normalizar distancias
    normalizadas = normalizar(distancias)

    % Encontrar el minimo, su posicion y devolver el resultado
    minimo = min(min(normalizadas))
    dato = find(normalizadas == minimo)
    fprintf("El vector x pertenece a la clase %d\n", dato)

  else
    if opc == 2
      distancias = calcular_mahalanobis(x, centroides, clases)

      % Normalizar distancias
      normalizadas = normalizar(distancias)

      % Encontrar el minimo, su posicion y devolver el resultado
      minimo = min(min(normalizadas))
      dato = find(normalizadas == minimo)
      fprintf("El vector x pertenece a la clase %d\n", dato)

    else
      if opc == 3
        maxProb = maxima_probabilidad(x, centroides, clases)

        % Normalizar maxProb
        normalizadas = normalizar(maxProb)

        % Encontrar el minimo, su posicion y devolver el resultado
        max_prob = max(max(normalizadas))
        dato = find(normalizadas == max_prob)
        fprintf("El vector x pertenece a la clase %d\n", dato)

      else
        disp("Seleccione una opcion valida")

      endif
    endif

  endif

  % Validacion del bucle del menu
  repetir = input("Quiere ingresar otro vector(s/n)? ", "s");
  if repetir == 'n'
    disp("Nos vemos en 8 dias")
  endif

end
