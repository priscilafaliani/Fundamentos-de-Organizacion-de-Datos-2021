program ejercicio3;

uses sysutils;

const
    // cantidad de sucursales de las que se recibe un archivo de ventas
    SUCURSALES = 30;

    CODIGO_SALIDA = 32767;

type
    // ---- ARCHIVO MAESTRO ----
    // registro de archivo maestro
    reg_producto = record
        codigo : integer;
        nombre : string;
        descripcion : string;
        stock_disponible : integer;
        stock_minimo : integer;
        precio : real;
    end;

    // archivo maestro
    archivo_productos = file of reg_producto;


    // ---- ARCHIVO DETALLE ----
    // registro de archivo detalle
    reg_venta_producto = record
        codigo_producto : integer;
        cantidad : integer;
    end;

    // archivo detalle
    archivo_ventas = file of reg_venta_producto;

    rango_sucursales = 1..SUCURSALES;

    // array de archivos detalle
    archivos_de_ventas = array[rango_sucursales] of archivo_ventas;


    // ---- ARCHIVO INFORME ----
    // registro de archivo de informe
    reg_informe_producto = record
        nombre_producto : integer;
        descripcion : string;
        stock_disponible : integer;
        precio : real;
    end;

    // archivo informe
    archivo_informe = file of reg_informe_producto;


// los nombres de los archivos -> supongamos que son automaticos y no deberían cambiarse
procedure conectar_archivos_ventas(var ventas : archivos_de_ventas);
var 
    i : integer;
begin
    for i := 1 to SUCURSALES do
        assign(ventas[i], 'ventas\ventas_sucursal' + intToStr(i));
end;


procedure abrir_archivos_ventas(var ventas : archivos_de_ventas);
var 
    i : integer;
begin
    for i := 1 to SUCURSALES do
        reset(ventas[i]);
end;


procedure cerrar_archivos_ventas(var ventas : archivos_de_ventas);
var
    i : integer;
begin
    for i := 1 to SUCURSALES do
        close(ventas[i]);
end;


procedure leer_sin_modificar_puntero(var ventas : archivo_ventas; var venta : reg_venta_producto);
begin
    if (not eof(ventas)) then
    begin
        read(ventas, venta);
        // acomoda el puntero donde estaba
        seek(ventas, filepos(ventas) - 1);
    end
    else 
        venta.codigo_producto := CODIGO_SALIDA;
end;


// los archivos se deben abrir antes de ser enviados a este procedimiento
// y cerrar cuando corresponda.
procedure obtener_venta(var ventas : archivos_de_ventas; var minimo : reg_venta_producto);
var 
    i, posicion : integer;
    actual : reg_venta_producto;
begin
    minimo.codigo_producto := CODIGO_SALIDA;
    for i := 1 to SUCURSALES do
    begin
        leer_sin_modificar_puntero(ventas[i], actual);
        if (actual.codigo_producto <> CODIGO_SALIDA) and (actual.codigo_producto < minimo.codigo_producto) then
        begin
            minimo := actual;
            posicion := i;
        end;
    end;

    // si existen productos aún,
    // adelanta el puntero
    if (minimo.codigo_producto <> CODIGO_SALIDA) then
        seek(ventas[posicion], filepos(ventas[posicion]) + 1);
end;


procedure leer_producto(var productos : archivo_productos; var producto : reg_producto);
begin
    if (not eof(productos)) then
        read(productos, producto)
    else
        producto.codigo := CODIGO_SALIDA;
end;


procedure actualizar_stock(var productos : archivo_productos; var ventas : archivos_de_ventas);
var
    minimo : reg_venta_producto;
    producto_actual : reg_producto;
begin
    // abrir archivo maestro
    reset(productos);

    // abrir archivos detalle
    abrir_archivos_ventas(ventas);

    obtener_venta(ventas, minimo);
    while (minimo.codigo_producto <> CODIGO_SALIDA) do
    begin
        // busca el producto en el archivo maestro
        leer_producto(productos, producto_actual);
        while (producto_actual.codigo <> CODIGO_SALIDA) and (producto_actual.codigo <> minimo.codigo_producto) do
            leer_producto(productos, producto_actual);

        // junta todos los datos del producto actual de entre todos los archivos detalle
        while (minimo.codigo_producto <> CODIGO_SALIDA) and (minimo.codigo_producto = producto_actual.codigo) do
        begin
            producto_actual.stock_disponible := producto_actual.stock_disponible - minimo.cantidad;
            obtener_venta(ventas, minimo);
        end;

        // escribe los datos en el archivo maestro
        seek(productos, filepos(productos) - 1);
        write(productos, producto_actual);

    end;

    close(productos);
    cerrar_archivos_ventas(ventas);
end;

procedure crear_informe_productos(var productos : archivo_productos);
var
    informe : text;
    producto : reg_producto;
begin
    reset(productos);

    assign(informe, 'informe.txt');
    rewrite(informe);

    while (not eof(productos)) do
    begin
        read(productos, producto);
        if (producto.stock_disponible < producto.stock_minimo) then
        begin
            writeln(informe, producto.nombre);
            writeln(informe, producto.descripcion);
            writeln(informe, producto.stock_disponible, ' ', producto.precio);
        end;
    end;

    close(productos);
end;

// procedimientos creados para testing
procedure leer_venta(var venta : reg_venta_producto);
begin
    with venta do begin
        write('codigo de producto: ');
        readln(codigo_producto);
        write('cantidad vendida: ');
        readln(cantidad);
    end;
end;


procedure crear_archivos_detalle(var ventas : archivos_de_ventas);
var
    i, j : integer;
    venta : reg_venta_producto;
begin
    abrir_archivos_ventas(ventas);
    
    for i := 1 to SUCURSALES do 
    begin
        writeln('cargando datos en archivo detalle ', i);
        for j := 1 to 4 do
        begin
            leer_venta(venta);
            write(ventas[i], venta);
        end;
    end;

    cerrar_archivos_ventas(ventas);
end;


procedure leer_registro_producto(var producto : reg_producto);
begin
    with producto do
    begin
        write('codigo: ');
        readln(codigo);
        write('nombre: ');
        readln(nombre);
        write('descripcion: ');
        readln(descripcion);
        write('stock disponible: ');
        readln(stock_disponible);
        write('stock minimo: ');
        readln(stock_minimo);
        write('precio: ');
        readln(precio);
    end;
end;


procedure crear_archivo_productos(var productos : archivo_productos);
var 
    i : integer;
    producto : reg_producto;
begin
    rewrite(productos);
    for i := 1 to 5 do begin
        writeln('cargando datos del producto ', i);
        leer_registro_producto(producto);
        write(productos, producto);
    end;
    close(productos);
end;

procedure exportar_archivo_productos(var productos : archivo_productos);
var
    producto : reg_producto;
    texto : text;
begin
    assign(texto, 'exportado.txt');
    rewrite(texto);

    reset(productos);

    while (not eof(productos)) do
    begin
        read(productos, producto);
        writeln(texto, producto.codigo, ' ', producto.nombre);
        writeln(texto, producto.descripcion);
        writeln(texto, producto.stock_disponible, ' ', producto.stock_minimo, ' ', producto.precio);
    end;

    close(productos);
    close(texto);
end;


var
    productos : archivo_productos;
    ventas : archivos_de_ventas;
begin

    // conecto archivo de productos
    assign(productos, 'productos');

    // conecto los archivos de ventas
    conectar_archivos_ventas(ventas);

    // ---- testing ----
    // crear_archivos_detalle(ventas);

    // crear_archivo_productos(productos);

    // exportar_archivo_productos(productos);
    // --- --- --- --- -

    // actualizo stock
    actualizar_stock(productos, ventas);


    crear_informe_productos(productos);
    readln;
end.
