program ejercicio1;

type

    reg_empleado = record
        codigo : integer;
        nombre : string;
        comision : real;
    end;

    archivo_empleados = file of reg_empleado;


procedure leer_empleado(var empleados : archivo_empleados; var empleado : reg_empleado);
begin
    reset(empleados);

    if (not eof(empleados)) then
        read(empleados, empleado)
    else
        empleado.codigo := -32767

    close(empleados);
end;


procedure compactar_archivo(var entrada, salida : archivo_empleados);
var
    empleado_a_escribir, empleado_recien_leido : reg_empleado;
    codigo_actual := integer;
begin
    rewrite(salida);

    leer(entrada, empleado_recien_leido);

    // mientras no llegue al fin del archivo
    while (empleado_recien_leido.codigo <>  -32767) do
    begin
        empleado_a_escribir := empleado_recien_leido
        // mientras que sea el mismo empleado
        while (empleado_a_escribir.codigo = empleado_recien_leido.codigo) do 
        begin
            empleado_a_escribir.comision := empleado_a_escribir.comision + empleado_a_escribir.comision;
            leer(entrada, empleado_recien_leido);
        end;

        write(salida, empleado_a_escribir);
    end;

    close(salida);    
end;


var
    archivo_entrada : archivo_empleados;
    archivo_salida : archivo_empleados;
begin
    assign(archivo_entrada, 'empleados');
    assign(archivo_salida, 'empleados_fixed');

    compactar_archivo(archivo_entrada, archivo_salida);
end.