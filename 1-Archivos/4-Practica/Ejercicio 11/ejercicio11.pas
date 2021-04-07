program ejercicio11;

const
    CODIGO_FIN = 'zzz'

type
    reg_maestro = record
        provincia : string;
        personas_alfabetizadas : integer;
        encuestados : integer;
    end;

    archivo_maestro : file of reg_maestro;

    reg_detalle = record
        provincia : string;
        codigo_localidad : integer;
        personas_alfabetizadas : integer;
        encuestados : integer;
    end;

    archivo_detalle : file of reg_detalle;


procedure leer(var archivo : archivo_detalle; var registro : reg_detalle);
begin
    if not eof(archivo) then
        read(archivo, registro)
    else
        registro.provincia := CODIGO_FIN;
end;


procedure minimo(var minimo, reg1, reg2 : reg_detalle; var detalle1, detalle2 : archivo_detalle);
begin
    minimo.provincia := CODIGO_FIN;

    if reg1.provincia < reg2.provincia then
    begin
        minimo := reg1
        leer(detalle1, reg1);
    end
    else begin
        minimo := reg2;
        leer(detalle2, reg2);        
    end;
end;


procedure actualizar_maestro();
var
    maestro : archivo_maestro;
    detalle1, detalle2 : archivo_detalle;
    reg1, reg2, min : reg_detalle;
    acumulador : reg_maestro;
begin
    assign(maestro, 'maestro');
    assign(detalle1, 'detalle1');
    assign(detalle2, 'detalle2');

    reset(maestro);
    reset(detalle1);
    reset(detalle2);


    leer(detalle1, reg1);
    leer(detalle2, reg2);
    minimo(min, reg1, reg2 detalle1, detalle2);
    while (min.provincia <> CODIGO_FIN) do
    begin
        read(maestro, acumulador);
        while (acumulador.provincia <> min.provincia) do
            read(maestro, acumulador);

        while (min.provincia = acumulador.provincia) do
        begin
            acumulador.personas_alfabetizadas := acumulador.personas_alfabetizadas + min.personas_alfabetizadas;
            acumulador.encuestados := acumulador.encuestados + min.encuestados;
            minimo(min, reg1, reg2 detalle1, detalle2);
        end;

        seek(maestro, filepos(maestro) - 1);
        write(maestro, acumulador);
    end;


    close(maestro);
    close(detalle1);
    close(detalle2);
end;

begin
    actualizar_maestro();
end.