program ejemplo2;

type 

    const valor_corte = 32767;

    reg_producto = record
        codigo : string[4];
        descripcion : string;
        stock : integer;
    end;

    reg_venta = record
        codigo : string[4];
        cantidad : integer;
    end;

    archivo_detalle = file of venta;
    archivo_maestro = file of producto;

procedure leer(var detalle : archivo_detalle; var venta : reg_venta);
begin
    if (not eof(detalle)) then
        read(detalle, venta)
    else
        venta.codigo := 32767;
end;

var
    producto : reg_producto;
    venta : reg_venta;
    maestro : archivo_maestro;
    detalle : archivo_detalle;
    codigo_actual : string[4];
    total_vendido : integer;

begin
    
    assign(maestro, 'maestro');
    assign(detalle, 'detalle');

    reset(maestro);
    reset(detalle);

    { movemos la lectura y el EOF check afuera }
    leer(detalle, venta);
    while (venta.codigo <> valor_corte) do begin
        read(maestro, producto);
        while (producto.codigo <> venta.codigo) do
            read(maestro, producto);

        codigo_actual := venta.codigo;
        total_vendido := 0;

        while (venta.codigo = codigo_actual) do begin
            total_vendido := total_vendido + venta.cantidad;
            leer(detalle, venta);
        end;

        producto.stock := producto.stock - total_vendido;
        seek(maestro, filepos(maestro) - 1);
        write(maestro, producto);
    end;
    
    close(maestro);
    close(detalle);
end.