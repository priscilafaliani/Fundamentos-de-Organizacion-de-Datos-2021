program ejercicio2;

type
    reg_empleado = record
        codigo : integer;
        apellido : string;
        nombre : string;
        direccion : string;
        dni : integer;
        fecha_nac : string;
    end;

    archivo_empleados = file of reg_empleado;


procedure leer_empleado(var e : reg_empleado);
begin
    with e do begin
        readln(codigo);
        readln(apellido);
        readln(nombre);
        readln(direccion);
        readln(dni);
        readln(fecha_nac);
    end;
end;


procedure crear();
var
    e : reg_empleado;
    arch : archivo_empleados;
begin
    assign(arch, 'empleados');
    rewrite(arch);

    leer_empleado(e);
    while e.nombre <> '' do
    begin
        write(arch, e);
        leer_empleado(e);
    end;

    close(arch);
end;


procedure marcar(var arch : archivo_empleados; e : reg_empleado);
begin
    e.nombre := '*' + e.nombre;
    seek(arch, filepos(arch) - 1);
    write(arch, e);
end;


procedure eliminar_80000000();
var
    arch : archivo_empleados;
    e : reg_empleado;
begin
    reset(arch);

    while not eof(arch) do
    begin
        read(arch, e);
        if e.dni < 80000000 then
            marcar(arch, e);
    end;

    close(arch);
end;

procedure main();
begin
    crear();
    eliminar_80000000();
end;