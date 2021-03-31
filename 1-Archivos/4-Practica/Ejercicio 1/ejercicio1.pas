program ejercicio;

const
    CODIGO_FIN = -1;

type
    reg_empleado = record
        codigo_empleado : integer;
        nombre : string;
        monto_comision : real;
    end;

    archivo_empleados = file of reg_empleado;


procedure leer_empleado_bin(var archivo : archivo_empleados; var empleado : reg_empleado);
begin
    if not eof(archivo) then
        read(archivo, empleado)
    else
        empleado.codigo_empleado := CODIGO_FIN;
end;


procedure compactar_archivo();
var
    maestro, detalle : archivo_empleados;
    aux, empleado_actual : reg_empleado;
begin
    assign(maestro, 'empleados');
    rewrite(maestro);

    assign(detalle, 'info_empleados');
    reset(detalle);

    leer_empleado_bin(detalle, aux);
    while (aux.codigo_empleado <> CODIGO_FIN) do
    begin
        empleado := aux;

        while (aux.codigo_empleado = empleado.codigo_empleado) do
        begin
            empleado.monto_comision := empleado.monto_comision + aux.monto_comision;
            leer_empleado_bin(detalle, aux);
        end;

        write(maestro, empleado);
    end;

    close(archivo);
end;


begin
    compactar_archivo();
end.