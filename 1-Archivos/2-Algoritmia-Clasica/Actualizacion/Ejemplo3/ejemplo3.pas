program ejemplo3;

const VALOR_CORTE = '9999';

type

    reg_producto = record 
        codigo : string[4];
        descripcion : string;
        stock : integer;
    end;

    reg_venta : record
        codigo : string[4];
        cantidad : integer;
    end;

    archivo_detalle = file of reg_venta;
    archivo_maestro = file of reg_producto;

procedure leer (var detalle : archivo_detalle; var venta : reg_venta);
begin
    if (not eof(detalle)) then
        read(detalle, venta)
    else
        venta.codigo = VALOR_CORTE;
end;

procedure get_minimo(var v1, v2, v3, min : reg_venta; var detalle1, detalle2, detalle3 : archivo_detalle);
begin
    if ((v1.codigo <= v2.codigo) and (v1.codigo <= v3.codigo)) then begin
        min := v1;
        leer(detalle1, v1);
    end
    else if (v2.codigo <= v3.codigo) then begin
        min := v2;
        leer(detalle2, v2);
    end
    else begin 
        min := v3;
        leer(detalle3, v3);
    end;
end;

var
    producto : reg_producto;
    minimo, venta_detalle1, venta_detalle2, venta_detalle3 : reg_venta;
    maestro : archivo_maestro;
    detalle1, detalle2, detalle3 : archivo_detalle;
    codigo_actual : string[4];
    total_vendido : integer;

begin
    assign(maestro, 'maestro');
    assign(detalle1, 'detalle1');
    assign(detalle2, 'detalle2');
    assign(detalle3, 'detalle3');

    reset(maestro);
    reset(detalle1);
    reset(detalle2);
    reset(detalle3);

    leer(detalle1, venta_detalle1);
    leer(detalle2, venta_detalle2);
    leer(detalle3, venta_detalle3);

    get_minimo(venta_detalle1, venta_detalle2, venta_detalle3, minimo, detalle1, detalle2, detalle3);
    while (minimo.codigo <> VALOR_CORTE) do begin
        codigo_actual := minimo.codigo;
        total_vendido := 0;
        while (codigo_actual = minimo.codigo) do begin
            total_vendido := total_vendido + minimo.cantidad;
            get_minimo(venta_detalle1, venta_detalle2, venta_detalle3, minimo, detalle1, detalle2, detalle3);
        end;

        read(maestro, producto);
        while (producto.codigo <> codigo_actual) do
            read(maestro, producto);

        producto.stock := producto.stock - total_vendido;

        seek(maestro, filepos(maestro) - 1);
        write(maestro, producto);
    end;


    close(maestro);
    close(detalle1);
    close(detalle2);
    close(detalle3);
end.