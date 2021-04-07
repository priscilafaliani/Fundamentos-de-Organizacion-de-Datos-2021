program ejercicio13;

const
    CODIGO_FIN = 32767;

type
    reg_log = record
        numero_usuario : integer;
        nombre_usuario : string;
        nombre : string;
        apellido : string;
        mails_enviados : integer;
    end;

    archivo_log = file of reg_log;

    reg_detalle = record
        numero_usuario : integer;
        destino : string;
        cuerpo_msg : string;
    end;

    archivo_detalle = file of reg_detalle;


procedure leer(var archivo : archivo_detalle; var registro : reg_detalle);
begin
    if not eof(archivo) then
        read(archivo, registro)
    else
        registro.numero_usuario := CODIGO_FIN;
end;


procedure actualizar_log(nombre_detalle : string);
var
    maestro : archivo_log;
    detalle : archivo_detalle;
    mensaje : reg_detalle;
    log : reg_log;
begin
    assign(maestro, '/var/log/logmail.dat');
    reset(maestro);

    assign(detalle, nombre_detalle);
    reset(detalle);

    leer(detalle, mensaje);
    while mensaje.numero_usuario <> CODIGO_FIN do
    begin
        read(maestro, log);
        while log.numero_usuario <> mensaje.numero_usuario do
            read(maestro, log);

        while log.numero_usuario = mensaje.numero_usuario do
        begin
            log.mails_enviados := log.mails_enviados + 1;
            leer(detalle, mensaje);
        end;

        seek(maestro, filepos(maestro) - 1);
        write(maestro, log);
    end;

    close(maestro);
    close(detalle);
end;


procedure generar_texto_detalle(nombre_detalle : string);
var
    maestro : archivo_maestro;
    detalle : archivo_detalle;
    mensaje : reg_detalle;
    log : maestro;
    mensajes_totales : integer;
begin
    assign(maestro, '/var/log/logmail.dat');
    reset(maestro);

    assign(detalle, nombre_detalle);
    reset(detalle);


    leer(detalle, mensaje);
    while mensaje.numero_usuario <> CODIGO_FIN do
    begin
        write('Numero de usuario ', mensaje.numero_usuario, '. ');

        mensajes_totales := 0;
        // si existe en el detalle, existe en el maestro
        read(maestro, log);
        if log.numero_usuario = mensaje.numero_usuario then
        begin
            while (log.numero_usuario = mensaje.numero_usuario) do
            begin
                mensajes_totales := mensajes_totales + 1;
                leer(detalle, mensaje);
            end;
        end
        else
            leer(detalle, mensaje);            

        writeln('Cantidad de mensajes enviados: ', mensajes_totales);
    end;


    close(maestro);
    close(detalle);
end;


procedure main();
var 
    eleccion : integer;
    nombre_det : string;
begin
    write('Opcion: ');
    readln(eleccion);
    writeln('Nombre del detalle: ');
    readln(nombre_det);
    while (eleccion > 0) and (eleccion < 3) do 
    begin
        case eleccion of
            1: actualizar_log(nombre_det);
            2: generar_texto_detalle(nombre_det);
        end;
        write('Opcion: ');
        readln(eleccion);
        writeln('Nombre del detalle: ');
        readln(nombre_det);
    end;  
end;

begin
    main();
end.