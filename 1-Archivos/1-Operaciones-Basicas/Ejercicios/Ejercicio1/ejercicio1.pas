program ejercicio1;

type
    reg_producto = record
        nombre : string;
        stock : integer;
        precio : real;
        tipo : string;
    end;

    archivo_productos = file of reg_producto;

procedure leer_producto(var producto : reg_producto);
begin
    with producto do begin
        readln(nombre);
        readln(stock);
        readln(precio);
        readln(tipo);
    end;
end;

var
    productos : archivo_productos;
    producto : reg_producto;

begin

    assign(productos, 'productos');
    rewrite(productos);

    leer_producto(producto);
    while(producto.precio <> 0) do begin
        write(productos, producto);
        leer_producto(producto);
    end;

    close(productos);
end.