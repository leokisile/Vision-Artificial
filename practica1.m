% Clase 1: Ubicada en la zona inferior izquierda
c1 = [ 5,  8, 12,  6, 10, 15,  7;
       8, 15, 10, 18, 12,  5, 20 ];

% Clase 2: Ubicada en la zona inferior derecha
c2 = [ 35, 42, 38, 45, 40, 48, 36;
        8, 12, 18, 10, 15,  6, 20 ];

% Clase 3: Ubicada en el centro del plano
c3 = [ 20, 25, 22, 28, 24, 26, 21;
       22, 28, 25, 20, 27, 24, 30 ];

% Clase 4: Ubicada en la zona superior izquierda
c4 = [  6, 12,  8, 15, 10, 18,  5;
       35, 42, 38, 45, 40, 48, 36 ];

% Clase 5: Ubicada en la zona superior derecha
c5 = [ 38, 45, 40, 42, 48, 35, 43;
       36, 40, 45, 38, 42, 48, 35 ];

clases = {c1, c2, c3, c4, c5}

contador = 0;
repetir = 's';
while repetir == 's'
  % Lectura de los datos
  contador = contador + 1;
  disp("Los limites tanto en x c¢mo en y son de [0,60]")
  if contador > 0
    vx = input("Dame la otra coordenada del vector en x=");
    vy = input("Dame la otra coordenada del vector en y=");
  else
    vx = input("Dame la coordenada del vector en x=");
    vy = input("Dame la coordenada del vector en y=");
  endif

  if vx >60 || vy > 60
    disp("El vector excede el limite permitido, por lo que no pertenece a ninguna clase")
    repetir = input("Quiere ingresar otro vector(s/n)? ", "s");
    if repetir == 'n'
      disp("Nos vemos en 8 dias")
      break
    endif
    continue
  endif

  x = [vx; vy]

  % Funcion para graficar dinamicamente n clases
  graficar_clases(clases, x)

  % Calculo de los centroides
  centroides = calcular_centroides(clases)
  %disp(centroides(:,4)) % Impresion de un centroide

  % Calculo de las distnacias con respecto a los centroides
  distancias = calcular_distancias(x, centroides)

  % Normalizar distancias
  normalizadas = normalizar(distancias)

  % Encontrar el minimo, su posicion y devolver el resultado
  minimo = min(min(normalizadas))
  dato = find(normalizadas == minimo)
  fprintf("El vector x pertenece a la clase %d\n", dato)

  % Validacion del bucle del menu
  repetir = input("Quiere ingresar otro vector(s/n)? ", "s");
  if repetir == 'n'
    disp("Nos vemos en 8 dias")
  endif

end

