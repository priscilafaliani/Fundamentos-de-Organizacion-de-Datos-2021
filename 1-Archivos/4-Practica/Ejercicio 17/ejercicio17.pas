program ejercicio17;

const
    CODIGO_FIN = 32767;

type
    reg_maestro = record
        codigo : integer;
        nombre : string;
        descripcion : string;
        modelo : string;
        stock : integer;
    end;

    archivo_maestro = file of reg_maestro;

    reg_detalle = record
        codigo : integer;
        precio : real;
        fecha : string;
    end;

    archivo_detalle = file of reg_detalle;


procedure leer(var archivo : archivo_detalle; var registro : reg_detalle);
begin
    if not eof(archivo) then
        read(archivo, registro)
    else
        registro.codigo := CODIGO_FIN;
end;


procedure minimo(var min, reg1, reg2 : reg_detalle; var archivo1, archivo2 : archivo_detalle);
begin
    min.codigo = CODIGO_FIN;

    if (reg1.codigo < reg2.codigo) then
    begin
        min := reg1;
        leer(archivo1, reg1);
    end
    else
    begin
        min := reg2;
        leer(archivo2, reg2);
    end;
end;


procedure actualizar_stock();
var
    maestro : archivo_maestro;
    detalle1, detalle2 : archivo_detalle;
    mreg : reg_maestro;
    dreg1, dreg2, min : reg_detalle;
    cant_vendida_act, cant_vendidad_max, codigo_max : integer;
begin
    assign(maestro, 'maestro');
    reset(maestro);

    assign(detalle1, 'detalle1');
    assign(detalle2, 'detalle2');

    reset(detalle1);
    reset(detalle2);

    leer(detalle1, dreg1);
    leer(detalle2, dreg2);

    cant_vendidad_max := -32767; codigo_max := -1;
    minimo(min, dreg1, dreg2, detalle1, detalle2);
    while min.codigo <> CODIGO_FIN do
    begin
        read(maestro, mreg);
        while mreg.codigo <> min.codigo do
            read(maestro, mreg);

        cant_vendida_act := 0;
        while mreg.codigo = min.codigo do
        begin
            cant_vendida_act := cant_vendida_act + 1;
            mreg.stock := mreg.stock - 1;
        end;

        if cant_vendida_act > cant_vendidad_max then
        begin
            cant_vendidad_max := cant_vendida_act;
            codigo_max := mreg.codigo;
        end;
        
        seek(maestro, filepos(maestro) - 1);
        write(maestro, mreg);
    end;

    // No dice q tengo q informar del maximo asi que solo digo el codigo 
    writeln('El auto mas vendido fue el de codigo ', codigo_max);

    close(maestro);
    close(detalle1);
    close(detalle2);
end;