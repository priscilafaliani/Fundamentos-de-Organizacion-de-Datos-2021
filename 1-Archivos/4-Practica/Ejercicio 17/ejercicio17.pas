program ejercicio17;

const
    CODIGO_FIN := 32767;

type
    reg_vehiculo = record
    codigo_vehiculo : integer;
        nombre : string;
        descripcion : string;
        modelo : string;
        stock : integer;
    end;

    archivo_maestro = file of reg_vehiculo;

    reg_venta = record
        codigo_vehiculo : integer;
        precio : real;
        fecha : string;
    end;

    archivo_detalle = file of reg_venta;


procedure leer_venta_bin(var detalle : archivo_detalle; var venta : reg_venta);
begin
    if not eof(detalle) then
        read(detalle, venta)
    else
        venta.codigo_vehiculo := CODIGO_FIN;
end;


procedure actualizar_maestro();
var
    maestro : archivo_maestro;
    detalle1, detalle2 : archivo_detalle;
    vehiculo, mas_vendido: reg_vehiculo;
    venta, ventas_mas_vendido : reg_venta;
begin
    assign(maestro, 'maestro');
    assign(detalle1,'detalle1');
    assign(detalle2, 'detalle2');

    reset(maestro);
    reset(detalle1);
    reset(detalle2);

    


    close(maestro);
    close(detalle1);
    close(detalle2;)
end;