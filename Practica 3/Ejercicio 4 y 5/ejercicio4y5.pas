uses sysutils;

procedure agregar(var a: tArchRevistas; titulo : tTitulo);
var 
    cabecera, reemplazo : tTitulo;
    en_int : integer;
begin
    reset(a);

    read(a, cabecera);
    en_int := strToInt(cabecera);
    if en_int <> 0 then
    begin
        // voy a donde debo escribir
        seek(a, en_int);
        // recupero el valor
        read(a, reemplazo);
        // escribo el nuevo registro
        seek(a, en int);
        write(a, titulo);
        // escribo de nuevo en la cabecera
        seek(a, 0);
        write(reemplazo);
    end
    else
        seek(a, filesize(a));
        write(a, titulo);

    close(a);
end;


procedure listar(var a: tArchRevistas);
var titulo : tTitulo;
begin
    while not eof(a) do
    begin
        read(a, titulo);
        if strToIntDef(titulo, -1) <> -1 then 
            writeln(titulo);
    end;
end;


procedure leer(var a: tArchRevistas; titulo : tTitulo);
begin
    if not eof(tArchRevistas) then
        read(a, titulo)
    else 
        titulo := '';    
end;


procedure eliminar(var a: tArchRevistas; titulo : tTitulo);
var
    t, cabecera : tTitulo;
begin
    reset(a);

    read(a, cabecera);

    leer(a, t);
    while t <> '' and t <> titulo do
        leer(a, t);

    if t <> '' then
    begin
        seek(a, filepos(a) - 1);
        write(a, cabecera);
        cabecera := filepos(a) - 1;
        seek(a, 0);
        write(a, cabecera);
    end;

    close(a);
end;