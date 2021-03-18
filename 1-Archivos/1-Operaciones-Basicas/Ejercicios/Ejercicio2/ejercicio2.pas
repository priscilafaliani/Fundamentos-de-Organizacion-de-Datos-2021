program ejercicio1;

type
    reg_producto = record
        nombre : string;
        stock : integer;
        precio : real;
        tipo : string;
    end;

    archivo_productos = file of reg_producto;

procedure mostrar_producto(producto : reg_producto);
begin
    with producto do begin
        writeln('nombre: ', nombre);
        writeln('stock':, stock);
        writeln('precio: ', precio);
        writeln('tipo: ', tipo)
    end;
end;


var
    productos : archivo_productos;
    producto : reg_producto;

begin

    assign(productos, 'productos');
    reset(productos);

    while (not eof(productos)) do begin
        read(productos, producto);

        if ((producto.tipo = 'limpieza') or (producto.stock > 100)) then
            mostrar_producto(producto);
    end;

    close(productos);
end.