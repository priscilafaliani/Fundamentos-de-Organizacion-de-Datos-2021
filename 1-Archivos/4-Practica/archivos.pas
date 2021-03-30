{
    colección de procedures/functions para
    utilizar en archivos
}

procedure leer(var archivo : archivo_de_x; var registro : reg_de_x);
begin
    if (not eof(archivo)) then
        read(archivo, registro);
    else
        registro.campo := VALOR_INDICADOR;
end;


// CAMBIAR EL NOMBRE SEGÚN SE DESEE
procedure conectar_archivos(var archivos : arr_archivos);
var i : integer;
begin
    for i := 1 to CONSTANTE do
        assign(archivos[i], 'NOMBRE' + intToStr(i));
end;


// CAMBIAR A RESET/REWRITE SEGÚN SE DESEE
procedure abrir_archivos(var archivos : arr_archivos);
var i : integer;
begin
    for i := 1 to CONSTANTE do 
        reset(archivos[i]);
end;


procedure cerrar_archivos(var archivos : arr_archivos);
var i : integer;
begin
    for i := 1 to CONSTANTE do
        close(archivos[i]);
end;


{ PROCEDIMIENTOS UTILIZADOS PARA REALIZACION DE MERGE }

// utilizado para la obtención del mínimo. Se utiliza una vez.
procedure iniciar_arr_registros_lectura(var archivos : arr_archivos; var registros : arr_registros);
var i : integer;
begin
    for i := 1 to CONSTANTE do
        leer(archivos[i], registros_de_x[i]);
end;


procedure obtener_registro_minimo(var archivos : arr_archivos; var registros : arr_registros; var minimo : reg_de_x);
var i, pos : integer;
begin
    minimo.campo := CODIGO_SALIDA;
    for i := 1 to CONSTANTE do
    begin
        if (registros[i].campo < minimo.campo) then
        begin
            minimo := registros[i];
            pos := i;
        end;
    end;

    if (minimo.campo <> CODIGO_SALIDA) then
        leer(archivos[pos], registros[pos]);
end;