program ejercicio5;

const
    PATH_INPUT_MAESTRO = 'productos.txt';
    PATH_OUTPUT_MAESTRO = 'report.txt';
    PATH_OUTPUT_MAL = 'stock_minimo.txt';
    PATH_INPUT_VENTAS = 'ventas.txt';
    CODIGO_SALIDA = 32767;

type
    reg_producto = record
        codigo : integer;
        nombre : string;
        precio : real;
        stock_actual : integer;
        stock_minimo : integer;
    end;

    archivo_maestro = file of reg_producto;

    reg_venta = record
        codigo_producto : integer;
        ventas : integer;
    end;

    archivo_detalle = file of reg_venta;

procedure menu();
begin
    writeln('----');
    writeln;
    writeln('1. Crear archivo maestro');
    writeln('2. Exportar archivo maestro');
    writeln('3. Crear archivo detalle');
    writeln('4. Mostrar contenidos de archivo detalle');
    writeln('5. Actualizar archivo maestro con archivo detalle');
    writeln('6. Exportar productos que no superan stock minimo');
    writeln;
    writeln('----');
end;

{
    el producto en el txt esta tal que:
    codigo nombre
    precio stock actual stock minimo
}
procedure leer_producto_txt(var archivo : text; var registro : reg_producto);
begin
    if (not eof(archivo)) then 
    begin
        read(archivo, registro.codigo, registro.nombre);
        read(archivo, registro.precio, registro.stock_actual, registro.stock_minimo);
    end
    else
        registro.codigo := CODIGO_SALIDA;
end;


procedure crear_archivo_maestro();
var
    maestro : archivo_maestro;
    productos : text;
    producto : reg_producto;
begin
    assign(maestro, 'maestro');
    assign(productos, PATH_INPUT_MAESTRO);

    rewrite(maestro);
    reset(productos);

    leer_producto_txt(productos, producto);
    while (producto.codigo <> CODIGO_SALIDA) do
    begin
        write(maestro, producto);
        leer_producto_txt(productos, producto);
    end;

    close(maestro);
    close(productos);
end;


procedure leer_producto_bin(var archivo : archivo_maestro; var registro : reg_producto);
begin
    if (not eof(archivo)) then 
        read(archivo, registro)
    else
        registro.codigo := CODIGO_SALIDA;
end;


procedure escribir_producto(var archivo : text; var registro : reg_producto);
begin
    write(archivo, registro.codigo, ' ', registro.nombre);
    write(archivo, registro.precio, ' ', registro.stock_actual, ' ', registro.stock_minimo);
end;


procedure exportar_archivo_maestro();
var
    maestro : archivo_maestro;
    producto : reg_producto;
    productos : text;
begin
    assign(maestro, 'maestro');
    assign(productos, PATH_OUTPUT_MAESTRO);

    reset(maestro);
    rewrite(productos);

    leer_producto_bin(maestro, producto);
    while (producto.codigo <> CODIGO_SALIDA) do
    begin
        escribir_producto(productos, producto);
        leer_producto_bin(maestro, producto);
    end;

    close(maestro);
    close(productos);
end;


{
    el producto en el txt esta tal que:
    codigo ventas
}
procedure leer_venta_txt(var archivo : text; var registro : reg_venta);
begin
    if (not eof(archivo)) then 
        read(archivo, registro.codigo_producto, registro.ventas)
    else
        registro.codigo_producto := CODIGO_SALIDA;
end;


procedure crear_archivo_detalle();
var
    detalle : archivo_detalle;
    ventas : text;
    venta : reg_venta;
begin
    assign(detalle, 'detalle');
    assign(ventas, PATH_INPUT_VENTAS);

    rewrite(detalle);
    reset(ventas);

    leer_venta_txt(ventas, venta);
    while (venta.codigo_producto <> CODIGO_SALIDA) do
    begin
        write(detalle, venta);
        leer_venta_txt(ventas, venta);
    end;

    close(detalle);
    close(ventas);
end;


procedure leer_venta_bin(var archivo : archivo_detalle; var registro : reg_venta);
begin
    if (not eof(archivo)) then 
        read(archivo, registro)
    else
        registro.codigo_producto := CODIGO_SALIDA;
end;


procedure mostrar_archivo_detalle();
var
    detalle : archivo_detalle;
    venta : reg_venta;
begin
    assign(detalle, 'detalle');
    reset(detalle);

    leer_venta_bin(detalle, venta);
    while (venta.codigo_producto <> CODIGO_SALIDA) do
    begin
        writeln('codigo del producto: ', venta.codigo_producto, ' ventas: ', venta.ventas);
        leer_venta_bin(detalle, venta);
    end;

    close(detalle);
end;


procedure actualizar_archivo_maestro();
var 
    maestro : archivo_maestro;
    detalle : archivo_detalle;
    venta : reg_venta;
    producto : reg_producto;
begin
    assign(maestro, 'maestro');
    assign(detalle, 'detalle');

    reset(maestro);
    reset(detalle);

    leer_venta_bin(detalle, venta);
    while (venta.codigo_producto <> CODIGO_SALIDA) do
    begin
        
        leer_producto_bin(maestro, producto);
        while (producto.codigo <> CODIGO_SALIDA) and (producto.codigo <> venta.codigo_producto) do
            leer_producto_bin(maestro, producto);

        while (venta.codigo_producto <> CODIGO_SALIDA) and (venta.codigo_producto = producto.codigo) do
        begin
            producto.stock_actual := producto.stock_actual - venta.ventas;            
            leer_venta_bin(detalle, venta);
        end;
        
        seek(maestro, filepos(maestro) - 1);
        write(maestro, producto);
    end;

    close(maestro);
    close(detalle);
end;


procedure exportar_productos_debajo_del_stock();
var
    maestro : archivo_maestro;
    productos_mal : text;
    producto : reg_producto;
begin
    assign(maestro, 'maestro');
    reset(maestro);

    assign(productos_mal, PATH_OUTPUT_MAL);
    rewrite(productos_mal);

    leer_producto_bin(maestro, producto);
    while (producto.codigo <> CODIGO_SALIDA) do
    begin
        if (producto.stock_actual < producto.stock_minimo) then
            escribir_producto(productos_mal, producto);
        leer_producto_bin(maestro, producto);
    end;

    close(productos_mal);
    close(maestro);
end;


procedure main();
var
    eleccion : integer;
begin
    readln(eleccion);

    case eleccion of
        1: crear_archivo_maestro();
        2: exportar_archivo_maestro();
        3: crear_archivo_detalle();
        4: mostrar_archivo_detalle();
        5: actualizar_archivo_maestro();
        6: exportar_productos_debajo_del_stock();
    end;
end;

begin
    main();
end.