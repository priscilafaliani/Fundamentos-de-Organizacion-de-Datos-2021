program ejercicio2;

type

    // el registro del archivo maestro
    reg_alumno = record
        codigo : integer;
        apellido : string;
        nombre : string;
        materias_cursadas : integer;
        materias_aprobadas : integer;
    end;

    // el registro del archivo detalle
    reg_alumno_detalle = record
        codigo : integer;
        aprobo : string; // 'final' o 'cursada'
    end;

    // archivos
    archivo_maestro = file of reg_alumno;
    archivo_detalle = file of reg_alumno_detalle;


procedure mostrar_menu_inicial();
begin
    writeln('---- ELIGA UNA OPCION ----');
    writeln;
    writeln('1. Crear archivo maestro');
    writeln('2. Crear archvivo detalle');
    writeln('3. Exportar archivo maestro');
    writeln('4. Exportar archivo detalle');
    writeln('5. Actualizar archivo maestro');
    writeln('6. Exportar datos de quienes aprobaron más de 4 cursadas pero no todos los finales');
    writeln('Cualquier otro numero para salir');
    writeln;
    writeln('--------------------------')
end;


procedure leer_reg_alumno_txt(var data : text; var alumno : reg_alumno);
begin
    if (not eof(data)) then
    begin
        readln(data, alumno.nombre);
        readln(data, alumno.apellido);
        readln(data, alumno.codigo, alumno.materias_cursadas, alumno.materias_aprobadas);
    end 
    else
        alumno.codigo := -32767;
end;


{ 
    el archivo entrada es uno predefinido, por lo cual no es necesario enviarlo como parámetro
    si no, abrirlo directamente. 

    se da por hecho que no hay alumnos repetidos en el archivo de entrada alumnos.txt
}
procedure crear_archivo_maestro();
var
    maestro : archivo_maestro;
    data : text;
    alumno : reg_alumno;
begin
    // crea el archivo maestro
    assign(maestro, 'info_alumnos');
    rewrite(maestro);

    // conecta el archivo de entrada
    assign(data, 'alumnos.txt');
    reset(data);

    leer_reg_alumno_txt(data, alumno);
    while (alumno.codigo <> -32767) do 
    begin
        write(maestro, alumno);
        leer_reg_alumno_txt(data, alumno);
    end;

    close(maestro);
    close(data);    
end;


procedure leer_reg_alumno_detalle_txt(var data : text; var alumno_detalle : reg_alumno_detalle);
begin
    if (not eof(data)) then
        read(data, alumno_detalle.codigo, alumno_detalle.aprobo)
    else 
        alumno_detalle.codigo := -32767;
end;


//  el archivo archivo detalle sí tiene registros repetidos
procedure crear_archivo_detalle();
var 
    detalle : archivo_detalle;
    data : text;
    alumno_detalle : reg_alumno_detalle;
begin
    // crea el archivo detalle
    assign(detalle, 'actualizacion_alumnos');
    rewrite(detalle);

    // conecta el archivo de entrada
    assign(data, 'detalle.txt');
    reset(data);

    leer_reg_alumno_detalle_txt(data, alumno_detalle);
    while (alumno_detalle.codigo <> -32767) do
    begin
        write(detalle, alumno_detalle);
        leer_reg_alumno_detalle_txt(data, alumno_detalle);
    end;

    close(detalle);
    close(data);
end;


procedure escribir_maestro_txt(var exportado : text; alumno : reg_alumno);
begin
    writeln(exportado, alumno.nombre);
    writeln(exportado, alumno.apellido);
    writeln(exportado, alumno.codigo, ' ',  alumno.materias_cursadas, ' ', alumno.materias_aprobadas);
end;


procedure exportar_maestro();
var
    maestro : archivo_maestro;
    archivo_exportado : text;
    alumno : reg_alumno;
begin
    // abro archivo maestro
    assign(maestro, 'info_alumnos');
    reset(maestro);

    // creo archivo de export
    assign(archivo_exportado, 'reporteAlumnos.txt');
    rewrite(archivo_exportado);

    while (not eof(maestro)) do
    begin
        read(maestro, alumno);
        escribir_maestro_txt(archivo_exportado, alumno);
    end;

    close(maestro);
    close(archivo_exportado);
end;


procedure escribir_detalle_txt(var exportado : text; alumno : reg_alumno_detalle);
begin
    writeln(exportado, alumno.codigo, alumno.aprobo);
end;


procedure exportar_detalle();
var
    detalle : archivo_detalle;
    archivo_exportado : text;
    alumno : reg_alumno_detalle;
begin
    // abro archivo detalle
    assign(detalle, 'actualizacion_alumnos');
    reset(detalle);

    // creo archivo de export
    assign(archivo_exportado, 'reporteDetalle.txt');
    rewrite(archivo_exportado);

    while (not eof(detalle)) do
    begin
        read(detalle, alumno);
        escribir_detalle_txt(archivo_exportado, alumno);
    end;

    close(detalle);
    close(archivo_exportado);
end;


procedure leer_detalle(var detalle : archivo_detalle; var alumno : reg_alumno_detalle);
begin
    if (not eof(detalle)) then
        read(detalle, alumno)
    else
        alumno.codigo := -32767;
end;


procedure actualizar_maestro();
var
    maestro : archivo_maestro;
    alumno_maestro : reg_alumno;
    detalle : archivo_detalle;
    alumno_detalle : reg_alumno_detalle;
begin
    // abro los archivos
    assign(maestro, 'info_alumnos');
    assign(detalle, 'actualizacion_alumnos');

    reset(maestro);
    reset(detalle);

    leer_detalle(detalle, alumno_detalle);
    while (alumno_detalle.codigo <> -32767) do
    begin
        // busco el alumno en el archivo maestro
        read(maestro, alumno_maestro);
        while ((not eof(maestro)) and (alumno_maestro.codigo <> alumno_detalle.codigo)) do 
            read(maestro, alumno_maestro);

        // actualizo juntando todos los datos del archivo detalle
        while ((alumno_detalle.codigo <> -32767) and (alumno_detalle.codigo = alumno_maestro.codigo)) do
        begin
            if alumno_detalle.aprobo = ' final' then
                alumno_maestro.materias_aprobadas := alumno_maestro.materias_aprobadas + 1 
            else if alumno_detalle.aprobo = ' cursada' then
                alumno_maestro.materias_cursadas := alumno_maestro.materias_cursadas + 1;
            leer_detalle(detalle, alumno_detalle);
        end;

        // escribo
        seek(maestro, filepos(maestro) - 1);
        write(maestro, alumno_maestro);
    end;

    close(maestro);
    close(detalle);
end;


procedure mas_de_cuatro();
var
    maestro : archivo_maestro;
    exportado : text;
    alumno : reg_alumno;
begin

    // abro archivo maestro
    assign(maestro, 'info_alumnos');
    reset(maestro);

    // creo archivo de export
    assign(exportado, 'aprobaron_cuatro_sin_finales.txt');
    rewrite(exportado);

    while (not eof(maestro)) do
    begin
        read(maestro, alumno);

        // escribe en la salida si:
        // curso al menos 4 materias, pero aprobo menos finales de las que tiene cursadas
        if ((alumno.materias_cursadas > 4) and (alumno.materias_cursadas > alumno.materias_aprobadas)) then
            escribir_maestro_txt(exportado, alumno);
    end;

    close(maestro);
    close(exportado);
end;

procedure main();
var
    eleccion : integer;
begin
    mostrar_menu_inicial();
    readln(eleccion);

    while (eleccion >= 1) and (eleccion <= 6) do
    begin
        case eleccion of
            1: crear_archivo_maestro();             
            2: crear_archivo_detalle();
            3: exportar_maestro();
            4: exportar_detalle();
            5: actualizar_maestro();
            6: mas_de_cuatro();
            else writeln('Finalizado');
        end;
        mostrar_menu_inicial();
        readln(eleccion);
    end;
end;


begin
    main();
    readln;
end.