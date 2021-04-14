program ejercicio16;

const
    CODIGO_FIN1 = '9999'
    CODIGO_FIN2 = 32767;

type
    reg_maestro = record
        precio : real;
        fecha : string;
        nombre : string;
        vendidos : integer;
        descripcion : string;
        ejemplares : integer;
        codigo_seminario : integer;
    end;

    archivo_maestro = file of reg_maestro;

    reg_detalle = record
        fecha : string;
        codigo_seminario : integer;
        vendidos : integer;
    end;

    archivo_detalle = file of reg_detalle;

    arr_reg_detalle = array[1..100] of reg_detalle;
    arr_arch_detalle = array[1..100] of archivo_detalle;


procedure iniciar_arr_reg(var archivos : arr_arch_detalle; var registros : arr_reg_detalle);
var i : integer;
begin
    for i := 1 to CANTIDAD do
        leer(archivos[i], registros[i]);
end;


procedure abrir_detalles(var detalles : arr_arch_detalle);
var i : integer;
begin
    for i := 1 to CANTIDAD do
    begin
        assign(archivos[i], 'detalle' + intToStr(i));
        reset(archivos[i]);
    end;
end;


procedure cerrar_detalles(var archivos : arr_arch_detalle);
var i : integer;
begin
    for i := 1 to CANTIDAD do
        close(archivos[i]);
end;


procedure leer(var archivo : archivo_detalle; var registro : reg_detalle);
begin
    if not eof(archivo) then
        read(archivo, registro)
    else
        registro.fecha := CODIGO_FIN;
end;


procedure minimo(var archivos : arr_arch_detalle; var registros : arr_reg_detalle; var min : reg_detalle);
var i, pos : integer;
begin
    min.fecha := CODIGO_FIN1;
    min.codigo_seminario := CODIGO_FIN2;

    for i := 1 to CANTIDAD do
    begin
        if (min.fecha <= registros[i].fecha) and (min.codigo_seminario < registros[i].codigo_seminario) then
        begin
            min := registros[i];
            pos := i;
        end;
    end;

    if (min.fecha <> CODIGO_FIN) then
        leer(archivos[pos], registros[pos]);
end;
