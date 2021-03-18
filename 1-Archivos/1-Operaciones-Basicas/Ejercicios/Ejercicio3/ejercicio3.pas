program ejercicio1;

type
    reg_producto = record
        nombre : string;
        stock : integer;
        precio : real;
        tipo : string;
    end;

    archivo_productos = file of reg_producto;


var
    productos : archivo_productos;
    producto : reg_producto;
    porcentaje : real;
begin

    assign(productos, 'productos');
    reset(productos);

    while (not eof(productos)) do begin
        read(productos, producto);

        if (producto.tipo = 'limpieza') then 
            porcentaje := 5
        else if (producto.tipo = 'comestible') then 
            porcentaje := 10
        else
            porcentaje := 20;

        producto.precio := producto.precio + ((producto.precio * porcentaje) / 100);

        seek(productos, filepos(productos) - 1);
        write(productos, producto);
    end;

    close(productos);
end.