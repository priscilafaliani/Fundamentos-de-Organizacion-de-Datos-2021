program ejercicio14;

const
    CODIGO_FIN = 'zzz';

type
    reg_maestro = record
        destino : string;
        fecha : string;
        hora_salida : string;
        asientos : integer;
    end;

    archivo_maestro = file of reg_maestro;

    reg_detalle = record
        destino : string;
        fecha : string;
        hora_salida : string;
        comprados : integer;
    end;

    archivo_detalle = file of reg_detalle;

    reg_salida = record
        destino : string;
        fecha : string;
        hora_salida : string;
    end;

    archivo_salida = file of reg_salida;


procedure leer(var archivo : archivo_detalle; var registro : reg_detalle);
begin
    if not eof(archivo) then
        read(archivo, registro)
    else
        registro.destino := CODIGO_FIN;
end;


procedure minimo(var min, reg1, reg2 : reg_detalle; var archivo1, archivo2 : archivo_detalle);
begin
    minimo.destino := CODIGO_FIN;

    if reg1.destino < reg2.destino and reg1.fecha < reg2.fecha and reg1.hora_salida < reg2.hora_salida then
    begin
        min := reg1;
        leer(reg1, archivo1);
    end
    else
    begin
        min := reg2;
        leer(reg2, archivo2);
    end;
end;


procedure actualizar_maestro();
var
    maestro : archivo_maestro;
    detalle1, detalle2 : archivo_detalle;
    dreg1, dreg2, min : reg_detalle;
    destino_act, fecha_act, salida_act : string;
    mreg : reg_maestro;
begin
    assign(maestro, 'maestro');
    reset(maestro);

    assign(detalle1, 'detalle1');
    assign(detalle2, 'detalle2');

    reset(detalle1);
    reset(detalle2);


    leer(detalle1, dreg1);
    leer(detalle2, dreg2);
    minimo(min, dreg1, dreg2, detalle1, detalle2);

    while (min.destino <> CODIGO_FIN) do
    begin
        read(maestro, mreg);
        while mreg.destino <> min.destino and mreg.fecha <> min.fecha and mreg.hora_salida <> min.hora_salida do
            read(maestro, mreg);

        while mreg.destino = min.destino and mreg.fecha = min.fecha and mreg.hora_salida = min.hora_salida do
        begin
            mreg.asientos := mreg.asientos - min.comprados;
            minimo(min, dreg1, dreg2, detalle1, detalle);
        end;

        seek(maestro, filepos(maestro) - 1);
        write(maestro, mreg);
    end;

    close(maestro);
    close(detalle1);
    close(detalle2);
end;


// genera lista de vuelos con aquellos q tienen menos asientos disponibles q los dados
procedure generar_lista_vuelos(asientos_disponibles : integer);
var
    maestro : archivo_maestro;
    salida : archivo_salida;
    mreg : reg_maestro;
    sreg : reg_salida;
begin
    assign(maestro, 'maestro');
    reset(maestro);

    assign(salida, 'salida');
    rewrite(salida);

    while not eof(maestro) do
    begin
        read(maestro, mreg);
        if mreg.asientos < asientos_disponibles then
        begin
            sreg.destino := mreg.destino;
            sreg.fecha := mreg.fecha;
            sreg.hora_salida := mreg.hora_salida;
            write(salida, mreg);
        end;
    end;

    close(maestro);
    close(salida);
end;


procedure main();
var
    asientos_disponibles : integer;
begin
    actualizar_maestro();
    writeln('Cantidad de asientos? ');
    readln(asientos_disponibles);
    generar_lista_vuelos(asientos_disponibles);
end;


begin
    main();
end.