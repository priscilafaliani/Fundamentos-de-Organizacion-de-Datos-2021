program ejercicio3;

uses sysutils;

const
    SUCURSALES = 30;
    CODIGO_FIN = 32767;

type
    reg_producto = record
        codigo_producto : integer;
        nombre : string;
        descripcion : string;
        stock : integer;
        stock_minimo : integer;
        precio : real;
    end;

    archivo_maestro = file of reg_producto;

    reg_venta = record
        codigo_producto : integer;
        cantidad : integer;
    end;

    arr_ventas = array[1..SUCURSALES] of reg_venta;

    archivo_detalle = file of reg_venta;

    arr_detalles = array[1..SUCURSALES] of archivo_detalle;


procedure leer_venta_bin(var archivo : archivo_detalle; var venta : reg_venta);
begin
    if not eof(archivo) then
        read(archivo, venta)
    else
        venta.codigo_producto = CODIGO_FIN;
end;


procedure iniciar_arr_ventas(var ventas : arr_ventas; var detalles : arr_detalles);
var i : integer;
begin
    for i := 1 to SUCURSALES do
        leer_venta_bin(detalles[i], ventas[i]);
end;


procedure abrir_detalles(var detalles : arr_detalles);
var i : integer;
begin
    for i := 1 to SUCURSALES do
    begin
        assign(detalles[i], 'detalle' + intToStr(i));
        reset(detalles[i]);
    end;
end;


procedure cerrar_detalles(var detalles : arr_detalles);
var i : integer;
begin
    for i := 1 to SUCURSALES do
        close(detalles[i]);
end;


procedure minimo(var detalles : arr_detalles; var ventas : arr_ventas; var minimo : reg_venta);
var i, pos : integer;
begin
    minimo.codigo_producto := CODIGO_FIN;
    for i := 1 to SUCURSALES do
    begin
        if (minimo.codigo_producto < ventas[i].codigo_producto) then
        begin
            minimo := ventas[i];
            pos := i;
        end;
    end;

    if (minimo.codigo_producto <> CODIGO_FIN) then
        leer(detalles[pos], ventas[pos]);
end;


procedure actualizar_maestro();
var
    maestro : archivo_maestro;
    detalles : arr_detalles;
    ventas : arr_ventas;
    venta : reg_venta;
    producto : reg_producto;
begin
    assign(maestro, 'maestro');
    reset(maestro);
    abrir_detalles(detalles);

    iniciar_arr_ventas(ventas, detalles);
    minimo(detalles, ventas, venta)

    while (venta.codigo_producto <> CODIGO_FIN) do
    begin
        while (producto.codigo_producto <> venta.codigo_producto) do
            read(maestro, producto);

        while (producto.codigo_producto = venta.codigo_producto) do
        begin
            producto.stock := producto.stock - venta.cantidad;
            minimo(detalles, ventas, venta);
        end;

        seek(maestro, filepos(maestro) - 1);
        write(maestro, producto);
    end;

    cerrar_detalles(detalles);
    close(maestro);
end;


procedure leer_producto_bin(var archivo : archivo_maestro; var producto : reg_producto);
begin
    if not eof(archivo) then
        read(archivo, producto)
    else
        producto.codigo_producto = CODIGO_FIN;
end;


procedure informe_stock();
var
    maestro : archivo_maestro;
    informe : text;
    producto : reg_producto;
begin
    assign(maestro, 'maestro');
    reset(maestro);

    assign(informe, 'informe.txt');
    rewrite(informe);

    leer_producto_bin(maestro, producto);
    while (producto.codigo_producto <> CODIGO_FIN) do 
    begin
        if (producto.stock < producto.stock_minimo) then
        begin
            writeln(informe, producto.stock, ' ', producto.nombre);
            writeln(informe, producto.precio, ' ', producto.descripcion);
        end;
        leer_producto_bin(maestro, producto);
    end;

    close(maestro);
    close(informe);
end;

begin
    actualizar_maestro();
    informe_stock();
end.