program ejercicio3;

type
    reg_novela = record
        codigo : integer;
        genero : string;
        nombre : string;
        duracion : integer;
        director : string;
        precio : real;
    end;

    archivo_novelas = file of reg_novela;


procedure leer_novela(var n : reg_novela; existia : boolean);
begin
    with n do begin
        if not existia then
            readln(codigo);
        readln(genero);
        readln(nombre);
        readln(duracion);
        readln(director);
        readln(precio);
    end;
end;


procedure crear(nombre);
var 
    arch : archivo_novelas;
    n : novela;
begin
    assign(arch, nombre);
    rewrite(arch);

    // registro cabecera
    n.codigo := 0;
    write(arch, n);

    leer_novela(n, false);
    while n.codigo <> 0 do
    begin
        write(arch, n);
        leer_novela(n, false);
    end;

    close(arch);
end;


procedure alta(nombre);
var
    n, aux : reg_novela;
    arch : archivo_novelas;
begin
    assign(arch, nombre);
    reset(arch);

    // leo novela de teclado
    leer_novela(n);

    // obtengo el registro cabecera
    read(arch, aux);

    // verifico si hay espacio
    if aux.codigo <> 0 then
    begin
        // voy a direccion de ultimo borrado
        seek(arch, aux.codigo * -1);
        // obtengo la dirección a la que apunta donde voy a escribir
        read(arch, aux);
        // escribo el nuevo registro
        write(arch, n);
        // actualizo la cabecera
        seek(arch, 0);
        write(arch, aux);
    end
    // si no, agrego al final
    else
        seek(arch, filesize(arch));
        write(arch, n);

    close(arch);
end;


procedure leer(var arch : archivo_novelas; var n : reg_novela);
begin
    if not eof(arch) then
        read(arch, n)
    else
        n.codigo := 32767;
end;


procedure modificar(nombre);
var
    arch : archivo_novelas;
    n : reg_novela;
    codigo : integer;
begin
    assign(arch, nombre);
    reset(arch);

    write('codigo de novela que desea modificar: ');
    readln(codigo);

    leer(arch, n);
    while n.codigo <> 32767 and n.codigo <> codigo
        leer(arch, n);

    leer_novela(n, true);
    seek(arch, filepos(arch) - 1);
    write(arch, n);

    close(arch);
end;


procedure eliminar(nombre);
var 
    codigo, nrr : integer;
    n, aux : reg_novela;
    arch : archivo_novelas;
begin
    assign(arch, nombre);
    reset(arch);

    write('codigo de la novela que desea eliminar: ');
    readln(codigo);

    // guardo el reg cabecera
    leer(arch, aux);

    // busco
    leer(arch, n);
    while n.codigo <> 32767 and n.codigo <> codigo do
        leer(arch, n);

    // se encontro para eliminar
    if n.codigo <> 32767 then
    begin
        nrr := filepos(arch) - 1;
        // escribo lo que estaba en la cabecera
        seek(arch, nrr);
        write(arch, aux);

        // escribo nrr del borrado en cabecera
        n.codigo := nrr * -1;
        seek(arch, 0);
        write(arch, n);
    end;


    close(arch);
end;


procedure escribir_novela(var salida : text; n : reg_novela);
begin
    with n do begin
        writeln(salida, codigo, ' ', nombre, ' ');
        writeln(salida, duracion, ' ', n.precio, ' ', n.director);
        writeln(salida, genero);
    end;
end;


procedure listar(nombre);
var
    arch : archivo_novelas;
    salida : text;
    n : reg_novela;
begin
    assign(arch, nombre);
    reset(arch);

    assign(salida, 'novelas.txt');
    rewrite(salida);

    leer(arch, n);
    while n.codigo <> 32767 do
    begin
        escribir_novela(salida, n);
        leer(arch, n);
    end;

    close(arch);
    close(salida);
end;


procedure menu();
begin
    writeln('1. crear archivo');
    writeln('2. abrir archivo');
    writeln('3. exportar a texto');
    writeln;
end;


procedure menu2();
begin
    writeln('1. agregar novela');
    writeln('2. modificar novela');
    writeln('3. eliminar novela');
    writeln;
end;


procedure main2(nombre);
var
    eleccion : integer;
begin
    menu2();
    write('>');
    readln(eleccion);

    case eleccion of
        case 1: alta(nombre);
        case 2: modificar(nombre);
        case 3: eliminar(nombre);
    end;
end;


procedure main();
var
    eleccion : integer;
    nombre : string;
begin
    menu();
    write('>')
    readln(eleccion);
    while eleccion > 0 and eleccion < 4 do begin
        write('nombre del archivo: ');
        readln(nombre);
        case eleccion of
            case 1: crear(nombre);
            case 2: main2(nombre);
            case 3: listar(nombre);
            else writeln('saliendo');
        end;
        menu();
        readln(eleccion);
    end;
end;

begin
    main();
end.