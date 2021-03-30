program ejercicio7;

const
    CODIGO_SALIDA = 32767;

type
    reg_mesa_electoral = record
        codigo_provincia : integer;
        codigo_localidad : integer;
        numero_mesa : integer;
        votos : integer;
    end;

    archivo_mesas = file of reg_mesa_electoral;


procedure leer_mesa_bin(var mesas : archivo_mesas; var mesa : reg_mesa_electoral);
begin
    if not eof(mesa) then
        read(mesas, mesa)
    else 
        mesa.numero_mesa := 32767;
end;


procedure presentar_listado();
var
    mesas : archivo_mesas;
    aux, mesa_actual : reg_mesa_electoral;
    total_provincia, total_localidad : integer;
begin
    assign(mesas, 'mesas');
    reset(mesas);

    leer_mesa_bin(mesas, aux);
    while (aux.numero_mesa <> CODIGO_SALIDA) do
    begin
        mesa_actual := aux;
        writeln('codigo de provincia: ', mesa_actual.codigo_provincia);
        total_provincia := 0;
        while (aux.numero_mesa <> CODIGO_SALIDA) and (aux.codigo_provincia = mesa_actual.codigo_provincia) do
        begin
            mesa_actual.codigo_localidad := aux.codigo_localidad;
            total_localidad := 0;
            writeln('codigo de localidad: ', mesa_actual.codigo_localidad);
            while (aux.numero_mesa <> CODIGO_SALIDA) and (aux.codigo_provincia = mesa_actual.codigo_provincia)  and (aux.codigo_localidad = acutal.codigo_localidad) do
            begin
                total_localidad := total_localidad + aux.votos;
                leer_mesa_bin(mesas, aux);
            end;
            writeln('total votos: ', total_localidad);
            total_provincia := total_provincia + total_localidad;
        end;
        writeln('total votos provincia: ', total_provincia);
    end;

    close(mesas);
end;

begin
    presentar_listado();
end.