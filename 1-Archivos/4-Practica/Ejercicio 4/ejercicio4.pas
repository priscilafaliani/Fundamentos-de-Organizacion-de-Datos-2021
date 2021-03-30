program ejercicio4;

uses sysutils;

const
    CANTIDAD_MAQUINAS = 5;
    CODIGO_SALIDA = 32767;

type

    { ARCHIVO DETALLE }

    // registro detalle
    registro_sesion = record
        codigo_usuario : integer;
        fecha : string;
        tiempo_en_sesion : integer;
    end;

    // archivo detalle
    archivo_sesiones = file of registro_sesion;

    // arreglo de archivos detalle
    arr_archivos_sesiones = array[1..CANTIDAD_MAQUINAS] of archivo_sesiones;

    // arreglo de registros detalle
    arr_registros_sesion = arr[1..CANTIDAD_MAQUINAS] of registro_sesion;
    
    { ARCHIVO MAESTRO }
    
    // registro maestro
    registro_acumulador = record
        codigo_usuario : integer;
        fecha : string;
        tiempo_total_en_sesion : integer;
    end;

    // archivo maestro
    archivo_registro_acumulador = file of registro_acumulador;


procedure conectar_archivos(var archivos : arr_archivos_sesiones);
var i : integer;
begin
    for i := 1 to CANTIDAD_MAQUINAS do
        assign(archivos[i], 'var\log\semanal\sesiones' + intToStr(i));
end;


procedure abrir_archivos(var archivos : arr_archivos_sesiones);
var i : integer;
begin
    for i := 1 to CANTIDAD_MAQUINAS do 
        reset(archivos[i]);
end;


procedure cerrar_archivos(var archivos : arr_archivos_sesiones);
var i : integer;
begin
    for i := 1 to CANTIDAD_MAQUINAS do
        close(archivos[i]);
end;


procedure leer(var archivo : archivo_sesiones; var registro : registro_sesion);
begin
    if (not eof(archivo)) then
        read(archivo, registro)
    else
        registro.campo := CODIGO_SALIDA;
end;


// lee un registro de cada archivo
procedure iniciar_arr_registros_lectura(var archivos_sesiones : arr_archivos_sesiones; var registros_sesion : arr_registros_sesion);
var i : integer;
begin
    for i := 1 to CANTIDAD_MAQUINAS do
        leer(archivos_sesiones[i], registros_sesion[i]);
end;


procedure obtener_registro_minimo(var archivos_sesiones : arr_archivos_sesiones; var registros_sesion : arr_registros_sesion; var minimo : registro_sesion)
var i, pos : integer;
begin
    minimo.codigo_usuario := CODIGO_SALIDA;
    for i := 1 to CANTIDAD_MAQUINAS do
    begin
        if (registros_sesion[i].codigo_usuario < minimo.codigo_usuario>) then
        begin
            minimo := registros_sesion[i];
            pos := i;
        end;
    end;

    if (minimo.codigo_usuario <> CODIGO_SALIDA) then
        leer(archivos_sesiones[pos], registros_sesion[pos]);
end;


// genera el archivo maestro a partir de los archivos detalle
procedure generar_archivo_maestro(var archivos_sesiones : arr_archivos_sesiones);
var
    maestro : archivo_registro_acumulador;
    registros_sesion : arr_registros_sesion;
    minimo : registro_sesion;
    acumulador : registro_acumulador;
begin
    // creo archivo maestro
    assign(maestro, 'var\log\maestro');
    rewrite(maestro);

    // abrir archivos detalle
    abrir_archivos(archivo_sesiones);

    // lectura en el array de registros para buscar el mínimo...
    iniciar_arr_registros_lectura(archivos_sesiones,registros_sesion);

    // leer hasta que no haya más registros en los archivos
    obtener_registro_minimo(archivos_sesiones, registros_sesion, minimo);
    while (minimo.codigo_usuario <> CODIGO_SALIDA) do 
    begin
        // acumulo los datos del mismo usuario en la misma fecha
        registro_acumulador.codigo_usuario := minimo.codigo_usuario;
        registro_acumulador.fecha := minimo.fecha;
        registro_acumulador.tiempo_total_en_sesion := 0;

        while (minimo.codigo_usuario = registro_acumulador.codigo_usuario) and (minimo.fecha = registro_acumulador.fecha) do
        begin
            registro_acumulador.tiempo_total_en_sesion := registro_acumulador.tiempo_total_en_sesion + minimo.tiempo_en_sesion;
            obtener_registro_minimo(archivos_sesiones, registros_sesion, minimo);
        end;

        write(maestro, registro_acumulador);
    end;

    // cierro archivo maestro
    close(maestro);

    // cierro todos los archivos detalle
    cerrar_archivos(archivos_sesiones);
end;

var
    archivos_sesiones : arr_archivos_sesiones;

begin
    // conecta todos los archivos detalle
    conectar_archivos(archivo_sesiones);

    generar_archivo_maestro(archivos_sesiones);

    readln;
end.
